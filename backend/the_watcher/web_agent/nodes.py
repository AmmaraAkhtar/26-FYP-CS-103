from langchain_groq import ChatGroq
from langchain_core.messages import HumanMessage
from pydantic import BaseModel, Field
from typing import Literal
from dotenv import load_dotenv
from .state import WebState
from .. import models
from django.utils import timezone
from datetime import timedelta
from urllib.parse import urlparse
from ..utils import send_alert

load_dotenv()

llm = ChatGroq(model="llama-3.3-70b-versatile", temperature=0)


def extract_domain(url: str) -> str:
    try:
        return urlparse(url).netloc.replace("www.", "")
    except:
        return url

# Context Fetcher Node — Ye node database se child aur web usage ki history fetch karega, jo baad mein LLM ke reasoning ke liye use hoga.
def web_context_fetcher_node(state: WebState) -> WebState:
    child_id = state["child_id"]
    child = models.child.objects.select_related("parent").get(id=child_id)
    domain = extract_domain(state["url"])

    seven_days_ago = timezone.now().date() - timedelta(days=7)

    web_history = list(
        models.webUsage.objects
        .filter(child=child, date__gte=seven_days_ago)
        .filter(url__icontains=domain)
        .order_by("-date")
        .values("date", "url", "risk", "action", "category")
    )
    for h in web_history:
        h["date"] = str(h["date"])

    recent_alerts = list(
        models.Alert.objects
        .filter(child=child)
        .order_by("-created_at")
        .values("alert_type", "message", "created_at")[:3]
    )
    for a in recent_alerts:
        a["created_at"] = str(a["created_at"])

    today = timezone.now().date()
    total_web_today = models.webUsage.objects.filter(
        child=child, date=today
    ).count()

    return {
       
        "child_id":state["child_id"],
        "url":state["url"],
        "ml_prediction": state["ml_category"],  
        "web_usage_id":state["web_usage_id"],    

        # ── Context fetched ──
        "child_age":child.age,
        "screen_limit_mins": child.screen_time_limit,
        "web_history":web_history,
        "recent_alerts": recent_alerts,
        "total_web_today":total_web_today,
    }


# Defining the structured output model for LLM's decision
class AgentDecision(BaseModel):
    risk_level: Literal["low", "medium", "high"] = Field(
        description="Risk level based on full context — child age, history, pattern"
    )
    action: Literal["block", "alert", "allow", "escalate"] = Field(
        description="Action to take on this website"
    )
    reasoning: str = Field(
        description="Step by step explanation referencing history and context"
    )
    urgency: Literal["low", "medium", "high"] = Field(
        description="How urgent is this for the parent"
    )

llm_with_structure = llm.with_structured_output(AgentDecision)

