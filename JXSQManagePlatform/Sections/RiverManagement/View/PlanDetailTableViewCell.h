//
//  PlanDetailTableViewCell.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/18.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ProgressIDLab;
@property (weak, nonatomic) IBOutlet UILabel *handleName;
@property (weak, nonatomic) IBOutlet UILabel *handleDateLab;
@property (weak, nonatomic) IBOutlet UILabel *progressContentLab;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end
