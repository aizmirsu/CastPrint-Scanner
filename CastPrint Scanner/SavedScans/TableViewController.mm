//
//  SavedScansTableController.m
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 10/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewController.h"


#pragma mark - Table Controller Setup

@interface TableViewController ()
{}

@end

@implementation TableViewController

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
    self.scanDates = [[NSMutableArray alloc] init];
    self.scanDict = [[NSMutableDictionary alloc] init];
    
    // Fetch the scans from persistent data store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Scan"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSMutableArray *scanArray = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (id savedScan in scanArray)
    {
        NSDate *scannedDate = [savedScan valueForKey:@"date"];
        NSString *dateString = [NSDateFormatter localizedStringFromDate:scannedDate dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
        
        if ([self.scanDict objectForKey:dateString]) {
            NSLog(@"There's an object set for key %@", dateString);
            [[self.scanDict objectForKey:dateString] addObject:savedScan];
        } else {
            NSLog(@"No object set for key %@", dateString);
            [self.scanDates addObject:dateString];
            NSMutableArray *matchArray = [NSMutableArray arrayWithObject:savedScan];
            [self.scanDict setObject:matchArray forKey:dateString];
        }
    }
    
    NSLog(@"%@", self.scanDict);
    
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
    NSString *scanDateString = [self.scanDates objectAtIndex:indexPath.row];
    NSUInteger elements = [[self.scanDict objectForKey:[NSString stringWithFormat:@"%@", scanDateString]] count];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %lu", scanDateString, (unsigned long)elements]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.scanDates.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *scanDateString = [self.scanDates objectAtIndex:indexPath.row];
    NSLog(@"%@", scanDateString);
    [self.delegate setSelectedDateScans:[self.scanDict objectForKey:[NSString stringWithFormat:@"%@", scanDateString]]];
}


@end
