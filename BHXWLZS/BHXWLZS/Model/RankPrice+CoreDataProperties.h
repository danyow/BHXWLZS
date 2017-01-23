//
//  RankPrice+CoreDataProperties.h
//  
//
//  Created by Danyow.Ed on 2017/1/22.
//
//  This file was automatically generated and should not be edited.
//

#import "RankPrice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RankPrice (CoreDataProperties)

+ (NSFetchRequest<RankPrice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *rankPrice;
@property (nonatomic) int64_t rankWeight;
@property (nullable, nonatomic, retain) Rule *whichRule;

@end

NS_ASSUME_NONNULL_END
