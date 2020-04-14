//
//  TwoListViewController.m
//  LWIntelligenceOperations
//
//  Created by 吴坤 on 17/5/17.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "TwoListViewController.h"
#import "SearchViewController.h"
#import "StationModel.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "WaterENViewController.h"
#import "HandInContentViewController.h"

@interface TwoListViewController ()<UITableViewDelegate,UITableViewDataSource>{
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
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *actionStr;
@property(nonatomic,strong)NSMutableArray *siteTyIDArray;
@property(nonatomic,strong)NSMutableArray *numberModelArray;
@end

@implementation TwoListViewController
- (StationModel *)model{
    if (!_model) {
        self.model = [[StationModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)siteTyIDArray{
    if (!_siteTyIDArray) {
        self.siteTyIDArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _siteTyIDArray;
}
-(NSMutableArray *)numberModelArray{
    if (!_numberModelArray) {
        self.numberModelArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _numberModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    [self createSearhBut];
    dataManger = [DataSource sharedDataSource];
    self.automaticallyAdjustsScrollViewInsets =  NO;
    
   
    if ([dataManger.tagString isEqualToString:@"3"]) {
         //曝气工程
        self.siteTypeStr = @"3,4";
        [self requestDataForBQRiver];
    }else if ([dataManger.tagString isEqualToString:@"30"]) {
        //工程
        self.siteTypeStr = @"19";
        [self requestDataForBQRiver];
    }else if ([dataManger.tagString isEqualToString:@"40"]) {
        //曝气工程
        self.siteTypeStr = @"20";
        [self requestDataForBQRiver];
    }else{
         [self sendTownshipListListSecondary];
    }
   
    [self createTableView];
    self.searchTF = @"";
}
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/WaterEnvironment?action=1&method={siteTypeID:2}
//乡镇列表
- (void)sendTownshipListListSecondary {
//    NSDictionary *param ;

    self.urlStr =  F(@"%@/GetTownInfo",RequestURL);
    NSString *jgstr;
    if ([dataManger.tagString isEqualToString:@"2"]) {//河道水质
        self.siteTypeStr = @"2";
        jgstr = @"0";
    } else if ([dataManger.tagString isEqualToString:@"4"]){//农村生活污水
        self.siteTypeStr = @"6";
       jgstr = @"0";
    }  else if([dataManger.tagString isEqualToString:@"1"]) { //地表水
        self.siteTypeStr = @"1";
       jgstr = @"0";
    }else if([dataManger.tagString isEqualToString:@"50"]||[dataManger.tagString isEqualToString:@"51"]||[dataManger.tagString isEqualToString:@"52"]){
         self.siteTypeStr = @"6";
      jgstr = @"1";
    }
    NSDictionary * param = @{@"sitetypeid":_siteTypeStr ,@"dataflg":@"",@"videoflg":@"",@"isnwjg":jgstr};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"oneList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.model.StreetIDArr addObject:dic[@"ID"]];
                [self.model.StreetNameArr addObject:dic[@"DictName"]];
                [self.model.SiteCountArr addObject:dic[@"SiteCount"]];
            }
            if ([dataManger.tagString isEqualToString:@"2"]) {
                [self getVideoCount];
                return ;
            }
        }
        [CustomHUD dismiss];
        [self.tableView1 reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
      [self.tableView1 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self sendTownThreeListStation:self.model.StreetIDArr.firstObject];
        NSLog(@"乡镇列表 === %@----%@", result,self.model.StreetNameArr);
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        
        [CustomHUD dismiss];
    }];
}
//获取数据和视频站点的数量  （河道水质）
-(void)getVideoCount{
    [gs_HttpManager httpManagerPostParameter:@{@"sitetypeid":_siteTypeStr} toHttpUrlStr:F(@"%@/getSiteTypeByCount", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"oneList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.model.StreetIDArr addObject:dic[@"ID"]];
                [self.model.StreetNameArr addObject:@"视频站点"];
                [self.model.StreetNameArr addObject:@"数据站点"];
                [self.model.SiteCountArr addObject:dic[@"VideoCount"]];
                [self.model.SiteCountArr addObject:dic[@"DataCount"]];
                
            }
            
        }
        
        [self.tableView1 reloadData];
        [CustomHUD dismiss];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
         [self.tableView1 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self sendTownThreeListStation:self.model.StreetIDArr.firstObject];
        NSLog(@"乡镇列表 === %@----%@", result,self.model.StreetNameArr);
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
    
}
//河道水质获取视频数据站点 /河道曝气工程
-(void)getDataAndVideoByTownID:(NSString *)townid dataflag:(NSString *)dataFlag videoFlag:(NSString *)videoFlag riverid:(NSString *)riverid{
    self.model.SiteIDArr = nil;
    self.model.SiteNameArr = nil;
    self.model.HasDataFlgArr = nil;
    self.siteTyIDArray = nil;
    self.model.HasVideoFlagArr = nil;
//    self.JWArray = nil;
    NSDictionary *param = @{
                            @"riverid":riverid,
                            @"townid":townid,
                            @"hasvideoflg":videoFlag,
                            @"hasdataflg":dataFlag,
                            @"sitetypeid":self.siteTypeStr
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/getSiteInfoByRiverID", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"twoList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.model.SiteIDArr addObject:dic[@"ID"]];
                [self.model.SiteNameArr addObject:dic[@"SiteName"]];
                [self.model.HasDataFlgArr addObject:F(@"%@",dic[@"HasDataFlg"])];
                [self.model.HasVideoFlagArr addObject:F(@"%@",dic[@"HasVideoFlg"])];
                [self.siteTyIDArray addObject:F(@"%@", dic[@"SiteTypeID"])];
//                [self.JWArray addObject:F(@"%@,%@", F(@"%@", dic[@"SiteLon"]),F(@"%@", dic[@"SiteLat"]))];
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
//站点列表
- (void)sendTownThreeListStation:(NSString *)StreetID {
    self.model.SiteIDArr = nil;
    self.model.SiteNameArr = nil;
    self.model.HasDataFlgArr = nil;
    self.siteTyIDArray = nil;
    self.model.HasVideoFlagArr = nil;
    //河道水质
    NSDictionary *param;
    if ([dataManger.tagString isEqualToString:@"2"]) {
        self.siteTypeStr = @"2";
        self.urlStr = BaseWaterEnURLStr; //WaterEnvironment
        self.actionStr = @"2";
        param = @{
                  @"action":self.actionStr,
                  @"method":F(@"{siteTypeID:%@,townID:%@}",_siteTypeStr, StreetID),
                  };
        
    } else if ([dataManger.tagString isEqualToString:@"4"]){//农村生活污水
        
        self.actionStr = @"2";
        self.urlStr = BaseWaterEnURLStr;
        param = @{
                  @"action":self.actionStr,
                  @"method":F(@"{siteTypeID:%@,townID:%@,isnwjg:0}",_siteTypeStr, StreetID)
                  };
        
    }else if ([dataManger.tagString isEqualToString:@"1"]) { //地表水
        self.siteTypeStr = @"1";
        self.urlStr = BaseWaterEnURLStr;
        self.actionStr = @"2";
        param = @{
                  @"action":self.actionStr,
                  @"method":F(@"{siteTypeID:%@,townID:%@}",_siteTypeStr, StreetID),
                  };
    }else if([dataManger.tagString isEqualToString:@"50"]||[dataManger.tagString isEqualToString:@"51"]||[dataManger.tagString isEqualToString:@"52"]){
        self.actionStr = @"2";
        self.urlStr = BaseWaterEnURLStr;
        param = @{
                  @"action":self.actionStr,
                  @"method":F(@"{siteTypeID:%@,townID:%@,isnwjg:%@}",_siteTypeStr, StreetID,@"1"),
                  };
    }
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"twoList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            if ([dicData[@"Msg"] isEqualToString:@"成功"]) {
                for (NSDictionary *dic in dicData[@"Result"]) {
                    [self.model.SiteIDArr addObject:dic[@"SiteID"]];
                    [self.model.SiteNameArr addObject:dic[@"SiteName"]];
                    if ([dataManger.tagString isEqualToString:@"2"] || [dataManger.tagString isEqualToString:@"4"]|| [dataManger.tagString isEqualToString:@"50"]) {
                        [self.model.HasDataFlgArr addObject:F(@"%@",dic[@"HasDataFlg"])];
                        [self.model.HasVideoFlagArr addObject:F(@"%@",dic[@"HasVideoFlg"])];
                        
                    }
                    StationModel *stationmodel = [[StationModel alloc]init];
                    [stationmodel setValuesForKeysWithDictionary:dic];
                    [self.numberModelArray addObject:stationmodel];
                }
          
            } else {
                [YJProgressHUD showError:dicData[@"Msg"]];
            }
            
        }
        [CustomHUD dismiss];
        [self.tableView2 reloadData];
        
        NSLog(@"--列表 === %@", result);
    } orFail:^(NSError *error) {
        NSLog(@"列表%@", error);
        [CustomHUD dismiss];
    }];
}
//曝气河道
-(void)requestDataForBQRiver{
    [gs_HttpManager httpManagerPostParameter:@{@"sitetypeid":self.siteTypeStr} toHttpUrlStr:F(@"%@/GetRiverInfoBySiteType", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"twoList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.model.StreetIDArr addObject:F(@"%@",dic[@"RiverID"])];
                [self.model.StreetNameArr addObject:dic[@"RiverName"]];
                [self.model.SiteCountArr addObject:F(@"%@",dic[@"SiteCount"])];
            }
        }
        [CustomHUD dismiss];
        [self.tableView1 reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView1 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self getDataAndVideoByTownID:@"" dataflag:@"" videoFlag:@"" riverid:self.model.StreetIDArr.firstObject];
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
   
    _searchVC = [[SearchViewController alloc]init];
    
    [_searchVC sendTownThreeListStation:self.searchTF];

    [self.navigationController pushViewController:_searchVC animated:YES];

    
}

