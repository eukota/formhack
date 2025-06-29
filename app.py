import gradio as gr
from transformers import AutoImageProcessor
from transformers import SiglipForImageClassification
from transformers.image_utils import load_image
from PIL import Image
import torch
from agent import run_image_reasoning_pipeline

# Load model and processor
model_name = "prithivMLmods/Gym-Workout-Classifier-SigLIP2"
model = SiglipForImageClassification.from_pretrained(model_name)
processor = AutoImageProcessor.from_pretrained(model_name)

state = ''

def workout_classification(image):
    """Predicts workout exercise classification for an image."""
    image = Image.fromarray(image).convert("RGB")
    inputs = processor(images=image, return_tensors="pt")
    
    with torch.no_grad():
        outputs = model(**inputs)
        logits = outputs.logits
        probs = torch.nn.functional.softmax(logits, dim=1).squeeze().tolist()
    
    labels = {
        "0": "barbell biceps curl", "1": "bench press", "2": "chest fly machine", "3": "deadlift",
        "4": "decline bench press", "5": "hammer curl", "6": "hip thrust", "7": "incline bench press",
        "8": "lat pulldown", "9": "lateral raises", "10": "leg extension", "11": "leg raises",
        "12": "plank", "13": "pull up", "14": "push up", "15": "romanian deadlift",
        "16": "russian twist", "17": "shoulder press", "18": "squat", "19": "t bar row",
        "20": "tricep dips", "21": "tricep pushdown"
    }
    predictions = {labels[str(i)]: round(probs[i], 3) for i in range(1)}
    state = predictions
    return predictions

# Create Gradio interface
iface = gr.Interface(
    fn=workout_classification,
    inputs=gr.Image(sources=["upload","webcam","clipboard"],type="numpy"),
    # input_video = gr.Video(sources=["webcam"], type="numpy"),
    outputs=gr.Label(label="Prediction Scores"),
    title="Gym Workout Classification",
    description="Upload an image to classify the workout exercise."
)

# Launch the app
if __name__ == "__main__":
    print(gr.__version__)
    iface.launch(server_name="0.0.0.0", server_port=7860)
    # Load UI
    image_digest = next(iter(state))
    print(image_digest)
    # Run Langgraph React Workflow to get User Improvements
    recommendation = run_image_reasoning_pipeline('./', image_digest)
    print(recommendation)
    # Update the interface with the recommendation
    gr.Interface(
        fn=workout_classification,
        inputs=gr.Image(sources=["upload","webcam","clipboard"],type="numpy"),
        outputs=gr.Label(label="Recommendation"),
        title="Workout Improvement Recommendation",
        description=recommendation
    ).launch(server_name="0.0.0.0", server_port=7860)