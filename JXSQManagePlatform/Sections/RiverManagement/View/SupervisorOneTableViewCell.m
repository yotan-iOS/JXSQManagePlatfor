//
//  SupervisorOneTableViewCell.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/19.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "SupervisorOneTableViewCell.h"

@implementation SupervisorOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.texfTF.layer.borderWidth = 1.f;
    self.texfTF.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
    [self.texfTF setPlaceholderWithText:@"请添加内容" Color:UIColorFromRGB(0xE9E9E9)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
