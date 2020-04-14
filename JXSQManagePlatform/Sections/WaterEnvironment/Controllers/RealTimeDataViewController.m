//
//  RealTimeDataViewController.m
//  LWIntelligenceOperations
//
//  Created by 吴坤 on 17/5/17.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "RealTimeDataViewController.h"
#import "DVLineChartView.h"
#import "UIColor+Hex.h"
#import "UIView+Extension.h"
#import "StatisticalViewCell.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface RealTimeDataViewController ()<UITableViewDelegate,UITableViewDataSource,DVLineChartViewDelegate>{
    DataSource *dataManager;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *mdata;

@property (nonatomic, strong) NSMutableArray *dataTitleArr;
@property (nonatomic, strong) NSMutableArray *dataValuesArr;
@property (nonatomic, strong) NSMutableArray *dataTitleChineseArr;//变量中文名
@property (nonatomic, strong) NSMutableArray *dataNnitArr;//变量单位（""即为无单位）


@property (nonatomic, strong) NSMutableArray *DataTimesArr;
@property (nonatomic, strong) NSMutableArray *VarValuesArr;


@property(nonatomic,copy)NSString *actionStr;
@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,assign)NSInteger ht;
@end

@implementation RealTimeDataViewController
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] init];
    }
    return _tableView;
}
- (NSMutableArray *)dataTitleChineseArr {
    if (!_dataTitleChineseArr) {
        self.dataTitleChineseArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataTitleChineseArr;
}
- (NSMutableArray *)dataNnitArr {
    if (!_dataNnitArr) {
        self.dataNnitArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataNnitArr;
}
- (NSMutableArray *)dataTitleArr {
    if (!_dataTitleArr) {
        self.dataTitleArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataTitleArr;
}
- (NSMutableArray *)dataValuesArr {
    if (!_dataValuesArr) {
        self.dataValuesArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataValuesArr;
}
- (NSMutableArray *)DataTimesArr {
    if (!_DataTimesArr) {
        self.DataTimesArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _DataTimesArr;
}
- (NSMutableArray *)VarValuesArr {
    if (!_VarValuesArr) {
        self.VarValuesArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _VarValuesArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    dataManager = [DataSource sharedDataSource];
    if ([dataManager.tagString isEqualToString:@"10"]) {
        //在线水质
        self.urlString = F(@"%@/WaterEnvironment",RequestURL);
        self.actionStr = @"4";
        dataManager.siteClassID = self.SiteTypeIDstr;
        dataManager.siteIDString = self.siteID;
        _ht = NAVIHEIGHT;
    } else if ([dataManager.tagString isEqualToString:@"2"] || [dataManager.tagString isEqualToString:@"4"] || [dataManager.tagString isEqualToString:@"1"]||[dataManager.tagString isEqualToString:@"50"]){
        //地表水1 农村生活污水4 河道水质2
         self.view.frame = CGRectMake(0, 50+NAVIHEIGHT, WT, HT - 50-NAVIHEIGHT);
        self.urlString = BaseWaterEnURLStr;
        self.actionStr = @"4";
        _ht = 0;
    }
    [self setUpScrollView];
    [self sendOnlineMonitoringData];
    
}
- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _ht, WT, HT/2-30) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableViewHeader.frame = CGRectMake(0, 0, WT, 80);
    _tableView.tableHeaderView = self.tableViewHeader;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.timeDataLabel.adjustsFontSizeToFitWidth = YES;
    if ([dataManager.tagString isEqualToString:@"4"]||[dataManager.tagString isEqualToString:@"50"]) {
        self.waterLevelLab.hidden = YES;
        if (self.dataTitleArr.count > 0) {
            if ([self.dataValuesArr[0] isEqualToString:@"0"]) {
                self.timeDataLabel.text = @"数据采集时间:--";
            } else {
                self.timeDataLabel.text = F(@"数据采集时间:%@", self.dataValuesArr[0]);
            }
            
        } else {
            self.timeDataLabel.text = @"数据采集时间:--";
        }
    } else {
        if (self.dataTitleArr.count > 0) {
            if (WT < 350) {
                self.waterLevelLab.font = [UIFont systemFontOfSize:12];
            } else if (WT > 350 && WT < 500) {
                self.waterLevelLab.font = [UIFont systemFontOfSize:15];
            } else {
                self.waterLevelLab.adjustsFontSizeToFitWidth = YES;
            }
            if ([[self.dataTitleArr lastObject] isEqualToString:@"WaterLevelName"]) {
                if ([[self.dataValuesArr lastObject] isEqualToString:@"-1"]) {
                    self.waterLevelLab.text = @"当前水质类别:--";
                } else {
                    self.waterLevelLab.text = F(@"当前水质类别:%@", [self.dataValuesArr lastObject]);
                }
            } else {
                self.waterLevelLab.text = @"当前水质类别:--";
            }
            
            if ([self.dataValuesArr[0] isEqualToString:@"0"] || [self.dataValuesArr[0] isEqualToString:@"-1"]) {
                self.timeDataLabel.text = @"数据采集时间:--";
            } else {
                self.timeDataLabel.text = F(@"数据采集时间:%@", self.dataValuesArr[0]);
            }
            
        } else {
            self.timeDataLabel.text = @"数据采集时间:--";
            self.waterLevelLab.text = @"当前水质类别:--";
        }
    }
    
    
    //曲线
    if (self.dataTitleArr.count > 0) {
        [self sendChartRequest:self.dataTitleArr[1]];
    }
   
    
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //    //设置刷新控件的事件
//    [self headerRefresh];
    [self.view addSubview:_tableView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HT/2-20+_ht, WT, 30)];
    if (self.dataTitleArr.count > 0&&self.dataTitleChineseArr.count > 0) {
        _textLabel.text = F(@"%@ %@", self.dataTitleChineseArr[1],self.dataNnitArr[1]);
    }
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_textLabel];
}
- (void)sendOnlineMonitoringData {
    NSLog(@"====================%@+", dataManager.siteIDString );
    NSDictionary *param = @{
                            @"action":self.actionStr,
                            @"method":F(@"{siteTypeID:%@,siteID:%@}", dataManager.siteClassID,dataManager.siteIDString)
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlString isCacheorNot:NO targetViewController:self andUrlFunctionName:@"on-line" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Result"]) {
                if (dic[@"EName"]) {
                    [self.dataTitleArr addObject:dic[@"EName"]];
                }
                if (dic[@"Values"]) {
                    [self.dataValuesArr addObject:dic[@"Values"]];
                }
                if (dic[@"CName"]) {
                    [self.dataTitleChineseArr addObject:dic[@"CName"]];
                }
                if (dic[@"Unit"]) {
                    [self.dataNnitArr addObject:dic[@"Unit"]];
                }
            }
            
        }
        [self.tableView reloadData];
        
        [self setupTableView];
        
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
}
-(void)headerRefresh{
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)setUpScrollView {
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, HT/2+10+_ht, k_MainBoundsWidth*1, 300*HT/568.0-144)];
    //设置内容区域的大小  (水平滑动指示器)
    [_scrollView setContentSize:CGSizeMake(k_MainBoundsWidth*1, 300*HT/568.0-144)];
    //关闭垂直滑动指示器
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.scrollEnabled = YES;
    //在本类中代理scrollView的整体事件
    [_scrollView setDelegate:self];
    _scrollView.zoomScale = 1;
    //设置最大伸缩比例
    _scrollView.maximumZoomScale = 7.0;
    //设置最小伸缩比例
    _scrollView.minimumZoomScale = 1;
    [self.view addSubview:self.scrollView];
}
- (void)addChartView {
    [self.scrollView removeFromSuperview];
    [self setUpScrollView];
    
    if (self.DataTimesArr.count > 0 && self.VarValuesArr.count > 0) {
        DVLineChartView *ccc = [[DVLineChartView alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth*1, HT/2 - 5*HT/568.0-144)];
        [self.scrollView addSubview:ccc];
        
        ccc.yAxisViewWidth = 52;
        
        
        if (WT  > 320) {
            ccc.numberOfYAxisElements = 10;
        }else{
            ccc.numberOfYAxisElements = 5;
        }
        ccc.delegate = self;
        ccc.pointUserInteractionEnabled = YES;
        NSNumber *max = [self.VarValuesArr valueForKeyPath:@"@max.floatValue"];
        if ([max integerValue] > 500) {
            ccc.yAxisMaxValue = 1000;
        }else if ([max integerValue] > 100 && [max integerValue] < 500) {
            ccc.yAxisMaxValue = 500;
        }else if ([max integerValue] > 50 && [max integerValue] < 100){
            ccc.yAxisMaxValue = 100;
        } else if ([max integerValue] > 20 && [max integerValue] < 50) {
            ccc.yAxisMaxValue = 50;
        } else if ([max integerValue] > 10 && [max integerValue] < 20) {
            ccc.yAxisMaxValue = 20;
        }else {
            ccc.yAxisMaxValue = 10;
        }
        ccc.pointGap = 50;
        ccc.showSeparate = YES;
        ccc.separateColor = [UIColor colorWithHexString:@"67707c"];
        ccc.textColor = [UIColor colorWithHexString:@"9aafc1"];
        ccc.backColor = [UIColor whiteColor];
        ccc.axisColor = [UIColor colorWithHexString:@"67707c"];
        ccc.xAxisTitleArray = self.DataTimesArr;
        
        DVPlot *plot = [[DVPlot alloc] init];
        plot.pointArray = self.VarValuesArr;
        
        
        plot.lineColor = [UIColor colorWithHexString:@"81C2D6"];
        plot.pointColor = [UIColor colorWithHexString:@"14b9d6"];
        plot.chartViewFill = NO;
        plot.withPoint = YES;
        
        [ccc addPlot:plot];
        [ccc draw];
    } else {
        UILabel *tsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth*1, HT/2 - 5*HT/568.0-144)];
        tsLab.text = @"暂无数据";
        tsLab.textAlignment = NSTextAlignmentCenter;
        tsLab.textColor = [UIColor grayColor];
        [self.scrollView addSubview:tsLab];
    }
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataManager.tagString isEqualToString:@"4"]||[dataManager.tagString isEqualToString:@"50"]) {
        return self.dataTitleArr.count-1;
    } else if ([dataManager.tagString isEqualToString:@"10"]) {
        if ([[self.dataTitleArr lastObject] isEqualToString:@"WaterLevelName"]) {
            return self.dataTitleArr.count-1-1;
        } else {
            return self.dataTitleArr.count-1;
        }
    } else {
        return self.dataTitleArr.count-1-1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatisticalViewCell *cell = [StatisticalViewCell StatisticalViewCell:self.tableView];
    cell.oneLable.text = self.dataTitleChineseArr[indexPath.row+1];
    cell.twoLabel.text = self.dataValuesArr[indexPath.row +1];
    
    if ([self.dataNnitArr[indexPath.row+1] isEqualToString:@""]) {
        cell.threeLable.text = @"--";
    } else {
        cell.threeLable.text = self.dataNnitArr[indexPath.row+1];
    }
    
    cell.fourLable.text = @"--";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self sendChartRequest:self.dataTitleArr[indexPath.row+1]];
    if ([self.dataNnitArr[indexPath.row+1] isEqualToString:@""]) {
        _textLabel.text = F(@"%@", self.dataTitleChineseArr[indexPath.row+1]);
    } else {
        
        _textLabel.text = F(@"%@ %@", self.dataTitleChineseArr[indexPath.row+1],self.dataNnitArr[indexPath.row+1]);
    }
    
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WT, 30)];
    footerV.backgroundColor = UIColorFromRGB(0xF6F6F6);
    
    _declineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _declineBtn.backgroundColor = [UIColor clearColor];
    _declineBtn.frame = CGRectMake(0, 0, WT, 30);
    [_declineBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal] ;
    _declineBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _declineBtn.alpha = 0.5;
    [_declineBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_declineBtn addTarget:self action:@selector(SlideToTheBottomClick:) forControlEvents:UIControlEventTouchDown];
    [footerV addSubview:_declineBtn];
    
    
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    if ([dataManager.tagString isEqualToString:@"4"]||[dataManager.tagString isEqualToString:@"50"]) {
        if ((self.dataTitleChineseArr.count-1) > visiblePaths.count) {
            [_declineBtn setTitle:@" 滑动到底部" forState:UIControlStateNormal];
            [_declineBtn setImage:[UIImage imageNamed:@"Decline"] forState:UIControlStateNormal];
          
        } else {
            [_declineBtn setTitle:@" 已到底部" forState:UIControlStateNormal];
            [_declineBtn setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
        }
    } else {
        if ((self.dataTitleChineseArr.count-2) > visiblePaths.count) {
            [_declineBtn setTitle:@" 滑动到底部" forState:UIControlStateNormal];
            [_declineBtn setImage:[UIImage imageNamed:@"Decline"] forState:UIControlStateNormal];
        } else {
            [_declineBtn setTitle:@" 已到底部" forState:UIControlStateNormal];
            [_declineBtn setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
        }
    }
    
    
    return footerV;
}
#pragma mark - UIScrollViewDelegate
//scrollView只要滑动就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s %d",__FUNCTION__, __LINE__);
    CGPoint contentOffsetPoint = _tableView.contentOffset;
    CGRect frame = _tableView.frame;
    if (contentOffsetPoint.y == _tableView.contentSize.height - frame.size.height || _tableView.contentSize.height < frame.size.height) {
        NSLog(@"scroll to the end");
        [_declineBtn setTitle:@" 已到底部" forState:UIControlStateNormal];
        [_declineBtn setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    } else {
        NSLog(@"这不是底部");
        [_declineBtn setTitle:@" 滑动到底部" forState:UIControlStateNormal];
        [_declineBtn setImage:[UIImage imageNamed:@"Decline"] forState:UIControlStateNormal];
    }
}
#pragma mark -
- (void)SlideToTheBottomClick:(UIButton *)sender {
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height) animated:NO];
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
//曲线
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/WaterEnvironment?action=5&method={siteTypeID:2,siteID:13,var:COD}
- (void)sendChartRequest:(NSString *)var {
   
    NSLog(@"siteClassID====================%@+%@+%@", dataManager.siteIDString,var,dataManager.siteClassID);
    [self.DataTimesArr removeAllObjects];
    [self.VarValuesArr removeAllObjects];
    NSString *actionstr = F(@"%ld", [self.actionStr integerValue] + 1);
    NSDictionary *param = @{
                            @"action":actionstr,
                            @"method":F(@"{siteID:%@,siteTypeID:%@,var:%@}", dataManager.siteIDString, dataManager.siteClassID, var),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlString isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Char" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.DataTimesArr addObject:dic[@"TimeStamp"]];
                [self.VarValuesArr addObject:dic[@"VarValues"]];
            }
            
        }
        
        [self addChartView];
        NSLog(@"成功%@================%@", result, self.DataTimesArr);
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
}
@end
