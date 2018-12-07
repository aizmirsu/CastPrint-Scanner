/*
 This file is part of the Structure SDK.
 Copyright © 2016 Occipital, Inc. All rights reserved.
 http://structure.io
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define HAS_LIBCXX

#import "MenuViewController.h"
#import <Structure/Structure.h>
#import <Structure/StructureSLAM.h>

//#import "MeshViewController.h"

@interface MenuViewController (Sensor) <STSensorControllerDelegate, ScanViewSensorDelegate>

//- (STSensorControllerInitStatus)connectToStructureSensorAndStartStreaming:(bool) startStream;
- (void)setupStructureSensor;
//- (BOOL)isStructureConnectedAndCharged;

@end
