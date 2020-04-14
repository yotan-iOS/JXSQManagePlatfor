//
//  RiverInformotionTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/19.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverInformotionTableViewCell.h"

@implementation RiverInformotionTableViewCell
+ (instancetype)RiverInformotionTableViewCell:(UITableView *)tableView {
    static NSString *ID = @"RiverInformotionTableViewCell";
    RiverInformotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RiverInformotionTableViewCell" owner:nil options:nil]firstObject];
        
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
