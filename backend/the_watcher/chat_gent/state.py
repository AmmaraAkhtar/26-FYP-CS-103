
from typing import TypedDict, Optional, List
 
 
class ChatState(TypedDict):
    # Agent Inputs
    child_id:int
    app_name:str
    message: str
    chat_obj_id: int
    ml_category: str  # ML se jo category aayi hai
 
    # Agent will fetch this information throgh context fetcher node
    child_age:  Optional[int]
    screen_limit_mins:  Optional[int]
    recent_alerts: Optional[List[dict]]
    chat_history: Optional[List[dict]]   # last 10 msgs of same app
    total_chats_today:  Optional[int]
 
    # Agent's decision based on the above fetched data
    final_category:Optional[str]   # normal / bullying / hate / suicide
    action:Optional[str]   # allow / warn / block
    reasoning:Optional[str]
    risk_level:Optional[str]   # low / medium / high
    urgency:Optional[str]   # low / medium / high
    alert_message:Optional[str]
    should_send_alert:Optional[bool]
 
