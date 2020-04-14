//
//  ReportButtonTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "ReportButtonTableViewCell.h"

@implementation ReportButtonTableViewCell
+ (instancetype)ReportButtonTableViewCell:(UITableView *)tableView {
    static NSString *ID = @"ReportButtonTableViewCell";
    ReportButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportButtonTableViewCell" owner:nil options:nil]firstObject];
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
