//
//  PatrolRiverRecordViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/11/9.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "PatrolRiverRecordViewController.h"
#import "PatrolRecordModel.h"
#import "PatrolRiverTableViewCell.h"
#import "MapRouteViewController.h"
@interface PatrolRiverRecordViewController ()<UITableViewDataSource,UITableViewDelegate>{
    DataSource *dataManager;
}
@property (strong, nonatomic) IBOutlet UIView *patrolRiveView;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,assign)NSInteger pageIdex;
@end

@implementation PatrolRiverRecordViewController
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configerriverView];
    dataManager = [DataSource sharedDataSource];
    self.view.backgroundColor =  UIColorFromRGB(0xF0F0F0); 
    [self configerBtn];
    [self createTableview];
    self.pageIdex = 0;
    [self firstGetChartDate];
}

-(void)configerriverView{
    self.patrolRiveView.frame = CGRectMake(0, NAVIHEIGHT, self.view.frame.size.width,66);
    [self.view addSubview:self.patrolRiveView];
}
- (void)refleshData{
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置上拉加载更多
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        
        [weakSelf getDataForChart];
        self.pageIdex++;
    }];
    NSLog(@"pageIdex---%ld",self.pageIdex);
    [self.listTableView.mj_footer beginRefreshing];
}
-(void)createTableview{
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.patrolRiveView.frame), WT, HT - 66-NAVIHEIGHT) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
//    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTableView];
    self.listTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.listTableView registerNib:[UINib nibWithNibName:@"PatrolRiverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
}
-(void)configerBtn{
    for (int i= 0; i < 3; i++) {
        UIButton *but = [self.view viewWithTag:220+i];
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 5;
    }
}
-(void)firstGetChartDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *changDate = [dateStr stringByReplacingCharactersInRange:NSMakeRange(8, 2) withString:@"01"];
    self.starttime = changDate;
    self.endtime = dateStr;
    [self.startTimeBtn setTitle:changDate forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:dateStr forState:UIControlStateNormal];
    [self refleshData];
}
-(void)getDataForChart{
    NSDictionary *param = @{
                            @"PageSize":@"10",
                            @"PageIndex":F(@"%ld", self.pageIdex),
                            @"PatrolID":dataManager.UserID,
                            @"StartTime":self.starttime,
                            @"EndTime":self.endtime
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetPatrolCheckInfoByPage",RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"qx-line" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                PatrolRecordModel *model = [[PatrolRecordModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
        }
        [self.listTableView reloadData];
        [self.listTableView.mj_footer endRefreshing];
        NSLog(@"列表---%@--%@",result,self.dataArr);
    } orFail:^(NSError *error) {
        NSLog(@"列表%@", error);
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView.frame = CGRectMake(0, 0, self.listTableView.frame.size.width, 40);
    return _headerView;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatrolRiverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.dataArr.count  > 0) {
        PatrolRecordModel *model = self.dataArr[indexPath.row];
        cell.riverNameLab.text = F(@"%@", model.RiverName);
        cell.startTimeLab.text = [F(@"%@",model.StartTime) stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        cell.endTimeLab.text = [F(@"%@",model.EndTime) stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MapRouteViewController *mapRout = [[MapRouteViewController alloc]init];
    if (self.dataArr.count > 0) {
        PatrolRecordModel *model = self.dataArr[indexPath.row];
        mapRout.pathStr = F(@"%@", model.PatorlPath);
        mapRout.timeLenStr = F(@"%@", model.LengthOfTime);
        mapRout.distanceStr = F(@"%@", model.PatrolRiverDistance);
    }
   
    [self.navigationController pushViewController:mapRout animated:NO];
    
}
- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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

- (IBAction)startAction:(id)sender {
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"时间： %@",date);
        
        
        NSDate *ssdate = [NSDate date];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSString *dateStr = [formatter stringFromDate:ssdate];
        NSArray *currentDateArr = [dateStr componentsSeparatedByString:@"-"];
        NSArray *arr = [date componentsSeparatedByString:@"-"];
        if (([arr[0] integerValue] == [currentDateArr[0] integerValue])&&([arr[1] integerValue] >[currentDateArr[1] integerValue])) {
            //            [self alert:@"提示" message:@"无法获取数据，11请检查起始时间"];
            [_startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
            self.starttime = dateStr;
        }else if (([arr[0] integerValue] >[currentDateArr[0] integerValue])) {
            //            [self alert:@"提示" message:@"无法获取数据，22请检查起始时间"];
            [_startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
            self.starttime = dateStr;
        }else if(([arr[0] integerValue] == [currentDateArr[0] integerValue])&&([arr[1] integerValue] == [currentDateArr[1] integerValue])&&([arr[2] integerValue]>[currentDateArr[2] integerValue])){
            //            [self alert:@"提示" message:@"无法获取数据，33请检查起始时间"];
            [_startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
            self.starttime = dateStr;
        } else {
            [_startTimeBtn setTitle:date forState:UIControlStateNormal];
            self.starttime = date;
        }
        
        
    }];
    datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
    [datepicker show];
}

- (IBAction)endAction:(id)sender {
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"时间： %@",date);
        
        NSDate *aadate = [NSDate date];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSString *dateStr = [formatter stringFromDate:aadate];
        NSArray *arr = [self.starttime componentsSeparatedByString:@"-"];
        NSArray *arr0 = [date componentsSeparatedByString:@"-"];
        if (([arr[0] integerValue] == [arr0[0] integerValue])&&([arr[1] integerValue] >[arr0[1] integerValue])) {
            self.endtime = dateStr;
            [_endTimeBtn setTitle:dateStr forState:UIControlStateNormal];
        }else if (([arr[0] integerValue] >[arr0[0] integerValue])) {
            self.endtime = dateStr;
            [_endTimeBtn setTitle:dateStr forState:UIControlStateNormal];
        }else if(([arr[0] integerValue] == [arr0[0] integerValue])&&([arr[1] integerValue] == [arr0[1] integerValue])&&([arr[2] integerValue]>[arr0[2] integerValue])){
            self.endtime = dateStr;
            [_endTimeBtn setTitle:dateStr forState:UIControlStateNormal];
        } else {
            self.endtime = date;
            [_endTimeBtn setTitle:date forState:UIControlStateNormal];
        }
        
    }];
    datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
    [datepicker show];
}

