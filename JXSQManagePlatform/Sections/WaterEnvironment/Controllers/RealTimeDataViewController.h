//
//  RealTimeDataViewController.h
//  LWIntelligenceOperations
//
//  Created by 吴坤 on 17/5/17.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealTimeDataViewController : UIViewController
@property (nonatomic,copy) NSString *siteID;

@property (strong, nonatomic) IBOutlet UIView *tableViewHeader;
@property (strong, nonatomic) IBOutlet UILabel *timeDataLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) IBOutlet UILabel *warningLabel;
@property (strong, nonatomic) IBOutlet UILabel *waterLevelLab;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) NSString *SiteTypeIDstr;

@property(nonatomic,strong) UIButton *declineBtn;//下滑
@end
