from langchain_groq import ChatGroq
from langchain_core.messages import HumanMessage
from pydantic import BaseModel, Field
from typing import Literal
from dotenv import load_dotenv
from .state import AppState
from .. import models
import os
import itertools
from django.utils import timezone
from datetime import timedelta
from ..utils  import send_alert #send_alert function from views.py file

load_dotenv()
# llm = ChatGroq( model="llama-3.3-70b-versatile",temperature= 0)

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

llm = get_llm()
# Defining Context Fetcher Node -- Ye node database se child aur app usage ki history fetch karega, jo baad mein LLM ke reasoning ke liye use hoga.

def context_fetcher_node(state: AppState) -> AppState:
    print("STATE RECEIVED:", state)   # ← yeh lagao
    #print("URL IN STATE:", state.get("url"))
    child_id = state["child_id"]
    child = models.child.objects.select_related("parent").get(id=child_id)

    # Last 7 days — same app ka usage
    seven_days_ago = timezone.now().date() - timedelta(days=7)
    history = list(
    models.appUsage.objects
    .filter(child=child, package_name=state["package_name"], date__gte=seven_days_ago)
    .order_by("-date")
    .values("date", "usage_time", "category", "action")  
)
    # date objects ko string mein convert karo JSON ke liye
    for h in history:
        h["date"] = str(h["date"])

    # Last 3 alerts — kisi bhi app ke liye jo parent ko bheje gaye ho
    recent_alerts = list(
    models.Alert.objects        
    .filter(child=child)
    .order_by("-created_at")
    .values("alert_type", "message", "created_at")[:3]
)
    for a in recent_alerts:
        a["created_at"] = str(a["created_at"]) # alert kbb create hua tha usko string mein convert karo

    # Aaj ka total screen time (all apps)
    today = timezone.now().date()
    today_usage = models.appUsage.objects.filter(child=child, date=today)
    total_today = sum(a.usage_time for a in today_usage) // 60  # minutes

    return {
        **state,
        "child_age":        child.age,
        "screen_limit_mins": child.screen_time_limit,
        "usage_history":    history,
        "recent_alerts":    recent_alerts,
        "total_usage_today": total_today,
    } 


#### LLM Reasoning and Decision Making Node

# Creating the pydantic model for agent's decision — isse LLM ko structured output dena easy hoga, aur hum reasoning ko bhi capture kar sakte hain for better transparency.
class AgentDecision(BaseModel):
    action: Literal["block", "alert", "allow", "escalate"] = Field(
        description="Action to take on this app right now"
    )
    reasoning: str = Field(
        description="Step-by-step explanation of why this action was chosen, referencing the history"
    )
    urgency: Literal["low", "medium", "high"] = Field(
        description="How urgent is this situation for the parent"
    )

llm_with_structure = llm.with_structured_output(AgentDecision,)


def reasoning_node(state: AppState) -> AppState:
    usage_mins = state["usage_time"] // 60

    # History ko readable format mein convert karo
    if state["usage_history"]:
        history_text = "\n".join([
            f"  - {h['date']}: {h['usage_time']//60} mins, action taken: {h['action']}"
            for h in state["usage_history"]
        ])
        avg_usage = sum(h["usage_time"] for h in state["usage_history"]) / len(state["usage_history"]) / 60
    else:
        history_text = "  No history — this app is being used for the first time."
        avg_usage = 0

    if state["recent_alerts"]:
        alerts_text = "\n".join([
            f"  - {a['alert_type']}: {a['message'][:80]}..."
            for a in state["recent_alerts"]
        ])
    else:
        alerts_text = "  No recent alerts sent to parent."

    prompt = f"""You are an intelligent child safety agent. Your job is to decide what action to take 
when a child uses an app. You must reason carefully using the context — do NOT follow fixed rules.

━━━ CHILD PROFILE ━━━
Age: {state['child_age']} years old
Daily screen time limit: {state['screen_limit_mins']} minutes
Total screen time used today so far: {state['total_usage_today']} minutes

━━━ CURRENT APP USAGE ━━━
App: {state['package_name']}
Category: {state['ml_category']}
Used for: {usage_mins} minutes right now
Average daily usage (last 7 days): {avg_usage:.0f} minutes

━━━ PAST 7 DAYS — THIS SPECIFIC APP ━━━
{history_text}

━━━ RECENT ALERTS SENT TO PARENT ━━━
{alerts_text}

━━━ YOUR TASK ━━━
Based on ALL of the above context, decide:

- "block"     → App should be blocked immediately on child's device
- "alert"     → Notify parent but keep app running  
- "allow"     → No action needed, just log
- "escalate"  → Situation is serious and repeated — parent needs urgent call to action

Consider:
1. Is usage significantly higher than the child's own pattern? (not generic rules)
2. Has this exact situation been alerted before without parent action?
3. Is the child approaching or past their daily screen limit?
4. Is this a first-time risky app or a repeated behavior?
5. Would sending another alert actually help or just create alert fatigue?

Reason step by step before deciding.
Respond in JSON format with keys: action, reasoning, urgency."""

    try:
        decision = llm_with_structure.invoke([HumanMessage(content=prompt)])
        action   = decision.action
        reasoning = decision.reasoning
        urgency   = decision.urgency
    except Exception as e:
        # Agar LLM se kuch galat response aata hai ya error hota hai, toh default action "alert" rakhte hain with a simple message.
        action = "alert"
        urgency   = "medium" 
        reasoning = f"LLM Error: {str(e)}. Defaulting to alert to be safe."

    return {
        **state,
        "action":   action,
        "reasoning": reasoning,
        "urgency":  urgency,  
    }


 ## Alert Creation Node — Parent ko bhejne ke liye alert message compose karega, based on the action and reasoning. Agar action "allow" hai toh koi alert nahi bhejna.

def alert_composer_node(state: AppState) -> AppState:
    # Allow ka matlab — koi message nahi
    if state["action"] == "allow":
        return {**state, "alert_message": None, "should_send_alert": False}

    usage_mins = state["usage_time"] // 60

    prompt = f"""You are writing a notification message to a parent about their child's phone activity.

Context:
- Child age: {state['child_age']} years
- App used: {state['package_name']} ({state['ml_category']})
- Used for: {usage_mins} minutes
- Action decided: {state['action']}
- Agent reasoning: {state['reasoning']}
- Screen time used today: {state['total_usage_today']} mins out of {state['screen_limit_mins']} mins limit

Write a WhatsApp-style notification message for the parent.
Requirements:
- Maximum 3 sentences
- First sentence: what happened (specific, not generic)
- Second sentence: why it's concerning based on THEIR child's pattern (reference actual numbers)
- Third sentence: one clear thing the parent can do right now
- Tone: calm, informative — not scary or alarmist
- Do NOT use technical jargon like "package_name" or "ML category"
- Write in English but simple words

Write ONLY the message, nothing else."""

    response = llm.invoke([HumanMessage(content=prompt)])

    return {
        **state,
        "alert_message":    response.content,
        "should_send_alert": True,
    }


## Action TAking Node — Jo bhi action LLM ne decide kiya hai, usko execute karega. Agar action "block" hai toh app ko lock karna, agar alert bhejna hai toh alert create karke parent ko notify karna.

def action_executor_node(state: AppState) -> AppState:
    child = models.child.objects.get(id=state["child_id"])

    if state["action"] == "block":
        child.is_locked = True
        child.save()

    if state.get("should_send_alert") and state.get("alert_message"):
        alert_obj = models.Alert.objects.create(
            child=child,
            alert_type=state["action"].capitalize(),
            message=state["alert_message"]
        )
        
        send_alert(alert_obj)

    return state