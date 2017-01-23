//
//  BHXRuleManager.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/22.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXRuleManager.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation BHXRuleManager

#pragma mark -  instance method

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static BHXRuleManager *instance_ = nil;
    dispatch_once(&onceToken, ^{
        instance_ = [self new];
    });
    return instance_;
}

#pragma mark -  price method

- (void)createRules
{
    [self createRuleWithName:@"一" gradeW:3000 firstP:@"6" addP:@"1" row:0
                       citys:@[@"广东",]
                      rankPs:@{@"1000" : @"6", @"2000" : @"6.5", @"3000" : @"7.5",}];
    [self createRuleWithName:@"二" gradeW:3000 firstP:@"6" addP:@"2.6" row:1
                       citys:@[@"上海", @"江苏", @"浙江", @"安徽", @"江西", @"福建", @"湖南", @"湖北", @"广西",]
                      rankPs:@{@"1000" : @"6", @"2000" : @"6.5", @"3000" : @"7.5",}];
    [self createRuleWithName:@"三" gradeW:3000 firstP:@"6" addP:@"4" row:2
                       citys:@[@"北京", @"河南", @"海南", @"山东", @"四川", @"重庆", @"贵州", @"天津",]
                      rankPs:@{@"1000" : @"6", @"2000" : @"6.5", @"3000" : @"7.5",}];
    [self createRuleWithName:@"四" gradeW:3000 firstP:@"6" addP:@"4.5" row:3
                       citys:@[@"河北", @"山西", @"陕西", @"云南", @"辽宁", @"黑龙江", @"吉林",]
                      rankPs:@{@"1000" : @"6", @"2000" : @"6.5", @"3000" : @"7.5",}];
    [self createRuleWithName:@"五" gradeW:1000 firstP:@"10" addP:@"10" row:4
                       citys:@[@"甘肃", @"青海", @"宁夏", @"内蒙",]
                      rankPs:@{@"1000" : @"10",}];
    [self createRuleWithName:@"六" gradeW:1000 firstP:@"17" addP:@"17" row:5
                       citys:@[@"新疆", @"西藏",]
                      rankPs:@{@"1000" : @"17",}];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

- (void)createRuleWithName:(NSString *)name
                    gradeW:(NSInteger)gradeW
                    firstP:(NSString *)firstP
                      addP:(NSString *)addP
                       row:(NSInteger)row
                     citys:(NSArray *)citys
                    rankPs:(NSDictionary *)rankPs
{
    Rule *rule       = [Rule MR_createEntity];
    rule.name        = name;
    rule.gradeWeight = gradeW;
    rule.firstWeight = 1000;
    rule.firstPrice  = [NSDecimalNumber decimalNumberWithString:firstP];
    rule.addWeight   = 1000;
    rule.addPrice    = [NSDecimalNumber decimalNumberWithString:addP];
    rule.row         = row;
    
    NSMutableSet *citySet = [NSMutableSet set];
    [citys enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        City *city      = [City MR_createEntity];
        city.name       = name;
        city.whichRule  = rule;
        city.row        = idx;
        [citySet addObject:city];
    }];
    rule.citys = citySet;
    
    NSMutableSet *rankSet = [NSMutableSet set];
    [rankPs enumerateKeysAndObjectsUsingBlock:^(NSString *weight, NSString *price, BOOL *stop) {
        RankPrice *rank = [RankPrice MR_createEntity];
        rank.rankWeight = [weight integerValue];
        rank.rankPrice  = [NSDecimalNumber decimalNumberWithString:price];
        rank.whichRule  = rule;
        [rankSet addObject:rank];
    }];
    rule.rankPrices = rankSet;
}

#pragma mark -  lazy load

- (NSArray *)allRule
{
    if (!_allRule) {
        _allRule = [Rule MR_findAll];
        if (_allRule.count == 0) {
            [self createRules];
            _allRule = [Rule MR_findAll];
        }
        _allRule = [_allRule sortedArrayUsingComparator:^NSComparisonResult(Rule *obj1, Rule *obj2) {
            return obj1.row > obj2.row;
        }];
    }
    return _allRule;
}

- (City *)selectedCity
{
    if (!_selectedCity) {
        __block City *city = nil;
        [self.allRule.firstObject.citys enumerateObjectsUsingBlock:^(City *obj, BOOL *stop) {
            if (obj.row == 0) {
                city = obj;
                *stop = YES;
                return ;
            }
        }];
        _selectedCity = city;
    }
    return _selectedCity;
}

@end
