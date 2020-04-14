//
//  ReportThreeTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "ReportThreeTableViewCell.h"

@implementation ReportThreeTableViewCell
+ (instancetype)ReportThreeTableViewCell:(UITableView *)tableView {
    static NSString *ID = @"ReportThreeTableViewCell";
    ReportThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportThreeTableViewCell" owner:nil options:nil]firstObject];
        
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
