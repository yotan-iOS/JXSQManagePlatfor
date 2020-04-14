//
//  ListNoticeTableViewCell.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/14.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListNoticeTableViewCell : UITableViewCell
+ (instancetype)ListNoticeTableViewCell:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *contextLable;

@end
