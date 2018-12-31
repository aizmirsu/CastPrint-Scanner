//
//  SavedMeshViewController.m
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 12/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SavedMeshViewController.h"
#import "TableViewController.h"
#import <ZipZap/ZipZap.h>

@interface SavedMeshViewController ()
{
    CGPoint slideVelocity;
    SCNNode *cameraNode;
    SCNCamera *camera;
    //HANDLE PAN CAMERA
    float lastWidthRatio ;
    float lastHeightRatio;
    int fingersNeededToPan;
    float maxWidthRatioRight;
    float maxWidthRatioLeft;
    float maxHeightRatioXDown;
    float maxHeightRatioXUp;
    
    //HANDLE PINCH CAMERA
    float pinchAttenuation;
    int lastFingersNumber;
}

@property MFMailComposeViewController *mailViewController;

@end

@implementation SavedMeshViewController

@synthesize scanObj = _scanObj;

+ (instancetype)viewController {
    SavedMeshViewController *vc = [[SavedMeshViewController alloc] initWithNibName:@"SavedMeshView" bundle:nil];
    return vc;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    NSString *savingTimeString = [dateFormatter stringFromDate:[_scanObj valueForKey:@"date"]];
    [_scanDateLabel setText:savingTimeString];
    [_nameInput setText:[_scanObj valueForKey:@"name"]];
    [self.holeFillingSwitch setOn:false];
    if ([_scanObj valueForKey:@"scanObjFilled"]) {
        [self.holeFillingSwitch setEnabled:YES];
    } else {
        [self.holeFillingSwitch setEnabled:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    // append a file name to it
    
    documentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[_scanObj valueForKey:@"scanObj"] path]]];
    MDLAsset *asset = [[MDLAsset alloc]initWithURL:documentsURL];
    [self drawModelObjectFromAsset:asset];
    
}

-(void)dismissView
{
    if (_scanObj)
    {
        [_scanObj setValue:_nameInput.text forKey:@"name"];
        _scanObj = nil;
    }
    _scanDateLabel.text = @"";
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setScanObj:(NSManagedObject *)scanObjRef
{
    _scanObj = scanObjRef;
    
    if (scanObjRef)
    {
        
// render or stuff
    }
}

#pragma mark -  UI Control

- (IBAction)backButtonPushed:(id)sender {
    [self dismissView];
}

- (IBAction)holeFillingSwitchChanged:(id)sender {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
     if (self.holeFillingSwitch.on)
     {
         documentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[_scanObj valueForKey:@"scanObjFilled"] path]]];
     }
     else
     {
         documentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[_scanObj valueForKey:@"scanObj"] path]]];
     }
    MDLAsset *asset = [[MDLAsset alloc]initWithURL:documentsURL];
    [self drawModelObjectFromAsset:asset];
}

- (IBAction)deleteButtonPushed:(id)sender {
    [self deleteScanData:_scanObj];
    _scanObj = nil;
    [self dismissView];
}

- (IBAction)emailButtonPushed:(id)sender {
    [self emailMesh];
}

#pragma mark - Email Mesh OBJ file

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self.mailViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)emailMesh
{
    self.mailViewController = [[MFMailComposeViewController alloc] init];
    
    if (!self.mailViewController)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"The email could not be sent."
                                                                       message:@"Please make sure an email account is properly setup on this device."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) { }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    self.mailViewController.mailComposeDelegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // Setup paths and filenames.
    NSString* cacheDirectory = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
    NSString* zipFilename = @"Model.zip";
    NSString* screenshotFilename = @"Preview.jpg";
    
    [self createModelArchive:zipFilename];
    NSString *zipPath = [cacheDirectory stringByAppendingPathComponent:zipFilename];
    
//    if (![self createModelArchive])
//    {
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"The email could not be sent."
//                                                                       message:@"There was a problem with object file archieving"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) { }];
//        
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//        return;
//    }
    
    NSString *screenshotPath = [cacheDirectory stringByAppendingPathComponent:[[self.scanObj valueForKey:@"scanImg"] path]];
    
    [self.mailViewController setSubject:@"3D Model"];
    
    NSString *messageBody = @"Dati pievienoti";
    
    [self.mailViewController setMessageBody:messageBody isHTML:NO];
    
    // Attach the Screenshot.
    [self.mailViewController addAttachmentData:[NSData dataWithContentsOfFile:screenshotPath] mimeType:@"image/jpeg" fileName:screenshotFilename];
    
    // Attach the zipped mesh.
    [self.mailViewController addAttachmentData:[NSData dataWithContentsOfFile:zipPath] mimeType:@"application/zip" fileName:zipFilename];
    
    [self presentViewController:self.mailViewController animated:YES completion:^(){}];
}

