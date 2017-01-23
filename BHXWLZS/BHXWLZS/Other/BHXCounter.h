//
//  BHXCounter.h
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/22.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHXCounter : NSObject

@property (nonatomic, strong) NSNumber *actualPrice;
@property (nonatomic, strong) NSNumber *retailPrice;
@property (nonatomic, strong) NSNumber *freight;

@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger exempt;

@property (nonatomic, copy) void (^didCounter)();

+ (instancetype)shareCounter;
- (void)startCounter;

@end
