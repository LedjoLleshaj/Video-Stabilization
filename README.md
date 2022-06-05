# Video-Stabilization

Creation of two MATLAB scripts that allow you to stabilize a video using translation and rotation.

## rotatetraslateStabilization.m

This function allows the user to select a video to stabilize, he is shown the
first frame and is asked to interactively to crop a part of the image that he want to keep stabilized

You can find the function [here](https://github.com/LedjoLleshaj/Video-Stabilization/blob/main/rotatetraslateStabilization.m).

## pointFeatureStabilization.m

This function shows the implementation using the point feature recognition and calculates the best offsset for then to use
this offset to revert the shaking and stabilize the video

You can find the function [here](https://github.com/LedjoLleshaj/Video-Stabilization/blob/main/pointFeatureStabilization.m).

## How to run:

Open Matlab and call the functions for the script u want to utilize
Insert the name of the video u want to use as a parameter

```
pointFeatureStabilization('car.avi')
```

or

```
rotatetraslateStabilization('car.avi')
```

For a better understanding read the [documentation]()
