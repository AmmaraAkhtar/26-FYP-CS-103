from typing import TypedDict, Optional, List



class AppState(TypedDict):
     # Input se jo data aa rha hai ... yaani collected data from the device
    package_name: str
    usage_time: int          # seconds
    ml_category: str
    child_id: int

    # agent should be aware of the child's profile and history to make informed decisions
    child_age: Optional[int]
    screen_limit_mins: Optional[int]
    usage_history: Optional[List[dict]]   # last 7 days same app
    recent_alerts: Optional[List[dict]]   # last 3 alerts for this child
    total_usage_today: Optional[int]      # all apps today, minutes

    # Agent's decision based on the above data
    action: Optional[str]           # block / alert / allow / escalate
    reasoning: Optional[str]        # LLM ka sochne ka process
    alert_message: Optional[str]    # parent ko bheja jane wala alert
    should_send_alert: Optional[bool]
    urgency: Optional[str] 