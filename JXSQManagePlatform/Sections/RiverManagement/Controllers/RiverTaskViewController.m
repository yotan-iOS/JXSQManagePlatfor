//
//  RiverTaskViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/4.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverTaskViewController.h"
#import "SearchViewController.h"
#import "StationModel.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"

#import "RiverTaskDetailViewController.h"
@interface RiverTaskViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *dataManger;
}
@property (nonatomic,copy) NSString *mdata;
@property (nonatomic,strong) StationModel *model;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) SearchViewController *searchVC;
@property (nonatomic,copy) NSString *searchTF;
@property (nonatomic,copy) NSString *siteTypeStr;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *actionStr;

@end

@implementation RiverTaskViewController

- (StationModel *)model{
    if (!_model) {
        self.model = [[StationModel alloc] init];
    }
    return _model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [self createSearhBut];
    dataManger = [DataSource sharedDataSource];
    self.automaticallyAdjustsScrollViewInsets =  NO;
    [self configerBtn];
     [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
     self.status = @"1";
    [self sendTownshipListListSecondary];
    [self createTableView];
    self.searchTF = @"";
}
-(void)configerBtn{
    UIView *btview = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, SCREEN_WIDTH, 60)];
    [self.view addSubview:btview];
    btview.backgroundColor = [UIColor whiteColor];
    self.yesBtn = [[RadioButton alloc]initWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH - 60)/2.0, 40)];
    [btview addSubview:self.yesBtn];
    self.noBtn = [[RadioButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.yesBtn.frame)+20, 10, (SCREEN_WIDTH - 60)/2.0, 40)];
    [btview addSubview:self.noBtn];
    
    [self.yesBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.noBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    self.yesBtn.groupButtons = @[self.noBtn];
    [self.noBtn setBackgroundColor:UIColorFromRGB(0x008688)];
    [self.yesBtn setBackgroundColor:UIColorFromRGB(0x008688)];
    [self.yesBtn setTitle:@"处理中" forState:UIControlStateNormal];
    [self.noBtn setTitle:@"待处理" forState:UIControlStateNormal];
    [self.yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.noBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.yesBtn.layer.cornerRadius = 5;
    self.yesBtn.layer.masksToBounds = YES;
    self.noBtn.layer.cornerRadius = 5;
    self.noBtn.layer.masksToBounds = YES;
    self.yesBtn.selected = YES;
}
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/RiverManagement?action=14&method={riverID:1,status:2}
//乡镇列表
- (void)sendTownshipListListSecondary {
    //河长管理status 处理中1，已处理2
   
    
        self.actionStr = @"14";
         NSDictionary *param = @{
                  @"action":self.actionStr,
                  @"method":F(@"{status:%@,userID:%@}",self.status,dataManger.UserID)
                  };
  
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/RiverManagement",RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"oList" success:^(id result) {
        NSLog(@"乡镇列表 === %@----%@", result,self.model.StreetNameArr);
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"] && [dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.model.StreetIDArr addObject:dic[@"TownID"]];
                [self.model.StreetNameArr addObject:dic[@"TownName"]];
            }
            
        }else{
            [YJProgressHUD showError:@"暂无任务"];
        }
        [CustomHUD dismiss];
        [self.tableView1 reloadData];
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
}
//站点列表
- (void)sendTownThreeListStation:(NSString *)StreetID {
     [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
        self.actionStr = @"15";
           NSDictionary *param = @{
                  @"action":self.actionStr,
                  @"method":F(@"{status:%@,userID:%@,townID:%@}",self.status, dataManger.UserID,StreetID),
                  };
        
    NSLog(@"StreetID--%@----%@====%@",self.status,dataManger.RiverID,StreetID);
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/RiverManagement",RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"tList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.model.SiteIDArr addObject:dic[@"SiteID"]];
                [self.model.SiteNameArr addObject:dic[@"SiteName"]];
                [self.model.RecordIDArr addObject:dic[@"RecordID"]];
            }
            
        }
        [CustomHUD dismiss];
        [self.tableView2 reloadData];
        NSLog(@"列表 === %@", result);
    } orFail:^(NSError *error) {
        NSLog(@"列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
}
-(void)createSearhBut{
    int h = NAVIHEIGHT+20+50;
   
   
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(5, h, WT-90+30, 36)];
    _tf.layer.borderWidth = 2;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.placeholder = @"请输入站点名";
    //设置tf右边的view
    self.tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
     self.tf.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *iconImag = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 30)];
    iconImag.image = [UIImage imageNamed:@"searchbar"];
    [self.tf.leftView addSubview:iconImag];
    
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf.layer.borderColor = [UIColor whiteColor].CGColor;
    _tf.layer.borderWidth = 0.1;
    [_tf addTarget:self action:@selector(textFieldChangedSearch:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_tf];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -55, h, 50, 36)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor colorWithRed:0.211 green:0.586 blue:0.992 alpha:1.0] forState:UIControlStateNormal];
