# Workout Form Checkr

* OSS4AI June 2025 Hackathon Repo for team `Gym#`

## Team

**Team Name**
* Gym# (gym-sharp)

**Team Members**
* Aaryaneil Nimbalkar
* Darrell Ross
* Austin Motley
* Michael William Wijaya

## Project

_AI Enhanced Workout Form Training_

* Leverage AI with multi-modal input to interpret images of people working out
* Detect what workout form they are doing
* Make recommendations on improved form
* Allow video input

_Slides available for download [here](./gymsharp_workout_checkr_slides.pdf)_

### Libraries Used

* Gradio - quickly build a demo API
* Python Imaging Library - used for opening, editing, and converting images in python
* Torch - tensor formatting
* LangChain/LangGraph - form recommendations

### Process

#### Interface

* Upload images
* Record single frame by asccesing webcam
* Paste image in

#### Form Recommendations

* LangChain - react agent
* LangGraph - workflow
* Results - display recommendation

### Challenges

We ran the model locally and the overall image recognition had a lot of errors - not recognizing different forms.

## Building

This repo contains a Makefile and Dockerfile for building out the container that runs the project. Two different containers were designed.

### N8N + JupyterLab + App

The first container tried to use N8N for workflow building while also providing JupyterLab for experimentation. While it does build, this proved to be too much work.

**Build**

`make build`

**Run**

`make run`

**Browse**

* N8N: http://localhost:5678
* JupyterLab: http://locahost:8888
* App: http://localhost:7860

### App Only

The second smaller container just runs the app while mounting local files so that we can experiment more easily.

**Build**

`make docker-build-small`

**Run**

`make docker-run-small`

**Browse**

* http://localhost:7860
