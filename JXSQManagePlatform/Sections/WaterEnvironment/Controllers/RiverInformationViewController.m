//
//  RiverInformationViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/19.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverInformationViewController.h"
#import "RiverInformotionTableViewCell.h"
#import "LMJDropdownMenu.h"
#import "RiverListModel.h"
#import "DVLineChartView.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
@interface RiverInformationViewController ()<UITableViewDelegate,UITableViewDataSource,LMJDropdownMenuDelegate,DVLineChartViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *stationLabel;
@property (nonatomic, strong) NSMutableArray *listStationArr;
@property (nonatomic, strong) LMJDropdownMenu *dropdownMenu;
@property (nonatomic, strong) NSMutableArray *IDArr;
@property (nonatomic, strong) NSMutableArray *RiverNameArr;
@property (nonatomic, strong) DVLineChartView *ccc;

@end

@implementation RiverInformationViewController
//人工采样
- (NSMutableArray *)listStationArr {
    if (!_listStationArr) {
        self.listStationArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _listStationArr;
}
- (NSMutableArray *)IDArr {
    if (!_IDArr) {
        self.IDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _IDArr;
}
- (NSMutableArray *)RiverNameArr {
    if (!_RiverNameArr) {
        self.RiverNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _RiverNameArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self sendArtificialSamplingList];
    // Do any additional setup after loading the view from its nib.
}
- (void)sendArtificialSamplingList {
    NSDictionary *param = @{
                            @"RiverType":@"1",@"RiverLevel":@""
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetALLRiverInfo", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"base" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.IDArr addObject:dic[@"ID"]];
                [self.RiverNameArr addObject:dic[@"RiverName"]];
                
            }
        }
        [self setViewHeader];
        NSLog(@"人工采样==========%@", result);
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)sendWaterMonitoringByID:(NSString *)RiverID {
    [self.listStationArr removeAllObjects];
    [self.CODArr removeAllObjects];
    [self.NHArr removeAllObjects];
    [self.TPArr removeAllObjects];
    [self.dateArr removeAllObjects];
    NSDictionary *param = @{
                            @"RiverID":RiverID
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetWaterMonitoringByID", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"information" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.CODArr addObject:dic[@"COD"]];
                [self.NHArr addObject:dic[@"NH3"]];
                [self.TPArr addObject:dic[@"TP"]];
                [self.dateArr addObject:dic[@"Month"]];
                
                RiverListModel *listModel = [[RiverListModel alloc] initWithDic:dic];
                [self.listStationArr addObject:listModel];
                
        }
        }
        [CustomHUD dismiss];
        [self.tableView reloadData];
        [self getLineChart];
//        NSLog(@"河道信息信息信息==========%@", result);
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)setViewHeader {
    DataSource *drasour = [DataSource sharedDataSource];
    drasour.selectArtificialStr = self.RiverNameArr[0];
    
    self.stationLabel = [[UILabel alloc] init];
    _stationLabel.text = @"点击选择站点:";
    _stationLabel.font = [UIFont systemFontOfSize:15];
    _stationLabel.frame = CGRectMake(10, NAVIHEIGHT+16, WT/3, 40);
    _stationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_stationLabel];
    _dropdownMenu = [[LMJDropdownMenu alloc] init];
    [_dropdownMenu setFrame:CGRectMake(CGRectGetMaxX(_stationLabel.frame)+10, NAVIHEIGHT+16, WT/2, 40)];
    if (self.RiverNameArr.count > 0) {
        [_dropdownMenu setMenuTitles:self.RiverNameArr rowHeight:50];
        [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
        [self sendWaterMonitoringByID:self.IDArr[0]];
    }
    _dropdownMenu.delegate = self;
    [self.view addSubview:_dropdownMenu];
    [self createSegement];
    [self setCreatTabelView];
}
- (void)createSegement {
    NSArray *array = [NSArray arrayWithObjects:@"数据详情",@"折线图", nil];
    _segment = [[UISegmentedControl alloc]initWithItems:array];
    _segment.selectedSegmentIndex = 0;
    _segment.frame = CGRectMake(WT/2.0 - 150, CGRectGetMaxY(self.stationLabel.frame)+10, 300, 36);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont boldSystemFontOfSize:15],
                         NSFontAttributeName,nil];
    
    [_segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    _segment.backgroundColor = [UIColor whiteColor];
    [_segment addTarget:self action:@selector(HandleChanges:) forControlEvents:UIControlEventValueChanged];
    _segment.tintColor = UIColorFromRGB(0x2ab1e7);
    [self.view addSubview: _segment];
}
- (void)HandleChanges:(UISegmentedControl *)segemet {
    [_tableView removeFromSuperview];
    [self.chartView removeFromSuperview];
    switch (segemet.selectedSegmentIndex) {
        case 0:
        {
            [self.view addSubview:_tableView];
        }
            break;
        case 1:
        {
            [self chartViewSet];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setCreatTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, WT, HT-120-NAVIHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerTabView;
    [self.view addSubview:_tableView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listStationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RiverInformotionTableViewCell *cell = [RiverInformotionTableViewCell RiverInformotionTableViewCell:self.tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listStationArr.count > 0) {
        RiverListModel *model = self.listStationArr[indexPath.row];
        cell.mouthLabel.text = model.Month;
        cell.CODLabel.text = model.COD;
        cell.NHLabel.text = model.NH3;
        cell.TPLabel.text = model.TP;
        cell.levelLabel.text = model.RealWaterLevelName;
    }
   
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld=====%@",number, self.IDArr[number]);
    [self sendWaterMonitoringByID:self.IDArr[number]];
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    NSLog(@"--已经显示--");
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--已经隐藏--");
}
#pragma mark - 折线图
- (void)chartViewSet {
    self.chartView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.segment.frame)+5, WT, HT-120-NAVIHEIGHT)];
    self.chartView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.view addSubview:self.chartView];
    
    self.annotationLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WT, 40)];
    UILabel *codLab = [[UILabel alloc] init];
    if (WT < 350) {
        codLab.frame = CGRectMake(WT/6, 15, 30, 10);
    } else if (WT > 350 && WT < 400) {
        codLab.frame = CGRectMake(WT/5+10, 15, 30, 10);
    } else if (WT > 500) {
        codLab.frame = CGRectMake(WT/3+20, 15, 30, 10);
    } else {
        codLab.frame = CGRectMake(WT/4, 15, 30, 10);
    }
    codLab.backgroundColor = [UIColor colorWithHexString:@"0071bc"];
    [self.annotationLab addSubview:codLab];
    UILabel *codNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codLab.frame)+10, 15, 30, 10)];
    codNameLab.font = [UIFont systemFontOfSize:13];
    codNameLab.text = @"COD";
    [self.annotationLab addSubview:codNameLab];
    
    UILabel *NHLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codNameLab.frame)+10, 15, 30, 10)];
    NHLab.backgroundColor = [UIColor colorWithHexString:@"009245"];
    [self.annotationLab addSubview:NHLab];
    UILabel *nhNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(NHLab.frame)+10, 15, 50, 10)];
    nhNameLab.text = @"NH3-N";
    nhNameLab.font = [UIFont systemFontOfSize:13];
    [self.annotationLab addSubview:nhNameLab];
    
    UILabel *tpLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nhNameLab.frame)+10, 15, 30, 10)];
    tpLab.backgroundColor = [UIColor colorWithHexString:@"6fae22"];
    [self.annotationLab addSubview:tpLab];
    UILabel *tpNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tpLab.frame)+10, 15, 30, 10)];
    tpNameLab.text = @"TP";
    tpNameLab.font = [UIFont systemFontOfSize:13];
    [self.annotationLab addSubview:tpNameLab];
    [self.chartView addSubview:self.annotationLab];
    [self getLineChart];
}
//COD:#0071bc  NH3:#009245  TP:#6fae22
- (void)getLineChart {
    [_ccc removeFromSuperview];
    _ccc = [[DVLineChartView alloc] initWithFrame:CGRectMake(0, 40, WT-5, self.chartView.size.height-100)];
    [self.chartView addSubview:_ccc];
    
    _ccc.yAxisViewWidth = 52;
    _ccc.delegate = self;
    _ccc.pointUserInteractionEnabled = YES;
    NSNumber *CODmax = [self.CODArr valueForKeyPath:@"@max.floatValue"];
    NSNumber *NHmax = [self.NHArr valueForKeyPath:@"@max.floatValue"];
    NSNumber *TPmax = [self.TPArr valueForKeyPath:@"@max.floatValue"];
    NSArray *arr = [NSArray arrayWithObjects:CODmax,NHmax,TPmax, nil];
    NSNumber *max = [arr valueForKeyPath:@"@max.floatValue"];
    
    if ([max integerValue] > 50 && [max integerValue] < 100){
        _ccc.yAxisMaxValue = 100;
        _ccc.numberOfYAxisElements = 20;
    } else if ([max integerValue] > 20 && [max integerValue] < 50) {
        _ccc.yAxisMaxValue = 50;
        _ccc.numberOfYAxisElements = 10;
    } else if ([max integerValue] > 10 && [max integerValue] < 20) {
        _ccc.yAxisMaxValue = 20;
        _ccc.numberOfYAxisElements = 10;
    }else {
        _ccc.yAxisMaxValue = 10;
        _ccc.numberOfYAxisElements = 10;
    }
    _ccc.pointGap = 50;
    _ccc.showSeparate = NO;
    _ccc.separateColor = [UIColor colorWithHexString:@"67707c"];
    
    _ccc.textColor = [UIColor blackColor];
    _ccc.backColor = [UIColor clearColor];
    _ccc.axisColor = [UIColor colorWithHexString:@"67707c"];
    
    _ccc.xAxisTitleArray = self.dateArr;
    
    
    DVPlot *plot = [[DVPlot alloc] init];
    plot.pointArray = self.CODArr;
    plot.lineColor = [UIColor colorWithHexString:@"0071bc"];
    plot.pointColor = [UIColor colorWithHexString:@"0071bc"];
    plot.chartViewFill = YES;
    plot.withPoint = YES;
    
    
    DVPlot *plot1 = [[DVPlot alloc] init];
    plot1.pointArray = self.NHArr;
    plot1.lineColor = [UIColor colorWithHexString:@"009245"];
    plot1.pointColor = [UIColor colorWithHexString:@"009245"];
    plot1.chartViewFill = YES;
    plot1.withPoint = YES;
    
    DVPlot *plot2 = [[DVPlot alloc] init];
    plot2.pointArray = self.TPArr;
    plot2.lineColor = [UIColor colorWithHexString:@"6fae22"];
    plot2.pointColor = [UIColor colorWithHexString:@"6fae22"];
    plot2.chartViewFill = YES;
    plot2.withPoint = YES;
    
    
    [_ccc addPlot:plot];
    [_ccc addPlot:plot1];
    [_ccc addPlot:plot2];
    [_ccc draw];
}

- (NSMutableArray *)CODArr {
    if (!_CODArr) {
        self.CODArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _CODArr;
}
- (NSMutableArray *)NHArr {
    if (!_NHArr) {
        self.NHArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _NHArr;
}
- (NSMutableArray *)TPArr {
    if (!_TPArr) {
        self.TPArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _TPArr;
}
- (NSMutableArray *)dateArr {
    if (!_dateArr) {
        self.dateArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dateArr;
}
@end