-(void)deleteScanData:(NSManagedObject*)scanObject
{
    NSError* error = nil;
    NSDate *creationDate = [scanObject valueForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *savingTimeString = [dateFormatter stringFromDate:creationDate];
    
    NSString *currentDir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
    NSString *deletableDir = [currentDir stringByAppendingPathComponent:savingTimeString];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    [_fileManager removeItemAtPath:deletableDir error:&error];
    
    if (![_fileManager fileExistsAtPath:deletableDir isDirectory:(BOOL *)true])
    {
        [context deleteObject:scanObject];
        [context save:nil];
    }
}


-(void)drawModelObjectFromAsset:(MDLAsset *)modelAsset
{
    
    _objectNode = [SCNNode nodeWithMDLObject:[modelAsset objectAtIndex:0]];
    
    
    // create a new scene
    SCNScene *scene = [SCNScene scene];
    //    SCNScene *scene = _scanSceneView.scene;
    //    SCNScene *scene = [SCNScene sceneWithMDLAsset:asset];
    
    // create and add a camera to the scene
    cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 2);
//    cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -2);
    
    // Create ambient light
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor colorWithWhite:0.3 alpha:0.9];
    // Add ambient light to scene
    [scene.rootNode addChildNode:ambientLightNode];
    // Create directional light
    SCNNode *directionalLight = [SCNNode node];
    directionalLight.light = [SCNLight light];
    directionalLight.light.type = SCNLightTypeDirectional;
    directionalLight.light.color = [UIColor colorWithWhite:0.40 alpha:1.0];
//    directionalLight.position = SCNVector3Make(0, 1, -10);
    directionalLight.orientation = SCNVector4Make(0, 0, 0, 0);
    // Add directional light
//    [scene.rootNode addChildNode:directionalLight];
    // Create directional light
    SCNNode *directionalLight2 = [SCNNode node];
    directionalLight2.light = [SCNLight light];
    directionalLight2.light.type = SCNLightTypeDirectional;
    directionalLight2.light.color = [UIColor colorWithWhite:0.40 alpha:1.0];
    directionalLight2.orientation = SCNVector4Make(0, 1, 1, 0);
    // Add directional light
//    [scene.rootNode addChildNode:directionalLight2];
    
    
    SCNNode *firstLvlCam = [SCNNode node];
    [scene.rootNode addChildNode:firstLvlCam];
    SCNMaterial *objMaterial = [SCNMaterial material];
    objMaterial.lightingModelName = SCNLightingModelPhysicallyBased;
    objMaterial.diffuse.contents = [UIColor greenColor];
    objMaterial.roughness.contents = @0.72;
    objMaterial.metalness.contents = @0.33;
    _objectNode.geometry.firstMaterial = objMaterial;
    
    SCNMaterial *objMaterial2 = [SCNMaterial material];
    objMaterial2.lightingModelName = SCNLightingModelLambert;
    objMaterial2.cullMode = SCNCullModeFront;
    objMaterial2.diffuse.contents = [UIColor blueColor];
    
    SCNNode *node2 = [SCNNode nodeWithMDLObject:[modelAsset objectAtIndex:0]];
    node2.geometry.firstMaterial = objMaterial2;
    
    
    //    [firstLvlObj addChildNode:_objectNode];
    [firstLvlCam addChildNode: cameraNode];
    //    [firstLvlCam addChildNode: ambientLightNode];
    [cameraNode addChildNode:directionalLight];
    [cameraNode addChildNode:directionalLight2];

    [scene.rootNode addChildNode:_objectNode];
    [scene.rootNode addChildNode:node2];
    
    
    // set the scene to the view
    _scanSceneView.scene = scene;
    //    // allows the user to manipulate the camera
    _scanSceneView.allowsCameraControl = YES;
    //
    ////    _scanSceneView.autoenablesDefaultLighting = YES;
    //
    //    // show statistics such as fps and timing information
    _scanSceneView.showsStatistics = NO;
    _scanSceneView.backgroundColor = [UIColor whiteColor];
        NSMutableArray *gestureRecognizers = [NSMutableArray array];
        [gestureRecognizers addObjectsFromArray:_scanSceneView.gestureRecognizers];
        _scanSceneView.gestureRecognizers = gestureRecognizers;
}

-(void)createModelArchive:(NSString *)archiveFilename
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *toCompress = [documentsDirectory stringByAppendingPathComponent:[[self.scanObj valueForKey:@"scanObj"] path]];
    
    ZZArchive* newArchive = [[ZZArchive alloc] initWithURL:[NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:archiveFilename]]
                                                   options:@{ZZOpenOptionsCreateIfMissingKey : @YES}
                                                     error:nil];
    [newArchive updateEntries:
     @[
       [ZZArchiveEntry archiveEntryWithFileName:@"Model.obj"
                                       compress:YES
                                      dataBlock:^(NSError** error)
        {
            return [NSData dataWithContentsOfFile:toCompress options:NSDataReadingMappedIfSafe error:error];
        }]
       ]
                        error:nil];
    
    if ([_scanObj valueForKey:@"scanObjFilled"]) {
        
        toCompress = [documentsDirectory stringByAppendingPathComponent:[[self.scanObj valueForKey:@"scanObjFilled"] path]];
        [newArchive updateEntries:
            [newArchive.entries arrayByAddingObject:
                [ZZArchiveEntry archiveEntryWithFileName:@"FilledModel.obj"
                                                compress:YES
                                               dataBlock:^(NSError** error)
           {
               return [NSData dataWithContentsOfFile:toCompress options:NSDataReadingMappedIfSafe error:error];
           }]]
                            error:nil];
    }

}

@end
