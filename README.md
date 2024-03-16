# You can find the APK in the release section

# auto_zooming_camera

A new Flutter project.

## Getting Started

A Flutter application that detects objects and start zooming automatically so that capturing photos becomes more flexible.

## Features
- Uses ssd_mobilenet pretrained model to detect the object and define the coordinates of it on the screen
- Uses GetX state management to create a controller for the camera that handles scanning objects

## Widgets
- ObjectBox : this widget is a yellow frame surrounding the detected object to give the user an experience that something is detected

## Views
- Camera View: the camera screen that detects the object
- Display Picture: A widget that displays the picture after pressing the capture icon
