//
//  MapRouteViewController.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/11/9.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapRouteViewController : UIViewController
@property (nonatomic, copy) NSString *pathStr;//获取的经纬度
@property (nonatomic, copy) NSString *timeLenStr;//距离
@property (nonatomic, copy) NSString *distanceStr;//时长

@end
