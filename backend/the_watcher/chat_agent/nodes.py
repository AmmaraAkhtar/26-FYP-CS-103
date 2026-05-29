from langchain_groq import ChatGroq
from langchain_core.messages import HumanMessage
from pydantic import BaseModel, Field
from typing import Literal
from dotenv import load_dotenv
from .state import ChatState
from .. import models
from ..utils import send_alert
from django.utils import timezone
from datetime import timedelta
import os
import itertools

load_dotenv()

# Rotate for multiple api keys
GROQ_KEYS = [
    k for k in [
        os.getenv("GROQ_API_KEY_1"),
        os.getenv("GROQ_API_KEY_2"),
        os.getenv("GROQ_API_KEY_3"),
        os.getenv("GROQ_API_KEY_4"),
        os.getenv("GROQ_API_KEY_5"),
        os.getenv("GROQ_API_KEY_6"),
    ] if k  # None keys filter karo
]

# agar sirf ek key hi available hai
if not GROQ_KEYS:
    single = os.getenv("GROQ_API_KEY")
    if single:
        GROQ_KEYS = [single]

key_cycle = itertools.cycle(GROQ_KEYS)


def get_llm():
    
    return ChatGroq(
        model="llama-3.1-8b-instant",
        temperature=0,
        groq_api_key=next(key_cycle),
    )




# Pydantic MOdel for Structured output from LLM
class AgentDecision(BaseModel):
    final_category: Literal["normal", "bullying", "hate", "suicide"] = Field(
        description="Actual category after full context analysis"
    )
    risk_level: Literal["low", "medium", "high"] = Field(
        description="Risk level based on child age, history, pattern"
    )
    action: Literal["allow", "warn", "block"] = Field(
        description="Action to take on this message"
    )
    reasoning: str = Field(
        description="Step by step explanation referencing history and context"
    )
    urgency: Literal["low", "medium", "high"] = Field(
        description="How urgent is this for the parent"
    )


# Node1--------> Context Fetcher Node
def chat_context_fetcher_node(state: ChatState) -> ChatState:
    child = models.child.objects.select_related("parent").get(id=state["child_id"])

    # Last 24 hours ke alerts
    recent_alerts = list(
        models.Alert.objects
        .filter(child=child, created_at__gte=timezone.now() - timedelta(hours=24))
        .order_by("-created_at")
        .values("alert_type", "message", "created_at")[:3]
    )
    for a in recent_alerts:
        a["created_at"] = str(a["created_at"])

    # Same app ki last 10 messages history
    chat_history = list(
        models.ChatMessage.objects
        .filter(child=child, app_name=state["app_name"])
        .order_by("-timestamp")
        .values("message", "category", "risk", "timestamp")[:10]
    )
    for c in chat_history:
        c["timestamp"] = str(c["timestamp"])

    # Aaj kitne messages aaye
    total_chats_today = models.ChatMessage.objects.filter(
        child=child,
        timestamp__date=timezone.now().date()
    ).count()

    return {
        **state,
        "child_age":         child.age,
        "screen_limit_mins": child.screen_time_limit,
        "recent_alerts":     recent_alerts,
        "chat_history":      chat_history,
        "total_chats_today": total_chats_today,
    }

# Node1--------> LLM Reasoning Node

