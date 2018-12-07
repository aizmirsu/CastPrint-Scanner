/*
 This file is part of the Structure SDK.
 Copyright © 2016 Occipital, Inc. All rights reserved.
 http://structure.io
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define HAS_LIBCXX
#import <Structure/Structure.h>

//#import "MenuViewController+Sensor.h"
#import "Scanner/ScanViewController.h"
#import "Scanner/ScanViewController+Sensor.h"
//#import "Scanner/CalibrationOverlay.h"
#import "Scanner/MeshViewController.h"

// See default initialization in: -(void)initializeDynamicOptions

//namespace { // anonymous namespace for utility function.
//
//    float keepInRange(float value, float minValue, float maxValue)
//    {
//        if (isnan (value))
//            return minValue;
//
//        if (value > maxValue)
//            return maxValue;
//
//        if (value < minValue)
//            return minValue;
//
//        return value;
//    }
//}


@interface MenuViewController : UIViewController <STBackgroundTaskDelegate, MeshViewDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate>
{
    ScanViewController *_scanViewController;
    
    // Structure Sensor controller.
    STSensorController *_sensorController;
//    STStreamConfig _structureStreamConfig;
    
    SlamData _slamState;
    
//    Options _options;
    
    // Manages the app status messages.
//    StructureSensorStatus _appStatus;
    
    DisplayData _display;
    
    //    // Most recent gravity vector from IMU.
    //    GLKVector3 _lastGravity;
    //
    //    // Scale of the scanning volume.
    //    PinchScaleState _volumeScale;
    
    // Mesh viewer controllers.
    UINavigationController *_meshViewNavigationController;
    MeshViewController *_meshViewController;
    
    // IMU handling.
    //    CMMotionManager *_motionManager;
    //    NSOperationQueue *_imuQueue;
    
//        STBackgroundTask* _naiveColorizeTask;
    //    STBackgroundTask* _enhancedColorizeTask;
    //    STDepthToRgba *_depthAsRgbaVisualizer;
    
    bool _useColorCamera;
    
    //    CalibrationOverlay* _calibrationOverlay;
}

//@property (assign, nonatomic) SlamData *slamData;

//@property (nonatomic, retain) AVCaptureSession *avCaptureSession;
//@property (nonatomic, retain) AVCaptureDevice *videoDevice;
//
//@property (weak, nonatomic) IBOutlet UILabel *appStatusMessageLabel;
//@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *scanViewButton;
//@property (weak, nonatomic) IBOutlet UIButton *resetButton;
//@property (weak, nonatomic) IBOutlet UIButton *doneButton;
//@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
//@property (weak, nonatomic) IBOutlet UILabel *trackingLostLabel;
//@property (weak, nonatomic) IBOutlet UIView *enableNewTrackerView;
//@property (weak, nonatomic) IBOutlet UILabel *batteryProcentageLabel;
//@property (weak, nonatomic) IBOutlet UIView *enableNewTrackerDataView;
//@property (weak, nonatomic) IBOutlet UILabel *sensorCubeHeightValueLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sensorCubeWidthValueLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sensorCubeDepthValueLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sensorCubeRangeValueLabel;
//@property (weak, nonatomic) IBOutlet UISlider *sensorCubeHeightSlider;
//@property (weak, nonatomic) IBOutlet UISlider *sensorCubeWidthSlider;
//@property (weak, nonatomic) IBOutlet UISlider *sensorCubeDepthSlider;
//@property (weak, nonatomic) IBOutlet UISlider *sensorCubeRangeSlider;

+ (instancetype) viewController;

//- (IBAction)scanButtonPressed:(id)sender;
//- (IBAction)resetButtonPressed:(id)sender;
//- (IBAction)doneButtonPressed:(id)sender;
////- (IBAction)optionsButtonPressed:(id)sender;
//- (IBAction)sensorCubeHeightSliderValueChanged:(id)sender;
//- (IBAction)sensorCubeWidthSliderValueChanged:(id)sender;
//- (IBAction)sensorCubeDepthSliderValueChanged:(id)sender;
//- (IBAction)sensorCubeRangeSliderValueChanged:(id)sender;

- (void)updateScanViewButtonColor;
//- (void)enterCubePlacementState;
//- (void)enterScanningState;
//- (void)enterViewingState;
//- (void)adjustVolumeSize:(GLKVector3)volumeSize;
//- (void)updateAppStatusMessage;
//- (BOOL)currentStateNeedsSensor;
//- (void)updateIdleTimer;
//- (void)showTrackingMessage:(NSString*)message;
//- (void)hideTrackingErrorMessage;
//- (void)processDeviceMotion:(CMDeviceMotion *)motion withError:(NSError *)error;
//- (void)onSLAMOptionsChanged;

@end
