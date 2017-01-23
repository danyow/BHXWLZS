//
//  BHXCounter.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/22.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXCounter.h"
#import "BHXGoodsManager.h"
#import "BHXRuleManager.h"

@interface BHXCounter ()

@property (nonatomic, strong) BHXGoodsManager *goodsManager;
@property (nonatomic, strong) BHXRuleManager  *ruleManager;

@end

@implementation BHXCounter

+ (instancetype)shareCounter
{
    static dispatch_once_t onceToken;
    static BHXCounter *instance_ = nil;
    dispatch_once(&onceToken, ^{
        instance_ = [self new];
        instance_.exempt = instance_.userData.exempt;
    });
    return instance_;
}

- (void)startCounter
{
    self.freight     = @0;
    self.actualPrice = @0;
    self.retailPrice = @0;
    self.weight      = 0;
    self.amount      = 0;
    [self.goodsManager.allGoods enumerateObjectsUsingBlock:^(Goods *goods, NSUInteger idx, BOOL *stop) {
        __block GoodsPrice *retailPrice = nil;
        __block GoodsPrice *actualPrice = nil;
        [goods.prices enumerateObjectsUsingBlock:^(GoodsPrice *price, BOOL *stop) {
            if ([price.priceInfo isEqualToString:self.goodsManager.selectedPriceInfo]) {
                actualPrice = price;
            }
            if ([price.priceInfo isEqualToString:self.goodsManager.priceInfos.lastObject]) {
                retailPrice = price;
            }
        }];
        self.actualPrice = @(self.actualPrice.integerValue + actualPrice.price.doubleValue * goods.amount);
        self.retailPrice = @(self.retailPrice.integerValue + retailPrice.price.doubleValue * goods.amount);
        self.weight      = self.weight + goods.weight * goods.amount;
        self.amount      = self.amount + goods.amount;
    }];
    
    if (self.amount >= self.exempt || self.weight == 0) {
        self.freight = @0;
    } else {
        Rule *rule = self.userData.selectedCity.whichRule;
        if (self.weight > rule.gradeWeight) {
            self.freight = @(rule.firstPrice.doubleValue);
            self.freight = @(self.freight.doubleValue + ceil((self.weight - rule.firstWeight) / (double)rule.addWeight) * rule.addPrice.doubleValue);
        } else {
            __block RankPrice *tempRank   = nil;
            __block RankPrice *actualRank = nil;
            [rule.rankPrices enumerateObjectsUsingBlock:^(RankPrice *rankPrice, BOOL *stop) {
                if (rankPrice.rankWeight > self.weight && !tempRank) {
                    tempRank = rankPrice;
                    actualRank = rankPrice;
                } else {
                    if (tempRank.rankWeight > rankPrice.rankWeight) {
                        if (rankPrice.rankWeight > self.weight) {
                            actualRank = rankPrice;
                            tempRank   = rankPrice;
                        }
                    }
                }
            }];
            self.freight = @(actualRank.rankPrice.doubleValue);
        }
    }
    
    self.actualPrice = @(self.actualPrice.doubleValue + self.freight.doubleValue);
    self.retailPrice = @(self.retailPrice.doubleValue + self.freight.doubleValue);
    if (self.didCounter) {
        self.didCounter();
    }
}

#pragma mark -  setter

- (void)setExempt:(NSInteger)exempt
{
    _exempt = exempt;
    self.userData.exempt = exempt;
}

#pragma mark -  lazy load

- (BHXGoodsManager *)goodsManager
{
    if (!_goodsManager) {
        _goodsManager = [BHXGoodsManager shareManager];
    }
    return _goodsManager;
}

- (BHXRuleManager *)ruleManager
{
    if (!_ruleManager) {
        _ruleManager = [BHXRuleManager shareManager];
    }
    return _ruleManager;
}

- (UserData *)userData
{
    if (!_userData) {
        _userData = [UserData MR_findFirst];
        if (_userData == nil) {
            _userData = [UserData MR_createEntity];
            _userData.exempt = 3;
            _userData.selectedCity = self.ruleManager.firstCity;
            BHXSaveModel;
        }
        _userData = [UserData MR_findFirst];
    }
    return _userData;
}

@end
