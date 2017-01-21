//
//  BHXInputStepperView.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXInputStepperView.h"

@interface BHXInputStepperView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;

@property (nonatomic, strong) NSTimer *longPressedTimer;

@property (nonatomic, copy) void (^minusButtonEnbledJudgeBlock)(NSInteger number);

@end

@implementation BHXInputStepperView

#pragma mark -  init method

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self prepareForConfig];
    [self addTextFieldObserver];
    __weak typeof(self) weakSelf = self;
    [self setMinusButtonEnbledJudgeBlock:^(NSInteger number) {
        weakSelf.minusButton.enabled = number;
        if (number == 0 && weakSelf.longPressedTimer) {
            [weakSelf.longPressedTimer invalidate];
            weakSelf.longPressedTimer = nil;
        }
        if (weakSelf.textFieldChangeBlock) {
            weakSelf.textFieldChangeBlock(number, weakSelf.longPressedTimer);
        }
    }];
}

#pragma mark -  private method

- (void)prepareForConfig
{
    UILongPressGestureRecognizer *minusButtonLongPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(minusButtonLongPressed:)];
    minusButtonLongPressed.minimumPressDuration = 1;
    [self.minusButton addGestureRecognizer:minusButtonLongPressed];
    
    UILongPressGestureRecognizer *plusButtonLongPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(plusButtonLongPressed:)];
    plusButtonLongPressed.minimumPressDuration = 1;
    [self.plusButton addGestureRecognizer:plusButtonLongPressed];
}

- (void)handleTextFieldWithNumber:(NSInteger)countingNumber
{
    NSInteger number = [self.textField.text integerValue];
    if (number == 0 && countingNumber < 0) {
        return;
    }
    if (countingNumber == 0) {
        number = 0;
    }
    number += countingNumber;
    self.textField.text = [NSString stringWithFormat:@"%zd", number];
}

- (void)addTextFieldObserver
{
    [self.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark -  event handle

- (IBAction)minusButtonDidClick:(UIButton *)sender
{
    [self handleTextFieldWithNumber:-1];
}

- (IBAction)plusButtonDidClick:(UIButton *)sender
{
    [self handleTextFieldWithNumber:1];
}

- (IBAction)cleanButtonDidClick:(UIButton *)sender
{
    [self handleTextFieldWithNumber:0];
}

- (IBAction)textFieldTextChange:(UITextField *)sender
{
    if (!sender.text.length) {
        sender.text = @"0";
        return;
    } else {
        if ([sender.text hasPrefix:@"0"]) {
            sender.text = [sender.text substringFromIndex:1];
            return;
        }
    }
    self.minusButtonEnbledJudgeBlock([self.textField.text integerValue]);
}

- (void)minusButtonLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    UIButton *button = (UIButton *)longPressed.view;
    switch (longPressed.state) {
        case UIGestureRecognizerStateBegan:{
            self.longPressedTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self handleTextFieldWithNumber:-1];
                button.highlighted = YES;
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            [self.longPressedTimer invalidate];
            self.longPressedTimer = nil;
            button.highlighted = NO;
            if (![self.textField.text isEqualToString:@"0"]) {
                self.minusButtonEnbledJudgeBlock([self.textField.text integerValue]);
            }
        }
            break;
        default:
            break;
    }
}

- (void)plusButtonLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    UIButton *button = (UIButton *)longPressed.view;
    switch (longPressed.state) {
        case UIGestureRecognizerStateBegan:{
            self.longPressedTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self handleTextFieldWithNumber:+1];
                button.highlighted = YES;
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            [self.longPressedTimer invalidate];
            self.longPressedTimer = nil;
            button.highlighted = NO;
            self.minusButtonEnbledJudgeBlock([self.textField.text integerValue]);
        }
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    self.minusButtonEnbledJudgeBlock([self.textField.text integerValue]);
}


@end
