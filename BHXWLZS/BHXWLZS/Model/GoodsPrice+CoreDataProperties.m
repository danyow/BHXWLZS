//
//  GoodsPrice+CoreDataProperties.m
//  
//
//  Created by Danyow.Ed on 2017/1/21.
//
//  This file was automatically generated and should not be edited.
//

#import "GoodsPrice+CoreDataProperties.h"

@implementation GoodsPrice (CoreDataProperties)

+ (NSFetchRequest<GoodsPrice *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GoodsPrice"];
}

@dynamic price;
@dynamic priceInfo;
@dynamic whichGoods;

@end