//    but.backgroundColor = [UIColor colorWithRed:0.211 green:0.586 blue:0.992 alpha:1.0];
    [but addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0,h+35+10,WT, 1)];
    line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line0];
}
-(void)changeStatus:(RadioButton *)sender{
    NSInteger index = sender.tag - 100;
    [self.model.StreetIDArr removeAllObjects];
    [self.model.StreetNameArr removeAllObjects];
    [self.model.SiteIDArr removeAllObjects];
    [self.model.SiteNameArr removeAllObjects];
    [self.model.RecordIDArr removeAllObjects];
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
    switch (index) {
        case 0:
        {//处理中
            self.status = @"1";
        }
            break;
            
        default:
        {//已处理
            self.status = @"2";
        }
            break;
    }
    [self sendTownshipListListSecondary];
}
- (void)searchAction:(UIButton *)sender{
//    [self.tableView1 removeFromSuperview];
//    [self.tableView2 removeFromSuperview];
    _searchVC = [[SearchViewController alloc]init];
//    _searchVC.view.frame = CGRectMake(0, CGRectGetMaxY(_tf.frame)+10, WT, HT-CGRectGetMaxY(_tf.frame));
    [_searchVC sendTownThreeListStation:self.searchTF];
//    [self addChildViewController:_searchVC];
//    [self.view addSubview:_searchVC.view];
    [self.navigationController pushViewController:_searchVC animated:YES];
    
}

- (void)textFieldChangedSearch:(UITextField *)textField {
    self.searchTF = textField.text;
    NSLog(@"dvccccccccccccccccc=--------%@", self.searchTF);
}

#pragma mark - UITableViewDataSource UITableViewDelegate
-(void)createTableView{
    int h = 121+NAVIHEIGHT;
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT/3.0, HT-h)];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView1.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.view addSubview:_tableView1];
    
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake((WT/3.0),h,2*WT/3.0 , HT-h)];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView2.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
    [self.view addSubview:_tableView2];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WT/3.0, h,1, HT-h)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView1]) {
        return self.model.StreetNameArr.count;
    } else if([tableView isEqual:self.tableView2]) {
        return self.model.SiteNameArr.count;
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
        cell.textLabel.text = self.model.StreetNameArr[indexPath.row];
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
        
        
        if (self.model.SiteNameArr.count > 0) {
            cell.textLabel.text = self.model.SiteNameArr[indexPath.row];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView1]) {
        [self.model.SiteIDArr removeAllObjects];
        [self.model.SiteNameArr removeAllObjects];
        
        if (self.model.StreetIDArr.count >0) {
            [self sendTownThreeListStation:self.model.StreetIDArr[indexPath.row]];
        }
    } else if([tableView isEqual:self.tableView2]){
        RiverTaskDetailViewController *taskVC = [[RiverTaskDetailViewController alloc]init];
        taskVC.status = self.status;
        if (self.model.SiteNameArr.count > 0) {
            taskVC.siteIDstr = self.model.SiteIDArr[indexPath.row];
            taskVC.title = self.model.SiteNameArr[indexPath.row];
            taskVC.recodeID = self.model.RecordIDArr[indexPath.row];
        }
        [self.navigationController pushViewController:taskVC animated:YES];
    }
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
- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
