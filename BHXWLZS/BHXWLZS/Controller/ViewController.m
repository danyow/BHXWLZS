//
//  ViewController.m
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/19.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import "ViewController.h"
#import "BHXTableViewCell.h"

static NSString * const kIdentifier = @"ID";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BHXTableViewCell class]) bundle:nil] forCellReuseIdentifier:kIdentifier];
}


#pragma mark -  UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row + 1];
    
    
    return cell;
}

@end
