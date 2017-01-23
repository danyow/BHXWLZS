//
//  UserData+CoreDataProperties.h
//  
//
//  Created by Danyow.Ed on 2017/1/23.
//
//  This file was automatically generated and should not be edited.
//

#import "UserData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserData (CoreDataProperties)

+ (NSFetchRequest<UserData *> *)fetchRequest;

@property (nonatomic) int64_t exempt;
@property (nullable, nonatomic, retain) City *selectedCity;

@end

NS_ASSUME_NONNULL_END
