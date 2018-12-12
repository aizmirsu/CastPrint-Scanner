//
//  SavedMeshViewController.h
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 12/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SavedMeshViewController : UIViewController
{
//    AppDelegate *_appDelegate;
//    NSManagedObjectContext *_context;
    NSFileManager *_fileManager;
}

@property (weak, nonatomic) IBOutlet UILabel *scanDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

+ (instancetype)viewController;

@property (nonatomic) NSManagedObject *scanObj;


//- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)backButtonPushed:(id)sender;

@end