# Node2 - LLM Reasoning and Decision Making Node
def web_reasoning_node(state: WebState) -> WebState:
    domain = extract_domain(state["url"])

    if state["web_history"]:
        history_text = "\n".join([
            f"  - {h['date']}: {h['url']} | Action taken: {h['action']}"
            for h in state["web_history"]
        ])
        visit_count   = len(state["web_history"])
        blocked_count = sum(1 for h in state["web_history"] if h["action"] == "Block")
    else:
        history_text  = "  No history — this domain is being visited for the first time."
        visit_count   = 0
        blocked_count = 0

    if state["recent_alerts"]:
        alerts_text = "\n".join([
            f"  - {a['alert_type']}: {a['message'][:80]}..."
            for a in state["recent_alerts"]
        ])
    else:
        alerts_text = "  No recent alerts sent to parent."

    # ML prediction sirf ek signal hai — 1 = suspicious, 0 = clean
    ml_signal = "Suspicious (ML flagged)" if state["ml_prediction"] == 1 else "Clean (ML passed)"

    prompt = f"""You are an intelligent child safety agent. Your job is to assess the risk of a website 
and decide what action to take when a child visits it. 
Reason carefully using ALL context — do NOT follow fixed rules.

━━━ CHILD PROFILE ━━━
Age: {state['child_age']} years old
Daily screen time limit: {state['screen_limit_mins']} minutes

━━━ CURRENT WEBSITE ━━━
URL visited: {state['url']}
Domain: {domain}
ML Signal: {ml_signal}  ← This is just one input. You decide the actual risk.

━━━ TODAY'S BROWSING ━━━
Total websites visited today: {state['total_web_today']}

━━━ PAST 7 DAYS — THIS DOMAIN ━━━
Total visits to this domain: {visit_count}
Times blocked before: {blocked_count}
Detail:
{history_text}

━━━ RECENT ALERTS SENT TO PARENT ━━━
{alerts_text}

━━━ ML SIGNAL (one input only) ━━━
{"URL pattern seems suspicious" if state["ml_prediction"] == 1 else "URL pattern seems clean"}


━━━ YOUR TASK ━━━
Step 1 — Assess Risk:
  Decide risk_level as "low", "medium", or "high" based on:
  - Child's age (younger = stricter)
  - ML signal (suspicious or clean)
  - Visit history (first time vs repeated)
  - Blocked before but still visiting?
  - Pattern of behavior this week

Step 2 — Decide Action:
  - "allow"    → Safe, just log
  - "alert"    → Notify parent but allow access
  - "block"    → Block immediately
  - "escalate" → Repeated risky behavior, urgent parent action needed

Step 3 — Consider:
  - Would another alert cause alert fatigue?
  - Is child's age making this more serious?
  - First time risky visit vs repeated pattern?

NOTE: ML only sees the URL. It does NOT know the child's age, history, or 
patterns. Your job is to use ALL context above to make a smarter decision.
A "suspicious" URL might be fine for a 16-year-old with no bad history.
A "clean" URL visited 10 times after being blocked is more concerning.

Assess risk based on the FULL picture, not just the ML signal.

Reason step by step before giving your final answer."""

    try:
        decision  = llm_with_structure.invoke([HumanMessage(content=prompt)])
        action     = decision.action
        reasoning  = decision.reasoning
        risk_level = decision.risk_level        # ✓ ab save ho raha hai
    except Exception as e:
        action     = "alert"
        reasoning  = f"LLM Error: {str(e)}. Defaulting to alert."
        risk_level = "medium"

    return {
        **state,
        "action":     action,
        "reasoning":  reasoning,
        "risk_level": risk_level,              
    }

# Node3 - Alert Composer Node
def web_alert_composer_node(state: WebState) -> WebState:
    if state["action"] == "allow":
        return {**state, "alert_message": None, "should_send_alert": False}

    domain = extract_domain(state["url"])

    prompt = f"""You are writing a notification to a parent about their child's web activity.

Context:
- Child age: {state['child_age']} years
- Website visited: {domain}
- Risk level: {state['risk_level']}        
- Action decided: {state['action']}
- Agent reasoning: {state['reasoning']}
- Total sites visited today: {state['total_web_today']}

Write a WhatsApp-style notification for the parent.
Requirements:
- Maximum 3 sentences
- First sentence: what happened (specific website, not generic)
- Second sentence: why it's concerning based on THIS child's pattern
- Third sentence: one clear action the parent can take right now
- Tone: calm, informative — not scary
- No technical jargon
- Simple English

Write ONLY the message, nothing else."""

    response = llm.invoke([HumanMessage(content=prompt)])

    return {
        **state,
        "alert_message":    response.content,
        "should_send_alert": True,
    }


# Node4 Action Executor Node --> Ye node final action lega, database update karega, aur parent ko alert bhejega agar zarurat hui toh.
# web_action_executor_node mein — ID se update karo
def web_action_executor_node(state: WebState) -> WebState:
    child = models.child.objects.get(id=state["child_id"])

    if state["action"] == "block":
        child.is_locked = True
        child.save()

    # ID se exact record update karo
    try:
        web_obj = models.webUsage.objects.get(id=state["web_usage_id"])
        web_obj.action    = state["action"].capitalize()
        web_obj.risk      = state["risk_level"].capitalize()
        web_obj.category  = "Malicious" if state["ml_prediction"] == 1 else "Safe"
        web_obj.reasoning = state.get("reasoning", "")
        web_obj.save()
        print(f"DB Updated — action: {web_obj.action}, risk: {web_obj.risk}")
    except models.webUsage.DoesNotExist:
        print(f"webUsage ID {state['web_usage_id']} not found")

    if state.get("should_send_alert") and state.get("alert_message"):
        alert_obj = models.Alert.objects.create(
            child=child,
            alert_type=state["action"].capitalize(),
            message=state["alert_message"]
        )
        send_alert(alert_obj)

    return state