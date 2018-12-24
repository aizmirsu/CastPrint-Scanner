//
//  SavedMeshViewController.h
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 12/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
#import <SceneKit/SceneKit.h>
#import <GLKit/GLKit.h>
#import "AppDelegate.h"

@interface SavedMeshViewController : UIViewController <SCNSceneRendererDelegate>
{
//    AppDelegate *_appDelegate;
//    NSManagedObjectContext *_context;
    NSFileManager *_fileManager;
}

@property (weak, nonatomic) IBOutlet UILabel *scanDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet SCNView *scanSceneView;

+ (instancetype)viewController;

@property (nonatomic) NSManagedObject *scanObj;
@property (nonatomic) SCNNode *objectNode;
//@property (nonatomic) SCNNode *cameraNode;


- (IBAction)backButtonPushed:(id)sender;

@end