- (void)textFieldChangedSearch:(UITextField *)textField {
    self.searchTF = textField.text;
    NSLog(@"dvccccccccccccccccc=--------%@", self.searchTF);
}

#pragma mark - UITableViewDataSource UITableViewDelegate
-(void)createTableView{
    int h = NAVIHEIGHT+90;
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
        if(self.model.StreetNameArr.count > 0 ){
            cell.textLabel.text = F(@"%@ (%@)",self.model.StreetNameArr[indexPath.row],self.model.SiteCountArr[indexPath.row]);
        }
        //        cell.textLabel.text = self.model.StreetNameArr[indexPath.row];
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
            [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
            if ([dataManger.tagString isEqualToString:@"3"]||[dataManger.tagString isEqualToString:@"30"]||[dataManger.tagString isEqualToString:@"40"]) {
                //曝气工程
             [self getDataAndVideoByTownID:@"" dataflag:@"" videoFlag:@"" riverid:self.model.StreetIDArr[indexPath.row]];
               
            }else{
                if(indexPath.row == 0 ){
                    [self sendTownThreeListStation:self.model.StreetIDArr[indexPath.row]];
//                     [self getDataAndVideoByTownID:self.model.StreetIDArr.firstObject dataflag:@"" videoFlag:@"" riverid:@""];
                }else{
                    if(indexPath.row == 1){
                        [self getDataAndVideoByTownID:self.model.StreetIDArr.firstObject dataflag:@"" videoFlag:@"1" riverid:@""];
                    }else if (indexPath.row == 2){
                        [self getDataAndVideoByTownID:self.model.StreetIDArr.firstObject dataflag:@"1" videoFlag:@"" riverid:@""];
                    }
                    
                }
            }
        }

    } else if([tableView isEqual:self.tableView2]){
        NSString *titstr;
        NSString *siteIDStr;
        
        if (self.model.SiteNameArr.count > 0) {
            titstr = self.model.SiteNameArr[indexPath.row];
            siteIDStr = self.model.SiteIDArr[indexPath.row];
            dataManger.siteIDString = self.model.SiteIDArr[indexPath.row];
        }
        
        if ([dataManger.tagString isEqualToString:@"2"]||[dataManger.tagString isEqualToString:@"4"]|| [dataManger.tagString isEqualToString:@"1"]||[dataManger.tagString isEqualToString:@"50"]) {
            WaterENViewController *waterVC = [[WaterENViewController alloc]init];
            waterVC.title = titstr;
            waterVC.siteID = siteIDStr;
            if ([dataManger.tagString isEqualToString:@"2"] || [dataManger.tagString isEqualToString:@"4"] || [dataManger.tagString isEqualToString:@"50"]) {
                waterVC.dataFlags =  F(@"%@",self.model.HasDataFlgArr[indexPath.row]);
                waterVC.videoFlags = F(@"%@", self.model.HasVideoFlagArr[indexPath.row]);
            }
            [self.navigationController pushViewController:waterVC animated:YES];
        }else if ([dataManger.tagString isEqualToString:@"3"]||[dataManger.tagString isEqualToString:@"30"]||[dataManger.tagString isEqualToString:@"40"]){
            RiverProgramViewController *riverProVC = [[RiverProgramViewController alloc]init];
            riverProVC.title = titstr;
            dataManger.siteIDString = siteIDStr;
             dataManger.siteClassID = self.siteTyIDArray[indexPath.row];
            //            riverProVC.JWStr = self.JWArray[indexPath.row];
            [self.navigationController pushViewController:riverProVC animated:YES];
            
        }else if ([dataManger.tagString isEqualToString:@"51"]){
            ////视频中心
            SimpleDemoViewController *playVC = [[SimpleDemoViewController alloc]init];
            playVC.title = titstr;
            playVC.siteID = siteIDStr;
            playVC.view.frame = CGRectMake(0, 110, WT, HT-100);
            playVC.stationModel = self.numberModelArray[indexPath.row];
            [self.navigationController pushViewController:playVC animated:YES];
            
        }else if ([dataManger.tagString isEqualToString:@"52"]){
            HandInContentViewController *handle = [[HandInContentViewController alloc]init];
            handle.title = titstr;
            handle.stationModel = self.numberModelArray[indexPath.row];
            handle.siteID = siteIDStr;
            [self.navigationController pushViewController:handle animated:YES];
            
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
- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
