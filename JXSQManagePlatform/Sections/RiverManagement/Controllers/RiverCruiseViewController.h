//
//  RiverCruiseViewController.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/4.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiverCruiseViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *AllTheData;

@property (nonatomic,copy) NSString *AddressReport;
@property (nonatomic,copy) NSString *longitudeReport;
@property (nonatomic,copy) NSString *latitudeReport;

//结束的时候上传的经纬度
@property (nonatomic,copy) NSString *patorlPath;
//@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) double ExistingTime;//已经有的时长
@property (nonatomic, assign) double ExistingTimeone;
@property (nonatomic, copy) NSString *distanceExisting;//已经有的距离
@property (nonatomic, copy) NSString *onedistanceExisting;

@end
