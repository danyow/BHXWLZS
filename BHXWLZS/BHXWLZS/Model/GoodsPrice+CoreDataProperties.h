//
//  GoodsPrice+CoreDataProperties.h
//  
//
//  Created by Danyow.Ed on 2017/1/21.
//
//  This file was automatically generated and should not be edited.
//

#import "GoodsPrice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GoodsPrice (CoreDataProperties)

+ (NSFetchRequest<GoodsPrice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *price;
@property (nullable, nonatomic, copy) NSString *priceInfo;
@property (nullable, nonatomic, retain) Goods *whichGoods;

@end

NS_ASSUME_NONNULL_END
