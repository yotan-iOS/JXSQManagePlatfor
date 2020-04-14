//
//  RiverCruiseViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/4.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverCruiseViewController.h"
#import "RiverCruiseModel.h"
#import "EndRiverViewController.h"
#import "RiverTourReportViewController.h"
#import "YZLocationManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Latitude_and_longitude+CoreDataClass.h"//经纬度
#import "Patrol_record+CoreDataClass.h"//上传信息
#define phoneScale [UIScreen mainScreen].bounds.size.width/720.0

@interface RiverCruiseViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate> {
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    BMKGeoCodeSearch *_geoCodeSearch;
    CLLocationCoordinate2D MapCoordinate;
    DataSource *datasource;
}
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKMapView *mapView;
@property(strong,nonatomic) UIView *topView;

@property(strong,nonatomic) UILabel *timeLabel;
@property(strong,nonatomic) UILabel *distanceLabel;
@property(strong,nonatomic) UILabel *strDistanceLabel;
@property(strong,nonatomic) UILabel *strTimeLabel;
@property(strong,nonatomic) UIButton *startBtn;
@property(strong,nonatomic) UIButton *endBtn;
@property(strong,nonatomic) UIButton *reportBtn;
@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *startLat;
@property (nonatomic, copy) NSString *startLon;
@property (nonatomic) CLLocationDistance distance;

@property(strong,nonatomic) RiverCruiseModel *rcModel;
@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, strong) NSMutableArray *dataSouce;
@property (nonatomic, strong) NSMutableArray *datalong;

@property (nonatomic, strong) YZLocationManager *manager;
@property (nonatomic, strong) JHUD *hudView;
@property (nonatomic, strong)NSMutableDictionary *RIDDic;
@property (nonatomic, copy)NSString *RID;

/** 步行时间 */
@property (nonatomic,assign) NSTimeInterval sumTime;
/** 步行距离 */
@property (nonatomic,assign) CGFloat sumDistance;

@end
//河长巡河
@implementation RiverCruiseViewController
static  CLLocationDegrees latitude = 0.0;
static  CLLocationDegrees longitude = 0.0;
static  CLLocationCoordinate2D coordinateOld;
static  CLLocationCoordinate2D coordinateNew;
- (RiverCruiseModel *)rcModel{
    if (!_rcModel) {
        self.rcModel = [[RiverCruiseModel alloc] init];
    }
    return _rcModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"河长巡河";
    datasource = [DataSource sharedDataSource];
    [self sendJudgePatrolRiverRequest];
    
    self.RIDDic = [NSMutableDictionary dictionaryWithCapacity:1];
    // Do any additional setup after loading the view from its nib.
    // 设置百度地图
    [self setupMapViewWithParam];
}
- (void)sendJudgePatrolRiverRequest {
    NSDictionary *param = @{
                            @"action":@"2",
                            @"method":F(@"{patrolID:%@}", datasource.UserID)
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/RiverManagement", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"result" success:^(id result) {
        if ([result[@"Status"] isEqualToString:@"OK"]) {
            NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:result[@"Result"]];
            datasource.IsStart = F(@"%@", dic[@"IsStart"]);
            datasource.IsEnd = F(@"%@", dic[@"IsEnd"]);
            datasource.dataRiverID = F(@"%@", dic[@"PatorlRiverID"]);
            datasource.RiverID = F(@"%@", dic[@"RiverID"]);
            self.ExistingTimeone = [dic[@"LengthOfTime"] doubleValue];
            self.onedistanceExisting = F(@"%@", dic[@"PatrolRiverDistance"]);
        } else {
            [YJProgressHUD showError:result[@"Msg"]];
        }
        
        [self setButtonChangeState];
        [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
        
        
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
    }];
}
//实时上传经纬度
- (void)sendUploadLongitudeLatitudeRealTimeRequest {
//    // 1.将时间转换为date
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *date1 = [formatter dateFromString:[self getCurrentTimes]];
//    NSDate *date2 = [formatter dateFromString:datasource.TimeDifferenceStart];
//    // 2.创建日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    // 3.利用日历对象比较两个时间的差值
//    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
//    // 4.输出结果
//    NSString *delta = F(@"%ld", cmps.day*24*60*60+cmps.hour*60*60+cmps.minute*60+cmps.second);
    
    NSString *delta;
    if (self.dataSouce.count > 1) {
        NSInteger cout = self.dataSouce.count-2;
        delta = F(@"%.0f", [[self compareTwoTime:F(@"%@", self.dataSouce[cout]) time2:F(@"%@", self.dataSouce.lastObject)] doubleValue]*60);
    } else {
        delta = F(@"%f", [[self compareTwoTime:F(@"%@", self.dataSouce.firstObject) time2:F(@"%@", self.dataSouce.lastObject)] doubleValue]*60);
    }
    
    
    NSLog(@"两个时间相差%@秒==============距离%@", delta, datasource.distancePoints);
    
//    if (self.AllTheData.count > 0) {
        self.patorlPath = self.AllTheData.lastObject;
//    } else {
//        self.patorlPath = F(@"%@'%@", _startLat,_startLon);
//    }
    NSDictionary *param = @{
                            @"PatrolCheckID":datasource.dataRiverID,
                            @"LatLonlist":self.patorlPath,
                            @"strDistance":datasource.distancePoints,
                            @"strTime":F(@"%.0f", round([delta doubleValue]))
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/UpLoadLatLonList", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"result" success:^(id result) {
        NSLog(@"实时上传经纬度=========%@", result);

    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
    }];
}

