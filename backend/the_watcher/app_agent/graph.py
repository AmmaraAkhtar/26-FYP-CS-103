from langgraph.graph import StateGraph, END,START
from langgraph.checkpoint.memory import MemorySaver
from .state import AppState
from .nodes import (
    context_fetcher_node,
    reasoning_node,
    alert_composer_node,
    action_executor_node,
)


def build_agent():
    graph = StateGraph(AppState)

# Defining the nodes of the graph — har node ek function hai jo AppState leta hai aur updated AppState return karta hai. Yeh functions alag-alag tasks perform karenge, jaise ki context fetching, reasoning, alert composing, aur action executing.
    graph.add_node("context_fetcher",  context_fetcher_node)
    graph.add_node("reasoning",        reasoning_node)
    graph.add_node("alert_composer",   alert_composer_node)
    graph.add_node("action_executor",  action_executor_node)

# Defining the edges — yeh decide karega ki nodes ka flow kaisa hoga. Jaise pehle context fetch hoga, phir reasoning, uske baad alert compose hoga, aur finally action execute hoga.
    graph.add_edge(START,"context_fetcher")
    graph.add_edge("context_fetcher", "reasoning")
    graph.add_edge("reasoning",       "alert_composer")
    graph.add_edge("alert_composer",  "action_executor")
    graph.add_edge("action_executor", END)

    # Har child ka alag thread — memory maintain hogi
    #checkpointer = MemorySaver()
    #return graph.compile(checkpointer=checkpointer)
    return graph.compile()

app_agent = build_agent()