//
//  BHXMainVC.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXMainVC.h"

#import <UICountingLabel.h>

#import "BHXLocationVC.h"

#import "MTRUnderlineSegmentView.h"
#import "BHXTableViewCell.h"

#import "BHXGoodsManager.h"
#import "BHXRuleManager.h"
#import "BHXCounter.h"

#import "UIView+DrawAround.h"

static NSString * const kGoodsCellIdentifier = @"GoodsCell";
static NSString * const kLocationIdentifier  = @"Location";

@interface BHXMainVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MTRUnderlineSegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *labelsHostView;

@property (nonatomic, strong) BHXGoodsManager *goodsManager;
@property (nonatomic, strong) BHXRuleManager  *ruleManager;
@property (nonatomic, strong) BHXCounter      *counter;

@property (weak, nonatomic) IBOutlet UICountingLabel *actualPriceLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *retailPriceLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *freightLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, assign) BOOL editing;

@end

@implementation BHXMainVC

#pragma mark -  life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSArray *familyNames = [UIFont familyNames];
//    for(NSString *familyName in familyNames)
//    {
//        NSLog(@"%@", familyName);
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for(NSString *fontName in fontNames)
//        {
//            NSLog(@"\t%@", fontName);
//        }  
//    }
    [self prepareForConfig];
    [self prepareForUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)orientChange:(NSNotification *)noti
{
   [self.segmentView setUnderlineEdge:UIEdgeInsetsMake(2, 0, 0, 0)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.segmentView setUnderlineEdge:UIEdgeInsetsMake(2, 0, 0, 0)];
    [self.counter startCounter];
}

#pragma mark -  private method

- (void)prepareForConfig
{
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BHXTableViewCell class]) bundle:nil] forCellReuseIdentifier:kGoodsCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    
    self.freightLabel.format     = @"%.1lf";
    self.actualPriceLabel.format = @"%.1lf";
    self.retailPriceLabel.format = @"%.1lf";
    self.freightLabel.animationDuration     = 0.7;
    self.actualPriceLabel.animationDuration = 0.7;
    self.retailPriceLabel.animationDuration = 0.7;
    
    NSMutableArray *segments = [NSMutableArray array];
    [self.goodsManager.priceInfos enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if (idx < self.goodsManager.priceInfos.count - 1) {
            [segments addObject:@{kUnderlineSegmentViewTitleText : obj}];
        }
    }];
    
    [self.segmentView setSegments:segments];
    [self.segmentView setSelectedIndexBlock:^(NSInteger selectedIndex) {
        self.goodsManager.selectedPriceInfo = self.goodsManager.priceInfos[selectedIndex];
        [self.counter startCounter];
    }];
}

- (void)prepareForUI
{
    [self.segmentView setNormalFont:BHXFont selectedFont:BHXFont];
    [self.segmentView setNormalColor:[UIColor lightGrayColor] selectedColor:[UIColor blackColor]];
    [self.segmentView drawAroundViewWithLocation:DrawBottom color:[UIColor lightGrayColor] insets:UIEdgeInsetsMake(-0.5, 0, 0, 0)];
    [self.labelsHostView drawAroundViewWithLocation:DrawBottom color:[UIColor lightGrayColor] insets:UIEdgeInsetsMake(-0.5, 0, 0, 0)];
}

#pragma mark -  event handle

- (void)editButtonDidClick:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.editing = YES;
    } else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        self.editing = NO;
    }
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
    return self.goodsManager.allGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLocationIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kLocationIdentifier];
        }
        cell.textLabel.text = @"地区";
        cell.textLabel.font = BHXFont;
        cell.detailTextLabel.text = self.ruleManager.selectedCity.name;
        cell.detailTextLabel.font = BHXFont;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        BHXTableViewCell *goodCell = [tableView dequeueReusableCellWithIdentifier:kGoodsCellIdentifier];
        goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
        Goods *goods = self.goodsManager.allGoods[indexPath.row];
        goodCell.nameLabel.text = goods.name;
        goodCell.inputStepperView.textField.text = [NSString stringWithFormat:@"%zd", goods.amount];
        [goodCell.inputStepperView setTextFieldChangeBlock:^(NSInteger amount, BOOL quickChange) {
            if (!quickChange) {
                self.goodsManager.allGoods[indexPath.row].amount = amount;
                [self.counter startCounter];
            } else {
                NSLog(@"➖%zd", amount);
            }
        }];
        goodCell.inputStepperView.userInteractionEnabled = !self.editing;
        return goodCell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return self.editing;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return self.editing;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleInsert:
            
            break;
        case UITableViewCellEditingStyleDelete:
            
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return @[];
}

#pragma mark -  UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        BHXLocationVC *locationVC = [UIStoryboard storyboardWithName:NSStringFromClass([BHXLocationVC class]) bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:locationVC animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark -  setter

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    [self.tableView setEditing:editing animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -  lazy load

- (BHXGoodsManager *)goodsManager
{
    if (!_goodsManager) {
        _goodsManager = [BHXGoodsManager shareManager];
    }
    return _goodsManager;
}

- (BHXRuleManager *)ruleManager
{
    if (!_ruleManager) {
        _ruleManager = [BHXRuleManager shareManager];
    }
    return _ruleManager;
}

- (BHXCounter *)counter
{
    if (!_counter) {
        _counter = [BHXCounter shareCounter];
        __weak typeof(_counter) weakCounter = _counter;
        __weak typeof(self) weakSelf = self;
        [_counter setDidCounter:^{
            [weakSelf.freightLabel     countFromCurrentValueTo:weakCounter.freight.doubleValue];
            [weakSelf.retailPriceLabel countFromCurrentValueTo:weakCounter.retailPrice.doubleValue];
            [weakSelf.actualPriceLabel countFromCurrentValueTo:weakCounter.actualPrice.doubleValue];
        }];
    }
    return _counter;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BHXFont;
        _titleLabel.text = @"笨浣熊柜台";
        _titleLabel.textColor = [UIColor blackColor];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton = [[UIButton alloc] init];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:BHXFont];
        [_editButton addTarget:self action:@selector(editButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editButton sizeToFit];
    }
    return _editButton;
}

@end
