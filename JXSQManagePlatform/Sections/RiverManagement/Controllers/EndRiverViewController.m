//
//  EndRiverViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/5.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "EndRiverViewController.h"
#import "RiverManagerViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface EndRiverViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
@property (weak, nonatomic) UIButton *mapPin;
@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKLocationService *locService;

@property(strong,nonatomic) UIWindow *window;
@property(strong,nonatomic) UIView *underView;
@end

@implementation EndRiverViewController
- (BMKLocationService *)locService{
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];//设置定位精度
    }
    return _locService;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showPrompt:@"巡河已经结束!"];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, WT, HT-NAVIHEIGHT)];
    [self.view addSubview:_mapView];
    _mapView.mapType = BMKMapTypeStandard;//设置地图为类型

    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    //启动LocationService
    [_locService startUserLocationService];

    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
    [_mapView setZoomLevel:17];
    
    [self setMapLineDrawing];
    
    [self footViewGetset];
}

- (void)footViewGetset {
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(0, HT-100, WT, 90)];
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor whiteColor];
    _window.layer.masksToBounds = YES;
    _underView = [[UIView alloc] init];
    _underView.frame = CGRectMake(0, 0, _window.frame.size.width, 90);
    
    UILabel *reslustLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _underView.frame.size.width, _underView.frame.size.height/3)];
    if (![_TourRiverResultsStr isEqualToString:@"有效"]) {
        reslustLabel.textColor = [UIColor redColor];
    }
    reslustLabel.text = F(@"   巡河结果: %@", _TourRiverResultsStr);
    [_underView addSubview:reslustLabel];
    
    UILabel *strTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(reslustLabel.frame), _underView.frame.size.width, _underView.frame.size.height/3)];
    strTimeLabel.text = F(@"   巡河时长: %@分钟", _lengthStr);
    [_underView addSubview:strTimeLabel];
    
    UILabel *strDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(strTimeLabel.frame), _underView.frame.size.width, _underView.frame.size.height/3)];
    strDistanceLabel.text = F(@"   巡河距离: %@米", _distanceStr);
    [_underView addSubview:strDistanceLabel];
    
    [_window addSubview:_underView];
    [_window makeKeyAndVisible];//关键语句,显示window
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    [_window resignKeyWindow];
    _window = nil;
    _underView.hidden = YES;
    
    DataSource *datasource = [DataSource sharedDataSource];
    datasource.isTouchBegin = nil;
    datasource.isTouchOver = nil;
    datasource.IsStart = nil;
    datasource.IsEnd = nil;
    datasource.dataRiverID = nil;
    [datasource.AllTheData removeAllObjects];
    [datasource.dataSouce removeAllObjects];
    [datasource.datalong removeAllObjects];
    datasource.preLocation = nil;
    [datasource.locationArrayM removeAllObjects];
    datasource.polyLine = nil;
    datasource.trail = TrailStart;
    datasource.startPoint = nil;
    datasource.endPoint = nil;
    datasource.timeLenthStr = nil;
    datasource.disLentStr = nil;
    
}

- (void)setMapLineDrawing {
    self.PathArray = [self.allPathStr componentsSeparatedByString:@";"];
    float tripArrayCount = [self.PathArray count];
    CLLocationCoordinate2D * coors = (CLLocationCoordinate2D *)malloc(tripArrayCount * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < self.PathArray.count; i++) {
        self.arrayCut = [self.PathArray[i] componentsSeparatedByString:@"'"];
        coors[i].latitude = [self.arrayCut[0] doubleValue];
        coors[i].longitude = [self.arrayCut[1] doubleValue];
    }
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coors count:self.PathArray.count];
    [_mapView addOverlay:polyline];
    
    
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polyLineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polyLineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        polyLineView.lineWidth = 5.0;
        
        return polyLineView;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    self.mapView.showsUserLocation = YES;//显示定位图层
    [self.mapView updateLocationData:userLocation];
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
}
- (void)dealloc{
    if(_mapView) {
        _mapView=nil;
    }
}
- (BOOL)navigationShouldPopOnBackButton {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[RiverManagerViewController class]]) {
            RiverManagerViewController *homeRiverVC = (RiverManagerViewController *)controller;
            [self.navigationController popToViewController:homeRiverVC animated:YES];
        }
    }
    return NO;
}
- (void)showPrompt:(NSString *)promptMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:promptMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:true completion:nil];
}



@end
