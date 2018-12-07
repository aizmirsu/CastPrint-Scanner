/*
 This file is part of the Structure SDK.
 Copyright © 2016 Occipital, Inc. All rights reserved.
 http://structure.io
 */

#import "MenuViewController.h"
#import "MenuViewController+Sensor.h"

#import <Structure/Structure.h>
#import <Structure/StructureSLAM.h>

@implementation MenuViewController (Sensor)

#pragma mark -  Structure Sensor delegates

- (void)setupStructureSensor
{
    // Get the sensor controller singleton
    _sensorController = [STSensorController sharedController];
    
    // Set ourself as the delegate to receive sensor data.
    _sensorController.delegate = self;
}

#pragma mark -  Scan View Sensor delegates

- (BOOL)isStructureConnectedAndCharged
{
    return [_sensorController isConnected] && ![_sensorController isLowPower];
}

- (BOOL)isStructureConnected
{
    return [_sensorController isConnected];
}

- (SlamData *)getSlamData
{
    return &_slamState;
}

- (STSensorController *)getSensorController
{
    return _sensorController;
}

- (STSensorControllerInitStatus)connectToStructureSensorAndStartStreaming:(bool) startStream
{
    bool connected = false;
    // Try connecting to a Structure Sensor.
    STSensorControllerInitStatus result = [_sensorController initializeSensorConnection];
    
    if (result == STSensorControllerInitStatusSuccess || result == STSensorControllerInitStatusAlreadyInitialized)
    {
        connected = true;
    }
    else
    {
        switch (result)
        {
            case STSensorControllerInitStatusSensorNotFound:
                NSLog(@"[Structure] No sensor found"); break;
            case STSensorControllerInitStatusOpenFailed:
                NSLog(@"[Structure] Error: Open failed."); break;
            case STSensorControllerInitStatusSensorIsWakingUp:
                NSLog(@"[Structure] Error: Sensor still waking up."); break;
            default: {}
        }
    }
    
    [_scanViewController connectToStructureSensorAndStartStreaming:startStream andSensorControllerConnected:connected];
    
    return result;
}

#pragma mark -  Structure Sensor delegates

- (void)sensorDidConnect
{
    NSLog(@"[Structure] Sensor connected!");
    
    [_scanViewController sensorDidConnect];
    
    [self updateScanViewButtonColor];
    
//    if ([_scanViewController currentStateNeedsSensor])
//        [self connectToStructureSensorAndStartStreaming:true];
}

- (void)sensorDidLeaveLowPowerMode
{
    [_scanViewController sensorDidLeaveLowPowerMode];
    
    [self updateScanViewButtonColor];
}

- (void)sensorBatteryNeedsCharging
{
    [_scanViewController sensorBatteryNeedsCharging];
    
    [self updateScanViewButtonColor];
}

- (void)sensorDidStopStreaming:(STSensorControllerDidStopStreamingReason)reason
{
    [_scanViewController sensorDidStopStreaming:reason];
//    if (reason == STSensorControllerDidStopStreamingReasonAppWillResignActive)
//    {
//        [self stopColorCamera];
//        NSLog(@"[Structure] Stopped streaming because the app will resign its active state.");
//    }
//    else
//    {
//        NSLog(@"[Structure] Stopped streaming for an unknown reason.");
//    }
}

- (void)sensorDidDisconnect
{
    [_scanViewController sensorDidDisconnect];
    
    [self updateScanViewButtonColor];
//    // If we receive the message while in background, do nothing. We'll check the status when we
//    // become active again.
//    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
//        return;
//
//    NSLog(@"[Structure] Sensor disconnected!");
//
//    // Reset the scan on disconnect, since we won't be able to recover afterwards.
//    if (_slamState.scannerState == ScannerStateScanning)
//    {
//        [self resetButtonPressed:self];
//    }
//
//    if (_useColorCamera)
//        [self stopColorCamera];
//
//    // We only show the app status when we need sensor
//    if ([self currentStateNeedsSensor])
//    {
//        _appStatus.sensorStatus = SensorStatus::SensorStatusNeedsUserToConnect;
//        [self updateSensorStatusMessage];
//    }
//
//    if (_calibrationOverlay)
//        _calibrationOverlay.hidden = true;
//
//    [self updateIdleTimer];
}

- (void)sensorDidOutputSynchronizedDepthFrame:(STDepthFrame*)depthFrame
                                   colorFrame:(STColorFrame*)colorFrame
{
    [_scanViewController sensorDidOutputSynchronizedDepthFrame:depthFrame colorFrame:colorFrame];
}

- (void)sensorDidOutputDepthFrame:(STDepthFrame *)depthFrame
{
    [_scanViewController sensorDidOutputDepthFrame:depthFrame];
}

@end
