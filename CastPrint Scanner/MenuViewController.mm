//
//  MenuViewController.cpp
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 06/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//
/*
 This file is part of the Structure SDK.
 Copyright © 2016 Occipital, Inc. All rights reserved.
 http://structure.io
 */

#import "MenuViewController.h"
#import "MenuViewController+Sensor.h"
#import "ScanViewController.h"
#import "ScanViewController+Camera.h"
#import "ScanViewController+Sensor.h"
#import "ScanViewController+SLAM.h"
#import "ScanViewController+OpenGL.h"

#import "SavedScans/TableViewController.h"
#import "SavedScans/DetailViewController.h"

#include <cmath>
#include <algorithm>

#pragma mark - ViewController Setup

@interface ScanViewController ()
{}


@end

@implementation MenuViewController

+ (instancetype) viewController
{
    MenuViewController* vc = [[MenuViewController alloc] initWithNibName:@"MenuView" bundle:nil];
    return vc;
}

//- (void)dealloc
//{
//    [self.avCaptureSession stopRunning];
//
//    if ([EAGLContext currentContext] == _display.context)
//    {
//        [EAGLContext setCurrentContext:nil];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup ScanViewController and Structure Sensor
    [self setupScanViewControllerAndStructure];
    [self setupSplitViewController];
    
    // Later, we’ll set this true if we have a device-specific calibration
    //    _useColorCamera = [STSensorController approximateCalibrationGuaranteedForDevice];
    _useColorCamera = false;
    
    // Make sure we get notified when the app becomes active to start/restore the sensor state if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // The framebuffer will only be really ready with its final size after the view appears.
//    [(EAGLView *)self.view setFramebuffer];
    
//    [self setupGLViewport];
    
//    [self updateSensorStatusMessage];
    
    // We will connect to the sensor when we receive appDidBecomeActive.
}

- (void)appDidBecomeActive
{
    [_scanViewController activateSensor];
    [self updateScanViewButtonColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self respondToMemoryWarning];
}

//- (void)setupUserInterface
//{
//    // Make sure the status bar is hidden.
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//
//    // Fully transparent message label, initially.
//    self.appStatusMessageLabel.alpha = 0;
//
//    // Make sure the label is on top of everything else.
//    self.appStatusMessageLabel.layer.zPosition = 100;
//
//    // Set range label
//    self.sensorCubeRangeValueLabel.text = [NSString stringWithFormat: @"%.2f%s", _slamState.cubeRange, " m"];
//}

// Make sure the status bar is disabled (iOS 7+)
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setupScanViewControllerAndStructure
{
    _scanViewController = [ScanViewController viewController];
    _scanViewController.delegate = self;
    [self setupStructureSensor];
    [_scanViewController initializeDynamicOptions];
    
}

- (void)setupSplitViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SavedScans" bundle:nil];
    _splitViewController = (UISplitViewController *)[sb instantiateInitialViewController];
    
    DetailViewController *detailViewController = (DetailViewController *) [_splitViewController.viewControllers lastObject];
    
    TableViewController *masterViewController = (TableViewController *) [[_splitViewController.viewControllers firstObject] topViewController];
    
    masterViewController.delegate = detailViewController;
    
}


#pragma mark - IMU


#pragma mark - UI Callbacks

- (IBAction)savedViewButtonPushed:(id)sender {
    [self presentViewController:_splitViewController animated:YES completion:NULL];
}

-(void) updateScanViewButtonColor
{
    if ([self isStructureConnectedAndCharged])
    {
        _scanViewButton.backgroundColor = [UIColor greenColor];
    }
    else if ([self isStructureConnected])
    {
        _scanViewButton.backgroundColor = [UIColor redColor];
    }
    else
    {
        _scanViewButton.backgroundColor = [UIColor grayColor];
    }
//    switch ([_scanViewController getStructureSensorStatus]) {
//        case StructureSensorStatus::SensorStatusOk:
//            _scanViewButton.backgroundColor = [UIColor greenColor];
//            break;
//        case StructureSensorStatus::SensorStatusNeedsUserToCharge:
//            _scanViewButton.backgroundColor = [UIColor redColor];
//            break;
//        case StructureSensorStatus::SensorStatusNeedsUserToConnect:
//            _scanViewButton.backgroundColor = [UIColor blueColor];
//            break;
//
//        default:
//            _scanViewButton.backgroundColor = [UIColor grayColor];
//            break;
//    }
//    if ([self isStructureConnectedAndCharged])
//    {
//        _scanViewButton.backgroundColor = [UIColor greenColor];
//    }
//    else if ([_scanViewController getStructureSensorStatus] == StructureSensorStatus::SensorStatusNeedsUserToCharge &&
//             [self isStructureConnected])
//    {
//        _scanViewButton.backgroundColor = [UIColor redColor];
//    }
//    else
//    {
//        _scanViewButton.backgroundColor = [UIColor grayColor];
//    }
}

//- (void)adjustVolumeSize:(GLKVector3)volumeSize
//{
//    // Make sure the volume size remains between 10 centimeters and 3 meters.
//    volumeSize.x = keepInRange (volumeSize.x, 0.1, 3.f);
//    volumeSize.y = keepInRange (volumeSize.y, 0.1, 3.f);
//    volumeSize.z = keepInRange (volumeSize.z, 0.1, 3.f);
//
//    // show volume information
//    self.sensorCubeWidthValueLabel.text = [NSString stringWithFormat: @"%.02f%s", volumeSize.x, " m"];
//    self.sensorCubeHeightValueLabel.text = [NSString stringWithFormat: @"%.2f%s", volumeSize.y , " m"];
//    self.sensorCubeDepthValueLabel.text = [NSString stringWithFormat: @"%.2f%s", volumeSize.z, " m"];
//
//    // Set slider values
//    self.sensorCubeWidthSlider.value = volumeSize.x;
//    self.sensorCubeHeightSlider.value = volumeSize.y;
//    self.sensorCubeDepthSlider.value = volumeSize.z;
//
//    _slamState.volumeSizeInMeters = volumeSize;
//
//    _slamState.cameraPoseInitializer.volumeSizeInMeters = volumeSize;
//    [_display.cubeRenderer adjustCubeSize:_slamState.volumeSizeInMeters];
//}


- (IBAction)scanViewButtonPushed:(id)sender
{
    [self presentViewController:_scanViewController animated:YES completion:nil];
}


- (void) respondToMemoryWarning
{

}
@end
