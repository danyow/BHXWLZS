//
//  RankPrice+CoreDataProperties.m
//  
//
//  Created by Danyow.Ed on 2017/1/22.
//
//  This file was automatically generated and should not be edited.
//

#import "RankPrice+CoreDataProperties.h"

@implementation RankPrice (CoreDataProperties)

+ (NSFetchRequest<RankPrice *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RankPrice"];
}

@dynamic rankPrice;
@dynamic rankWeight;
@dynamic whichRule;

@end
