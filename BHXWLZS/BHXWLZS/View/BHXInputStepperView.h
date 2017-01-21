//
//  BHXInputStepperView.h
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHXInputStepperView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) void (^textFieldChangeBlock)(NSInteger number, BOOL quickChange);

@end
