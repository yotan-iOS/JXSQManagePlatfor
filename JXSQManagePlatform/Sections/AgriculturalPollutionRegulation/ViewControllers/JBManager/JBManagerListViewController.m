//
//  JBManagerListViewController.m
//  BGRuralDomesticWaste
//
//  Created by 吴坤 on 2017/8/26.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "JBManagerListViewController.h"
#import "StationModel.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "HandInContentViewController.h"
#import "JBManagerHistoryListController.h"
@interface JBManagerListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *dataManger;
  
}

@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) UITableView *tableView3;
@property(nonatomic,strong)NSMutableArray *siteNameArr;
@property(nonatomic,strong)NSMutableArray *townArr;
@property(nonatomic,copy)NSString  *urlStr;
@property(nonatomic,copy)NSString  *tyID;
@property (nonatomic,copy) NSString *searchTF;
@property(nonatomic,strong) JBManagerHistoryListController *history;
@end

@implementation JBManagerListViewController
- (NSMutableArray *)siteNameArr{
    if (!_siteNameArr) {
        self.siteNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _siteNameArr;
}

- (NSMutableArray *)townArr{
    if (!_townArr) {
        self.townArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _townArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"巡检登记";
    dataManger = [DataSource sharedDataSource];
    self.view.backgroundColor = UIColorFromRGB(0xF5F4F5);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configerHeaderView];
    [self createSearhBut];
    [self createTableView];
    [self readData];
}
-(void)readData{
    self.townArr = nil;
    self.siteNameArr  = nil;
    
//    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
//    [jHUDm showSucceessAnimationViewAddSuperview:self.view];
    
    [self.tableView2 reloadData];
    //数据列表;
    
    self.urlStr = F(@"%@/StreetInfo/ListByOnOffLineSite",BaseRequestUrl);
     NSDictionary *parmDic = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"VideoNetStatus",dataManger.UserID,@"UserID",@"",@"Authority", nil];
    [gs_HttpManager httpManagerPostParameter:parmDic toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"jmList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"status"]);
        
        if ([status isEqualToString:@"1"] && [dicData[@"message"] isEqualToString:@"成功"]) {
            
            for (NSDictionary *dic in dicData[@"data"]) {
                StationModel *model = [[StationModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.townArr addObject:model];
                
            }
            
        }
//        [CustomHUD dismiss];

        [self.tableView1 reloadData];
        [self.tableView1.mj_header endRefreshing];
//        NSLog(@" 列表 -------%@-----%ld---%@",self.townArr ,self.townArr.count,result);
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
//        [CustomHUD dismiss];

        [self.tableView1.mj_header endRefreshing];
    }];
}

//乡镇列表
- (void)getSiteInfoWithStreetNumber:(NSString *)streetNumber{
//    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];

    NSDictionary *param = @{@"StreetNumber":streetNumber,@"UserID":dataManger.UserID,@"Authority":@""};
    //数据列表;
//    self.urlStr = BaseSiteListURLStr;
    // ;
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"jmtwoList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"status"]);
        
        if ([status isEqualToString:@"1"]&&[dicData[@"message"]isEqualToString:@"成功"]) {
            
            for (NSDictionary *dic in dicData[@"data"]) {
                StationModel *model = [[StationModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.siteNameArr addObject:model];
            }
            
        }
//        [CustomHUD dismiss];
     
        [self.tableView2 reloadData];
//        NSLog(@" 列表 -------%@-----%ld---%@",self.siteNameArr ,self.siteNameArr.count,result);
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
//        [CustomHUD dismiss];
       
    }];
}

