/*
  This file is part of the Structure SDK.
  Copyright © 2016 Occipital, Inc. All rights reserved.
  http://structure.io
*/

#import "ScanViewController.h"
#import "ScanViewController+Camera.h"
#import "ScanViewController+Sensor.h"
#import "ScanViewController+SLAM.h"
#import "ScanViewController+OpenGL.h"

#import <Structure/Structure.h>
#import <Structure/StructureSLAM.h>

@implementation ScanViewController (Sensor)

#pragma mark -  Structure Sensor delegates

- (void)sensorDidConnect
{
    NSLog(@"[Structure] Sensor connected!");
    
    if ([self currentStateNeedsSensor])
        [self.delegate connectToStructureSensorAndStartStreaming:true];
}

- (void)sensorDidLeaveLowPowerMode
{
    _structureSensorStatus.sensorStatus = StructureSensorStatus::SensorStatusNeedsUserToConnect;
    [self updateSensorStatusMessage];
}

- (void)sensorBatteryNeedsCharging
{
    // Notify the user that the sensor needs to be charged.
    _structureSensorStatus.sensorStatus = StructureSensorStatus::SensorStatusNeedsUserToCharge;
    [self updateSensorStatusMessage];
}

- (void)sensorDidStopStreaming:(STSensorControllerDidStopStreamingReason)reason
{
    if (reason == STSensorControllerDidStopStreamingReasonAppWillResignActive)
    {
        [self stopColorCamera];
        NSLog(@"[Structure] Stopped streaming because the app will resign its active state.");
    }
    else
    {
        NSLog(@"[Structure] Stopped streaming for an unknown reason.");
    }
}

- (void)sensorDidDisconnect
{
    // If we receive the message while in background, do nothing. We'll check the status when we
    // become active again.
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
        return;
    
    NSLog(@"[Structure] Sensor disconnected!");
    
    // Reset the scan on disconnect, since we won't be able to recover afterwards.
    if (_slamState->scannerState == ScannerStateScanning)
    {
        [self resetButtonPressed:self];
    }
    
    if (_useColorCamera)
        [self stopColorCamera];
    
    // We only show the app status when we need sensor
    if ([self currentStateNeedsSensor])
    {
        _structureSensorStatus.sensorStatus = StructureSensorStatus::SensorStatusNeedsUserToConnect;
        [self updateSensorStatusMessage];
    }
    
    if (_calibrationOverlay)
        _calibrationOverlay.hidden = true;
    
    [self updateIdleTimer];
}


- (void)connectToStructureSensorAndStartStreaming:(bool) startStream
                     andSensorControllerConnected:(bool) connected
{
    if (connected)
    {
        // Update the app status message.
        _structureSensorStatus.sensorStatus = StructureSensorStatus::SensorStatusOk;
        [self updateSensorStatusMessage];
        
        if (startStream) {
            // Even though _useColorCamera was set in viewDidLoad by asking if an approximate calibration is guaranteed,
            // it's still possible that the Structure Sensor that has just been plugged in has a custom or approximate calibration
            // that we couldn't have known about in advance.
            
            STCalibrationType calibrationType = [_sensorController calibrationType];
            
            //        _useColorCamera =
            //               calibrationType == STCalibrationTypeApproximate
            //            || calibrationType == STCalibrationTypeDeviceSpecific;
            
            if (!_useColorCamera)
            {
                // Disable both the new tracker and its UI switch, since there is no color camera input.
                _options.depthAndColorTrackerIsOn = false;
                
                // Disable both the high resolution coloring and its UI switch, since there is no color camera input.
                _options.highResColoring = false;
                
                // If we can't use the color camera, then don't try to use registered depth.
                _options.useHardwareRegisteredDepth = false;
            }
            
            // Reset the SLAM pipeline.
            // This will also synchronize the UI switches states from the dynamic option values.
            [self onSLAMOptionsChanged];
            
//            // Update the app status message.
//            _appStatus.sensorStatus = AppStatus::SensorStatusOk;
//            [self updateSensorStatusMessage];
            
            // Start streaming depth data.
            [self startStructureSensorStreaming];
        }
    }
    else
    {
        _structureSensorStatus.sensorStatus = StructureSensorStatus::SensorStatusNeedsUserToConnect;
        [self updateSensorStatusMessage];
    }
    
    [self updateIdleTimer];
}

