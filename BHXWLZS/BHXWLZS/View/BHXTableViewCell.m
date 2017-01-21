//
//  BHXTableViewCell.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXTableViewCell.h"

#import <Masonry.h>

@interface BHXTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *inputHostView;

@end

@implementation BHXTableViewCell

#pragma mark -  life cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self prepareForSubview];
}

#pragma mark -  prive method

- (void)prepareForSubview
{
    [self.inputHostView addSubview:self.inputStepperView];
    [self.inputStepperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.inputHostView);
    }];
}

#pragma mark -  over write


#pragma mark -  lazy load

- (BHXInputStepperView *)inputStepperView
{
    if (!_inputStepperView) {
        _inputStepperView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BHXInputStepperView class]) owner:nil options:nil].lastObject;
    }
    return _inputStepperView;
}

@end
