//
//  ReportTwoTableViewCell.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTwoTableViewCell : UITableViewCell
+ (instancetype)ReportTwoTableViewCell:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UILabel *shijianLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
