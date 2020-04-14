//
//  JBOperationListViewController.m
//  BGRuralDomesticWaste
//
//  Created by 吴坤 on 2017/8/26.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "JBOperationListViewController.h"
#import "OperationHandleTableViewCell.h"
#import "StationModel.h"
#import "HandOverViewController.h"
#import "HandlingOperationDetailViewController.h"

#define SelectColor  UIColorFromRGB(0xE2E2E2)// 2ab1e7
@interface JBOperationListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    DataSource *datamanager;
    
}
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,copy) NSString *urlStr;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,strong)NSMutableArray *SArr;
@end

@implementation JBOperationListViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        self.searchArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _searchArray;
}
-(NSMutableArray *)SArr{
    if (!_SArr) {
        self.SArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _SArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    datamanager = [DataSource sharedDataSource];
    
    [self createSearhBut];
    [self configerHeaderView];
    [self createTableView];
    self.view.backgroundColor = UIColorFromRGB(0xEDEDED);
    UIView *hdview0 = [_headerView viewWithTag:810];
    hdview0.backgroundColor = SelectColor;
    [self addGesturTapForView];
    
}
-(void)readDataForCount{
    //数量
    self.urlStr = F(@"%@/GetApPushCount",BaseRequestUrl);
    NSDictionary *param = @{@"OperationUserID":datamanager.UserID};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"jboonecount" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        
        if ([status isEqualToString:@"OK"]) {
            
            for (NSDictionary *dic in dicData[@"Data"]) {
                StationModel *model = [[StationModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                self.dealingNum.text = F(@"%@",model.HandingCount);
                self.overNum.text = F(@"%@", model.OverdueCount);
                
            }
            
        }
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
    }];
}

//交办列表
-(void)readData{
    self.dataArray = nil;
    self.urlStr = F(@"%@/GetApPushList",BaseRequestUrl);
    NSDictionary *param = @{@"PushType":self.pushTyID,@"UserID":datamanager.UserID,@"Authority":datamanager.GroupID};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"oneList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]&& [dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                StationModel *model = [[StationModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }else{
               [YJProgressHUD showWaiting:dicData[@"Msg"]];
        }
       
   
        self.SArr = self.dataArray;
        [self.tableView1 reloadData];
        
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
    }];
}
-(void)configerHeaderView{
    if (KISIphoneX) {
        self.headerView.frame = CGRectMake(0, NAVIHEIGHT+24, WT,70);
    } else {
        self.headerView.frame = CGRectMake(0, NAVIHEIGHT, WT,70);
    }
    
    [self.view addSubview:self.headerView];
    
}
-(void)createSearhBut{
    int h;
    if (KISIphoneX) {
        h = 70+NAVIHEIGHT+10+24;
    } else {
        h = 70+NAVIHEIGHT+10;
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
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -70, h, 50 + 10, 40)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    
    but.backgroundColor = UIColorFromRGB(0x3FB3E6);
    [but addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    
}
- (void)searchAction:(UIButton *)sender{
    self.searchArray = nil;
    self.searchArray = self.dataArray;
    self.dataArray = nil;
    NSMutableArray *searArr = [NSMutableArray arrayWithCapacity:1];
    for (StationModel *model in self.searchArray) {
        if (![searArr containsObject:model.SiteName]) {
            [searArr addObject:model.SiteName];
        }
    }
    NSString *pstringt = [NSString stringWithFormat: @"SELF CONTAINS '%@'",self.tf.text];
    
    NSPredicate * predidate = [NSPredicate predicateWithFormat:pstringt];
    
    //进行谓词匹配
    NSArray *array2 =[searArr filteredArrayUsingPredicate:predidate];
    
    
    for (StationModel *model in self.searchArray) {
        for (NSString *name in array2) {
            if ([model.SiteName isEqualToString:name]) {
                [self.dataArray addObject:model];
            }
        }
    }
    if (self.dataArray.count > 0) {
        [self.tableView1 reloadData];
    }else{
        [YJProgressHUD showError:@"无匹配内容"];
        self.dataArray  = self.SArr;
        [self.tableView1 reloadData];
    }
    
    
}

- (void)textFieldChangedSearch:(UITextField *)textField {
    
}

#pragma mark - UITableViewDataSource UITableViewDelegate
-(void)createTableView{
    int h;
    if (KISIphoneX) {
        h = 70+NAVIHEIGHT+50+10+24;
    } else {
        h = 70+NAVIHEIGHT+50+10;
    }
    
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT, HT-h)];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    _tableView1.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.view addSubview:_tableView1];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"OperationHandleTableViewCell" bundle:nil] forCellReuseIdentifier:@"operation"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 155;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OperationHandleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"operation" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        StationModel *model =self.dataArray[indexPath.row];
        cell.siteNameLab.text = model.SiteName;
        
