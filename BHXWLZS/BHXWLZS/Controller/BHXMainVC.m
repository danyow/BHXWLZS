//
//  BHXMainVC.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXMainVC.h"

#import "BHXTableViewCell.h"
#import "BHXGoodsManager.h"

static NSString * const kGoodsCellIdentifier = @"GoodsCell";
static NSString * const kLocationIdentifier  = @"Location";

@interface BHXMainVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BHXGoodsManager *manager;

@end

@implementation BHXMainVC

#pragma mark -  life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames)
    {
        NSLog(@"%@", familyName);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames)
        {
            NSLog(@"\t%@", fontName);
        }  
    }
    [self prepareForConfig];
}

#pragma mark -  private method

- (void)prepareForConfig
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BHXTableViewCell class]) bundle:nil] forCellReuseIdentifier:kGoodsCellIdentifier];
}

#pragma mark -  UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.manager.allGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLocationIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kLocationIdentifier];
        }
        cell.textLabel.text = @"地区";
        cell.textLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:17];
        cell.detailTextLabel.text = @"广东";
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        BHXTableViewCell *goodCell = [tableView dequeueReusableCellWithIdentifier:kGoodsCellIdentifier];
        goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
        Goods *goods = self.manager.allGoods[indexPath.row];
        goodCell.nameLabel.text = goods.name;
        goodCell.inputStepperView.textField.text = [NSString stringWithFormat:@"%zd", goods.amount];
        [goodCell.inputStepperView setTextFieldChangeBlock:^(NSInteger amount, BOOL quickChange) {
            if (!quickChange) {
                NSLog(@"%zd %zd", indexPath.row + 1, amount);
            } else {
                NSLog(@"➖  %zd", amount);
            }
        }];
        return goodCell;
    }
}

#pragma mark -  UITableView Delegate


#pragma mark -  lazy load

- (BHXGoodsManager *)manager
{
    if (!_manager) {
        _manager = [BHXGoodsManager shareManager];
    }
    return _manager;
}

@end
