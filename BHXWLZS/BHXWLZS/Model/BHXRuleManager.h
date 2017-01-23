//
//  BHXRuleManager.h
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/22.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Rule+CoreDataProperties.h"
#import "City+CoreDataProperties.h"
#import "RankPrice+CoreDataProperties.h"

@interface BHXRuleManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong) NSArray <Rule *> *allRule;

@property (nonatomic, strong) City *firstCity;

@end
