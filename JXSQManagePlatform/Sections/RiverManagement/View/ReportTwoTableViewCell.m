//
//  ReportTwoTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "ReportTwoTableViewCell.h"

@implementation ReportTwoTableViewCell
+ (instancetype)ReportTwoTableViewCell:(UITableView *)tableView {
    static NSString *ID = @"ReportTwoTableViewCell";
    ReportTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportTwoTableViewCell" owner:nil options:nil]firstObject];
        
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
