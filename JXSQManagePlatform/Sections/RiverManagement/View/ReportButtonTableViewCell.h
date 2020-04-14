//
//  ReportButtonTableViewCell.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportButtonTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *clickBtn;
+ (instancetype)ReportButtonTableViewCell:(UITableView *)tableView;
@end
