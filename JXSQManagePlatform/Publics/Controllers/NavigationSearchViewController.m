//
//  NavigationSearchViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/23.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "NavigationSearchViewController.h"
#import "SearchTableViewCell.h"
#import "NavigationModel.h"
#import "MapNavigationManager.h"
#import "RiverListModel.h"
#import "SimpleDemoViewController.h"
#import "RealTimeDataViewController.h"
#import "StationModel.h"
#define KW [UIScreen mainScreen].bounds.size.width
#define KH [UIScreen mainScreen].bounds.size.height
@interface NavigationSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy) NSString *siteTypeStr;
@property(nonatomic,copy) NSString *urlStr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,copy) NSString *searchTF;
@property (nonatomic,strong) UILabel *line0;
@end

@implementation NavigationSearchViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataArray;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//       self.view.frame = CGRectMake(0, 64+50+20 + 100,KW,KH-64-40-20-50);
    self.title = @"站点搜索";
    [self createSearhBut];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
    [_tf addTarget:self action:@selector(textFieldChangedSearch:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_tf];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -70, h, 50 + 10, 30 + 20)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    
    but.backgroundColor = UIColorFromRGB(0x3FB3E6);
    [but addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    self.line0 = [[UILabel alloc]initWithFrame:CGRectMake(0,h+50 + 20-1 ,WT, 1)];
    _line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_line0];
    [self.view addSubview:self.tableView];
}

- (void)searchAction:(UIButton  *)sender{
    [self sendTownListStation:self.searchTF];
}

- (void)textFieldChangedSearch:(UITextField *)textField {
    self.searchTF = textField.text;
    NSLog(@"dvccccccccccccccccc=--------%@", self.searchTF);
}

//列表的搜索
- (void)sendTownListStation:(NSString *)keyboardStr {
    DataSource *datasource = [DataSource sharedDataSource];
    
    [self.dataArray removeAllObjects];
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    
    
    if ([datasource.tagString isEqualToString:@"14"]) {
        //电子导航
        self.urlStr = F(@"%@/getSiteInfoBySiteName", RequestURL);
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:keyboardStr,@"SiteName", nil];
        [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Search" success:^(id result) {
            NSDictionary *dicData = result;
            if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
                for (NSDictionary *dic in dicData[@"Data"]) {
                    NavigationModel *model = [[NavigationModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }else{
                [YJProgressHUD showError:@"无匹配内容"];
            }
            [CustomHUD dismiss];
            [self.tableView reloadData];
            [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
            NSLog(@"列表的搜索 === %@", result);
        } orFail:^(NSError *error) {
            NSLog(@"列表的搜索 %@", error);
            [YJProgressHUD showError:@"数据获取失败"];
            [CustomHUD dismiss];
        }];
        
    } else {
        self.urlStr = BaseRiverMURLStr;
        NSDictionary *param;
        if ([datasource.tagString isEqualToString:@"10"]) {//在线水质
            self.siteTypeStr = @"1;2";
            param = @{
                      @"action":@"25",
                      @"method":F(@"{searchName:%@,siteTypeID:%@,hasvideoflg:%@,hasdataflg:%@}",keyboardStr, self.siteTypeStr,@"",@"1"),
                      };
        } else if ([datasource.tagString isEqualToString:@"11"]) {//视频
            self.siteTypeStr = @"";
            param = @{
                      @"action":@"25",
                      @"method":F(@"{searchName:%@,siteTypeID:%@,hasvideoflg:%@,hasdataflg:%@}",keyboardStr, self.siteTypeStr,@"1",@""),
                      };
        }
        
        [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Search" success:^(id result) {
            NSDictionary *dicData = result;
            if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
                for (NSDictionary *dic in dicData[@"Result"]) {
                    StationModel *smodel = [[StationModel alloc]init];
                    [smodel setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:smodel];
                }
                
            }else{
                [YJProgressHUD showError:@"无匹配内容"];
            }
            [CustomHUD dismiss];
            [self.tableView reloadData];
            
            [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
            NSLog(@"列表的搜索 === %@", result);
        } orFail:^(NSError *error) {
            NSLog(@"列表的搜索 %@", error);
            [YJProgressHUD showError:@"数据获取失败"];
            [CustomHUD dismiss];
        }];
    }
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataSource *datasource = [DataSource sharedDataSource];
    SearchTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        if ([datasource.tagString isEqualToString:@"10"] || [datasource.tagString isEqualToString:@"11"]) {
            StationModel *model = self.dataArray[indexPath.row];
            cell.stationLable.text = model.SiteName;
        } else {
            NavigationModel *model = self.dataArray[indexPath.row];
            cell.stationLable.text = model.SiteName;
        }
        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DataSource *datamnager = [DataSource sharedDataSource];
    if (self.dataArray.count > 0) {
//        电子导航
        if ([datamnager.tagString isEqualToString:@"14"]) {
            NavigationModel *model = self.dataArray[indexPath.row];
            [MapNavigationManager showSheetAddAview:self.view Coordinate2D:CLLocationCoordinate2DMake([model.SiteLat doubleValue],[model.SiteLon doubleValue])];
        }else if ([datamnager.tagString isEqualToString:@"10"]){
            //在线水质
            StationModel *model = self.dataArray[indexPath.row];
            RealTimeDataViewController *realVC = [[RealTimeDataViewController alloc]init];
            realVC.title = model.SiteName;
            realVC.SiteTypeIDstr = model.SiteTypeID;
            realVC.siteID = model.SiteID;
            [self.navigationController pushViewController:realVC animated:YES];
            
        }else if([datamnager.tagString isEqualToString:@"11"]){
            //实时视频
            StationModel *model = self.dataArray[indexPath.row];
            SimpleDemoViewController *playVC = [[SimpleDemoViewController alloc] init];
            playVC.videoTitle = model.SiteName;
            playVC.siteID = model.SiteID;
            
            [self.navigationController pushViewController:playVC animated:YES];
            
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line0.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.line0.frame)) style:UITableViewStylePlain];
        self.tableView.delegate =self;
        self.tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
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
