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
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"

@interface SavedMeshViewController : UIViewController <SCNSceneRendererDelegate, MFMailComposeViewControllerDelegate>
{
//    AppDelegate *_appDelegate;
//    NSManagedObjectContext *_context;
    NSFileManager *_fileManager;
}

@property (weak, nonatomic) IBOutlet UILabel *scanDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet SCNView *scanSceneView;
@property (weak, nonatomic) IBOutlet UISwitch *holeFillingSwitch;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

+ (instancetype)viewController;

@property (nonatomic) NSManagedObject *scanObj;
@property (nonatomic) SCNNode *objectNode;


//- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)backButtonPushed:(id)sender;
- (IBAction)holeFillingSwitchChanged:(id)sender;
- (IBAction)deleteButtonPushed:(id)sender;
- (IBAction)emailButtonPushed:(id)sender;


@end