//改变状态
- (void)setButtonChangeState {
    [self performSelector:@selector(UnderCreateButton) withObject:nil afterDelay:1];
    
    if ([datasource.IsStart intValue] == 1 && [datasource.IsEnd intValue] == 0) {
        if (datasource.isTouchBegin == NO && datasource.isTouchOver == NO) {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您上次的巡河未结束,是否继续上次的巡河" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1=[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.ExistingTime = self.ExistingTimeone/60;
                self.distanceExisting = self.onedistanceExisting;
                
                [self startRivierCruise];//继续巡河
                [self drawWalkPolyline];

            }];
            UIAlertAction *act2=[UIAlertAction actionWithTitle:@"不继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self endRiverCruise];
            }];
            [controller addAction:act1];
            [controller addAction:act2];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        } else {
            if (datasource.dataSouce.count > 0) {
                [self startRivierCruise];//继续巡河
                [self drawWalkPolyline];
            }
        }
        
    } else {
        [datasource.dataSouce removeAllObjects];
        [self.dataSouce removeAllObjects];
        [self.datalong removeAllObjects];
        [self.AllTheData removeAllObjects];
    }
    
}
#pragma mark - 设置百度地图
-(void)setupMapViewWithParam {
    _locationService = [[BMKLocationService alloc] init];
    _locationService.distanceFilter = 5;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电量
    _locationService.desiredAccuracy = kCLLocationAccuracyBest;//设定定位精度
    [_locationService startUserLocationService];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, WT, HT - NAVIHEIGHT)];
    
    _mapView.buildingsEnabled = YES;//设定地图是否现显示3D楼块效果
    _mapView.overlookEnabled = YES; //设定地图View能否支持俯仰角
    _mapView.showMapScaleBar = YES; // 设定是否显式比例尺
    self.mapView.rotateEnabled = YES;
    _mapView.zoomLevel = 20;//设置放大级别
    [self.view addSubview:_mapView];
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
    userlocationStyle.isRotateAngleValid = YES;
    userlocationStyle.isAccuracyCircleShow = NO;
    userlocationStyle.locationViewOffsetX = 0;
    userlocationStyle.locationViewOffsetY = 0;
//    displayParam.locationViewImgName = @"walk";
    [self.mapView updateLocationViewWithParam:userlocationStyle];
}


