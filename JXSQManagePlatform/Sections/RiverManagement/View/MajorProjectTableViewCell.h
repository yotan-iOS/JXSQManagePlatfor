//
//  MajorProjectTableViewCell.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/18.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MajorProjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *planIDLab;
@property (weak, nonatomic) IBOutlet UILabel *planTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *yearLab;

@property (weak, nonatomic) IBOutlet UILabel *monthLab;

@end