//        cell.errorContentLab.text = @"";
//        NSArray *arr = [model.ErrCodeList componentsSeparatedByString:@","];
//        for (int i = 0; i < arr.count; i++) {
//            [self readDataWithCode:arr[i] lab: cell.errorContentLab];
//        }
        cell.errorContentLab.text = model.PushComment;
        cell.errorDays.text =  [F(@"%@", model.DealEndTime) stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        cell.instertimeLab.text = F(@"%@", [[model.InsertDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19]);
        cell.statusLab.text = model.PushStatusName;
    }
    return cell;
    
}

-(void)readDataWithCode:(NSString *)code lab:(UILabel *)lab{
    
    NSLog(@"code--%@",code);
    self.urlStr = F(@"%@/GetApErrCodeByErrcode",RequestURL);
    NSDictionary *param = @{@"ErrCode":code};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"errList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        
        if ([status isEqualToString:@"OK"]) {
            NSDictionary *dic = dicData[@"Data"];
            NSLog(@"%@====================%@", dic,dic[@"ErrContemt"]);
            NSString *str =  F(@"%@",dic[@"ErrContemt"]);
            lab.text = [lab.text stringByAppendingFormat:@"%@ ",str];
        }
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        
        
    }];
    
}
-(NSString *)getStatusValuesWithStatus:(NSString *)status{
    NSString *str;
    if ([status isEqualToString:@"1"]) {
        str = @"待处理";
    }else if([status isEqualToString:@"2"]){
        str = @"待初审";
    }else if([status isEqualToString:@"3"]){
        str = @"待审核";
    }else if([status isEqualToString:@"4"]){
        str = @"已解决";
    }else if([status isEqualToString:@"11"]){
        str = @"不做处理";
    }else if([status isEqualToString:@"22"]){
        str = @"申请延期";
    }
    
    return str;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > 0) {
        StationModel *model =self.dataArray[indexPath.row];
        OperationHandleTableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:indexPath];
        
        if ([F(@"%@",model.Status) isEqualToString:@"1"]) {
            if(([F(@"%@",model.PushStatus) isEqualToString:@"2"]||[F(@"%@",model.PushStatus) isEqualToString:@"11"])){
                HandlingOperationDetailViewController *detail = [[HandlingOperationDetailViewController alloc]init];
                detail.model = model;
                detail.title = model.SiteName;
                detail.errContentString = cell.errorContentLab.text;
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                HandOverViewController *handover = [[HandOverViewController alloc]init];
                handover.title = model.SiteName;
                handover.model = model;
                handover.errcontentStr = cell.errorContentLab.text;
                [self.navigationController pushViewController:handover animated:YES];
            }
    
            
        }else{
            HandlingOperationDetailViewController *detail = [[HandlingOperationDetailViewController alloc]init];
            detail.model = model;
            detail.title = model.SiteName;
            detail.errContentString = cell.errorContentLab.text;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}
- (void)addGesturTapForView{
    for (int i = 0; i < 2; i++) {
        UIView *hdview = [self.headerView viewWithTag:810 + i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeData:)];
        hdview.userInteractionEnabled = YES;
        [hdview addGestureRecognizer:tap];
        
    }
}
-(void)changeData:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 810;
    UIView *hdview0 = [self.headerView viewWithTag:810];
    UIView *hdview1 = [self.headerView viewWithTag:811];
    
    switch (index) {
        case 0:
        {
            hdview0.backgroundColor = SelectColor ;
            hdview1.backgroundColor = [UIColor whiteColor];
            
            self.pushTyID = @"Handling";
            [self readData];
        }
            break;
        case 1:
        {
            hdview1.backgroundColor = SelectColor;
            hdview0.backgroundColor = [UIColor whiteColor];
            
            self.pushTyID = @"Overdue";
            [self readData];
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.pushTyID = @"Handling";
    [self readData];
    [self readDataForCount];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
