//
//  Scan+CoreDataProperties.m
//  CastPrint Scanner
//
//  Created by Maija Obrumane on 10/12/2018.
//  Copyright © 2018 Occipital. All rights reserved.
//
//

#import "Scan+CoreDataProperties.h"

@implementation Scan (CoreDataProperties)

+ (NSFetchRequest<Scan *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Scan"];
}

@dynamic name;
@dynamic date;
@dynamic scanObj;
@dynamic scanImg;
@dynamic scanObjFilled;
@dynamic sent;

@end
