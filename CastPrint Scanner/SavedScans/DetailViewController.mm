//
//  DetailViewController.m
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 11/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"


@interface DetailViewController ()
{}

@end

@implementation DetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scansCollectionView.delegate = self;
    _cacheDirectory = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
    [self setupSavedMeshViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scansCollectionView reloadData];
}

- (void)setupSavedMeshViewController
{
    _savedMeshViewController = [SavedMeshViewController viewController];
}

#pragma mark - ScanTableViewDelegate

- (void)setSelectedDateScans: (NSMutableArray *)dateScanArray
{
    NSLog(@"%@", dateScanArray);
    _scansArray = dateScanArray;
    [self.scansCollectionView reloadData];
}

- (void)emptySelectedDetails
{
     _scansArray = nil;
    [self.scansCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _scansArray.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ScanDetailsCell";
    ScanDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSManagedObject *scanObj = [self.scansArray objectAtIndex:indexPath.row];
    
    // label
    [cell.scanLabel setText:[scanObj valueForKey:@"name"]];
    // image
    NSString *imgPath = [_cacheDirectory stringByAppendingPathComponent:[[scanObj valueForKey:@"scanImg"] path]];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    [cell.scanImageView setImage:image];
    // datetime
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *savingTimeString = [dateFormatter stringFromDate:[scanObj valueForKey:@"date"]];
    [cell.scanDateLabel setText:savingTimeString];
    
    cell.backgroundColor = [UIColor grayColor];
    
    return cell; 
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *selected = [self.scansArray objectAtIndex:indexPath.row];
    NSLog(@"selected=%@", selected);
    _savedMeshViewController.scanObj = [self.scansArray objectAtIndex:indexPath.row];
    [self presentViewController:_savedMeshViewController animated:YES completion:NULL];
}

@end
