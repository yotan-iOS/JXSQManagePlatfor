//
//  ReportThreeTableViewCell.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportThreeTableViewCell : UITableViewCell
+ (instancetype)ReportThreeTableViewCell:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UILabel *renLabel;

@property (strong, nonatomic) IBOutlet UITextField *nameLabel;

@end