- (IBAction)searchAction:(id)sender {
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"YYYY-MM-dd";
//    NSString *dateStr = [formatter stringFromDate:date];
//    NSArray *currentDateArr = [dateStr componentsSeparatedByString:@"-"];
//    NSArray *arr = [self.starttime componentsSeparatedByString:@"-"];
//    NSArray *arr0 = [self.endtime componentsSeparatedByString:@"-"];
//    if (([arr[0] integerValue] == [arr0[0] integerValue])&&([arr[1] integerValue] >[arr0[1] integerValue])) {
//        [self alert:@"提示" message:@"无法获取数据，请检查起始时间"];
//    }else if (([arr[0] integerValue] >[arr0[0] integerValue])) {
//        [self alert:@"提示" message:@"无法获取数据，请检查起始时间"];
//    }else if(([arr[0] integerValue] == [arr0[0] integerValue])&&([arr[1] integerValue] == [arr0[1] integerValue])&&([arr[2] integerValue]>[arr0[2] integerValue])){
//        [self alert:@"提示" message:@"无法获取数据，请检查起始时间"];
//    }else if([self.starttime isEqualToString:self.endtime]){
//        [self alert:@"提示" message:@"无法获取数据，请检查起始时间"];
//    }else if(([arr0[0] integerValue] == [currentDateArr[0] integerValue])&&(([arr0[1] integerValue] == [currentDateArr[1] integerValue])&&([arr0[2] integerValue]>[currentDateArr[2] integerValue]+10))){
//        [self alert:@"提示" message:@"请检查起始时间"];
//
//    }else if(([arr0[0] integerValue] == [currentDateArr[0] integerValue])&&(([arr0[1] integerValue] > [currentDateArr[1] integerValue]+5))){
//        [self alert:@"提示" message:@"请检查起始时间"];
//
//    }else if(([arr0[0] integerValue] > [currentDateArr[0] integerValue])){
//        [self alert:@"提示" message:@"请检查起始时间"];
//
//    }else{
        self.pageIdex = 0;
        self.dataArr = nil;
        
        [self refleshData];
//    }
}

@end
