from langgraph.graph import StateGraph, END
from langgraph.prebuilt import create_react_agent
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from typing import TypedDict

from app import model  # <- your image-to-text function

# --- Define the state ---
class GraphState(TypedDict):
    image_path: str
    image_digest: str
    caption: str
    response: str

# --- Step 1: Use local image model to caption the image ---
def caption_image(state: GraphState) -> GraphState:
    caption = model(state["image_path"])
    print(f"[Caption Generated]: {caption}")
    return {**state, "caption": caption}

# --- Step 2: Query GPT-4o Mini ReAct agent with that caption ---
def react_reasoning(state: GraphState) -> GraphState:
    # Set up the agent using GPT-4o Mini
    llm = ChatOpenAI(model="gpt-4o", temperature=0.3)

    prompt = ChatPromptTemplate.from_messages([
        ("system", "You are a helpful AI that answers questions based on image captions."),
        ("human", "{input}")
    ])

    agent = create_react_agent(llm=llm, tools=[], prompt=prompt)
    # executor = AgentExecutor(agent=agent, tools=[], verbose=True)

    result = agent.invoke({"input": state["caption"]})
    return {**state, "response": result["output"]}

# --- Build LangGraph ---
graph = StateGraph(GraphState)
graph.add_node("caption", caption_image)
graph.add_node("reason", react_reasoning)

graph.set_entry_point("caption")
graph.add_edge("caption", "reason")
graph.set_finish_point("reason")

building = graph.compile()

# --- Main function to call with an image ---
def run_image_reasoning_pipeline(image_path: str, image_digests: str ) -> str:
    result = building.invoke({"image_path": image_path, "image_digest": image_digests})
    return result["response"]

# --- Example usage ---
if __name__ == "__main__":
    path = "example.jpg"  # path to an image
    final_response = run_image_reasoning_pipeline(path)
    print("\nFinal Reasoning:\n", final_response)
