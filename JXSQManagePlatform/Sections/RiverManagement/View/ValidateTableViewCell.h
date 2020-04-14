//
//  ReportThreeTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateTableViewCell : UITableViewCell
+ (instancetype)ValidateTableViewCell:(UITableView *)tableView;

@property (strong, nonatomic) IBOutlet UILabel *nameRadio;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_check;

@end
