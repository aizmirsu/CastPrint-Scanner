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


@interface MenuViewController : UIViewController <UIPopoverControllerDelegate, UIGestureRecognizerDelegate>
{
    ScanViewController *_scanViewController;
    UISplitViewController *_splitViewController;
    
    // Structure Sensor controller.
    STSensorController *_sensorController;
    
    SlamData _slamState;
    
//    Options _options;
    
    DisplayData _display;
    
    //    // Most recent gravity vector from IMU.
    //    GLKVector3 _lastGravity;
    //
    //    // Scale of the scanning volume.
    //    PinchScaleState _volumeScale;
    
    // Mesh viewer controllers.
//    UINavigationController *_meshViewNavigationController;
//    MeshViewController *_meshViewController;
    
    // IMU handling.
    //    CMMotionManager *_motionManager;
    //    NSOperationQueue *_imuQueue;
    
    bool _useColorCamera;
}

//@property (assign, nonatomic) SlamData *slamData;

//@property (nonatomic, retain) AVCaptureSession *avCaptureSession;
//@property (nonatomic, retain) AVCaptureDevice *videoDevice;
//
//@property (weak, nonatomic) IBOutlet UILabel *appStatusMessageLabel;
//@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *scanViewButton;
@property (weak, nonatomic) IBOutlet UIButton *savedViewButton;
//@property (weak, nonatomic) IBOutlet UIButton *resetButton;


+ (instancetype) viewController;


//- (IBAction)sensorCubeDepthSliderValueChanged:(id)sender;
//- (IBAction)sensorCubeRangeSliderValueChanged:(id)sender;
- (IBAction)scanViewButtonPushed:(id)sender;
- (IBAction)savedViewButtonPushed:(id)sender;

- (void)updateScanViewButtonColor;
//- (void)enterCubePlacementState;
//- (void)enterScanningState;
//- (void)enterViewingState;

@end
