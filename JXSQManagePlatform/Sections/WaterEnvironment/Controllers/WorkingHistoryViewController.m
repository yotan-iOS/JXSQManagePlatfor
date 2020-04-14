//
//  WorkingHistoryViewController.m
//  DVLineChart
//
//  Created by ghost on 2017/12/26.
//  Copyright © 2017年 Fire. All rights reserved.
//

#import "WorkingHistoryViewController.h"
#import "DVLineChartView.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
#import "HisDataWorkChartModel.h"
#import "WorkChartTableViewCell.h"

#import "AAChartKit.h"

#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define KBlueColor         ColorWithRGB(63, 153,231,1)

@interface WorkingHistoryViewController ()<UITableViewDelegate, UITableViewDataSource, DVLineChartViewDelegate>
@property (nonatomic, strong) HisDataWorkChartModel *wcModel;
@property (nonatomic, strong) UITableView *chartTableView;

@property (nonatomic, strong) AAChartModel *chartModel;
@property (nonatomic, strong) AAChartView  *chartView;
@end

@implementation WorkingHistoryViewController
- (HisDataWorkChartModel *)wcModel{
    if (!_wcModel) {
        self.wcModel = [[HisDataWorkChartModel alloc] init];
    }
    return _wcModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSendWorkingConditionHistory];
    [self setCreateTableView];
}
- (void)setSendWorkingConditionHistory {
    NSDictionary *param = @{
                            @"SiteID":self.SiteIDStr,
                            @"type":self.typeStr
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetHisDataWorkChart",RequestURL ) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"chart" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            NSDictionary *data = [[NSDictionary alloc] initWithDictionary:dicData[@"Data"]];
            self.wcModel.xAxisDataArr = data[@"xAxisData"];
            
            for (NSDictionary *dic in data[@"seriesData"]) {
                [self.wcModel.nameArr addObject:dic[@"name"]];
                [self.wcModel.dataArr addObject:dic[@"data"]];
            }
        }
        [self.chartTableView reloadData];
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
}
- (void)setCreateTableView {
    self.chartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WT, HT-110) style:UITableViewStylePlain];
    _chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chartTableView.delegate = self;
    _chartTableView.dataSource = self;
    self.chartTableView.estimatedRowHeight = 0;
    self.chartTableView.estimatedSectionHeaderHeight = 0;
    self.chartTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.chartTableView];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.wcModel.nameArr.count > 0) {
        return self.wcModel.nameArr.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (WT > 350) {
        return HT/2-100;
    } else {
        return HT/2-50;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkChartTableViewCell *cell = [WorkChartTableViewCell WorkChartTableViewCell:self.chartTableView];
    
    NSMutableArray *arrayAll = [[NSMutableArray alloc] init];
    arrayAll = self.wcModel.dataArr[indexPath.section];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayAll.count; i++) {
        [array addObject:[NSNumber numberWithInt:[self.wcModel.dataArr[indexPath.section][i] intValue]]];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AAChartType chartType = AAChartTypeArea;
    
    self.chartView = [[AAChartView alloc]initWithFrame:CGRectMake(0, 0, WT, HT/2-100)];
    self.chartView.scrollEnabled = NO;
    [cell addSubview:self.chartView];
    
    self.chartModel = AAObject(AAChartModel)
    .chartTypeSet(chartType)
    .animationDurationSet(@0)
    .legendEnabledSet(NO)
    .yAxisAllowDecimalsSet(NO)
//    .colorsThemeSet(@[@"#CF3030",@"#ef476f",@"#ffd066",@"#04d69f",@"#25547c"])
    .dataLabelEnabledSet(YES)
    .titleSet(@"")
    .subtitleSet(@"")
    .categoriesSet(self.wcModel.xAxisDataArr)
    .yAxisTitleSet(@"")
    ;
    
    self.chartModel
    .gradientColorEnabledSet(true)
    .markerRadiusSet(@0)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(self.wcModel.nameArr[indexPath.section])
                 .colorSet(@"#1e90ff")
                 .dataSet(array)//self.wcModel.dataArr[indexPath.section]
                 .stepSet((id)@(true))
                 ]
               );
    [self.chartView aa_drawChartWithChartModel:self.chartModel];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WT, 20)];
    headerTitle.backgroundColor = UIColorFromRGB(0xF9F9F9);
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = headerTitle.frame;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = self.wcModel.nameArr[section];
    [headerTitle addSubview:titleLab];
    
    return headerTitle;
}

@end
