//
//  ReportOneTableViewCell.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportOneTableViewCell : UITableViewCell
+ (instancetype)ReportOneTableViewCell:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UILabel *labTitle;

@end
