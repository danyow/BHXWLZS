//
//  UIView+DrawAround.m
//  BGMSProject-d
//
//  Created by junhong.zhu@lachesis-mh.com on 2016/10/9.
//  Copyright © 2016年 联新. All rights reserved.
//

#import "UIView+DrawAround.h"
#import <objc/runtime.h>

@implementation UIView (DrawAround)


- (UIView *)drawAroundViewWithLocation:(DrawLocation)location color:(UIColor *)color insets:(UIEdgeInsets)insets
{
    UIView *view;
    if ([self viewWithTag:location]) {
        view = [self viewWithTag:location];
    } else {
        view = [[UIView alloc] init];
    }
    view.backgroundColor = color;
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    switch (location) {
        case DrawTop:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:insets.top]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:insets.left]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:insets.right]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:insets.bottom + 1]];
            
//            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.leading.trailing.mas_equalTo(insets);
//                make.height.equalTo(@(1 + insets.bottom));
//            }];
            break;
        case DrawLeft:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:insets.top]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:insets.left]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:insets.bottom]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:insets.right + 1]];
//            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.leading.bottom.mas_equalTo(insets);
//                make.width.equalTo(@(1 + insets.right));
//            }];
            break;
        case DrawBottom:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:insets.right]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:insets.left]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:insets.bottom]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:insets.top + 1]];

//            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.trailing.leading.bottom.mas_equalTo(insets);
//                make.height.equalTo(@(1 + insets.top));
//            }];
            break;
        case DrawRight:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:insets.top]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:insets.right]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:insets.bottom]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:insets.left + 1]];
//            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.trailing.bottom.mas_equalTo(insets);
//                make.width.equalTo(@(1 + insets.left));
//            }];
            
            break;
        default:
            break;
    }
    view.tag = location;
    return view;
}


- (CAShapeLayer *)drawAroundLayerWithLocation:(DrawLocation)location color:(UIColor *)color insets:(UIEdgeInsets)insets
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    switch (location) {
        case DrawTop:
            [self.topLayer removeFromSuperlayer];
            self.topLayer = layer;
            [path moveToPoint:CGPointMake(insets.left, insets.top)];
            [path addLineToPoint:CGPointMake(width - insets.right, insets.top)];
            layer.lineWidth = insets.bottom + 1;
            break;
        case DrawLeft:
            [self.leftLayer removeFromSuperlayer];
            self.leftLayer = layer;
            [path moveToPoint:CGPointMake(insets.left, insets.top)];
            [path addLineToPoint:CGPointMake(insets.left, height - insets.bottom)];
            layer.lineWidth = insets.right + 1;
            break;
        case DrawBottom:
            [self.bottomLayer removeFromSuperlayer];
            self.bottomLayer = layer;
            [path moveToPoint:CGPointMake(insets.left, height - insets.bottom)];
            [path addLineToPoint:CGPointMake(width - insets.right, height - insets.bottom)];
            layer.lineWidth = insets.top + 1;
            break;
        case DrawRight:
            [self.rightLayer removeFromSuperlayer];
            self.rightLayer = layer;
            [path moveToPoint:CGPointMake(width - insets.right, insets.top)];
            [path addLineToPoint:CGPointMake(width - insets.right, height - insets.bottom)];
            layer.lineWidth = insets.left + 1;
            break;
        default:
            break;
    }
    
    layer.path = path.CGPath;
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
    return layer;
}
//{
//    CAShapeLayer *layer;
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    CGFloat width  = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//    switch (location) {
//        case DrawTop:
//            if ([self.layer.sublayers containsObject:self.topLayer]) {
//                layer = self.topLayer;
//            } else {
//                layer = [[CAShapeLayer alloc] init];
//                self.topLayer = layer;
//            }
//            [path moveToPoint:CGPointMake(insets.left, insets.top)];
//            [path addLineToPoint:CGPointMake(width - insets.right, insets.top)];
//            layer.lineWidth = insets.bottom + 1;
//            break;
//        case DrawLeft:
//            if ([self.layer.sublayers containsObject:self.leftLayer]) {
//                layer = self.leftLayer;
//            } else {
//                layer = [[CAShapeLayer alloc] init];
//                self.leftLayer = layer;
//            }
//            [path moveToPoint:CGPointMake(insets.left, insets.top)];
//            [path addLineToPoint:CGPointMake(insets.left, height - insets.bottom)];
//            layer.lineWidth = insets.right + 1;
//            break;
//        case DrawBottom:
//            if ([self.layer.sublayers containsObject:self.bottomLayer]) {
//                layer = self.bottomLayer;
//            } else {
//                layer = [[CAShapeLayer alloc] init];
//                self.bottomLayer = layer;
//            }
//            [path moveToPoint:CGPointMake(insets.left, height - insets.bottom)];
//            [path addLineToPoint:CGPointMake(width - insets.right, height - insets.bottom)];
//            layer.lineWidth = insets.top + 1;
//            break;
//        case DrawRight:
//            if ([self.layer.sublayers containsObject:self.rightLayer]) {
//                layer = self.rightLayer;
//            } else {
//                layer = [[CAShapeLayer alloc] init];
//                self.rightLayer = layer;
//            }
//            [path moveToPoint:CGPointMake(width - insets.right, insets.top)];
//            [path addLineToPoint:CGPointMake(width - insets.right, height - insets.bottom)];
//            layer.lineWidth = insets.left + 1;
//            break;
//        default:
//            break;
//    }
//    
//    layer.path = path.CGPath;
//    layer.strokeColor = color.CGColor;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    [self.layer addSublayer:layer];
//    return layer;
//}

static void *top_layer_key = &top_layer_key;
- (void)setTopLayer:(CAShapeLayer *)topLayer
{
    objc_setAssociatedObject(self, top_layer_key, topLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)topLayer
{
    return objc_getAssociatedObject(self, top_layer_key);
}

static void *left_layer_key = &left_layer_key;
- (void)setLeftLayer:(CAShapeLayer *)leftLayer
{
    objc_setAssociatedObject(self, left_layer_key, leftLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)leftLayer
{
    return objc_getAssociatedObject(self, left_layer_key);
}

static void *bottom_layer_key = &bottom_layer_key;
- (void)setBottomLayer:(CAShapeLayer *)bottomLayer
{
    objc_setAssociatedObject(self, bottom_layer_key, bottomLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)bottomLayer
{
    return objc_getAssociatedObject(self, bottom_layer_key);
}

static void *right_layer_key = &right_layer_key;
- (void)setRightLayer:(CAShapeLayer *)rightLayer
{
    objc_setAssociatedObject(self, right_layer_key, rightLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)rightLayer
{
    return objc_getAssociatedObject(self, right_layer_key);
}


@end
