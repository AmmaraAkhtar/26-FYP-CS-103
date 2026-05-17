
from langgraph.graph import StateGraph, END,START
from langgraph.checkpoint.memory import MemorySaver
from .state import WebState
from .nodes import (
    web_context_fetcher_node,
    web_reasoning_node,
    web_alert_composer_node,
    web_action_executor_node,
)


# Conditional edge to decide whether to call agent or notS
def should_call_agent(state: WebState) -> str:

    #  ML ne suspicious flag kiya — agent zaroor call ho
    if state["ml_prediction"] == 1:
        return "call_agent"

    # ML ne clean kaha — history check karo
    web_history = state.get("web_history", [])

    if web_history:
        blocked_before = sum(
            1 for h in web_history if h["action"] == "Block"
        )
        # Pehle block ho chuka hai is domain pe — agent decide kare
        if blocked_before > 0:
            return "call_agent"

        # Bohot zyada baar visit — suspicious pattern
        if len(web_history) >= 5:
            return "call_agent"

    # Genuinely safe — agent ki zarurat nahi
    return "skip_agent"


# Skip function — jab ML clean bole aur history bhi safe ho, tab directly allow kar dena, bina agent ko call kiye
# ye tbb call ho ga agr agent call na ho 
def skip_node(state: WebState) -> WebState:
    return {
        **state,
        "risk_level":       "low",
        "action":           "allow",
        "reasoning":        "ML marked clean, no suspicious history — safe to allow.",
        "urgency":          "low",
        "alert_message":    None,
        "should_send_alert": False,
    }


# Graph Construction 
def build_web_graph():
    graph = StateGraph(WebState)

    # Definig nodes of graph
    graph.add_node("context_fetcher",  web_context_fetcher_node)
    graph.add_node("skip",             skip_node)
    graph.add_node("reasoning",        web_reasoning_node)
    graph.add_node("alert_composer",   web_alert_composer_node)
    graph.add_node("action_executor",  web_action_executor_node)

    # Defining Edges of graph
    graph.add_edge(START,"context_fetcher")

    # Context fetch ke baad — agent call karna hai ya skip?
    graph.add_conditional_edges(
        "context_fetcher",
        should_call_agent,
        {
            "call_agent": "reasoning",
            "skip_agent": "skip",
        }
    )

    # Skip → directly execute (no alert)
    graph.add_edge("skip",           "action_executor")

    # Reasoning → Alert Compose → Execute
    graph.add_edge("reasoning",      "alert_composer")
    graph.add_edge("alert_composer", "action_executor")

    # End
    graph.add_edge("action_executor", END)

    # Memory — har child ka alag thread bne ga 
    memory = MemorySaver()
    return graph.compile(checkpointer=memory)


#  Building the graph
web_graph = build_web_graph()