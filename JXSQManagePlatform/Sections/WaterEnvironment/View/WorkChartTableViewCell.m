//
//  WorkChartTableViewCell.m
//  HaiNanAPP
//
//  Created by ghost on 2017/12/26.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "WorkChartTableViewCell.h"

@implementation WorkChartTableViewCell
+ (instancetype)WorkChartTableViewCell:(UITableView *)tableView {
    static NSString *ID = @"WorkChartTableViewCell";
    WorkChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkChartTableViewCell" owner:nil options:nil]firstObject];
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
