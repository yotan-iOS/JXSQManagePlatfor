//
//  DataSource.h
//  Witwater
//
//  Created by gaoqi on 2016/10/28.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "YZLocationManagerMacro.h"

typedef enum : NSUInteger {
    TrailStart,
    TrailEnd
} Trail;
@interface DataSource : NSObject
+(DataSource*)sharedDataSource;
@property (nonatomic, retain) NSString *tagString;
@property (nonatomic, retain) NSString *SignInName;//用户名
@property (nonatomic, retain) NSString *SignInPass;//密码
@property (nonatomic,copy) NSString *realNameStr;//真实名字
//@property (nonatomic,copy) NSString *RiverID;
@property (nonatomic,copy) NSString *UserID;//
@property (nonatomic,copy) NSString *RiverName;//
@property (nonatomic,copy) NSString *RiverLength;
@property (nonatomic,copy) NSString *groupType;//
@property (nonatomic,copy) NSString *GroupName;
@property (nonatomic,copy) NSString *GroupID;

@property (nonatomic,copy) NSString *siteClassID;//siteType;
@property (nonatomic,copy) NSString *siteTypeID;//siteID

@property (nonatomic,copy) NSString *imgFile;

@property (nonatomic,copy) NSString *siteIDString;

@property (nonatomic,assign) BOOL isTouchBegin;//是否点击开始
@property (nonatomic,assign) BOOL isTouchOver; //是否点击结束
@property (nonatomic,copy) NSString *IsStart;
@property (nonatomic,copy) NSString *IsEnd;
@property (nonatomic,copy) NSString *dataRiverID;//巡河数据的ID
@property (nonatomic,copy) NSString *RiverID;//巡河的河道ID
@property (nonatomic, strong) NSMutableArray *AllTheData;
@property (nonatomic, strong) NSMutableArray *dataSouce;
@property (nonatomic, strong) NSMutableArray *datalong;

@property (nonatomic,copy) NSString *selectArtificialStr;//人工采样默认选中的站点
@property(nonatomic,copy)NSString *idLeft;
@property(nonatomic,copy)NSString *siteLats;
@property(nonatomic,copy)NSString *siteLongs;
@property(nonatomic,copy)NSString *locations;


/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;
/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;
/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;
/** 轨迹记录状态 */
@property (nonatomic, assign) Trail trail;
/** 起点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *startPoint;
/** 终点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *endPoint;

@property (nonatomic, copy) NSString *timeLenthStr;//时长
@property (nonatomic, copy) NSString *disLentStr;//距离

@property (nonatomic, copy) NSString *TimeDifferenceStart;//时间段间的差
@property (nonatomic, copy) NSString *distancePoints;//两点间的距离


//登录 首页
@property (nonatomic, strong) NSMutableArray *cmListArr;
@property (nonatomic, strong) NSMutableArray *moduleArr;//模块名字
@property (nonatomic, strong) NSMutableArray *moduleArrIcon;//模块名字

@end
