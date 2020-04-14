//
//  TableViewCell2.m
//  text0
//
//  Created by 吴坤 on 16/11/29.
//  Copyright © 2016年 yotan. All rights reserved.
//

#import "TableViewCell2.h"

@implementation TableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.areLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, WT/2.0-50, 40)];
        self.areLab.font = [UIFont systemFontOfSize:17];
        self.areLab.numberOfLines = 0;
        self.areLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.areLab];
        self.countLab = [[UILabel alloc]initWithFrame:CGRectMake(WT/2.0-45, 0, 40, 40)];
        self.countLab.textAlignment = NSTextAlignmentCenter;

        [self addSubview:self.countLab];
    }
    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
