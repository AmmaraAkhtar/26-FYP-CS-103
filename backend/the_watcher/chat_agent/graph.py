from langgraph.graph import StateGraph, END,START
from .state import ChatState
from . import nodes


builder = StateGraph(ChatState)

# Dfining nodes of the graph 
builder.add_node("fetch_context",  nodes.chat_context_fetcher_node)
builder.add_node("llm_reasoning",  nodes.chat_reasoning_node)
# builder.add_node("compose_alert",  nodes.chat_alert_composer_node)
builder.add_node("execute_action", nodes.chat_action_executor_node)




# Creating the edges of the graph
builder.add_edge(START, "fetch_context")
builder.add_edge("fetch_context",  "llm_reasoning")
# builder.add_edge("llm_reasoning",  "compose_alert")
# builder.add_edge("compose_alert",  "execute_action")
builder.add_edge("llm_reasoning",  "execute_action")
builder.add_edge("execute_action", END)

chat_agent = builder.compile()