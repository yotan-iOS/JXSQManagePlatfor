//
//  ThreeListViewController.m
//  LWIntelligenceOperations
//
//  Created by 吴坤 on 17/5/17.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "ThreeListViewController.h"
#import "StationModel.h"
#import "SearchViewController.h"
#import "RiverProgramViewController.h"
@interface ThreeListViewController ()<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>{
    DataSource *datamnager;
}
@property(nonatomic,copy)NSString *mdata;
@property(nonatomic,strong)StationModel *model;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong) UITableView *tableView1;
@property(nonatomic,strong) UITableView *tableView2;
@property(nonatomic,strong) UITableView *tableView3;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)NSMutableArray *tableArr;
@property(nonatomic,strong)NSMutableArray *oneTableClassArr;
@property (nonatomic, strong) UIView        *backGroundView;//发生变换试图
@property(nonatomic,strong)NSMutableArray *sectionArray;

@property (nonatomic,strong) SearchViewController *searchVC;
@property (nonatomic,copy) NSString *searchTF;
@end

@implementation ThreeListViewController
- (StationModel *)model{
    if (!_model) {
        self.model = [[StationModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataArray;
}
-(NSMutableArray *)sectionArray{
    
    if (!_sectionArray) {
        
        self.sectionArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _sectionArray;
}


-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataSource;
}

-(NSMutableArray *)searchArray{
    
    if (!_searchArray) {
        
        self.searchArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _searchArray;
}
-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        self.dataArr =  [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataArr;
}

-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WT,HT)];
        _backGroundView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5f];
        _backGroundView.tag = 11;
    }
    return _backGroundView;
}

