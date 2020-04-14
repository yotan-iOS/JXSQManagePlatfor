//
//  ListNoticeTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/14.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "ListNoticeTableViewCell.h"

@implementation ListNoticeTableViewCell
+ (instancetype)ListNoticeTableViewCell:(UITableView *)tableView {
    static NSString *ID = @"ListNoticeTableViewCell";
    ListNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListNoticeTableViewCell" owner:nil options:nil]firstObject];
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
