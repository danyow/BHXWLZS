//
//  BHXAddGoodsVC.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/23.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXAddGoodsVC.h"
#import "UIView+DrawAround.h"

#import "BHXGoodsManager.h"

@interface BHXAddGoodsVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *aPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *bPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *cPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *dPriceTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation BHXAddGoodsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.toolBar.barTintColor = [UIColor whiteColor];
    [self drawBottomLineWithView:self.toolBar];
    [self drawBottomLineWithView:self.nameTextField];
    [self drawBottomLineWithView:self.weightTextField];
    [self drawBottomLineWithView:self.aPriceTextField];
    [self drawBottomLineWithView:self.bPriceTextField];
    [self drawBottomLineWithView:self.cPriceTextField];
    [self drawBottomLineWithView:self.dPriceTextField];
    [self judgeSaveButtonEnabled];
}

#pragma mark -  privat method

- (void)drawBottomLineWithView:(UIView *)view
{
    [view drawAroundLayerWithLocation:DrawBottom color:[UIColor lightGrayColor] insets:UIEdgeInsetsMake(-0.5, 0, 0, 0)];
}

- (void)judgeSaveButtonEnabled
{
    self.saveButton.enabled =
    self.nameTextField.text.length &&
    self.weightTextField.text.length &&
    self.aPriceTextField.text.length &&
    self.bPriceTextField.text.length &&
    self.cPriceTextField.text.length &&
    self.dPriceTextField.text.length;
}

#pragma mark -  event handle

- (IBAction)dismissButtonDidClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonDidClick:(UIButton *)sender
{
    Goods *newGoods = [[BHXGoodsManager shareManager]
     createGoodsWithName:self.nameTextField.text
     weight:self.weightTextField.text.integerValue
     row:[BHXGoodsManager shareManager].allGoods.count
     A:self.aPriceTextField.text
     B:self.bPriceTextField.text
     C:self.cPriceTextField.text
     D:self.dPriceTextField.text];
    newGoods.amount = 0;
    BHXSaveModel;
    [BHXGoodsManager shareManager].allGoods = nil;
    [self dismissButtonDidClick:nil];
}

- (IBAction)textFieldTextChange:(UITextField *)sender
{
    [self judgeSaveButtonEnabled];
}


@end