def chat_reasoning_node(state: ChatState) -> ChatState:

    # Chat history text
    if state.get("chat_history"):
        history_text = "\n".join([
            f"  - [{c['category']}] {c['message'][:60]}"
            for c in state["chat_history"]
        ])
        flagged_count = sum(
            1 for c in state["chat_history"]
            if c["category"] in ["hate", "bullying", "suicide"]
        )
    else:
        history_text  = "  No history — this is the first message."
        flagged_count = 0

    # Alerts text
    if state.get("recent_alerts"):
        alerts_text = "\n".join([
            f"  - {a['alert_type']}: {a['message'][:80]}..."
            for a in state["recent_alerts"]
        ])
    else:
        alerts_text = "  No recent alerts sent to parent."

    prompt = f"""You are an intelligent child safety agent. Your job is to assess 
the risk of a chat message and decide what action to take.
Reason carefully using ALL context — do NOT follow fixed rules.

━━━ CHILD PROFILE ━━━
Age: {state['child_age']} years old
App: {state['app_name']}
Total messages today: {state['total_chats_today']}

━━━ CURRENT MESSAGE ━━━
"{state['message']}"

ML Initial Category: {state['ml_category']}  ← This is just one input. You decide the actual category.

━━━ RECENT CHAT HISTORY (same app) ━━━
Total flagged messages before: {flagged_count}
Detail:
{history_text}

━━━ RECENT ALERTS SENT TO PARENT (last 24h) ━━━
{alerts_text}

━━━ YOUR TASK ━━━
Step 1 — Classify message:
  - "normal"   → casual conversation, school talk, family, fun
  - "bullying" → threats, insults, harassment, peer pressure
  - "hate"     → hate speech, discrimination, offensive language
  - "suicide"  → self-harm mentions, suicidal thoughts, hopelessness

Step 2 — Assess Risk:
  Decide risk_level as "low", "medium", or "high" based on:
  - Child's age (younger = stricter)
  - ML initial signal (starting point only)
  - Flagged messages before (pattern = more serious)
  - Context of message (Roman Urdu / mixed language)

Step 3 — Decide Action:
  - "allow" → Safe, just log
  - "warn"  → Notify parent but allow
  - "block" → Block app immediately + alert parent

Step 4 — Consider:
  - Would another alert cause alert fatigue?
  - Is child's age making this more serious?
  - First time vs repeated pattern?
  - Roman Urdu context — "mar dunga" in anger vs real threat?

NOTE: ML only sees the text surface. It does NOT know child's age, 
history, or patterns. Your job is to use ALL context above to make 
a smarter decision.
A "hate" flagged message might be normal slang for a 17-year-old.
A "normal" message after 5 bullying messages is more concerning.

Reason step by step before giving your final answer."""

    try:
        llm = get_llm()
        llm_with_structure = llm.with_structured_output(AgentDecision)
        decision = llm_with_structure.invoke([HumanMessage(content=prompt)])

        return {
            **state,
            "final_category": decision.final_category,
            "risk_level":     decision.risk_level,
            "action":         decision.action,
            "reasoning":      decision.reasoning,
            "urgency":        decision.urgency,
        }

    except Exception as e:
        print(f"Chat LLM Error: {e} — using ML fallback")
        action = "warn" if state["ml_category"] in ["hate", "bullying", "suicide"] else "allow"
        return {
            **state,
            "final_category": state["ml_category"] or "normal",
            "risk_level":     "medium" if action == "warn" else "low",
            "action":         action,
            "reasoning":      f"LLM unavailable. ML fallback used: {state['ml_category']}",
            "urgency":        "medium" if action == "warn" else "low",
        }


# Node3--------> Alert Composer Node
def chat_alert_composer_node(state: ChatState) -> ChatState:
    if state["action"] == "allow":
        return {**state, "alert_message": None, "should_send_alert": False}

    prompt = f"""You are writing a notification to a parent about their child's chat activity.

Context:
- Child age: {state['child_age']} years
- App: {state['app_name']}
- Message category: {state['final_category']}
- Risk level: {state['risk_level']}
- Action decided: {state['action']}
- Agent reasoning: {state['reasoning']}
- Total messages today: {state['total_chats_today']}

Write a WhatsApp-style notification for the parent.
Requirements:
- Maximum 3 sentences
- First sentence: what was detected (specific category, specific app)
- Second sentence: why it's concerning based on THIS child's pattern
- Third sentence: one clear action the parent can take right now
- Tone: calm, informative — not scary
- No technical jargon
- Simple English

Write ONLY the message, nothing else."""

    try:
        llm      = get_llm()
        response = llm.invoke([HumanMessage(content=prompt)])
        alert_msg = response.content
    except Exception as e:
        print(f"Alert composer error: {e}")
        alert_msg = (
            f"A concerning {state['final_category']} message was detected "
            f"on {state['app_name']} for your child. "
            f"Please review their conversations immediately."
        )

    return {
        **state,
        "alert_message":     alert_msg,
        "should_send_alert": True,
    }


# Node4--------> Action Executor Node
def chat_action_executor_node(state: ChatState) -> ChatState:
    child = models.child.objects.get(id=state["child_id"])

    # Block — app lock karo
    if state["action"] == "block":
        child.is_locked = True
        child.save()

    # DB update karo
    try:
        chat_obj          = models.ChatMessage.objects.get(id=state["chat_obj_id"])
        chat_obj.category = state["final_category"]
        chat_obj.risk     = state["risk_level"].capitalize()
        chat_obj.action   = state["action"].capitalize()
        chat_obj.save()
        print(f"DB Updated — category: {chat_obj.category}, action: {chat_obj.action}")
    except models.ChatMessage.DoesNotExist:
        print(f"ChatMessage ID {state['chat_obj_id']} not found")

    # Alert bhejo
    if state.get("should_send_alert") and state.get("alert_message"):
        alert_obj = models.Alert.objects.create(
            child      = child,
            alert_type = state["final_category"],
            message    = state["alert_message"],
        )
        send_alert(alert_obj)
        print(f"ALERT SENT: {state['alert_message']}")

    return state