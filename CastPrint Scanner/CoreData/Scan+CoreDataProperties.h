//
//  Scan+CoreDataProperties.h
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 10/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//
//

#import "Scan+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Scan (CoreDataProperties)

+ (NSFetchRequest<Scan *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSURL *scanObj;
@property (nullable, nonatomic, copy) NSURL *scanImg;
@property (nullable, nonatomic, copy) NSURL *scanObjFilled;
@property (nonatomic) BOOL sent;

@end

NS_ASSUME_NONNULL_END
