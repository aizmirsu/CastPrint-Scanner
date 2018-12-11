//
//  UITableView+SavedScansDetailViewController.h
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 11/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h" //UISplitViewControllerDelegate
#import "ScanDetailsCell.h"

@interface DetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, ScanTableViewDelegate>
{}

@property (weak, nonatomic) IBOutlet UICollectionView *scansCollectionView;

@property (strong) NSMutableArray *scansArray;

@end
