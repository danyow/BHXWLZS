//
//  UIView+DrawAround.h
//  BGMSProject-d
//
//  Created by junhong.zhu@lachesis-mh.com on 2016/10/9.
//  Copyright © 2016年 联新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    DrawTop     = 912,
    DrawLeft    = 909,
    DrawBottom  = 906,
    DrawRight   = 903,
}DrawLocation;

@interface UIView (DrawAround)

- (UIView *)drawAroundViewWithLocation:(DrawLocation)location color:(UIColor *)color insets:(UIEdgeInsets)insets;
- (CAShapeLayer *)drawAroundLayerWithLocation:(DrawLocation)location color:(UIColor *)color insets:(UIEdgeInsets)insets;

@property (nonatomic, strong) CAShapeLayer *topLayer;
@property (nonatomic, strong) CAShapeLayer *leftLayer;
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *rightLayer;

@end
