//
//  MapRouteViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/11/9.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "MapRouteViewController.h"

@interface MapRouteViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKMapView* mapView;

@property (nonatomic, strong) NSMutableArray *PatorlPathArr;

@property (nonatomic, strong) NSArray *PathArray;
@property (nonatomic, strong) NSArray *arrayCut;

@property (nonatomic, strong) BMKPointAnnotation *annotationEnd;

@property(strong,nonatomic) UIWindow *mapwindow;
@property(strong,nonatomic) UIView *underViewMap;
@end

@implementation MapRouteViewController
- (NSMutableArray *)PatorlPathArr {
    if (_PatorlPathArr == nil) {
        _PatorlPathArr = [NSMutableArray array];
    }
    
    return _PatorlPathArr;
}
-(void)viewDidAppear:(BOOL)animated{
    if (self.PathArray.count > 1) {
        NSArray *lonLatfirst = [self.PathArray.firstObject componentsSeparatedByString:@","];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake([lonLatfirst[0] floatValue], [lonLatfirst[1] floatValue]);
        annotation.title = @"起点";
        [self.mapView addAnnotation:annotation];
        
        NSArray *lonLatLast = [self.PathArray.lastObject componentsSeparatedByString:@","];
        self.annotationEnd = [[BMKPointAnnotation alloc]init];
        self.annotationEnd.coordinate = CLLocationCoordinate2DMake([lonLatLast[0] floatValue], [lonLatLast[1] floatValue]);
        self.annotationEnd.title = @"终点";
        [_mapView addAnnotation:self.annotationEnd];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"巡河轨迹";
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, WT, HT)];
    [self.view addSubview:_mapView];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    [_mapView setZoomLevel:17];
    
    if (_pathStr.length > 0) {
        self.PathArray = [_pathStr componentsSeparatedByString:@";"];
        if (self.PathArray.count <= 1) {
            [YJProgressHUD showError:@"该点无轨迹"];
        }
        NSArray *lonLat = [self.PathArray[0] componentsSeparatedByString:@","];
        CLLocationCoordinate2D coor;
        coor.latitude = [lonLat[0] floatValue];
        coor.longitude = [lonLat[1] floatValue];
        [self.mapView setCenterCoordinate:coor animated:YES];
        
        [self setMapLineDrawing];
    } else {
        [YJProgressHUD showError:@"该点无轨迹"];
    }
    [self setSuspendedView];
}
- (void)setSuspendedView {
    _mapwindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, HT-150, WT, 140)];
    _mapwindow.windowLevel = UIWindowLevelAlert+1;
    _mapwindow.backgroundColor = [UIColor whiteColor];
    _mapwindow.layer.masksToBounds = YES;
    _underViewMap = [[UIView alloc] init];
    _underViewMap.frame = CGRectMake(0, 0, _mapwindow.frame.size.width, 140);
    
    UILabel *reslustLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _underViewMap.frame.size.width, _underViewMap.frame.size.height/3)];
    if ([self.timeLenStr intValue] < 300) {
        reslustLabel.textColor = [UIColor redColor];
        reslustLabel.text = F(@"   巡河结果: %@", @"无效");
    } else {
        reslustLabel.text = F(@"   巡河结果: %@", @"有效");
    }
    
    [_underViewMap addSubview:reslustLabel];
    
    UILabel *strTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(reslustLabel.frame), _underViewMap.frame.size.width, _underViewMap.frame.size.height/3)];
    if(self.timeLenStr.length > 0) {
        strTimeLabel.text = F(@"   巡河时长: %.1f分钟", [self.timeLenStr intValue]/60.0);
    } else {
        strTimeLabel.text = @"   巡河时长: 0分钟";
    }
    
    [_underViewMap addSubview:strTimeLabel];
    
    UILabel *strDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(strTimeLabel.frame), _underViewMap.frame.size.width, _underViewMap.frame.size.height/3)];
    if (self.distanceStr.length > 0) {
        strDistanceLabel.text = F(@"   巡河距离: %@米", self.distanceStr);
    } else {
        strDistanceLabel.text = @"   巡河距离: 0米";
    }
    
    [_underViewMap addSubview:strDistanceLabel];
    
    [_mapwindow addSubview:_underViewMap];
    [_mapwindow makeKeyAndVisible];
}

- (void)setMapLineDrawing {
    self.PathArray = [_pathStr componentsSeparatedByString:@";"];
    float tripArrayCount = [self.PathArray count];
    CLLocationCoordinate2D * coors = (CLLocationCoordinate2D *)malloc(tripArrayCount * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < self.PathArray.count; i++) {
        self.arrayCut = [self.PathArray[i] componentsSeparatedByString:@","];
        coors[i].latitude = [self.arrayCut[0] doubleValue];
        coors[i].longitude = [self.arrayCut[1] doubleValue];
    }
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coors count:self.PathArray.count];
    [_mapView addOverlay:polyline];
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polyLineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polyLineView.strokeColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polyLineView.lineWidth = 2.0;
        
        return polyLineView;
    }
    return nil;
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
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        if (self.annotationEnd) {
            annotationView.image = [UIImage imageNamed:@"route_end.png"];
        } else {
            annotationView.image = [UIImage imageNamed:@"route_start.png"];
        }
        
        return annotationView;
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    
    [_mapwindow resignKeyWindow];
    _mapwindow = nil;
    _underViewMap.hidden = YES;
}
@end
