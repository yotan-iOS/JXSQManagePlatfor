//
//  PlanDetailViewController.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/18.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;
@property (weak, nonatomic) IBOutlet UILabel *planIDLab;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *planTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *yearLab;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *contentlab;
@property(nonatomic,copy)NSString *planIDStr;
@end
