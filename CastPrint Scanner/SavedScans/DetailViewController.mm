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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scansCollectionView reloadData];
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
    NSManagedObject *scan = [self.scansArray objectAtIndex:indexPath.row];
    [cell.scanLabel setText:[NSString stringWithFormat:@"%@", [scan valueForKey:@"date"]]];
    NSString *imgPath = [[scan valueForKey:@"scanImg"] path];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    [cell.scanImageView setImage:image];
    cell.backgroundColor = [UIColor blueColor];
    
    return cell; 
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [self.scansArray objectAtIndex:indexPath.row];
    NSLog(@"selected=%@", selected);
}

@end
