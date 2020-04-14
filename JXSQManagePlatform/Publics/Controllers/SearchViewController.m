//
//  RecordDetailViewController.m
//  LWIntelligenceOperations
//
//  Created by ghost on 2017/6/12.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "StationModel.h"


#define KW [UIScreen mainScreen].bounds.size.width
#define KH [UIScreen mainScreen].bounds.size.height
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy) NSString *mdata;
@property(nonatomic,strong)StationModel *smodel;
@property (nonatomic,copy) NSString *searchTF;
@property(nonatomic,copy) NSString *siteTypeStr;
@property(nonatomic,copy) NSString *urlStr;
@property(nonatomic,strong)NSMutableArray *siteClassIDArr;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong)UILabel *line0;
@end

@implementation SearchViewController
- (StationModel *)smodel{
    if (!_smodel) {
        self.smodel = [[StationModel alloc] init];
    }
    return _smodel;
}
-(NSMutableArray *)siteClassIDArr{
    if (!_siteClassIDArr) {
        self.siteClassIDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _siteClassIDArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _smodel = [[StationModel alloc] init];
    self.title = @"站点搜索";
    [self createSearhBut];
//    if (@available(iOS 11.0, *)) {
//        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
}
-(void)createSearhBut{
    int h = NAVIHEIGHT+20;
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(20, h, WT-90, 30 + 20)];
    _tf.layer.borderColor = UIColorFromRGB(0x3FB3E6).CGColor;
    _tf.layer.borderWidth = 2;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.placeholder = @" 请输入你想要搜索的站点名";
   [_tf setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
//    _tf.textAlignment = NSTextAlignmentCenter;
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_tf addTarget:self action:@selector(textFieldChangedSearchs:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_tf];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -70, h, 50 + 10, 30 + 20)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    
    but.backgroundColor = UIColorFromRGB(0x3FB3E6);
    [but addTarget:self action:@selector(searchActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    _line0 = [[UILabel alloc]initWithFrame:CGRectMake(0,h+50 + 20-1 ,WT, 1)];
    _line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_line0];
    [self.view addSubview:self.myTableView];
}

//列表的搜索
- (void)sendTownThreeListStation:(NSString *)keyboardStr {
    [self.smodel.SiteIDArr removeAllObjects];
    [self.smodel.SiteNameArr removeAllObjects];
    [self.smodel.SiteClassIDArr removeAllObjects];
    [self.smodel.SiteTypeIDArr removeAllObjects];
    [self.smodel.StatusArr removeAllObjects];
    DataSource *datasource = [DataSource sharedDataSource];
     [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    NSDictionary *param;
    if ([datasource.tagString isEqualToString:@"1"]) {//地表水
        self.siteTypeStr = @"1";
        self.urlStr = BaseWaterEnURLStr;
        param = @{
                  @"action":@"7",
                  @"method":F(@"{searchName:%@,siteTypeID:%@}",keyboardStr, self.siteTypeStr),
                  };
        
    } else if ([datasource.tagString isEqualToString:@"2"]) {//河道水质
        self.siteTypeStr = @"2";
        self.urlStr = F(@"%@/WaterEnvironment", RequestURL);
        param = @{
                  @"action":@"7",
                  @"method":F(@"{searchName:%@,siteTypeID:%@}",keyboardStr, self.siteTypeStr),
                  };
        
    } else if ([datasource.tagString isEqualToString:@"3"]){//河道工程
        self.siteTypeStr = @"3;4";
        self.urlStr = BaseWaterEnURLStr;
        param = @{
                  @"action":@"7",
                  @"method":F(@"{searchName:%@,siteTypeID:%@}",keyboardStr, self.siteTypeStr),
                  };
        
    } else if ([datasource.tagString isEqualToString:@"4"]||[datasource.tagString isEqualToString:@"50"]||[datasource.tagString isEqualToString:@"51"]||[datasource.tagString isEqualToString:@"52"]){//农村生活污水
        self.siteTypeStr = @"6";
        self.urlStr = BaseWaterEnURLStr;
        param = @{
                  @"action":@"7",
                  @"method":F(@"{searchName:%@,siteTypeID:%@}",keyboardStr, self.siteTypeStr),
                  };
        
    } else if ([datasource.tagString isEqualToString:@"9"]) {
        self.urlStr = BaseRiverMURLStr;
        param = @{
                  @"action":@"24",
                  @"method":F(@"{searchName:%@}",keyboardStr),
                  };
    } else if ([datasource.tagString isEqualToString:@"10"] || [datasource.tagString isEqualToString:@"11"]) {//在线水质
        self.siteTypeStr = @"2";
        self.urlStr = BaseRiverMURLStr;
        param = @{
                  @"action":@"23",
                  @"method":F(@"{searchName:%@,siteTypeID:%@}",keyboardStr, self.siteTypeStr),
                  };
    }else if ([datasource.tagString isEqualToString:@"30"]) {
        //工程
        self.siteTypeStr = @"19";
       self.urlStr = BaseWaterEnURLStr;
        param = @{
                  @"action":@"7",
                  @"method":F(@"{searchName:%@,siteTypeID:%@}",keyboardStr, self.siteTypeStr)
                  };
    }else if ([datasource.tagString isEqualToString:@"40"]) {
        //曝气工程
        self.siteTypeStr = @"20";
        self.urlStr = BaseWaterEnURLStr;
        param = @{
                  @"action":@"7",
                  @"method":F(@"{searchName:%@,siteTypeID:%@}",keyboardStr, self.siteTypeStr)
                  };
    }
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Search" success:^(id result) {
        NSDictionary *dicData = result;
       
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            //
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.smodel.SiteIDArr addObject:dic[@"SiteID"]];
                [self.smodel.SiteNameArr addObject:dic[@"SiteName"]];
                [self.siteClassIDArr addObject:F(@"%@",dic[@"SiteTypeID"])];
                if ([datasource.tagString isEqualToString:@"2"]||[datasource.tagString isEqualToString:@"4"]|| [datasource.tagString isEqualToString:@"50"]) {
                    [self.smodel.HasDataFlgArr addObject:F(@"%@",dic[@"HasDataFlg"])];
                    [self.smodel.HasVideoFlagArr addObject:F(@"%@",dic[@"HasVideoFlg"])];
                }
                
                if ([datasource.tagString isEqualToString:@"9"]) {
                    [self.smodel.StatusArr addObject:dic[@"Status"]];
                }
                
            }
            
        }else{
            [YJProgressHUD showError:@"无匹配内容"];
        }
        [CustomHUD dismiss];
        [self.myTableView reloadData];
        
        [self.myTableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        NSLog(@"列表的搜索 === %@", result);
    } orFail:^(NSError *error) {
        NSLog(@"列表的搜索 %@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.smodel.SiteNameArr.count; 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.stationLable.text = self.smodel.SiteNameArr[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DataSource *datamnager = [DataSource sharedDataSource];
    //河道水质/农村生活污水
    if ([datamnager.tagString isEqualToString:@"2"] || [datamnager.tagString isEqualToString:@"4"] || [datamnager.tagString isEqualToString:@"1"]||[datamnager.tagString isEqualToString:@"50"]) {
        WaterENViewController *waterVC = [[WaterENViewController alloc]init];
        waterVC.title = self.smodel.SiteNameArr[indexPath.row];
        waterVC.siteID = self.smodel.SiteIDArr[indexPath.row];
        datamnager.siteIDString = self.smodel.SiteIDArr[indexPath.row];
        if ([datamnager.tagString isEqualToString:@"2"]||[datamnager.tagString isEqualToString:@"4"]||[datamnager.tagString isEqualToString:@"50"]) {
        waterVC.dataFlags =  F(@"%@",self.smodel.HasDataFlgArr[indexPath.row]);
        waterVC.videoFlags =  F(@"%@",self.smodel.HasVideoFlagArr[indexPath.row]);
        }
        [self.navigationController pushViewController:waterVC animated:YES];
    }else if ([datamnager.tagString isEqualToString:@"3"]||[datamnager.tagString isEqualToString:@"30"]||[datamnager.tagString isEqualToString:@"40"]){
        RiverProgramViewController *riverProVC = [[RiverProgramViewController alloc]init];
        riverProVC.title = self.smodel.SiteNameArr[indexPath.row];
        datamnager.siteIDString = self.smodel.SiteIDArr[indexPath.row];
        datamnager.siteClassID = self.siteClassIDArr[indexPath.row];
        //            riverProVC.JWStr = self.JWArray[indexPath.row];
        [self.navigationController pushViewController:riverProVC animated:YES];
        
    }  else if ([datamnager.tagString isEqualToString:@"9"]) {
        //河长任务
        RiverTaskDetailViewController *taskVC = [[RiverTaskDetailViewController alloc]init];
        taskVC.status = self.smodel.StatusArr[indexPath.row];
        if (self.smodel.SiteNameArr.count > 0) {
            taskVC.siteIDstr = self.smodel.SiteIDArr[indexPath.row];
            taskVC.title = self.smodel.SiteNameArr[indexPath.row];
        }
        [self.navigationController pushViewController:taskVC animated:YES];
    }else if ([datamnager.tagString isEqualToString:@"51"]){
        ////视频中心
        SimpleDemoViewController *playVC = [[SimpleDemoViewController alloc]init];
        playVC.title = self.smodel.SiteNameArr[indexPath.row];
        playVC.siteID = self.smodel.SiteIDArr[indexPath.row];
        playVC.view.frame = CGRectMake(0, 110, WT, HT-100);
//        playVC.stationModel = self.numberModelArray[indexPath.row];
        [self.navigationController pushViewController:playVC animated:YES];
        
    }else if ([datamnager.tagString isEqualToString:@"52"]){
        HandInContentViewController *handle = [[HandInContentViewController alloc]init];
        handle.title = self.smodel.SiteNameArr[indexPath.row];
//        handle.stationModel = self.numberModelArray[indexPath.row];
        handle.siteID = self.smodel.SiteIDArr[indexPath.row];
        [self.navigationController pushViewController:handle animated:YES];
        
    }

}
- (void)searchActions:(UIButton *)sender{

    [self sendTownThreeListStation:self.searchTF];
    
}
- (void)textFieldChangedSearchs:(UITextField *)textField {
    self.searchTF = textField.text;
    NSLog(@"dvccccccccccccccccc=--------%@", self.searchTF);
}


-(UITableView *)myTableView{
    if (!_myTableView) {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line0.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.line0.frame)) style:UITableViewStylePlain];
        self.myTableView.delegate =self;
        self.myTableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _myTableView;
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
