/*
  This file is part of the Structure SDK.
  Copyright © 2016 Occipital, Inc. All rights reserved.
  http://structure.io
*/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define HAS_LIBCXX

#import "ScanViewController.h"
#import <Structure/Structure.h>
#import <Structure/StructureSLAM.h>

#import "MeshViewController.h"

@interface ScanViewController (Sensor) //<STSensorControllerDelegate>


//- (STSensorControllerInitStatus)connectToStructureSensorAndStartStreaming:(bool) startStream;
//- (void)setupStructureSensor;
//- (BOOL)isStructureConnectedAndCharged;

- (void)sensorDidConnect;
- (void)sensorDidLeaveLowPowerMode;
- (void)sensorBatteryNeedsCharging;
- (void)sensorDidStopStreaming:(STSensorControllerDidStopStreamingReason)reason;
- (void)sensorDidDisconnect;
- (void)sensorDidOutputSynchronizedDepthFrame:(STDepthFrame*)depthFrame
                                   colorFrame:(STColorFrame*)colorFrame;
- (void)sensorDidOutputDepthFrame:(STDepthFrame *)depthFrame;
- (void)connectToStructureSensorAndStartStreaming:(bool) startStream
                     andSensorControllerConnected:(bool) connected;

@end
