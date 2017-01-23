//
//  BHXGoodsManager.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXGoodsManager.h"

NSString *BHXGoodsAPartnerPrice = @"高级合伙人";
NSString *BHXGoodsBPartnerPrice = @"中级合伙人";
NSString *BHXGoodsCPartnerPrice = @"初级合伙人";
NSString *BHXGoodsRetailPrice   = @"零售";

#define MR_SHORTHAND

@implementation BHXGoodsManager

#pragma mark -  instance method

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static BHXGoodsManager *instance_ = nil;
    dispatch_once(&onceToken, ^{
        instance_ = [self new];
    });
    return instance_;
}

#pragma mark -  private method

- (void)createGoods
{
    [self createGoodsWithName:@"枣夹核桃"
                       weight:258 row:0 A:@"20.0" B:@"22.0" C:@"25.0" D:@"29.0"];
    [self createGoodsWithName:@"特级和田骏枣"
                       weight:250 row:1 A:@"16.0" B:@"18.0" C:@"21.0" D:@"25.0"];
    [self createGoodsWithName:@"若羌灰枣"
                       weight:250 row:2 A:@"16.0" B:@"18.0" C:@"21.0" D:@"25.0"];
    [self createGoodsWithName:@"原色薄皮核桃"
                       weight:258 row:3 A:@"11.0" B:@"13.0" C:@"16.0" D:@"20.0"];
    [self createGoodsWithName:@"手剥巴旦木"
                       weight:235 row:4 A:@"16.0" B:@"18.0" C:@"21.0" D:@"25.0"];
    [self createGoodsWithName:@"清洗黑加仑"
                       weight:280 row:5 A:@"16.0" B:@"18.0" C:@"21.0" D:@"25.0"];
    BHXSaveModel;
}

- (Goods *)createGoodsWithName:(NSString *)name weight:(double)weight row:(NSInteger)row A:(NSString *)A B:(NSString *)B C:(NSString *)C D:(NSString *)D
{
    return [self createGoodsWithName:name weight:weight
                                 row:row pricesDict:@{self.priceInfos[0] : A,
                                                      self.priceInfos[1] : B,
                                                      self.priceInfos[2] : C,
                                                      self.priceInfos[3] : D,}];
}

- (Goods *)createGoodsWithName:(NSString *)name weight:(double)weight row:(NSInteger)row pricesDict:(NSDictionary *)dict
{
    Goods *goods = [Goods MR_createEntity];
    goods.name   = name;
    goods.weight = weight;
    goods.row    = row;
    NSMutableSet *set = [NSMutableSet set];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        GoodsPrice *price = [GoodsPrice MR_createEntity];
        price.priceInfo   = key;
        price.price       = [NSDecimalNumber decimalNumberWithString:obj];
        price.whichGoods  = goods;
        [set addObject:price];
    }];
    goods.prices = set;
    return goods;
}

#pragma mark -  lazy load

- (NSArray<Goods *> *)allGoods
{
    if (!_allGoods) {
        
        NSString *firstKey = @"firstUsedAppToCreatDefaultGoods";
        BOOL used          = [[NSUserDefaults standardUserDefaults] boolForKey:firstKey];
        if(!used){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self createGoods];
        }
        _allGoods = [Goods MR_findAll];
        _allGoods = [_allGoods sortedArrayUsingComparator:^NSComparisonResult(Goods *obj1, Goods *obj2) {
            return obj1.row > obj2.row;
        }];
    }
    return _allGoods;
}

- (NSArray *)priceInfos
{
    if (!_priceInfos) {
        _priceInfos = @[BHXGoodsAPartnerPrice,
                        BHXGoodsBPartnerPrice,
                        BHXGoodsCPartnerPrice,
                        BHXGoodsRetailPrice];
    }
    return _priceInfos;
}

- (NSString *)selectedPriceInfo
{
    if (!_selectedPriceInfo) {
        _selectedPriceInfo = self.priceInfos.firstObject;
    }
    return _selectedPriceInfo;
}

@end
