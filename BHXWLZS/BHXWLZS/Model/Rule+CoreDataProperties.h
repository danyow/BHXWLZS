//
//  Rule+CoreDataProperties.h
//  
//
//  Created by Danyow.Ed on 2017/1/22.
//
//  This file was automatically generated and should not be edited.
//

#import "Rule+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Rule (CoreDataProperties)

+ (NSFetchRequest<Rule *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *addPrice;
@property (nonatomic) int64_t addWeight;
@property (nullable, nonatomic, copy) NSDecimalNumber *firstPrice;
@property (nonatomic) int64_t firstWeight;
@property (nonatomic) int64_t gradeWeight;
@property (nonatomic) int64_t row;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<City *> *citys;
@property (nullable, nonatomic, retain) NSSet<RankPrice *> *rankPrices;

@end

@interface Rule (CoreDataGeneratedAccessors)

- (void)addCitysObject:(City *)value;
- (void)removeCitysObject:(City *)value;
- (void)addCitys:(NSSet<City *> *)values;
- (void)removeCitys:(NSSet<City *> *)values;

- (void)addRankPricesObject:(RankPrice *)value;
- (void)removeRankPricesObject:(RankPrice *)value;
- (void)addRankPrices:(NSSet<RankPrice *> *)values;
- (void)removeRankPrices:(NSSet<RankPrice *> *)values;

@end

NS_ASSUME_NONNULL_END
