from typing import TypedDict, Optional, List



class WebState(TypedDict):
     # Input se jo data aa rha hai ... yaani collected data from the device
    url:str
   # usage_time: int          # seconds
    ml_prediction: int         # ML se jo category aayi hai (0 ya 1)
    child_id: int
    web_usage_id:int

    # agent should be aware of the child's profile and history to make informed decisions
    child_age: Optional[int]
    screen_limit_mins: Optional[int]
    web_history: Optional[List[dict]]   # last 7 days same app
    recent_alerts: Optional[List[dict]]   # last 3 alerts for this child
    total_web_today: Optional[int]      # total time spend on websites today , minutes

    # Agent's decision based on the above data
    action: Optional[str]           # block / alert / allow / escalate
    reasoning: Optional[str]        # LLM ka sochne ka process
    alert_message: Optional[str]    # parent ko bheja jane wala alert
    should_send_alert: Optional[bool]
    risk_level:         Optional[str]   # agent decide karega: low/medium/high
    urgency:            Optional[str]