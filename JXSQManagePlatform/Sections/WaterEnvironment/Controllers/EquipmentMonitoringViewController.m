//
//  EquipmentMonitoringViewController.m
//  JXSQManagePlatform
//
//  Created by TestGhost on 2018/7/10.
//  Copyright © 2018年 yotan. All rights reserved.
//

#import "EquipmentMonitoringViewController.h"
#import "DVLineChartView.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
#import "HisDataWorkChartModel.h"
#import "WorkChartTableViewCell.h"

#import "AAChartKit.h"
#import "EQCTableViewCell.h"
#import "SNTableViewCell.h"
#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define KBlueColor         ColorWithRGB(63, 153,231,1)
@interface EquipmentMonitoringViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger index;
}
@property (nonatomic, strong) HisDataWorkChartModel *wcModel;
@property (nonatomic, strong) UITableView *chartTableView;

@property (nonatomic, strong) AAChartModel *chartModel;
@property (nonatomic, strong) AAChartView  *chartView;

//@property(nonatomic,strong)NSArray *dataArr;
@property (nonatomic, strong)NSString * RemoteStatusValue;
@property (nonatomic, strong)NSString * snStatusValue;
@end

@implementation EquipmentMonitoringViewController
- (HisDataWorkChartModel *)wcModel{
    if (!_wcModel) {
        self.wcModel = [[HisDataWorkChartModel alloc] init];
    }
    return _wcModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexClick = 0;
    
    // Do any additional setup after loading the view from its nib.
    [self getDataForTable];
    [self setSendWorkingConditionHistory];
    [self setCreateTableView];
}
-(void)getDataForTable{
    [self.wcModel.nameArrTab removeAllObjects];
    [self.wcModel.dataArrTab removeAllObjects];
    NSDictionary *param = @{
                            @"SiteID":self.SiteIDStr,
                            @"SiteTypeID":self.typeStr
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/getSiteControlInfo", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"chart" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            self.RemoteStatusValue = [NSString stringWithFormat:@"%@",dicData[@"Data"][@"RemoteStatusValue"]];
            NSArray *arr = dicData[@"Data"][@"seriesData"];
            for (NSDictionary *dic in arr) {
                [self.wcModel.nameArrTab addObject:dic[@"name"]];
                NSArray *emptArr = dic[@"data"];
                [self.wcModel.dataArrTab addObject:emptArr.firstObject];
            }
        }
        self.snStatusValue = [self.RemoteStatusValue isEqualToString:@"1"]?@"1":@"0";
        [self.chartTableView reloadData];
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
    
}
- (void)setSendWorkingConditionHistory {
    NSDictionary *param = @{
                            @"SiteID":self.SiteIDStr,
                            @"type":self.typeStr
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetHisDataWorkChart", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"chart" success:^(id result) {
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
        NSLog(@"---------------%@=======%@", self.wcModel.nameArr,self.wcModel.dataArr);
        //        [self setCreateTableView];
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setCreateTableView {
    self.chartTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, WT-20, HT-110) style:UITableViewStylePlain];
    _chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chartTableView.delegate = self;
    _chartTableView.dataSource = self;
    self.chartTableView.estimatedRowHeight = 0;
    self.chartTableView.estimatedSectionHeaderHeight = 0;
    self.chartTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.chartTableView];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",self.chartTableView.contentOffset.y);
    if (self.chartTableView.contentOffset.y <= 0) {
        self.chartTableView.bounces = NO;
    } else {
        if (self.chartTableView.contentOffset.y >= 0){
            self.chartTableView.bounces = YES;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.wcModel.nameArrTab.count+1;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return 48;
        }else{
            return 86;
        }
    } else {
        if (WT > 500) {
            self.cellHeight = HT/2-100;
            return self.cellHeight;
        } else {
            self.cellHeight = 300*HT/568.0;
            return self.cellHeight;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            static NSString *ID1 = @"SNTableViewCell";
            SNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SNTableViewCell" owner:nil options:nil]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.snSwich addTarget:self action:@selector(valuwfristChanegeAction:) forControlEvents:UIControlEventValueChanged];
            
            if ([self.snStatusValue isEqualToString:@"1"]) {
                cell.snSwich.on = YES;
            } else{
                cell.snSwich.on = NO;
            }
            return cell;
        }else{
            static NSString *ID = @"EQCTableViewCell";
            EQCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"EQCTableViewCell" owner:nil options:nil]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.eqControlSwich.tag = indexPath.row+1000;
            cell.eqNameLab.text = self.wcModel.nameArrTab[indexPath.row-1];
            [cell.eqControlSwich addTarget:self action:@selector(valuwChanegeAction:) forControlEvents:UIControlEventValueChanged];
            if ([self.snStatusValue isEqualToString:@"1"]) {
                cell.eqControlSwich.userInteractionEnabled = YES;
                
                if ([self.wcModel.dataArrTab[indexPath.row-1] isEqualToString:@"1"]) {
                    cell.eqControlSwich.on = YES;
                }else{
                    cell.eqControlSwich.on = NO;
                }
                
            }else{
                
                cell.eqControlSwich.userInteractionEnabled = NO;
                if ([self.wcModel.dataArrTab[indexPath.row-1] isEqualToString:@"1"]) {
                    
                    cell.eqControlSwich.on = YES;
                    
                }else{
                    cell.eqControlSwich.on = NO;
                }
            }
            return cell;
        }
    } else {
        WorkChartTableViewCell *cell = [WorkChartTableViewCell WorkChartTableViewCell:self.chartTableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int fontNum;
        if(WT < 350) {
            fontNum = 8;
        } else if (WT > 350 && WT < 500) {
            fontNum = 9;
        } else {
            fontNum = 10;
        }
        
        
        if (self.wcModel.dataArr.count > 0) {
            NSMutableArray *arrayAll = [[NSMutableArray alloc] init];
            arrayAll = self.wcModel.dataArr[self.indexClick];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 0; i < arrayAll.count; i++) {
                [array addObject:[NSNumber numberWithInt:[arrayAll[i] intValue]]];
            }
            
            AAChartType chartType = AAChartTypeArea;
            
            self.chartView = [[AAChartView alloc]initWithFrame:CGRectMake(0, 0, WT, self.cellHeight-80)];
            self.chartView.scrollEnabled = NO;
            [cell addSubview:self.chartView];
            
            self.chartModel = AAObject(AAChartModel)
            .chartTypeSet(chartType)
            //        .animationDurationSet(@0)
            .legendEnabledSet(NO)
            .yAxisAllowDecimalsSet(NO)
            //    .colorsThemeSet(@[@"#CF3030",@"#ef476f",@"#ffd066",@"#04d69f",@"#25547c"])
            .dataLabelEnabledSet(YES)
            .titleSet(@"")
            .subtitleSet(@"")
            .categoriesSet(self.wcModel.xAxisDataArr)
            .yAxisTitleSet(@"")
            .xAxisLabelsFontSizeSet([NSNumber numberWithInt:fontNum])
            ;
            
            self.chartModel
            .gradientColorEnabledSet(true)
            .markerRadiusSet(@0)
            .seriesSet(@[
                         AAObject(AASeriesElement)
                         .nameSet(self.wcModel.nameArr[self.indexClick])
                         .colorSet(@"#1e90ff")
                         .dataSet(array)//self.wcModel.dataArr[indexPath.section]
                         .stepSet((id)@(true))
                         ]
                       );
            [self.chartView aa_drawChartWithChartModel:self.chartModel];
            
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:self.wcModel.nameArr];
            segment.selectedSegmentIndex = self.indexClick;
            if (WT > 500) {
                segment.frame = CGRectMake(WT/4, CGRectGetMaxY(self.chartView.frame)+10, WT/2, 36);
            } else {
                segment.frame = CGRectMake(10, CGRectGetMaxY(self.chartView.frame)+10, WT-20, 30);
            }
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont boldSystemFontOfSize:15],
                                 NSFontAttributeName,nil];
            
            [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
            segment.backgroundColor = [UIColor whiteColor];
            [segment addTarget:self action:@selector(HandleChanges:) forControlEvents:UIControlEventValueChanged];
            segment.tintColor = UIColorFromRGB(0x2ab1e7);
            [cell addSubview:segment];
        }
        
        return cell;
    }
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WT, 40)];
    headerTitle.backgroundColor = UIColorFromRGB(0xF9F9F9);
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = headerTitle.frame;
    titleLab.textAlignment = NSTextAlignmentCenter;
    //    titleLab.text = self.wcModel.nameArr[section];
    if (section == 0) {
        titleLab.text = @"设备控制";
    } else {
        titleLab.text = @"曲线统计图";
    }
    
    [headerTitle addSubview:titleLab];
    
    return headerTitle;
}

