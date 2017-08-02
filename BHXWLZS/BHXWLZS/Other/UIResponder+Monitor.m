//
//  UIResponder+Monitor.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/5/12.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "UIResponder+Monitor.h"
#import <objc/runtime.h>

@implementation UIResponder (Monitor)

//
//+(void)load{
//    
//    Method originalM = class_getInstanceMethod([self class], @selector(touchesEnded:withEvent:));
//    Method exchangeM = class_getInstanceMethod([self class], @selector(sw_touchesEnded:withEvent:));
//    method_exchangeImplementations(originalM, exchangeM);
//}
//
//- (void)sw_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%s", __FUNCTION__);
//    [self sw_touchesEnded:touches withEvent:event];
//}

@end