- (void)startStructureSensorStreaming
{
    if (![self.delegate isStructureConnectedAndCharged])
        return;
    
    // Tell the driver to start streaming.
    NSError *error = nil;
    BOOL optionsAreValid = FALSE;
    if (_useColorCamera)
    {
        // We can use either registered or unregistered depth.
        _structureStreamConfig = _options.useHardwareRegisteredDepth ? STStreamConfigRegisteredDepth320x240 : STStreamConfigDepth320x240;
        
        if (_options.useHardwareRegisteredDepth)
        {
            // We are using the color camera, so let's make sure the depth gets synchronized with it.
            // If we use registered depth, we also need to specify a fixed lens position value for the color camera.
            optionsAreValid = [_sensorController startStreamingWithOptions:@{kSTStreamConfigKey : @(_structureStreamConfig),
                                                                             kSTFrameSyncConfigKey : @(STFrameSyncDepthAndRgb),
                                                                             kSTColorCameraFixedLensPositionKey: @(_options.lensPosition)}
                                                                     error:&error];
        }
        else
        {
            // We are using the color camera, so let's make sure the depth gets synchronized with it.
            optionsAreValid = [_sensorController startStreamingWithOptions:@{kSTStreamConfigKey : @(_structureStreamConfig),
                                                                             kSTFrameSyncConfigKey : @(STFrameSyncDepthAndRgb)}
                                                                     error:&error];
        }
        
        [self startColorCamera];
    }
    else
    {
        _structureStreamConfig = STStreamConfigDepth320x240;
        
        optionsAreValid = [_sensorController startStreamingWithOptions:@{kSTStreamConfigKey : @(_structureStreamConfig),
                                                                         kSTFrameSyncConfigKey : @(STFrameSyncOff)} error:&error];
    }
    
    if (!optionsAreValid)
    {
        NSLog(@"Error during streaming start: %s", [[error localizedDescription] UTF8String]);
        return;
    }
    
    NSLog(@"[Structure] Streaming started.");
    
    // Notify and initialize streaming dependent objects.
    [self onStructureSensorStartedStreaming];
}

- (void)onStructureSensorStartedStreaming
{
    STCalibrationType calibrationType = [_sensorController calibrationType];
    
    // The Calibrator app will be updated to support future iPads, and additional attachment brackets will be released as well.
    const bool deviceIsLikelySupportedByCalibratorApp = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    // Only present the option to switch over to the Calibrator app if the sensor doesn't already have a device specific
    // calibration and the app knows how to calibrate this iOS device.
    if (calibrationType != STCalibrationTypeDeviceSpecific && deviceIsLikelySupportedByCalibratorApp)
    {
        if (!_calibrationOverlay)
        {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            _calibrationOverlay = [CalibrationOverlay calibrationOverlaySubviewOf:self.view
                                                                         atCenter:CGPointMake(screenBounds.size.width / 2,
                                                                                              screenBounds.size.height - 64)];
        }
        else
        {
            _calibrationOverlay.hidden = false;
        }
    }
    else
    {
        if (_calibrationOverlay)
            _calibrationOverlay.hidden = true;
    }
    
    if (!_slamState->initialized)
        [self setupSLAM];
}

- (void)sensorDidOutputSynchronizedDepthFrame:(STDepthFrame*)depthFrame
                                   colorFrame:(STColorFrame*)colorFrame
{
    if (_slamState->initialized)
    {
        [self processDepthFrame:depthFrame colorFrameOrNil:colorFrame];
        // Scene rendering is triggered by new frames to avoid rendering the same view several times.
        [self renderSceneForDepthFrame:depthFrame colorFrameOrNil:colorFrame];
    }
}

- (void)sensorDidOutputDepthFrame:(STDepthFrame *)depthFrame
{
    if (_slamState->initialized)
    {
        [self processDepthFrame:depthFrame colorFrameOrNil:nil];
        // Scene rendering is triggered by new frames to avoid rendering the same view several times.
        [self renderSceneForDepthFrame:depthFrame colorFrameOrNil:nil];
    }
}

@end
