//
//  RiverJBStatisticsViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverJBStatisticsViewController.h"
#import "CountModel.h"
#import "JHChartHeader.h"
@interface RiverJBStatisticsViewController (){
    DataSource *datamanager;
}
@property (strong, nonatomic) IBOutlet UIView *jbView;
@property(nonatomic,strong)JHColumnChart *ytcolumn;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,strong)NSMutableArray *ytArray;
@end

@implementation RiverJBStatisticsViewController
-(NSMutableArray *)ytArray{
    if (!_ytArray) {
        
        self.ytArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _ytArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"交办统计";
    [self configerjbView];
    datamanager = [DataSource sharedDataSource];
    [self firstGetChartDate];
    [self configerBtn];
}
-(void)configerjbView{
    self.jbView.frame = CGRectMake(0, NAVIHEIGHT+10, self.view.frame.size.width, SCREEN_HEIGHT - NAVIHEIGHT-10);
    [self.view addSubview:self.jbView];
    
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
    [self getDataForChart];
}
-(void)configerBtn{
    for (int i = 0 ; i < 4; i++) {
        UIButton *btn = [self.view viewWithTag:110+i];
        [btn addTarget:self action:@selector(selectedTimes:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
    }
    
    self.startTimeBtn.layer.cornerRadius = 5;
    self.startTimeBtn.layer.masksToBounds = YES;
    self.endTimeBtn.layer.cornerRadius = 5;
    self.endTimeBtn.layer.masksToBounds = YES;
    self.searchBtn.layer.cornerRadius = 5;
    self.searchBtn.layer.masksToBounds = YES;  
}

-(void)selectedTimes:(UIButton *)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    self.endtime = [formatter stringFromDate:[NSDate date]];
    NSInteger index = sender.tag - 110;
    switch (index) {
        case 0:
        {
            if (month-1<=0) {
                month = 12-month;
                year = year - 1;
            }
           
            self.starttime = F(@"%ld-%ld-%ld",year,month-1,day);
            [_startTimeBtn setTitle:self.starttime forState:UIControlStateNormal];
            [self getDataForChart];
        }
            break;
        case 1:
        {
            if (month-3<=0) {
                month = 12-month;
                year = year - 1;
            }
            self.starttime = F(@"%ld-%ld-%ld",year,month-3,day);
            [_startTimeBtn setTitle:self.starttime forState:UIControlStateNormal];
            [self getDataForChart];
        }
            break;
        case 2:
        {
            if (month-6<=0) {
                month = 12-month;
                year = year - 1;
            }
            self.starttime = F(@"%ld-%ld-%ld",year,month-6,day);
            [_startTimeBtn setTitle:self.starttime forState:UIControlStateNormal];
            [self getDataForChart];
        }
            break;
        default:
        {
               [self firstGetChartDate];
        }
            break;
    }
    NSLog(@"starttime:%@----endtime%@",self.starttime,self.endtime);
    
}
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/RiverManagement?action=12&method={startTime:2017-01-04,endTime:2017-06-25,riverID:1}
-(void)getDataForChart{
    self.ytArray = nil;
    NSDictionary *param = @{
                            @"action":@"12",
                            @"method":F(@"{startTime:%@,endTime:%@,userID:%@}",self.starttime,self.endtime,datamanager.UserID)
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/RiverManagement",RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"qx-line" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
           CountModel *model = [[CountModel alloc]init];
            [model setValuesForKeysWithDictionary:dicData[@"Result"]];
            [self.ytArray addObject:model.ALLCount];
            [self.ytArray addObject:model.DealCount];
            [self.ytArray addObject:model.UntreatedCount];
            [self showytColumnView];
        }else{
            [CustomHUD showErrorWithStatus:@"暂无数据"];
        }
     
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
    

    
    
}

- (IBAction)startTimeAction:(id)sender {
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
            [_startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
            self.starttime = dateStr;
        }else if (([arr[0] integerValue] >[currentDateArr[0] integerValue])) {
            [_startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
            self.starttime = dateStr;
        }else if(([arr[0] integerValue] == [currentDateArr[0] integerValue])&&([arr[1] integerValue] == [currentDateArr[1] integerValue])&&([arr[2] integerValue]>[currentDateArr[2] integerValue])){
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
- (IBAction)endTimeAction:(UIButton *)sender {
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
- (IBAction)searchAction:(UIButton *)sender {
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
//    }else{
        [self getDataForChart];
//    }
    

}

//柱状图
- (void)showytColumnView{
    
    NSLog(@"_ytArray----%@",_ytArray);
    if (_ytcolumn) {
        [_ytcolumn removeFromSuperview];
    }
    NSArray *myArray = [_ytArray copy];
    int sum = [[myArray valueForKeyPath:@"@sum.intValue"] intValue];
    if (sum > 0) {
        
        /*        创建对象         */
        _ytcolumn = [[JHColumnChart alloc] initWithFrame:CGRectMake(0,10, WT, HT-200)];
        
        /*        创建数据源数组 每个数组即为一个模块数据 例如第一个数组可以表示某个班级的不同科目的平均成绩 下一个数组表示另外一个班级的不同科目的平均成绩         */
        _ytcolumn.backgroundColor = [UIColor colorWithRed:0.866 green:0.866 blue:0.866 alpha:1.0];
        
        _ytcolumn.valueArr = _ytArray;
        /*       该点 表示原点距左下角的距离         */
        _ytcolumn.originSize = CGPointMake(30, 30);
        
        /*        第一个柱状图距原点的距离         */
        _ytcolumn.drawFromOriginX = 10;
        /*        柱状图的宽度         */
        _ytcolumn.columnWidth = 70;
        /*        X、Y轴字体颜色         */
        _ytcolumn.drawTextColorForX_Y = [UIColor blackColor];
        /*        X、Y轴线条颜色         */
        _ytcolumn.colorForXYLine = [UIColor blackColor];
        /*        每个模块的颜色数组 例如A班级的语文成绩颜色为红色 数学成绩颜色为绿色         */
        _ytcolumn.columnBGcolorsArr = @[[UIColor colorWithRed:0.173 green:1 blue:0.552 alpha:1.0],[UIColor colorWithRed:0.988 green:0.9 blue:0.176 alpha:0.8],[UIColor colorWithRed:0.992 green:0.176 blue:0.173 alpha:1.0]];;
        /*        模块的提示语         */
        _ytcolumn.xShowInfoText = @[@"总量",@"已处理",@"未处理"];
        /*        开始动画         */
        [_ytcolumn showAnimation];
        [self.chartBgView addSubview:_ytcolumn];
    } else {
        [YJProgressHUD showError:@"暂无数值"];
        UILabel *tsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10, WT, HT-200)];
        tsLabel.textColor = [UIColor grayColor];
        tsLabel.text = @"当前时间段暂无数值";
        tsLabel.textAlignment = NSTextAlignmentCenter;
        [self.chartBgView addSubview:tsLabel];
    }
    
    
   
   
    
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

@end
