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
{}

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
}

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