//界面上面的悬浮
- (void)createButton {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(10, 10+NAVIHEIGHT, WT-20, 80);
        _strTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _topView.frame.size.width/2, _topView.frame.size.height/2)];
        _strDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_strTimeLabel.frame), 0, _topView.frame.size.width/2, _topView.frame.size.height/2)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_strTimeLabel.frame), _topView.frame.size.width/2, _topView.frame.size.height/2)];
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_strTimeLabel.frame), CGRectGetMaxY(_strTimeLabel.frame), _topView.frame.size.width/2, _topView.frame.size.height/2)];
    }
    
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.layer.masksToBounds = YES;
    [self.view addSubview:_topView];
    
    
    _strTimeLabel.textAlignment = NSTextAlignmentCenter;
    _strTimeLabel.text = @"巡河时长";
    [_topView addSubview:_strTimeLabel];
    
    
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    NSString *string = [self getTheCorrectNum:[[NSString alloc] initWithFormat:@"%@", [self compareTwoTime:[self.dataSouce firstObject] time2:[self.dataSouce lastObject]]]];
    
    datasource.timeLenthStr = F(@"%.1f", [string doubleValue]);
    if (datasource.timeLenthStr != nil) {
        _timeLabel.text = [[NSString alloc] initWithFormat:@"%@ 分钟", datasource.timeLenthStr];
    } else {
        _timeLabel.text = [[NSString alloc] initWithFormat:@"%@ 分钟", @"-"];
    }
    
        
    
    [_topView addSubview:_timeLabel];
    
    
    
    _strDistanceLabel.text = @"巡河距离";
    _strDistanceLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_strDistanceLabel];
    
    
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    
    NSNumber *sum = [self.datalong valueForKeyPath:@"@sum.floatValue"];
    datasource.disLentStr = F(@"%.0f", round([sum floatValue]));
    if (datasource.disLentStr != nil) {
        _distanceLabel.text = F(@"%@ 米", datasource.disLentStr);
    } else {
        _distanceLabel.text = [[NSString alloc] initWithFormat:@"%@ 米", @"-"];
    }
    [_topView addSubview:_distanceLabel];
}
- (void)UnderCreateButton {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(5, self.view.frame.size.height-160*phoneScale, WT/3-10, 50);
        
    }
    _startBtn.layer.cornerRadius = 160*phoneScale/2;
    _startBtn.layer.masksToBounds = YES;
    [self.view addSubview:_startBtn];
    _startBtn.backgroundColor = UIColorFromRGB(0xD0D2D1);
    _startBtn.layer.cornerRadius = 10;
    [_startBtn setTitle:@"开始巡河" forState:UIControlStateNormal];
    if ([datasource.IsEnd intValue] == 0) {
        if ([datasource.IsStart intValue] == 1) {
            [_startBtn setTitleColor:UIColorFromRGB(0x989A99) forState:UIControlStateSelected];
        } else if ([datasource.IsStart intValue] == 0){
            [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_startBtn addTarget:self action:@selector(StartresignWindow) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if ([datasource.IsEnd intValue] == 1) {
        [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(StartresignWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!_reportBtn) {
        _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportBtn.frame = CGRectMake(CGRectGetMaxX(_startBtn.frame)+10, self.view.frame.size.height-160*phoneScale, WT/3-10, 50);
    }
    
    //结束
    if (!_endBtn) {
        _endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _endBtn.frame =  CGRectMake(CGRectGetMaxX(_reportBtn.frame)+10, self.view.frame.size.height-160*phoneScale, WT/3-10, 50);
    }
    _endBtn.layer.cornerRadius = 160*phoneScale/2;
    _endBtn.layer.masksToBounds = YES;
    [self.view addSubview:_endBtn];
    
    _endBtn.backgroundColor = UIColorFromRGB(0xD0D2D1);
    _endBtn.layer.cornerRadius = 10;
    [_endBtn setTitle:@"结束巡河" forState:UIControlStateNormal];
    if ([datasource.IsStart intValue] == 1) {
        if ([datasource.IsEnd intValue] == 1) {
            
            [_endBtn setTitleColor:UIColorFromRGB(0xD0D2D1) forState:UIControlStateSelected];
        } else if ([datasource.IsEnd intValue] == 0){
            _endBtn.selected = NO;
            [_endBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_endBtn addTarget:self action:@selector(ENDresignWindow) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } else if ([datasource.IsStart intValue] == 0){
        [_endBtn setTitleColor:UIColorFromRGB(0x989A99) forState:UIControlStateSelected];
        
    }
    
   //上报
   
    _reportBtn.layer.cornerRadius = 160*phoneScale/2;
    _reportBtn.layer.masksToBounds = YES;
    [self.view addSubview:_reportBtn];
    
    _reportBtn.backgroundColor = UIColorFromRGB(0xD0D2D1);
    _reportBtn.layer.cornerRadius = 10;
//    [_reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_reportBtn setTitle:@"巡河上报" forState:UIControlStateNormal];
//    [_reportBtn addTarget:self action:@selector(reportWindow) forControlEvents:UIControlEventTouchUpInside];
    //
    if ([datasource.IsStart intValue] == 1) {
        if ([datasource.IsEnd intValue] == 1) {
           
            [_reportBtn setTitleColor:UIColorFromRGB(0xD0D2D1) forState:UIControlStateSelected];
        } else if ([datasource.IsEnd intValue] == 0){
          
             [_reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
              [_reportBtn addTarget:self action:@selector(reportWindow) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } else if ([datasource.IsStart intValue] == 0){
        [_reportBtn setTitleColor:UIColorFromRGB(0x989A99) forState:UIControlStateSelected];
        
    }
    
    
    [CustomHUD dismiss];
}
- (void)StartresignWindow {
    
    [self getDataForWhereRiverID];
    
}
-(void)getDataForWhereRiverID{
    NSDictionary *param = @{
                            @"userid":datasource.UserID};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetRiverLongByUser", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"ssID" success:^(id result) {
        NSLog(@"选择那条河---%@",result);
        if ([result[@"Status"] isEqualToString:@"OK"]&&[result[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in result[@"Data"]) {
                [self.RIDDic setValue:dic[@"RiverID"] forKey:dic[@"RiverName"]];
            }
            if (self.RIDDic.count> 0 ) {
                
                [self getRID];
            }else{
                [YJProgressHUD showError:@"您暂无法巡河，请联系相关人员"];
            }
        }else{
            [YJProgressHUD showError:@"您暂无法巡河，请联系相关人员"];
        }
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}
- (void)getRID{
    NSArray *arr = self.RIDDic.allKeys ;
    
    [ZJBLStoreShopTypeAlert showWithTitle:@"选择巡河河道" titles:arr selectIndex:^(NSInteger selectIndex) {
        
        
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
        
        self.RID = _RIDDic[selectValue];
        datasource.RiverID = self.RID;
        datasource.RiverName = selectValue;
        NSLog(@"RID--%@",self.RID );
        [self startRivierCruise];
    } showCloseButton:YES];
}
//是否巡河上报
- (void)sendIsExistatrolReportInfoRequest{
    NSDictionary *param = @{
                            @"patrolcheckid":datasource.dataRiverID
                            };
    //F(@"%@/IsExistatrolReportInfo",BaseRequestUrl)
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/IsExistatrolReportInfo",RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"IsExistatrolReportInfo" success:^(id result) {
        NSLog(@"是否巡河上报---%@",result);
        if ([result[@"Status"] isEqualToString:@"OK"]
            && [result[@"Msg"] isEqualToString:@"成功"]) {
            [self setJudgePatrolTime];
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"本次巡河您还未上报,请先上报" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:actionCancel];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}
#pragma mark - button click
-(void)startRivierCruise{
    self.dataSouce = datasource.dataSouce;
    self.datalong = datasource.datalong;
    self.AllTheData = datasource.AllTheData;
    
    
    [self performSelector:@selector(startLocationService) withObject:nil afterDelay:0.5];
    
    if ([datasource.IsStart intValue] == 0 || ([datasource.IsStart intValue] == 1 && [datasource.IsEnd intValue] == 1)) {
        [self startRiverCruise];
    }
    _startBtn.selected = YES;
    [_startBtn setTitleColor:UIColorFromRGB(0x989A99) forState:UIControlStateSelected];
}
- (void)ENDresignWindow {
    [self sendIsExistatrolReportInfoRequest];
}

- (void)reportWindow {
    RiverTourReportViewController *reportVC = [[RiverTourReportViewController alloc] init];
    reportVC.CheckID = datasource.dataRiverID;
    if (self.AddressReport.length > 0) {
        reportVC.AddressStr = self.AddressReport;
    } else {
        reportVC.AddressStr = self.addressStr;
    }

    if (self.longitudeReport.length > 0 || self.latitudeReport.length > 0) {
        reportVC.longitudeStr = self.longitudeReport;
        reportVC.latitudeStr = self.latitudeReport;
    } else {
        reportVC.longitudeStr = _startLon;
        reportVC.latitudeStr = _startLat;
    }
    
    [self.navigationController pushViewController:reportVC animated:YES];
  
}
- (void)setJudgePatrolTime {
    if ([_timeLabel.text integerValue] >= 5.0) {
        [_locationService stopUserLocationService];
        [_manager stopLocationService];
        
        
        _endBtn.selected = YES;
        [_endBtn setTitleColor:UIColorFromRGB(0x989A99) forState:UIControlStateSelected];
        
        [self endRiverCruise];
        
        EndRiverViewController *endVC = [[EndRiverViewController alloc] init];
        endVC.TourRiverResultsStr = @"有效";
        endVC.lengthStr = datasource.timeLenthStr;
        endVC.distanceStr = datasource.disLentStr;
        endVC.allPathStr = self.patorlPath;
        endVC.title = @"河长巡河";
        [self.navigationController pushViewController:endVC animated:YES];//
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"巡河时长未达到5分钟，结束巡河数据无法上传，是否结束巡河" preferredStyle:UIAlertControllerStyleAlert];
        [alert  addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_locationService stopUserLocationService];
            [_manager stopLocationService];
            

            _endBtn.selected = YES;
            [_endBtn setTitleColor:UIColorFromRGB(0x989A99) forState:UIControlStateSelected];

            [self endRiverCruise];

            EndRiverViewController *endVC = [[EndRiverViewController alloc] init];
            endVC.TourRiverResultsStr = @"无效(巡河时长未达到5分钟)";
            endVC.lengthStr = datasource.timeLenthStr;
            endVC.distanceStr = datasource.disLentStr;
            endVC.allPathStr = self.patorlPath;
            endVC.title = @"河长巡河";
            [self.navigationController pushViewController:endVC animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - data request
-(void)getDataForReporterRiverID{
    NSDictionary *param = @{
                            @"userid":datasource.UserID
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetRiverLongByUser",BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"ssID" success:^(id result) {
        NSLog(@"该河长管理的所有河道---%@",result);
        if ([result[@"Status"] isEqualToString:@"OK"]&&[result[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in result[@"Data"]) {
                [self.RIDDic setValue:dic[@"RiverID"] forKey:dic[@"RiverName"]];
            }
            if (self.RIDDic.count> 0 &&[datasource.IsStart integerValue] == 0) {
                
                [self getReporteRID];
            }
        }else{
            [YJProgressHUD showError:@"您暂无法巡河，请联系相关人员"];
        }
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}
- (void)getReporteRID {
    NSArray *arr = self.RIDDic.allKeys ;
    
    [ZJBLStoreShopTypeAlert showWithTitle:@"选择巡河河道" titles:arr selectIndex:^(NSInteger selectIndex) {
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
        
        datasource.RiverID = _RIDDic[selectValue];
        RiverTourReportViewController *reportVC = [[RiverTourReportViewController alloc] init];
        datasource.RiverName = selectValue;
        [self.navigationController pushViewController:reportVC animated:YES];
        NSLog(@"RIDdatamanager.RiverID--%@",datasource.RiverID );
        
    } showCloseButton:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



#pragma mark - 视图的出现和消失(在其中设置代理和取消代理，优化内存管理)
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locationService.delegate = self;
    
    _topView.hidden = NO;
    _endBtn.hidden = NO;
    _startBtn.hidden = NO;
    _reportBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    
//    _mapView.delegate = nil;//不使用的时候设置为nil，否者影响内存释放
//    _locationService.delegate = nil ;
    
    _topView.hidden = YES;
    _endBtn.hidden = YES;
    _startBtn.hidden = YES;
    _reportBtn.hidden = YES;
    
}
#pragma mark - BMKLocationServiceDelegate
// 更新方向
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
    [self.mapView updateLocationData:userLocation];
}
//- (void)didFailToLocateUserWithError:(NSError *)error {
//    NSLog(@"did failed locate,error is %@",[error localizedDescription]);
//    UIAlertView *gpsWeaknessWarning = [[UIAlertView alloc]initWithTitle:@"定位失败" message:@"请允许使用您的位置通过隐私设置- > - >位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [gpsWeaknessWarning show];
//}
//处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    [_mapView updateLocationData:userLocation];
//
//    MapCoordinate.latitude = userLocation.location.coordinate.latitude;
//    MapCoordinate.longitude = userLocation.location.coordinate.longitude;
//    _startLat = [[NSString alloc] initWithFormat:@"%f",MapCoordinate.latitude];
//    _startLon = [[NSString alloc] initWithFormat:@"%f",MapCoordinate.longitude];
//    datasource.siteLats = _startLat;
//    datasource.siteLongs = _startLon;
//    //屏幕坐标转地图经纬度
//    if (_geoCodeSearch==nil) {
//        //初始化地理编码类
//        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
//        _geoCodeSearch.delegate = self;
//    }
//    if (_reverseGeoCodeOption==nil) {
//        //初始化反地理编码类
//        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
//    }
//    //需要逆地理编码的坐标位置
//    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
//    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
//    //创建地理编码对象
//    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
//    //创建位置
//    CLLocation *location=[[CLLocation alloc]initWithLatitude:MapCoordinate.latitude longitude:MapCoordinate.longitude];
//    //反地理编码
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        //判断是否有错误或者placemarks是否为空
//        if (error !=nil || placemarks.count==0) {
//            NSLog(@"%@",error);
//            return ;
//        }
//        for (CLPlacemark *placemark in placemarks) {
//            //赋值详细地址
//            self.addressStr = F(@"%@%@%@%@",placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.name);
//            NSLog(@"赋值详细地址====%@",self.addressStr);
//            datasource.locations = self.addressStr;
//
//        }
//
//    }];
//    DataSource *datasource = [DataSource sharedDataSource];
//    if ([datasource.IsStart intValue] == 1 && [datasource.IsEnd intValue] == 0) {
//        [self startTrailRouteWithUserLocation:userLocation];
//    }
//}
- (void)reverseGeoCodeCoordinate:(CLLocationCoordinate2D)coordinate{
    BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reversegeoCode = [[BMKReverseGeoCodeOption alloc]init];
    reversegeoCode.reverseGeoPoint = coordinate;
    BOOL flag = [geoCodeSearch reverseGeoCode:reversegeoCode];
    if (flag) {
        NSLog(@"反检索成功");
    } else {
        NSLog(@"反检索失败");
    }
}
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    MapCoordinate.latitude = userLocation.location.coordinate.latitude;
    MapCoordinate.longitude = userLocation.location.coordinate.longitude;
    _startLat = [[NSString alloc] initWithFormat:@"%f",MapCoordinate.latitude];
    _startLon = [[NSString alloc] initWithFormat:@"%f",MapCoordinate.longitude];
    datasource.siteLats = _startLat;
    datasource.siteLongs = _startLon;
    
    [self reverseGeoCodeCoordinate:userLocation.location.coordinate];
    DataSource *datasource = [DataSource sharedDataSource];
    if ([datasource.IsStart intValue] == 1 && [datasource.IsEnd intValue] == 0) {
        [self startTrailRouteWithUserLocation:userLocation];
    }
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.addressStr = F(@"%@",result.address);
        NSLog(@"赋值详细地址====%@",self.addressStr);
        datasource.locations = self.addressStr;
    } else {
        self.addressStr = @"未知位置";
    }
}
#pragma mark - Selector for didUpdateBMKUserLocation:
- (void)startTrailRouteWithUserLocation:(BMKUserLocation *)userLocation {
    if (datasource.preLocation) {
        NSTimeInterval dtime = [userLocation.location.timestamp timeIntervalSinceDate:datasource.preLocation.timestamp];
        self.sumTime += dtime;
        CGFloat distance = [userLocation.location distanceFromLocation:datasource.preLocation];
        NSLog(@"与上一位置点的距离为:%f",distance);
        if (distance < 5) {
            NSLog(@"与前一更新点距离小于5m，直接返回该方法");
            return;
        }
        
        if (userLocation.location.coordinate.latitude > datasource.preLocation.coordinate.latitude && userLocation.location.coordinate.longitude > datasource.preLocation.coordinate.longitude) {
            NSLog(@"东北方向行进中");
        }
        if (userLocation.location.coordinate.latitude > datasource.preLocation.coordinate.latitude && userLocation.location.coordinate.longitude < datasource.preLocation.coordinate.longitude) {
            NSLog(@"西北方向行进中");
        }
        if (userLocation.location.coordinate.latitude < datasource.preLocation.coordinate.latitude && userLocation.location.coordinate.longitude > datasource.preLocation.coordinate.longitude) {
            NSLog(@"东南方向行进中");
        }
        if (userLocation.location.coordinate.latitude < datasource.preLocation.coordinate.latitude && userLocation.location.coordinate.longitude < datasource.preLocation.coordinate.longitude) {
            NSLog(@"西南方向行进中");
        }
        
        self.sumDistance += distance;
        NSLog(@"步行总距离为:%f",self.sumDistance);
        
        CGFloat speed = distance / dtime;
        CGFloat avgSpeed  = self.sumDistance / self.sumTime;
        NSLog(@"步行的当前移动速度为:%.3f============%f", speed, avgSpeed);
       
    }
    
    [datasource.locationArrayM addObject:userLocation.location];
    datasource.preLocation = userLocation.location;
    
    [self drawWalkPolyline];
    
}
- (void)drawWalkPolyline {
    NSUInteger count = datasource.locationArrayM.count;
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    [datasource.locationArrayM enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
        NSLog(@"idx = %ld,tempPoints X = %f Y = %f",idx,tempPoints[idx].x,tempPoints[idx].y);
        
        if (0 == idx && TrailStart == datasource.trail && datasource.startPoint == nil) {
            datasource.startPoint = [self creatPointWithLocaiton:location title:@"起点"];
        }
//        [self creatPointWithLocaiton:location title:F(@"过程点%lu", (unsigned long)count)];
    }];
    
    if (datasource.polyLine) {
        [self.mapView removeOverlay:datasource.polyLine];
    }
    
    datasource.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    if (datasource.polyLine) {
        [self.mapView addOverlay:datasource.polyLine];
    }
    
    delete []tempPoints;
    
    [self mapViewFitPolyLine:datasource.polyLine];
}
#pragma mark -  开始 && 结束
//开始巡河
- (void)startRiverCruise {//,point:%@   ,F(@"%@,%@", _startLat,_startLon)
    NSDictionary *param = @{
                            @"action":@"1",
                            @"method":F(@"{riverID:%@,patrolID:%@,address:%@}", datasource.RiverID,datasource.UserID,self.addressStr)
                            };
    // http://218.108.63.142:7509/JXGQApi.asmx/RiverManagement?
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseRiverMURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"statemmm" success:^(id result) {
        NSLog(@"开始巡河的结果--------- %@", result);
        [YJProgressHUD showSuccess:@"巡河开始"];
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            self.rcModel.PatorlRiverID = dicData[@"Result"];
        }
        datasource.dataRiverID = self.rcModel.PatorlRiverID;
        datasource.isTouchBegin = YES;
        datasource.IsStart = @"1";
        datasource.isTouchOver = NO;
        datasource.IsEnd = @"0";


        datasource.TimeDifferenceStart = [self getCurrentTimes];


        [_startBtn setTitleColor:UIColorFromRGB(0x989A99) forState:UIControlStateSelected];
        [_endBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _startBtn.userInteractionEnabled = NO;
        _endBtn.userInteractionEnabled = YES;
         _reportBtn.userInteractionEnabled = YES;
         [_reportBtn addTarget:self action:@selector(reportWindow) forControlEvents:UIControlEventTouchUpInside];
        [_endBtn addTarget:self action:@selector(ENDresignWindow) forControlEvents:UIControlEventTouchUpInside];

//        datasource.locationArrayM = [NSMutableArray array];
        [datasource.locationArrayM removeAllObjects];
        [self clean];
        datasource.trail = TrailStart;

        [self sendJudgePatrolRiverRequest];


//            [self sendUploadLongitudeLatitudeRealTimeRequest];


    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
    
}

//结束巡河
- (void)endRiverCruise {
    if (self.AllTheData.count > 0) {
        self.patorlPath = [self.AllTheData componentsJoinedByString:@";"];
    } else {
        self.patorlPath = F(@"%@'%@", _startLat,_startLon);
    }
    if ([datasource.timeLenthStr isEqualToString:@"nan"] || datasource.timeLenthStr == nil) {
        datasource.timeLenthStr = @"0";
    }
    if (datasource.disLentStr == nil) {
        datasource.disLentStr = @"0";
    }
    
    NSString *deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名字--------%@", deviceName); 
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    NSDictionary *param = @{
                            @"action":@"3",
//                            @"method":F(@"{lengthOfTime:%@,patorlRiverID:%@,patrolRiverDistance:%@,patorlPath:%@}", datasource.timeLenthStr,datasource.dataRiverID,datasource.disLentStr, self.patorlPath),
                            @"method":F(@"{lengthOfTime:%@,patorlRiverID:%@,patrolRiverDistance:%@,patorlPath:%@,system:%@,version:%@}", @"",datasource.dataRiverID, @"",@"", deviceName, appCurVersion)
                            };
    //http://111.3.68.233:40007/JXGQApi.asmx/RiverManagement
    //BaseRiverMURLStr
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseRiverMURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"statemmm" success:^(id result) {
        NSLog(@"巡河结束啦啦啦啦--------- %@", result);   
        [self.datalong removeAllObjects];
        latitude = 0.0;
        longitude = 0.0;
        
        
        [YJProgressHUD showSuccess:@"巡河结束"];
        datasource.isTouchOver = YES;
        datasource.IsEnd = @"1";
        
        [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(StartresignWindow) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.userInteractionEnabled = YES;
        _endBtn.userInteractionEnabled = NO;
        _reportBtn.userInteractionEnabled = NO;
        //UIColorFromRGB(0x989A99)
        _endBtn.selected = NO;
        [_endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reportBtn.selected = NO;
        [_reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self stopTrack];
        
        [self sendJudgePatrolRiverRequest];
        
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"结束失败"];
        NSLog(@"%@", error);
    }];
}

#pragma mark - location line
- (void)startLocationService{
    _manager = [YZLocationManager sharedLocationManager];
    _manager.isBackGroundLocation = YES;
    _manager.locationInterval = 10;
    //    @weakify(manager)
    [_manager setYZBackGroundLocationHander:^(CLLocationCoordinate2D coordinate) {
        _plc(coordinate);
        YZLMLOG(@">>>>>>>>>>>>>%f,%f",coordinate.latitude,coordinate.longitude);
        self.longitudeReport = F(@"%f", coordinate.longitude);
        self.latitudeReport = F(@"%f", coordinate.latitude);
        //        @strongify(manager) //注意别造成循环引用
        [_manager geoCodeSearchWithCoorinate:coordinate address:^(NSString *address, NSUInteger error) {
            
                        YZLMLOG(@"4444444444++++++++++++address:%@",address);
            self.AddressReport = address;
        }];
        
        
        NSDictionary *dic = @{
                              @"time":self.dateString,
                              @"coordinate":[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude]
                              };
        
        YZLMLOG(@"4444444444>>>>>>>>>>address:++++++%@",dic);
        
        
        coordinateNew = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        NSInteger ss = 0 ;
        if (latitude == 0.0) {
            ss =  0;
        } else {
            ss = [self newDis:coordinateNew oldDis:coordinateOld];
        }
        if (ss >150){
            
            coordinateNew =   coordinateOld;
            ss = [self newDis:coordinateNew oldDis:coordinateOld];
        }else{
            
            latitude  = coordinate.latitude;
            longitude = coordinate.longitude;
            coordinateOld = CLLocationCoordinate2DMake(latitude, longitude);
            
        }
        NSLog(@"ss=%ld",(long)ss);
        
        [self.datalong addObject:F(@"%ld", (long)ss)];
        [self.dataSouce addObject:self.dateString];
        
        datasource.distancePoints = F(@"%ld", (long)ss);
        [self.AllTheData addObject:F(@"%f'%f",latitude,longitude)];
        
        NSLog(@"==================== %lu",(unsigned long)self.dataSouce.count);
        NSLog(@"dataSouce--%@--AllTheData---%@-datalong--%@",self.dataSouce,self.AllTheData,self.datalong);
        NSString *timeLe = F(@"%@", [self getTheCorrectNum:[self compareTwoTime:[self.dataSouce firstObject] time2:[self.dataSouce lastObject]]]);
        datasource.timeLenthStr = F(@"%.1f", [timeLe doubleValue] + self.ExistingTime);
        _timeLabel.text = F(@"%@ 分钟", datasource.timeLenthStr);
        
        NSNumber *sum = [self.datalong valueForKeyPath:@"@sum.floatValue"];
        datasource.disLentStr = F(@"%.0f", round([sum floatValue]+[self.distanceExisting floatValue]));
        _distanceLabel.text = F(@"%@ 米", datasource.disLentStr);
        
        
#warning <#message#>
        
            [self sendUploadLongitudeLatitudeRealTimeRequest];
        

    }];
    
    [_manager setYZBackGroundGeocderAddressHander:^(NSString *address) {
        YZLMLOG(@">>>>jjjjj>>>>>>address:%@",address);
        if (address.length > 0) {
            self.AddressReport = address;
        }
        
    }];
    [_manager startLocationService];
}
- (NSInteger)newDis:(CLLocationCoordinate2D)newDis oldDis:(CLLocationCoordinate2D)oldDis {
    BMKMapPoint point1 = BMKMapPointForCoordinate(oldDis);
    BMKMapPoint point2 = BMKMapPointForCoordinate(newDis);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);

    return (NSInteger)distance;
}
- (NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dateString;
}
//计算两个时间戳的时间差
- (NSString*)compareTwoTime:(NSString *)beginTimestamp time2:(NSString *)endTimestamp {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:MM:ss"];//@"yyyy-MM-dd-HHMMss"
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[beginTimestamp doubleValue]];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"开始时间: %@", dateString);
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[endTimestamp doubleValue]];
    NSString *dateString2 = [formatter stringFromDate:date2];
    NSLog(@"结束时间: %@", dateString2);
    
    NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
    NSLog(@"两个时间相隔：%f", seconds);
    
    
    return F(@"%f", seconds/60);
}


/*
 * 处理一个字符串数字加小数点的字符串,保留两位
 */
- (NSString*)getTheCorrectNum:(NSString*)tempString {
    if ([tempString hasPrefix:@"."]) {
        tempString = [NSString stringWithFormat:@"0%@",tempString];
    }
    NSUInteger endLength = tempString.length;
    if ([tempString containsString:@"."]) {
        NSRange pointRange = [tempString rangeOfString:@"."];
        NSLog(@"%lu",pointRange.location);
        NSUInteger f = tempString.length - 1 - pointRange.location;
        if (f > 2) {
            endLength = pointRange.location + 2;
        }
    }
    NSUInteger start = 0;
    const char *tempChar = [tempString UTF8String];
    for (int i = 0; i < tempString.length; i++) {
        if (tempChar[i] == '0') {
            start++;
        }else {
            break;
        }
    }
    if (tempChar[start] == '.') {
        start--;
    }
    NSRange range = {start,endLength-start};
    tempString = [tempString substringWithRange:range];
    return tempString;
}

#pragma mark - BMKMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
        polylineView.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if(datasource.startPoint){
            annotationView.pinColor = BMKPinAnnotationColorGreen;
        } else {
            annotationView.pinColor = BMKPinAnnotationColorPurple;
        }
        annotationView.animatesDrop = YES;
        annotationView.draggable = NO;
        
        return annotationView;
    }
    return nil;
}
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title {
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapView addAnnotation:point];
    
    return point;
}

- (void)clean {
    //清空数组
    [datasource.locationArrayM removeAllObjects];
    if (datasource.startPoint) {
        [self.mapView removeAnnotation:datasource.startPoint];
        datasource.startPoint = nil;
        datasource.timeLenthStr = nil;
        datasource.disLentStr = nil;
    }
    if (datasource.endPoint) {
        [self.mapView removeAnnotation:datasource.endPoint];
        datasource.endPoint = nil;
    }
    if (datasource.polyLine) {
        [self.mapView removeOverlay:datasource.polyLine];
        datasource.polyLine = nil;
    }
}

- (void)mapViewFitPolyLine:(BMKPolyline *)polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self.mapView setVisibleMapRect:rect];
    self.mapView.zoomLevel = self.mapView.zoomLevel - 0.3;
}
- (void)stopTrack {
    datasource.trail = TrailEnd;
    [self.locationService stopUserLocationService];
    if (datasource.startPoint) {
        datasource.endPoint = [self creatPointWithLocaiton:datasource.preLocation title:@"终点"];
    }
}

//获取当前的时间
- (NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}
#pragma mark - 将某个时间戳转化成 时间
- (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    return confromTimespStr;
    
}


@end
