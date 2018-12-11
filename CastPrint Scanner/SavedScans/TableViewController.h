//
//  SavedScansTableController.h
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 10/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class DetailViewController;

@protocol ScanTableViewDelegate <NSObject>
- (void)setSelectedDateScans: (NSMutableArray *)dateScanArray;

@end

@interface TableViewController : UITableViewController
{
    AppDelegate *_appDelegate;
    NSManagedObjectContext *_context;
    
}

@property (nonatomic, assign) id<ScanTableViewDelegate> delegate;

@property (strong) NSMutableArray *scanDates;
@property (strong) NSMutableDictionary *scanDict;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UITableView *scanDateTable;

- (IBAction)cancelButtonPushed:(id)sender;

@end
