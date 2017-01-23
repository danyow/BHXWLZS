//
//  UserData+CoreDataProperties.m
//  
//
//  Created by Danyow.Ed on 2017/1/23.
//
//  This file was automatically generated and should not be edited.
//

#import "UserData+CoreDataProperties.h"

@implementation UserData (CoreDataProperties)

+ (NSFetchRequest<UserData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
}

@dynamic exempt;
@dynamic selectedCity;

@end
