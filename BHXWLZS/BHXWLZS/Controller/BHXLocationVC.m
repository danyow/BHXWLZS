//
//  BHXLocationVC.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "BHXLocationVC.h"
#import "BHXCollectionReusableView.h"

#import "BHXRuleManager.h"
#import "BHXCounter.h"

#import <Masonry.h>

#import "UIView+DrawAround.h"

#define myRandomColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]

static NSString * const kLocationIdentifier  = @"Location";

@interface BHXLocationVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) BHXRuleManager *manager;

@end

@implementation BHXLocationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kLocationIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BHXCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLocationIdentifier];
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.manager.allRule.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.manager.allRule[section] citys].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLocationIdentifier forIndexPath:indexPath];
    
    UILabel *label = nil;
    if ([cell.contentView.subviews.lastObject isKindOfClass:[UILabel class]]) {
        label = (UILabel *)cell.contentView.subviews.lastObject;
    } else {
        label = [[UILabel alloc] init];
        label.font = BHXFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.minimumScaleFactor = 4;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    Rule *rule = self.manager.allRule[indexPath.section];
    __block City *city = nil;
    [rule.citys enumerateObjectsUsingBlock:^(City *obj, BOOL *stop) {
        if (obj.row == indexPath.item) {
            city = obj;
            *stop = YES;
            return ;
        }
    }];
    label.text = city.name;
    return cell;
}

#pragma mark -  UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BHXCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLocationIdentifier forIndexPath:indexPath];
        headerView.nameLabel.text = self.manager.allRule[indexPath.section].name;
        [headerView drawAroundViewWithLocation:DrawBottom color:[UIColor lightGrayColor] insets:UIEdgeInsetsMake(-0.5, 0, 0, 0)];
        return headerView;
    } else {
        return nil;
    }
}

#pragma mark -  UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Rule *rule = self.manager.allRule[indexPath.section];
    __block City *city = nil;
    [rule.citys enumerateObjectsUsingBlock:^(City *obj, BOOL *stop) {
        if (obj.row == indexPath.item) {
            city = obj;
            *stop = YES;
            return ;
        }
    }];
    [BHXCounter shareCounter].userData.selectedCity = city;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  lazy load

- (BHXRuleManager *)manager
{
    if (!_manager) {
        _manager = [BHXRuleManager shareManager];
    }
    return _manager;
}

@end
