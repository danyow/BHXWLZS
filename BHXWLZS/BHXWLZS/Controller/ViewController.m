//
//  ViewController.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/19.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "ViewController.h"
#import "BHXTableViewCell.h"
#import "BHXGoodsManager.h"

static NSString * const kIdentifier = @"ID";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BHXGoodsManager *manager;

@end

@implementation ViewController

#pragma mark -  life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareForConfig];
}

#pragma mark -  private method

- (void)prepareForConfig
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BHXTableViewCell class]) bundle:nil] forCellReuseIdentifier:kIdentifier];
}


#pragma mark -  UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.manager.allGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Goods *goods = self.manager.allGoods[indexPath.row];
    cell.nameLabel.text = goods.name;
    cell.inputStepperView.textField.text = [NSString stringWithFormat:@"%zd", goods.amount];
    [cell.inputStepperView setTextFieldChangeBlock:^(NSInteger amount, BOOL quickChange) {
        if (!quickChange) {
            NSLog(@"%zd %zd", indexPath.row + 1, amount);
        } else {
            NSLog(@"➖  %zd", amount);
        }
    }];
    return cell;
}

#pragma mark -  UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"地区";
    [label sizeToFit];
    return label;
}

#pragma mark -  lazy load

- (BHXGoodsManager *)manager
{
    if (!_manager) {
        _manager = [BHXGoodsManager shareManager];
    }
    return _manager;
}

@end
