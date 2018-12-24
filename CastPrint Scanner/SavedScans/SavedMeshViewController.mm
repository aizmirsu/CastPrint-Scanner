//
//  SavedMeshViewController.m
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 12/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SavedMeshViewController.h"

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
    [_scanNameLabel setText:[_scanObj valueForKey:@"name"]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    // append a file name to it
    
    documentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[_scanObj valueForKey:@"scanObj"] path]]];
    MDLAsset *asset = [[MDLAsset alloc]initWithURL:documentsURL];
    _objectNode = [SCNNode nodeWithMDLObject:[asset objectAtIndex:0]];

    
    
    
    // create a new scene
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    SCNScene *scene = [SCNScene scene];
//    SCNScene *scene = _scanSceneView.scene;
//    SCNScene *scene = [SCNScene sceneWithMDLAsset:asset];
    
/* old stuff ----------------------------------------------------------------------------- */
    
    // create and add a camera to the scene
//    SCNNode *cameraNode = [SCNNode node];
//    cameraNode.camera = [SCNCamera camera];
//    cameraNode.camera.usesOrthographicProjection = true;
//    cameraNode.camera.orthographicScale = 9;
////    cameraNode.camera.zNear = 0;
////    cameraNode.camera.zFar = 3;
//    cameraNode.camera.automaticallyAdjustsZRange = true;
//    cameraNode.camera.fieldOfView = 30;
////    cameraNode.camera.focalLength;
//
//    // place the camera
//    cameraNode.position = SCNVector3Make(0.4, 0.4, -3);
//    cameraNode.rotation = SCNVector4Make(M_PI, 0, 0, M_PI);
////    cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -3);
////    [scene.rootNode addChildNode:cameraNode];
////    [scene.node addChildNode:cameraNode];
    // create and add a camera to the scene
    cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 0);
    cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -15);
    
    
//    // create and add a light to the scene
//    SCNNode *lightNode = [SCNNode node];
//    lightNode.light = [SCNLight light];
//    lightNode.light.type = SCNLightTypeOmni;
////    lightNode.light.intensity = 0;
////    lightNode.light.temperature = 0;
//
//    lightNode.position = SCNVector3Make(0, 1, 0);
////    [scene.rootNode addChildNode:lightNode];
//    [cameraNode addChildNode:lightNode];
//
//    // create and add an ambient light to the scene
//    SCNNode *ambientLightNode = [SCNNode node];
//    ambientLightNode.light = [SCNLight light];
//    ambientLightNode.light.type = SCNLightTypeAmbient;
//    ambientLightNode.light.color = [UIColor darkGrayColor];
////    [scene.rootNode addChildNode:ambientLightNode];
//    [cameraNode addChildNode:ambientLightNode];
//
//    SCNMaterial *greenMaterial = [SCNMaterial material];
//    greenMaterial.diffuse.contents = [UIColor greenColor];
////    _objectNode.geometry.firstMaterial = greenMaterial;
    
    
    // Create ambient light
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor colorWithWhite:0.50 alpha:1.0];
    // Add ambient light to scene
    [scene.rootNode addChildNode:ambientLightNode];
    // Create directional light
    SCNNode *directionalLight = [SCNNode node];
    directionalLight.light = [SCNLight light];
    directionalLight.light.type = SCNLightTypeDirectional;
    directionalLight.light.color = [UIColor colorWithWhite:0.40 alpha:1.0];
//    directionalLight.light.color = [UIColor colorWithWhite:0.40 alpha:1.0];
//    SCNLookAtConstraint *lookAt = [SCNLookAtConstraint lookAtConstraintWithTarget:_objectNode];
//    directionalLight.constraints = [NSArray arrayWithObject:lookAt];
//    directionalLight.eulerAngles = SCNVector3Make(M_PI, 0, 0);
    directionalLight.position = SCNVector3Make(0, 1, -10);
    // Add directional light
    [scene.rootNode addChildNode:directionalLight];
    
    
    SCNNode *firstLvlCam = [SCNNode node];
//    SCNNode *firstLvlObj = [SCNNode node];
    [scene.rootNode addChildNode:firstLvlCam];
