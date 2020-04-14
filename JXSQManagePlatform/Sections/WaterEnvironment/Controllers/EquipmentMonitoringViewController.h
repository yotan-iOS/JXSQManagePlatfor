//
//  EquipmentMonitoringViewController.h
//  JXSQManagePlatform
//
//  Created by TestGhost on 2018/7/10.
//  Copyright © 2018年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentMonitoringViewController : UIViewController
@property (nonatomic, copy) NSString *SiteIDStr;
@property (nonatomic, copy) NSString *typeStr;

@property (nonatomic, assign) NSInteger indexClick;
@property (nonatomic, assign) NSInteger cellHeight;
@end
