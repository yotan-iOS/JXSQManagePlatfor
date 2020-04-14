//
//  NavigationListViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/12.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "NavigationListViewController.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "NavigationModel.h"
#import "MapNavigationManager.h"
#import "NavigationSearchViewController.h"
#import "RealTimeDataViewController.h"
#import "SimpleDemoViewController.h"
@interface NavigationListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *dataManger;
}
@property (nonatomic,strong) NavigationSearchViewController *searchVC;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,copy) NSString *searchTF;


@end

@implementation NavigationListViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    dataManger = [DataSource sharedDataSource];

    [self createSearhBut];
    [self createTableView];
    [self readData];
}
//获取河道

-(void)readData{
    self.sectionArray = nil;
     self.dataArray = nil; 
    [gs_HttpManager httpManagerPostParameter:@{@"sitetypeid":@"",@"dataflg":@"",@"videoflg":@"",@"isnwjg":@"0"} toHttpUrlStr:F(@"%@/GetTownInfo",BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"NoneList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                NavigationModel *model = [[NavigationModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.sectionArray addObject:model];
            }
            
        }
        [CustomHUD dismiss];
        [self.tableView1 reloadData];
         NSLog(@"列表 === %@", result);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
          [self.tableView1 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        NavigationModel *model = self.sectionArray.firstObject;
        [self sendTownThreeListStation:F(@"%@", model.ID)];
       
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];

}

//站点列表
- (void)sendTownThreeListStation:(NSString *)riverID {
    NSDictionary *param;
    //在线水质
    if ([dataManger.tagString isEqualToString:@"10"]) {
        param = @{@"townid":riverID,@"riverid":@"",@"hasvideoflg":@"",@"hasdataflg":@"1",@"sitetypeid":@"1,2"};
    }else if ([dataManger.tagString isEqualToString:@"11"]){
        //实时视频
         param = @{@"townid":riverID,@"riverid":@"",@"hasvideoflg":@"1",@"hasdataflg":@"",@"sitetypeid":@""};
    }else if ([dataManger.tagString isEqualToString:@"14"]){
        //电子导航
         param = @{@"townid":riverID,@"riverid":@"",@"hasvideoflg":@"",@"hasdataflg":@"",@"sitetypeid":@""};
    }
  
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/getSiteInfoByRiverID",BaseRequestUrl)  isCacheorNot:NO targetViewController:self andUrlFunctionName:@"NtwoList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                NavigationModel *model = [[NavigationModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [CustomHUD dismiss];
        [self.tableView2 reloadData];
        NSLog(@"列表 === %@", result);
    } orFail:^(NSError *error) {
        NSLog(@"列表%@", error);
         [CustomHUD dismiss];
    }];
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
    [_tf addTarget:self action:@selector(textFieldChangedSearch:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_tf];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -70, h, 50 + 10, 30 + 20)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    
    but.backgroundColor = UIColorFromRGB(0x3FB3E6);
    [but addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0,h+50 + 20-1 ,WT, 1)];
    line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line0];
}

- (void)searchAction:(UIButton *)sender{
//    [self.tableView1 removeFromSuperview];
//    [self.tableView2 removeFromSuperview];
    _searchVC = [[NavigationSearchViewController alloc]init];
//    _searchVC.view.frame = CGRectMake(0, CGRectGetMaxY(_tf.frame)+10, WT, HT-CGRectGetMaxY(_tf.frame));
    [_searchVC sendTownListStation:self.searchTF];
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
    int h = 90+NAVIHEIGHT;
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
      return  self.sectionArray.count;
    } else if([tableView isEqual:self.tableView2]) {
      return  self.dataArray.count;
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
        if (self.sectionArray.count > 0) {
            NavigationModel *model = self.sectionArray[indexPath.row];
            cell.textLabel.text = F(@"%@",model.DictName);
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
        if (self.dataArray.count > 0) {
            NavigationModel *model = self.dataArray[indexPath.row];
            cell.textLabel.text = model.SiteName;
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
        self.dataArray = nil;
        if (self.sectionArray.count  > 0) {
            NavigationModel *model = self.sectionArray[indexPath.row];
            [self sendTownThreeListStation:F(@"%@", model.ID)];
        }
       
    } else if ([tableView isEqual:self.tableView2]) {
        NavigationModel *model = self.dataArray[indexPath.row];
        if ([dataManger.tagString isEqualToString:@"14"]) {
             //电子导航
            [MapNavigationManager showSheetAddAview:self.view Coordinate2D:CLLocationCoordinate2DMake([model.SiteLat doubleValue],[model.SiteLon doubleValue])];
        }else if ([dataManger.tagString isEqualToString:@"11"]){
            //实时视频
            SimpleDemoViewController *playVC = [[SimpleDemoViewController alloc] init];
            playVC.videoTitle = model.SiteName;
            playVC.siteID = model.ID;
            [self.navigationController pushViewController:playVC animated:YES];
        }else if ([dataManger.tagString isEqualToString:@"10"]){
           //在线水质
            RealTimeDataViewController *realVC = [[RealTimeDataViewController alloc]init];
            realVC.title = model.SiteName;
            realVC.SiteTypeIDstr = model.SiteTypeID;
            realVC.siteID = model.ID;
            [self.navigationController pushViewController:realVC animated:YES];
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

@end