- (NSMutableArray *)tableArr{
    if (!_tableArr) {
        if ([datamnager.tagString isEqualToString:@"3"]) {
              self.tableArr = [NSMutableArray arrayWithObjects:@"微孔曝气工程",@"河道曝气工程", nil];
        }
  
    }
    return _tableArr;
}
- (NSMutableArray *)oneTableClassArr{
    if (!_oneTableClassArr) {
        self.oneTableClassArr = [NSMutableArray arrayWithObjects:@"3",@"4", nil];
    }
    return _oneTableClassArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    datamnager = [DataSource sharedDataSource];
    [self createSearhBut];
    [self createTableView];
    if ([datamnager.tagString isEqualToString:@"1"]) {
        self.title = @"污染源监测";
    }
    self.searchTF = @"";
}
//创建搜索框
-(void)createSearhBut{
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(20,79, WT-90, 40)];
    _tf.layer.borderColor = UIColorFromRGB(0x3FB3E6).CGColor;
    _tf.layer.borderWidth = 2;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.placeholder = @" 请输入站点名";
       [_tf setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    _tf.textAlignment = NSTextAlignmentCenter;
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_tf addTarget:self action:@selector(textFieldChangedSearch:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_tf];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -70, _tf.frame.origin.y,50, 40)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    
    but.backgroundColor = UIColorFromRGB(0x3FB3E6);
    [but addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0,74+40+20-1,WT, 1)];
    line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line0];
    
}
#pragma mark - UITableViewDataSource UITableViewDelegate
-(void)searchAction:(UIButton *)sender{
    [self.tableView1 removeFromSuperview];
    [self.tableView2 removeFromSuperview];
    _searchVC = [[SearchViewController alloc]init];
    _searchVC.view.frame = CGRectMake(0, CGRectGetMaxY(_tf.frame)+10, WT, HT-CGRectGetMaxY(_tf.frame));
    [_searchVC sendTownThreeListStation:self.searchTF];
    [self addChildViewController:_searchVC];
    [self.view addSubview:_searchVC.view];
}
- (void)textFieldChangedSearch:(UITextField *)textField {
    self.searchTF = textField.text;
    NSLog(@"dvccccccccccccccccc=--------%@", self.searchTF);
}
//创建tableView
- (void)createTableView{
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0,74+60, WT/3.0, HT-74-60)];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView1.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.view addSubview:_tableView1];
    
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake((WT/3.0),_tableView1.frame.origin.y,WT/3.0 , _tableView1.frame.size.height)];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView2.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.view addSubview:_tableView2];
    
    _tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(2*(WT/3.0),_tableView1.frame.origin.y,WT/3.0 , _tableView1.frame.size.height)];
    _tableView3.delegate = self;
    _tableView3.dataSource = self;
    _tableView3.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView3.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
    [self.view addSubview:_tableView3];
    //通知刷新tableview
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WT/3.0,_tableView1.frame.origin.y,1, _tableView1.frame.size.height)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(2*WT/3.0,_tableView1.frame.origin.y,1, _tableView1.frame.size.height)];
    line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line0];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView1]) {
        
        return self.tableArr.count;
        
    }else if([tableView isEqual:self.tableView2]){
        
        return self.model.SiteTypeIDArr.count;
    }
    return self.model.SiteIDArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableView1]) {
        
        return 40;
        
    }else if([tableView isEqual:self.tableView2]){
        
        return 45;
    }
    return 45;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([tableView isEqual:self.tableView1]) {
        
        static NSString *identfy = @"cell1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
        }
        
      
        cell.textLabel.text = self.tableArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        
    }else if ([tableView isEqual:self.tableView2]){
        
        static NSString *identfy = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
            
        }
        if (self.model.SiteTypeIDArr.count > 0) {
            cell.textLabel.text = self.model.SiteTypeNameArr[indexPath.row];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
       
     
        return cell;
        
        
    }else if ([tableView isEqual:self.tableView3]){
        static NSString *identfy = @"cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
            
        }
        if (self.model.SiteIDArr > 0) {
            cell.textLabel.text = self.model.SiteNameArr[indexPath.row];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
  
        
        return cell;
        
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //五个工程类型
    if ([tableView isEqual:self.tableView1]) {
        [self.model.SiteTypeIDArr removeAllObjects];
        [self.model.SiteTypeNameArr removeAllObjects];
        [self.model.SiteIDArr removeAllObjects];
        [self.model.SiteNameArr removeAllObjects];
        [self.tableView2 reloadData];
        [self.tableView3 reloadData];

        datamnager.siteClassID = self.oneTableClassArr[indexPath.row];
        
       
        [self sendToObtainListSecondary:self.oneTableClassArr[indexPath.row]];
        
    }else if([tableView isEqual:self.tableView2]){
        //乡镇
        [self.model.SiteIDArr removeAllObjects];
        [self.model.SiteNameArr removeAllObjects];
        if (self.model.SiteTypeIDArr.count > 0) {
            [self sendForLevelThreeSitesList:nil SiteClassID:self.model.SiteTypeIDArr[indexPath.row]];
            datamnager.siteTypeID = self.model.SiteTypeIDArr[indexPath.row];
        }
    } else if([tableView isEqual:self.tableView3]){
        //站点
        NSInteger tragerId = [datamnager.tagString integerValue];
        switch (tragerId) {
            case 3:
            {
                RiverProgramViewController *riverProVC = [[RiverProgramViewController alloc]init];
                riverProVC.title = self.model.SiteNameArr[indexPath.row];
                datamnager.siteIDString = self.model.SiteIDArr[indexPath.row];
                
                [self.navigationController pushViewController:riverProVC animated:YES];
            }
                break;
            case 2:
            {
            }
                break;
            default:
                break;
        }
        
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
//获取二级列表
- (void)sendToObtainListSecondary:(NSString *)classId {
     [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    if ([datamnager.tagString isEqualToString:@"3"]) {
        self.urlString = BaseWaterEnURLStr;
    }
    NSDictionary *param = @{
                            @"action":@"1",
                            @"method":F(@"{siteTypeID:%@}", classId),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlString isCacheorNot:NO targetViewController:self andUrlFunctionName:@"twoList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.model.SiteTypeIDArr addObject:dic[@"TownID"]];
                [self.model.SiteTypeNameArr addObject:dic[@"TownName"]];
               
            }
            [CustomHUD dismiss];
            [self.tableView2 reloadData];
        }
        
        NSLog(@"成功%@", result);
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
}
//获取三级站点列表
- (void)sendForLevelThreeSitesList:(NSString *)typeId SiteClassID:(NSString *)SiteClassID {
     [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    if ([datamnager.tagString isEqualToString:@"3"]) {
        self.urlString = BaseWaterEnURLStr;
    }
    
    NSDictionary *param = @{
                            @"action":@"2",
                            @"method":F(@"{siteTypeID:%@,townID:%@}", datamnager.siteClassID,SiteClassID),
                            };
    NSLog(@"SiteClassID----%@----%@",datamnager.siteClassID,SiteClassID);
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlString isCacheorNot:NO targetViewController:self andUrlFunctionName:@"thteeList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.model.SiteIDArr addObject:dic[@"SiteID"]];
                [self.model.SiteNameArr addObject:dic[@"SiteName"]];
            }
            [CustomHUD dismiss];
            [self.tableView3 reloadData];
        }
        
        NSLog(@"成功%@", result);
    } orFail:^(NSError *error) {
        NSLog(@"三级列表%@", error);
    }];
}
- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
