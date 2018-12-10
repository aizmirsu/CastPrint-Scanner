//
//  SavedScansTableController.m
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 10/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SavedScansTableController.h"
#import "AppDelegate.h"

#pragma mark - Table Controller Setup

@interface SavedScansTableController ()
{
    AppDelegate *_appDelegate;
    NSManagedObjectContext *_context;
    
}
@property (strong) NSMutableArray *scans;

@end

@implementation SavedScansTableController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get context
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _context = _appDelegate.persistentContainer.viewContext;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the scans from persistent data store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Scan"];
    self.scans = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.scanDateTable reloadData];
}

#pragma mark - UI Callbacks

- (IBAction)cancelButtonPushed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ScanDateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
    // Configure the cell...
        NSManagedObject *scan = [self.scans objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [scan valueForKey:@"date"], [scan valueForKey:@"name"]]];
    //    [cell.detailTextLabel setText:[scan valueForKey:@"company"]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.scans.count;
}


@end
