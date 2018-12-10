//
//  SavedScansTableController.h
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 10/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedScansTableController : UITableViewController

@property (nonatomic, strong) NSMutableArray *players;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UITableView *scanDateTable;

- (IBAction)cancelButtonPushed:(id)sender;

@end