//    [scene.rootNode addChildNode:firstLvlObj];
//    NSMutableArray *materialArray = [[NSMutableArray alloc] init];
    SCNMaterial *objMaterial = [SCNMaterial material];
    objMaterial.lightingModelName = SCNLightingModelPhysicallyBased;
    objMaterial.diffuse.contents = [UIColor greenColor];
    objMaterial.roughness.contents = @0.72;
    objMaterial.metalness.contents = @0.33;
//    objMaterial.doubleSided = true;
//    objMaterial.diffuse.contents = [UIColor greenColor];
//    objMaterial.c = [UIColor greenColor];
    _objectNode.geometry.firstMaterial = objMaterial;
    
//    [materialArray addObject:objMaterial];
    SCNMaterial *objMaterial2 = [SCNMaterial material];
    objMaterial2.lightingModelName = SCNLightingModelLambert;
    objMaterial2.cullMode = SCNCullModeFront;
    objMaterial2.diffuse.contents = [UIColor blueColor];
//    [materialArray addObject:objMaterial2];
//    _objectNode.geometry.materials = materialArray;
    SCNNode *node2 = [SCNNode nodeWithMDLObject:[asset objectAtIndex:0]];
    node2.geometry.firstMaterial = objMaterial2;
    
    
//    [firstLvlObj addChildNode:_objectNode];
    [firstLvlCam addChildNode: cameraNode];
//    [firstLvlCam addChildNode: ambientLightNode];
    [cameraNode addChildNode:directionalLight];
//    firstLvlCam.eulerAngles = SCNVector3Make(M_PI_4, M_PI_4*3, 0);
    
    
    
    [scene.rootNode addChildNode:_objectNode];
    [scene.rootNode addChildNode:node2];
    
//    // retrieve the ship node
//    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
//
//    // animate the 3d object
//    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // retrieve the SCNView
//    SCNView *scnView = (SCNView *)self.view;
//    SCNView *scnView = _scanSceneView;
 
/* ----------------------------------------------------------------------------- */
    
/* tapat neiet --------------------------------------------------------------
    //HANDLE PAN CAMERA
    lastWidthRatio = 0;
lastHeightRatio = 0.2;
    fingersNeededToPan = 1;
maxWidthRatioRight = 0.2;
maxWidthRatioLeft = -0.2;
maxHeightRatioXDown = 0.02;
maxHeightRatioXUp = 0.4;
    
    //HANDLE PINCH CAMERA
    pinchAttenuation = 20.0;  //1.0: very fast ---- 100.0 very slow
    lastFingersNumber = 0;
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    //Create a camera like Rickster said
    camera = [SCNCamera camera];
    camera.usesOrthographicProjection = true;
    camera.orthographicScale = 9;
    camera.automaticallyAdjustsZRange = YES;
//    camera.zNear = 1;
//    camera.zFar = 100;
    
    cameraNode = [SCNNode node];
//    cameraNode.position = SCNVector3Make(0, 0, 50);
    cameraNode.position = SCNVector3Make(0, 0, 0);
    cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -15);
    cameraNode.camera = camera;
    SCNNode *cameraOrbit = [SCNNode node];
    [cameraOrbit addChildNode:cameraNode];
    [scene.rootNode addChildNode:cameraOrbit];
    
    //initial camera setup
    cameraOrbit.eulerAngles = SCNVector3Make((-M_PI) * lastHeightRatio,  (-2 * M_PI) * lastWidthRatio, 0);
//    cameraOrbit.eulerAngles.y = (-2 * M_PI) * lastWidthRatio;
//    cameraOrbit.eulerAngles.x = (float)(-M_PI) * lastHeightRatio;
    
    // retrieve the SCNView
//    SCNView *scnView = _scanSceneView;
    
    // set the scene to the view
    _scanSceneView.scene = scene;
    
    //allows the user to manipulate the camera
    _scanSceneView.allowsCameraControl = false;  //not needed
    
    // add a tap gesture recognizer
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_scanSceneView addGestureRecognizer:panGesture];
    
    ----------------------------------------------------------------------------- */
    
    // add a pinch gesture recognizer
//    let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
//    scnView.addGestureRecognizer(pinchGesture)
    
    // set the scene to the view
    _scanSceneView.scene = scene;

