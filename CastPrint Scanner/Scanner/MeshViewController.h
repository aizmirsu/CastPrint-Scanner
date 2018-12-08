/*
  This file is part of the Structure SDK.
  Copyright © 2016 Occipital, Inc. All rights reserved.
  http://structure.io
*/

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Structure/StructureSLAM.h>
#import "EAGLView.h"

@protocol MeshViewDelegate <NSObject>
- (void)meshViewWillDismiss;
//- (void)meshViewDidDismiss;
- (BOOL)meshViewDidRequestColorizing:(STMesh*)mesh
            previewCompletionHandler:(void(^)(void))previewCompletionHandler
           enhancedCompletionHandler:(void(^)(void))enhancedCompletionHandler;
- (void)meshViewDidRequestRegularMesh;
- (void)meshViewDidRequestHoleFilling;
@end

@interface MeshViewController : UIViewController <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>


@property (nonatomic, assign) id<MeshViewDelegate> delegate;

@property (nonatomic) BOOL needsDisplay; // force the view to redraw.
@property (nonatomic) BOOL colorEnabled;
@property (nonatomic) STMesh * mesh;

//@property UIDocumentInteractionController* documentInteractionController;

@property (weak, nonatomic) IBOutlet UILabel *meshViewerMessageLabel;
@property (weak, nonatomic) IBOutlet UISwitch *XRaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *holeFillingSwitch;

+ (instancetype)viewController;

- (IBAction)holeFillingSwitchChanged:(id)sender;
- (IBAction)XRaySwitchChanged:(id)sender;

- (void)showMeshViewerMessage:(NSString *)msg;
- (void)hideMeshViewerMessage;

- (void)setMesh:(STMesh *)meshRef;

- (void)setCameraProjectionMatrix:(GLKMatrix4)projRt;
- (void)resetMeshCenter:(GLKVector3)center;

- (void)setupGL:(EAGLContext*)context;

@end
