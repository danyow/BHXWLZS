//
//  City+CoreDataProperties.h
//  
//
//  Created by Danyow.Ed on 2017/1/22.
//
//  This file was automatically generated and should not be edited.
//

#import "City+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t row;
@property (nullable, nonatomic, retain) Rule *whichRule;

@end

NS_ASSUME_NONNULL_END
