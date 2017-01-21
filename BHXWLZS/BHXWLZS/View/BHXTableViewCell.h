//
//  BHXTableViewCell.h
//  BHXWLZS
//
//  Created by Danyow.Ed on 2017/1/21.
//  Copyright © 2017年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHXInputStepperView.h"

@interface BHXTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) BHXInputStepperView *inputStepperView;

@end
