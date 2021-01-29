# MotionTracker

MotionTracker is an app bundle where you can track raw data from your apple watch for research purposes. Since it is hard to read out specific motions afterwards you or someone else can tag these motions with an iPhone when the desired motion is happening. 

![App preview images](https://raw.githubusercontent.com/MartPiet/MotionTracker/main/Resources/appPreview.png)

# Features
- Easily track CoreMotion raw data which will be stored as a csv file on the paired iPhone.
- Track specific motion on the go to ensure clean data.

# Getting started

Just install the iPhone App on an iPhone with Xcode and also install the watch companion app over the iOS Watch app. When you start tracking on the watch, the iPhone gets synced to ensure that tagged motions will be saved in the correct csv. 

In the file manager you can then tap on each file to share it e.g. via AirDrop to a MacBook. I recommend to use iExplorer to easily transfer the data from an connected iPhone. The data is stored on the iPhones ```MotionTracker/Documents/motionTracking/``` directory.

## Tracking motion
Tap "Start tracking" in the Apple Watch app to track motions with 25 data points per second. After you tap "Stop tracking" all the motion data will be send to the iPhone. Motion data looks like this:

```dd-MM_HH-mm-ss_measurePoints.csv```
```csv
timestamp,acceleration_x,acceleration_y,acceleration_z,attitude_pitch,attitude_roll,attitude_yaw,gravity_x,gravity_y,gravity_z,rotation_x,rotation_y,rotation_z
1604343708.411852,0.008955568075180054,0.010095715522766113,0.006651878356933594,0.8483728213445231,0.15813896202164363,-0.07112596823828855,0.10412696748971939,-0.7502055168151855,-0.6529543399810791,-0.026195568963885307,-0.03591288626194,-0.03373078256845474
1604343708.5118861,0.05553150922060013,-0.02580392360687256,0.01524043083190918,0.8561212774376936,0.16072815786246814,-0.06648994440755332,0.10488379001617432,-0.7553062438964844,-0.6469249725341797,-0.3347782492637634,-0.04193262755870819,0.08857255429029465
```

## Tagging motion
Long press the blue circle at the beginning of a desired motion and release the circle right after the motion has been finished. The resulting two entries in the csv file will look like this:

```dd-MM_HH-mm-ss_timeStamps.csv```
```csv
timestamp,event
1604343782.8712769,beginTag
1604343782.965354,endTag
```

Video Demo: https://youtu.be/Qscz2drf6o8


# Contribution

This app bundle is basically a MVP, but still should help a lot of people who want to do e.g. machine learning based on core motion data. If you have ideas and want to contribute, consider to contact me if you have any questions: martin@devpie.de

# Feedback

If you have any questions or feedback, feel free to contact me under martin@devpie.de