- (void)HandleChanges:(UISegmentedControl *)segemet {
    self.indexClick = segemet.selectedSegmentIndex;
    [self.chartTableView reloadData];
}

- (void)valuwfristChanegeAction:(UISwitch *)sender{
    //点击确认后需要做的事 胡其生胡云华
    if ([[DataSource sharedDataSource].realNameStr isEqualToString:@"胡其生"]||[[DataSource sharedDataSource].realNameStr isEqualToString:@"胡云华"]) {
      
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否改变远程控制使能的状态?" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.chartTableView reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (sender.on) {
                self.snStatusValue = @"1";
                [self sendRequestForsnData:@"1" filename:@"webrun"];
            } else {
                self.snStatusValue = @"0";
                [self sendRequestForsnData:@"0" filename:@"webstop"];
            }
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
   
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有设备控制权限,无法操作设备" preferredStyle: UIAlertControllerStyleAlert];
        [alert1 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          
            [self.chartTableView reloadData];
        }]];
        [self presentViewController:alert1 animated:YES completion:nil];
        
        
    }
    
    
}

-(void)valuwChanegeAction:(UISwitch*)sender{
    index = sender.tag-1001;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:F(@"是否改变%@的状态?", self.wcModel.nameArrTab[index]) preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.chartTableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (sender.on) {
            self.snStatusValue = @"1";
            [self.wcModel.dataArrTab replaceObjectAtIndex:index withObject:@"1"];
        } else {
            self.snStatusValue = @"0";
            [self.wcModel.dataArrTab replaceObjectAtIndex:index withObject:@"0"];
        }
        [self sendRequestForData:index];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)sendRequestForData:(NSInteger )index{
    [CustomHUD showIndicatorWithStatus:@"努力发送指令..."];
    NSString*filename =  F(@"P%ldControl",index+1);
    NSDictionary *param = @{
                            @"SiteID":self.SiteIDStr,
                            @"FieldName":filename,
                            @"Value":self.wcModel.dataArrTab[index],
                            @"SiteTypeID":self.typeStr
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/setSiteControlInfo", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"chart" success:^(id result) {
        NSDictionary *dicData = result;
        [self getDataForTable];
        
        //        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
        //            [self.wcModel.nameArrTab removeAllObjects];
        //            [self.wcModel.dataArrTab removeAllObjects];
        //
        //            self.RemoteStatusValue = [NSString stringWithFormat:@"%@",dicData[@"Data"][@"RemoteStatusValue"]];
        //            NSArray *arr = dicData[@"Data"][@"seriesData"];
        //            for (NSDictionary *dic in arr) {
        //                [self.wcModel.nameArrTab addObject:dic[@"name"]];
        //                NSArray *emptArr = dic[@"data"];
        //                [self.wcModel.dataArrTab addObject:emptArr.firstObject];
        //            }
        [CustomHUD dismiss];
        //
        //            if ([self.wcModel.dataArrTab[index] integerValue] == 0 && [self.snStatusValue integerValue] == 0) {
        //                [YJProgressHUD showSuccess:F(@"%@关闭成功!", self.wcModel.nameArrTab[index])];
        //            } else if ([self.wcModel.dataArrTab[index] integerValue] == 1 && [self.snStatusValue integerValue] == 1) {
        //                [YJProgressHUD showSuccess:F(@"%@开启成功!", self.wcModel.nameArrTab[index])];
        //            } else if ([self.wcModel.dataArrTab[index] integerValue] == 0 && [self.snStatusValue integerValue] == 1) {
        //                [YJProgressHUD showSuccess:F(@"%@开启失败!", self.wcModel.nameArrTab[index])];
        //            } else if ([self.wcModel.dataArrTab[index] integerValue] == 1 && [self.snStatusValue integerValue] == 0) {
        //                [YJProgressHUD showSuccess:F(@"%@关闭失败!", self.wcModel.nameArrTab[index])];
        //            }
        //        }
        //        self.snStatusValue = [self.RemoteStatusValue isEqualToString:@"1"]?@"1":@"0";
        //        [self.chartTableView reloadData];
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
        [CustomHUD dismiss];
    }];
}

