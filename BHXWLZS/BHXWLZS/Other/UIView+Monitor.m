//
//  UIView+Monitor.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/5/12.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "UIView+Monitor.h"

#import <objc/runtime.h>

@implementation UIView (Monitor)

//+(void)load{
//    
//    Method originalMT = class_getInstanceMethod([self class], @selector(touchesEnded:withEvent:));
//    Method exchangeMT = class_getInstanceMethod([self class], @selector(sw_touchesEnded:withEvent:));
//    method_exchangeImplementations(originalMT, exchangeMT);
//    
//    Method originalMH = class_getInstanceMethod([self class], @selector(hitTest:withEvent:));
//    Method exchangeMH = class_getInstanceMethod([self class], @selector(sw_hitTest:withEvent:));
//    method_exchangeImplementations(originalMH, exchangeMH);
//}
//
//- (void)sw_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%s", __FUNCTION__);
//    [self sw_touchesEnded:touches withEvent:event];
//}
//
//- (UIView *)sw_hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"%s", __FUNCTION__);
//    return [self sw_hitTest:point withEvent:event];
//}

@end
