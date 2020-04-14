//
//  ReportThreeTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "ValidateTableViewCell.h"

@implementation ValidateTableViewCell
+ (instancetype)ValidateTableViewCell:(UITableView *)tableView {
//    static NSString *ID = @"ValidateTableViewCell";
//    ValidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ValidateTableViewCell" owner:nil options:nil]firstObject];
//    }
//    return cell;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        static NSString *ID = @"ValidateTableViewCell_iPhone";
        ValidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ValidateTableViewCell_iPhone" owner:nil options:nil]firstObject];
        }
        return cell;
    } else {
        static NSString *ID = @"ValidateTableViewCell_iPad";
        ValidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ValidateTableViewCell_iPad" owner:nil options:nil]firstObject];
        }
        return cell;
    }
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
