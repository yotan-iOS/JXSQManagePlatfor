//
//  StatisticalViewCell.m
//  Witwater
//
//  Created by ghost on 2016/11/30.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "StatisticalViewCell.h"

@implementation StatisticalViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)StatisticalViewCell:(UITableView *)tableView {
    static NSString *ID = @"StatisticalViewCell";
    StatisticalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalViewCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

@end
