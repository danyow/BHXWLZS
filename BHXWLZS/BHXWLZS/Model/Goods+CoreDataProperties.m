//
//  Goods+CoreDataProperties.m
//  
//
//  Created by Danyow.Ed on 2017/1/21.
//
//  This file was automatically generated and should not be edited.
//

#import "Goods+CoreDataProperties.h"

@implementation Goods (CoreDataProperties)

+ (NSFetchRequest<Goods *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Goods"];
}

@dynamic amount;
@dynamic name;
@dynamic weight;
@dynamic row;
@dynamic prices;

@end