////    _scanSceneView.pointOfView.camera.screenSpaceAmbientOcclusionIntensity = 1.7;
////    _scanSceneView.pointOfView.camera.screenSpaceAmbientOcclusionNormalThreshold = 0.1;
////    _scanSceneView.pointOfView.camera.screenSpaceAmbientOcclusionDepthThreshold = 0.08;
////    _scanSceneView.pointOfView.camera.screenSpaceAmbientOcclusionBias = 0.33;
////    _scanSceneView.pointOfView.camera.screenSpaceAmbientOcclusionRadius = 3.0;
////    [_scanSceneView.pointOfView addChildNode:directionalLight];
//
//    // allows the user to manipulate the camera
    _scanSceneView.allowsCameraControl = YES;
//
////    _scanSceneView.autoenablesDefaultLighting = YES;
//
//    // show statistics such as fps and timing information
    _scanSceneView.showsStatistics = YES;
//
//    // configure the view
    _scanSceneView.backgroundColor = [UIColor lightGrayColor];
//
//    // add a tap gesture recognizer
////    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    NSMutableArray *gestureRecognizers = [NSMutableArray array];
//    [gestureRecognizers addObject:panGesture];
////    [gestureRecognizers addObject:tapGesture];
////    [gestureRecognizers addObjectsFromArray:_scanSceneView.gestureRecognizers];
//    _scanSceneView.gestureRecognizers = gestureRecognizers;
//    _scanSceneView.delegate = self;
//    _scanSceneView.playing = true;

    
    
}
//-(void)handlePan:(UIPanGestureRecognizer *)gestureRecognize{
//    slideVelocity = [gestureRecognize velocityInView:_scanSceneView];
//}
//
//-(void)renderer:(id<SCNSceneRenderer>)aRenderer didRenderScene:(SCNScene *)scenie atTime:(NSTimeInterval)time {
//    float viewSlideDivisor = 500;
//    //spin the camera according the the user's swipes
//    SCNQuaternion oldRot = cameraNode.rotation;  //get the current rotation of the camera as a quaternion
//    GLKQuaternion rot = GLKQuaternionMakeWithAngleAndAxis(oldRot.w, oldRot.x, oldRot.y, oldRot.z);  //make a GLKQuaternion from the SCNQuaternion
//
//
//    //The next function calls take these parameters: rotationAngle, xVector, yVector, zVector
//    //The angle is the size of the rotation (radians) and the vectors define the axis of rotation
//    GLKQuaternion rotX = GLKQuaternionMakeWithAngleAndAxis(-slideVelocity.x/viewSlideDivisor, 0, 1, 0); //For rotation when swiping with X we want to rotate *around* y axis, so if our vector is 0,1,0 that will be the y axis
//    GLKQuaternion rotY = GLKQuaternionMakeWithAngleAndAxis(-slideVelocity.y/viewSlideDivisor, 1, 0, 0); //For rotation by swiping with Y we want to rotate *around* the x axis.  By the same logic, we use 1,0,0
//    GLKQuaternion netRot = GLKQuaternionMultiply(rotX, rotY); //To combine rotations, you multiply the quaternions.  Here we are combining the x and y rotations
//    rot = GLKQuaternionMultiply(rot, netRot); //finally, we take the current rotation of the camera and rotate it by the new modified rotation.
//
//    //Then we have to separate the GLKQuaternion into components we can feed back into SceneKit
//    GLKVector3 axis = GLKQuaternionAxis(rot);
//    float angle = GLKQuaternionAngle(rot);
//
//    //finally we replace the current rotation of the camera with the updated rotation
//    cameraNode.rotation = SCNVector4Make(axis.x, axis.y, axis.z, angle);
//
//    //This specific implementation uses velocity.  If you don't want that, use the rotation method above just replace slideVelocity.
//    //decrease the slider velocity
//    if (slideVelocity.x > -0.1 && slideVelocity.x < 0.1) {
//        slideVelocity.x = 0;
//    }
//    else {
//        slideVelocity.x += (slideVelocity.x > 0) ? -1 : 1;
//    }
//
//    if (slideVelocity.y > -0.1 && slideVelocity.y < 0.1) {
//        slideVelocity.y = 0;
//    }
//    else {
//        slideVelocity.y += (slideVelocity.y > 0) ? -1 : 1;
//    }
//}


-(void)dismissView
{
    _scanObj = nil;
    _scanDateLabel.text = @"";
    _scanNameLabel.text = @"";
    
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

@end
