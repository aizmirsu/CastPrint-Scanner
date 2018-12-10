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

//- (void)setupMeshViewController
//{
//    _meshViewController = [MeshViewController viewController];
//    _meshViewController.delegate = self;
//    _meshViewNavigationController = [[UINavigationController alloc] initWithRootViewController:_meshViewController];
//}

//- (void)presentMeshViewer:(STMesh *)mesh
//{
//    [_meshViewController setupGL:_display.context];
//
//    _meshViewController.colorEnabled = _useColorCamera;
//    _meshViewController.mesh = mesh;
//    [_meshViewController setCameraProjectionMatrix:_display.depthCameraGLProjectionMatrix];
//
//    // Sample a few points to estimate the volume center
//    int totalNumVertices = 0;
//    for( int i=0; i<mesh.numberOfMeshes; ++i )
//        totalNumVertices += [mesh numberOfMeshVertices:i];
//
//    // The sample step if we need roughly 1000 sample points
//    int sampleStep = std::max (1.f, totalNumVertices/1000.f);
//    int sampleCount = 0;
//    GLKVector3 volumeCenter = GLKVector3Make(0,0,0);
//
//    for( int i=0; i<mesh.numberOfMeshes; ++i )
//    {
//        int numVertices = [mesh numberOfMeshVertices:i];
//        const GLKVector3* vertex = [mesh meshVertices:i];
//
//        for( int j=0; j<numVertices; j+=sampleStep )
//        {
//            volumeCenter = GLKVector3Add(volumeCenter, vertex[j]);
//            sampleCount++;
//        }
//    }
//
//    if( sampleCount>0 )
//        volumeCenter = GLKVector3DivideScalar(volumeCenter, sampleCount);
//
//    else
//        volumeCenter = GLKVector3MultiplyScalar(_slamState.volumeSizeInMeters, 0.5);
//
//    [_meshViewController resetMeshCenter:volumeCenter];
//
//    [self presentViewController:_meshViewNavigationController animated:YES completion:^{}];
//}


#pragma mark - IMU


#pragma mark - UI Callbacks

- (IBAction)savedViewButtonPushed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SavedScans" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"scansSplitViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
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
//    switch( _slamState.scannerState )
//    {
//        case ScannerStateViewing:
//        {
//            // If we are running a colorizing task, abort it
////            if( _enhancedColorizeTask != nil && !_slamState.showingMemoryWarning )
////            {
////                _slamState.showingMemoryWarning = true;
////
////                // stop the task
////                [_enhancedColorizeTask cancel];
////                _enhancedColorizeTask = nil;
////
////                // hide progress bar
////                [_meshViewController hideMeshViewerMessage];
////
////                UIAlertController *alertCtrl= [UIAlertController alertControllerWithTitle:@"Memory Low"
////                                                                                  message:@"Colorizing was canceled."
////                                                                           preferredStyle:UIAlertControllerStyleAlert];
////
////                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
////                                                                   style:UIAlertActionStyleDefault
////                                                                 handler:^(UIAlertAction *action)
////                                           {
////                                               _slamState.showingMemoryWarning = false;
////                                           }];
////
////                [alertCtrl addAction:okAction];
////
////                // show the alert in the meshViewController
////                [_meshViewController presentViewController:alertCtrl animated:YES completion:nil];
////            }
//
//            break;
//        }
//        case ScannerStateScanning:
//        {
//            if( !_slamState.showingMemoryWarning )
//            {
//                _slamState.showingMemoryWarning = true;
//
//                UIAlertController *alertCtrl= [UIAlertController alertControllerWithTitle:@"Memory Low"
//                                                                                  message:@"Scanning will be stopped to avoid loss."
//                                                                           preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                   style:UIAlertActionStyleDefault
//                                                                 handler:^(UIAlertAction *action)
//                                           {
////                                               _slamState.showingMemoryWarning = false;
////                                               [self enterViewingState];
//                                           }];
//
//
//                [alertCtrl addAction:okAction];
//
//                // show the alert
//                [self presentViewController:alertCtrl animated:YES completion:nil];
//            }
//
//            break;
//        }
//        default:
//        {
//            // not much we can do here
//        }
//    }
}
@end
