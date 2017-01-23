//
//  Goods+CoreDataProperties.h
//  
//
//  Created by Danyow.Ed on 2017/1/22.
//
//  This file was automatically generated and should not be edited.
//

#import "Goods+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Goods (CoreDataProperties)

+ (NSFetchRequest<Goods *> *)fetchRequest;

@property (nonatomic) int64_t amount;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t row;
@property (nonatomic) double weight;
@property (nullable, nonatomic, retain) NSSet<GoodsPrice *> *prices;

@end

@interface Goods (CoreDataGeneratedAccessors)

- (void)addPricesObject:(GoodsPrice *)value;
- (void)removePricesObject:(GoodsPrice *)value;
- (void)addPrices:(NSSet<GoodsPrice *> *)values;
- (void)removePrices:(NSSet<GoodsPrice *> *)values;

@end

NS_ASSUME_NONNULL_END
