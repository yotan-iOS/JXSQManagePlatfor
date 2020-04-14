//
//  RiverMessageModel.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/5.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiverMessageModel : NSObject

@property(nonatomic,copy)NSString *EarthCircle;
@property(nonatomic,strong)NSArray *Rank;

@property(nonatomic,copy)NSString *No;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *Length;

@property(nonatomic,copy)NSString *RiverName;//河道名称
@property(nonatomic,copy)NSString *RiverLongName;//河长姓名
@property(nonatomic,copy)NSString *RiverLongPhone;//河道手机号码
@property(nonatomic,copy)NSString *RiverLength;//河道长度
@property(nonatomic,copy)NSString *WaterLevel;//目标水质
@property(nonatomic,copy)NSString *AllPatrolCount;//上报内容条数
@property(nonatomic,copy)NSString *AllCount;//当月巡河次数
@property(nonatomic,copy)NSString *PatrolLength;//巡河总长度
@property(nonatomic,copy)NSString *TimeLength;//巡河总时间

@property(nonatomic,copy)NSString *RowIndex;//序号
@property(nonatomic,copy)NSString *EndTime;//巡河日期
@property(nonatomic,copy)NSString *PatrolCheckStatus;//巡河状态

@property(nonatomic,strong)NSArray *RiverList;

@property(nonatomic,copy)NSString *RiverStartPoint;//河道起点
@property(nonatomic,copy)NSString *RiverEndPoint;// 河道终点
@property(nonatomic,copy)NSString *ValidCount;//有效次数
@property(nonatomic,copy)NSString *InValidCount;// 无效次数
@property(nonatomic,copy)NSString *MustPatrolCount;

@end
