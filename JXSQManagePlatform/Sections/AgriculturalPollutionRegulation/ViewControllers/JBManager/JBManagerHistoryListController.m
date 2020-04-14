//
//  JBManagerHistoryListController.m
//  BGRuralDomesticWaste
//
//  Created by 吴坤 on 2017/8/28.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "JBManagerHistoryListController.h"
#import "StationModel.h"
#import "ComplainTableViewCell.h"
@interface JBManagerHistoryListController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *dataManger;
 
}
@property (nonatomic,strong) UITableView *tableView3;
@property(nonatomic,copy)NSString  *urlStr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation JBManagerHistoryListController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataManger = [DataSource sharedDataSource];
    if (KISIphoneX) {
        self.view.frame = CGRectMake(0, 51+NAVIHEIGHT+24, WT, HT-51-NAVIHEIGHT-24-10);
    } else {
        self.view.frame = CGRectMake(0, 51+NAVIHEIGHT, WT, HT-51-NAVIHEIGHT);
    }
    
    [self createtableView];
    [self readDataForRecord];
   
}
//获取交办记录
-(void)readDataForRecord{
    NSLog(@"%@",dataManger.UserID);
    self.dataArray = nil;
//    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    //数据列表;@{@"PushUserID":dataManger.UserID}
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:dataManger.UserID,@"PushUserID", dataManger.UserID,@"UserID",
                           @"",@"Authority", nil];
    self.urlStr = F(@"%@/PushInfo/List",BaseRequestUrl);
    
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"jmList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"status"]);
        
        if ([status isEqualToString:@"1"]&& [dicData[@"message"] isEqualToString:@"成功"]) {
            
            for (NSDictionary *dic in dicData[@"data"]) {
                StationModel *model = [[StationModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
//                NSLog(@"StreetName---%@",model.StreetName);
                
            }
            
        }
   
//        [CustomHUD dismiss];
     
        [self.tableView3 reloadData];
//       NSLog(@"_dataArray-------%@", _dataArray);
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
//        [CustomHUD dismiss];
   

    }];
    
    
}
-(void)createtableView{
    if (KISIphoneX) {
        _tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(0,0,WT, HT-51-NAVIHEIGHT-24-10)];
    } else {
        _tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(0,0,WT, HT-51-NAVIHEIGHT)];
    }
    
    _tableView3.delegate = self;
    _tableView3.dataSource = self;
    _tableView3.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView3.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
    [self.view addSubview:_tableView3];
    [self.tableView3 registerNib:[UINib nibWithNibName:@"ComplainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    ComplainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        StationModel *model = self.dataArray[indexPath.row];
        cell.riverNameLab.text = model.StreetName;
        cell.compStatusLab.text = [self getStatusValuesWithStatus:F(@"%@",model.PushStatus)];
        cell.titleLab.text  = model.SiteName;
        cell.timeLab.text = [[model.InsertDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
        cell.riverDistrict.text = [self getTypeWithTypeID:F(@"%@", model.AlarmType)];
        cell.contentLab.text = model.ErrContentList;
//        [self readDataWithCode:model.ErrCodeList lab:cell.contentLab];
        cell.alamTypeLab.text = @"预警类型";
        
    }
    
    
    
    
    return cell;
        
    
}
-(void)readDataWithCode:(NSString *)code lab:(UILabel *)lab{
    
//    NSLog(@"code--%@",code);
    self.urlStr = F(@"%@/ErrCode/Info",BaseRequestUrl);
    NSDictionary *param = @{@"ErrCode":code};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"errList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"status"]);
        
        if ([status isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dicData[@"data"]) {
                NSString *str =  F(@"%@",dic[@"ErrCotent"]);
                
                lab.text = [lab.text stringByAppendingFormat:@"%@ ",str];
//                NSLog(@"str--%@---%@",str,lab.text);
            }
            
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
    }else if([status isEqualToString:@"12"]){
         str = @"申请延期";
    }
    
    return str;
    
}
-(NSString *)getTypeWithTypeID:(NSString *)typeID{
    NSString *str;
    if ([typeID isEqualToString:@"1"]) {
        str = @"水流量异常";
    }else if([typeID isEqualToString:@"2"]){
        str = @"水质指标监测";
    }else if([typeID isEqualToString:@"3"]){
        str = @"动力设备运行";
    }else if([typeID isEqualToString:@"9"]){
        str = @"其他";
    }
    
    return str;
    
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