-(void)sendRequestForsnData:(NSString * )indexstr filename:(NSString *)filename{
    [CustomHUD showIndicatorWithStatus:@"努力发送指令..."];
    NSDictionary *param = @{
                            @"SiteID":self.SiteIDStr,
                            @"SiteTypeID":self.typeStr,
                            @"FieldName":filename,
                            @"Value":indexstr
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/setSiteControlInfo", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"chart" success:^(id result) {
        NSDictionary *dicData = result;
        [self getDataForTable];
        
        //        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
        //            [self.wcModel.nameArrTab removeAllObjects];
        //            [self.wcModel.dataArrTab removeAllObjects];
        //
        //            self.RemoteStatusValue = [NSString stringWithFormat:@"%@",dicData[@"Data"][@"RemoteStatusValue"]];
        //            NSArray *arr = dicData[@"Data"][@"seriesData"];
        //            for (NSDictionary *dic in arr) {
        //                [self.wcModel.nameArrTab addObject:dic[@"name"]];
        //                NSArray *emptArr = dic[@"data"];
        //                [self.wcModel.dataArrTab addObject:emptArr.firstObject];
        //            }
        [CustomHUD dismiss];
        //
        //            if ([self.RemoteStatusValue integerValue] == 0 && [self.snStatusValue integerValue] == 0) {
        //                [YJProgressHUD showSuccess:@"关闭成功!"];
        //            } else if ([self.RemoteStatusValue integerValue] == 1 && [self.snStatusValue integerValue] == 1) {
        //                [YJProgressHUD showSuccess:@"开启成功!"];
        //            } else if ([self.RemoteStatusValue integerValue] == 0 && [self.snStatusValue integerValue] == 1) {
        //                [YJProgressHUD showSuccess:@"开启失败!"];
        //            } else if ([self.RemoteStatusValue integerValue] == 1 && [self.snStatusValue integerValue] == 0) {
        //                [YJProgressHUD showSuccess:@"关闭失败!"];
        //            }
        //        }
        //        self.snStatusValue = [self.RemoteStatusValue isEqualToString:@"1"]?@"1":@"0";
        //        [self.chartTableView reloadData];
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
        [CustomHUD dismiss];
    }];
    
}
@end