-(void)configerHeaderView{
    if (KISIphoneX) {
        self.headerView.frame = CGRectMake(0, NAVIHEIGHT+24, WT, 50);
    } else {
        self.headerView.frame = CGRectMake(0, NAVIHEIGHT, WT, 50);
    }
    
    [self.view addSubview:self.headerView];
    
}
-(void)createSearhBut{
    int h;
    if (KISIphoneX) {
        h = NAVIHEIGHT+20+50-10+24;
    } else {
        h = NAVIHEIGHT+20+50-10;
    }
    
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(20, h, WT-90, 40)];
    _tf.layer.borderColor = UIColorFromRGB(0x3FB3E6).CGColor;
    _tf.layer.borderWidth = 2;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.placeholder = @"请输入站点名";
    _tf.textAlignment = NSTextAlignmentCenter;
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_tf addTarget:self action:@selector(textFieldChangedSearch:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_tf];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -70, h, 60 , 40)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    
    but.backgroundColor = UIColorFromRGB(0x3FB3E6);
    [but addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0,h+50-10 -10+ 20-1 ,WT, 1)];
    line0.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line0];
      _segement.tintColor = UIColorFromRGB(0x009FF2);
    [_segement addTarget:self action:@selector(changValues:) forControlEvents:UIControlEventValueChanged];
}
-(void)changValues:(UISegmentedControl *)segment{
    [self.history removeFromParentViewController];
    [self.history.view removeFromSuperview];
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
          
            [self readData];
        }
            break;
        case 1:
        {
           self.history = [[JBManagerHistoryListController alloc]init];
            [self addChildViewController:self.history];
            [self.view addSubview:self.history.view];
            
          
        }
            break;
        default:
            break;
    }
    
}
- (void)searchAction:(UIButton *)sender{

    
}

- (void)textFieldChangedSearch:(UITextField *)textField {
  
    self.searchTF = textField.text;
}

#pragma mark - UITableViewDataSource UITableViewDelegate
-(void)createTableView{
    int h;
    if (KISIphoneX) {
        h = 90+NAVIHEIGHT+50-10-10-10+24;
        
        _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT/3.0, HT-h-10)];
        _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake((WT/3.0),h,2*WT/3.0 , HT-h-10)];
    } else {
        h = 90+NAVIHEIGHT+50-10-10-10;
        
        _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT/3.0, HT-h)];
        _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake((WT/3.0),h,2*WT/3.0 , HT-h)];
    }
    
    
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView1.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.view addSubview:_tableView1];
    
    
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView2.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
    [self.view addSubview:_tableView2];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WT/3.0, h,1, HT-h)];
    line.backgroundColor = UIColorFromRGB(0xF5F4F5);
    [self.view addSubview:line];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView1]) {
        return self.townArr.count;
    } else if([tableView isEqual:self.tableView2]) {
        return self.siteNameArr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView1]) {
        return 40;
    } else if ([tableView isEqual:self.tableView2]) {
        return 45;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableView1]) {
        static NSString *identfy = @"cell1";
        TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        if (!cell) {
            cell = [[TableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
        }
      
        if (self.townArr.count > 0) {
            StationModel *model = self.townArr[indexPath.row];
            cell.textLabel.text = model.StreetName;
        }
      
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        
    }else if ([tableView isEqual:self.tableView2]){
        static NSString *identfy = @"cell2";
        TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        
        if (!cell) {
            cell = [[TableViewCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
        }
        
        
        if (self.siteNameArr.count > 0) {
            StationModel *model = self.siteNameArr[indexPath.row];
            cell.textLabel.text = model.SiteName;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }else  if ([tableView isEqual:self.tableView3]){
    
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView1]) {
        self.siteNameArr = nil;
        if (self.townArr.count > 0) {
            StationModel *model = self.townArr[indexPath.row];
            [self getSiteInfoWithStreetNumber:F(@"%@",@"")];
        }
       
       
    } else if([tableView isEqual:self.tableView2]){
        StationModel *model;
        if (self.siteNameArr.count > 0) {
            model = self.siteNameArr[indexPath.row];
            
        }
        HandInContentViewController *handle = [[HandInContentViewController alloc]init];
        handle.title = model.SiteName;
        handle.AlarmType = F(@"%@",@"");
        handle.siteID = F(@"%@", model.SiteID);
        handle.stationModel = model;
        [self.navigationController pushViewController:handle animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [CustomHUD dismiss];

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
