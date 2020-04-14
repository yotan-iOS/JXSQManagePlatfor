//
//  BaseIfonSearchViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/23.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "BaseIfonSearchViewController.h"
#import "TableViewCell1.h"
#import "WaterBaseTableViewCell.h"
#import "RiverListModel.h"
#import "PDFWebViewViewController.h"
#define KW [UIScreen mainScreen].bounds.size.width
#define KH [UIScreen mainScreen].bounds.size.height
@interface BaseIfonSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewTwo;
@property (nonatomic, strong) UITextField *searchTF;
//@property (nonatomic, strong) NSArray<NSArray*> *baseTitleArray;
@property (nonatomic, strong) NSMutableArray *baseTitleArray;
@property (nonatomic, strong) NSMutableArray *listDataArr;
@property (nonatomic, strong) NSMutableArray *InformationDataArr;

@property (nonatomic, copy) NSString *photoURLStr;
@property (nonatomic, copy) NSString *PicNameStr;

@property (nonatomic, strong) NSMutableArray *FileNameArr;
@property (nonatomic, strong) NSMutableArray *FileUrlArr;

@end

@implementation BaseIfonSearchViewController
- (NSMutableArray *)FileNameArr {
    if (!_FileNameArr) {
        self.FileNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _FileNameArr;
}
- (NSMutableArray *)FileUrlArr {
    if (!_FileUrlArr) {
        self.FileUrlArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _FileUrlArr;
}

- (NSMutableArray *)listDataArr {
    if (!_listDataArr) {
        self.listDataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _listDataArr;
}
- (NSMutableArray *)InformationDataArr {
    if (!_InformationDataArr) {
        self.InformationDataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _InformationDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
      // Do any additional setup after loading the view from its nib
    self.title = @"河道搜索";
    [self createTableView];
    [self createSearhBut];
    if (@available(iOS 11.0, *)) {
        self.tableViewOne.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
- (void)createSearhBut{
    int h = NAVIHEIGHT+20;
    _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(20, h, WT-90, 30 + 20)];
    _searchTF.layer.borderColor = UIColorFromRGB(0x3FB3E6).CGColor;
    _searchTF.layer.borderWidth = 2;
    _searchTF.backgroundColor = [UIColor whiteColor];
    _searchTF.placeholder = @" 请输入你想要搜索的站点名";
   [_searchTF setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
//    _searchTF.textAlignment = NSTextAlignmentCenter;
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchTF addTarget:self action:@selector(textFieldChangedSearch:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchTF];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(WT -70, h, 50 + 10, 30 + 20)];
    [but setTitle:@"搜索" forState:UIControlStateNormal];
    
    but.backgroundColor = UIColorFromRGB(0x3FB3E6);
    [but addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0,h+50 + 20-1 ,WT, 1)];
    line0.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line0];
}

- (void)textFieldChangedSearch:(UITextField *)textField {
    NSLog(@"dvccccccccccccccccc=--------%@", textField.text);
}
-(void)searchAction:(UIButton *)sender{
    [self sendTownListStation:self.searchTF.text];//调用搜索接口
    
}
//列表的搜索
- (void)sendTownListStation:(NSString *)keyboardStr {
    self.listDataArr = nil;
    self.InformationDataArr = nil;
     [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:keyboardStr,@"RiverName", nil];
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetRiverInfoByRiverName", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"information" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                RiverListModel *listModel = [[RiverListModel alloc] initWithDic:dic];
                [self.listDataArr addObject:listModel];

            }
        }else{
            
        [YJProgressHUD showError:@"无匹配内容"];
    
        }
        [CustomHUD dismiss];
        [self.tableViewOne reloadData];
        NSLog(@"河道信息信息信息==========%@", result);
    } orFail:^(NSError *error) {
        [CustomHUD dismiss];
        NSLog(@"%@", error);
    }];
}

-(void)createTableView{
    int h = NAVIHEIGHT+90;
    _tableViewOne = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT/3.0, HT-h)];
    _tableViewOne.delegate = self;
    _tableViewOne.dataSource = self;
    _tableViewOne.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewOne.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [_tableViewOne registerNib:[UINib nibWithNibName:@"TableViewCell1" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:_tableViewOne];
    
    _tableViewTwo = [[UITableView alloc]initWithFrame:CGRectMake((WT/3.0),h,2*WT/3.0 , HT-h)];
    _tableViewTwo.delegate = self;
    _tableViewTwo.dataSource = self;
    _tableViewTwo.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewTwo.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [_tableViewTwo registerNib:[UINib nibWithNibName:@"WaterBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"baseCell"];
    [self.view addSubview:_tableViewTwo];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WT/3.0, h,1, HT-h)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableViewOne]) {
        return self.listDataArr.count;
    } else if([tableView isEqual:self.tableViewTwo]) {
//        return _baseTitleArray[section].count;
        if (section == 0) {
            return _baseTitleArray.count;
        } else {
            return _FileNameArr.count;
        }
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([tableView isEqual:self.tableViewTwo]) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewOne]) {
        return 40;
    } else if ([tableView isEqual:self.tableViewTwo]) {
        return 45;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([tableView isEqual:self.tableViewTwo]) {
//        if (section == 0) {
            return 40;
//        } else {
//            return 5;
//        }
    } else {
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == _baseTitleArray.count-1) {
//        return 150;
//    } else {
//        return 0.1;
//    }
    return 5;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableViewTwo]) {
//        if (section == 0) {
            UIView *heaerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewTwo.frame.size.width, 40)];
            heaerView.backgroundColor = UIColorFromRGB(0xF6F6F6);
            UILabel *heaLab = [[UILabel alloc] init];
            heaLab.frame = heaerView.frame;
            heaLab.backgroundColor = [UIColor clearColor];
//            heaLab.text = @" 基本信息";
        if (section == 0) {
            heaLab.text = @" 基本信息";
        } else {
            heaLab.text = @" 一河一策";
        }
            [heaerView addSubview:heaLab];
            return heaerView;
//        }
//        return nil;
    }
    return nil;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if ([tableView isEqual:self.tableViewTwo]) {
//        if (section == _baseTitleArray.count-1) {
//            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewTwo.frame.size.width, 100)];
//            //            footView.backgroundColor = UIColorFromRGB(0xF6F6F6);
//            UILabel *foLabel = [[UILabel alloc] init];
//            foLabel.frame = CGRectMake(0, 0, self.tableViewTwo.frame.size.width, 40);
//            foLabel.backgroundColor = UIColorFromRGB(0xF6F6F6);
//            foLabel.text = @" 一河一策";
//
//            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            imgBtn.frame = CGRectMake(20, CGRectGetMaxY(foLabel.frame), self.tableViewTwo.frame.size.width-30, 50);
//            [imgBtn addTarget:self action:@selector(imageClickBtn:) forControlEvents:UIControlEventTouchDown];
//            [imgBtn setTitleColor:UIColorFromRGB(0x3E81CB) forState:UIControlStateNormal];
//            //            imgBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//            imgBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//            imgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            [imgBtn setTitle: self.PicNameStr forState:UIControlStateNormal];
//            imgBtn.titleLabel.lineBreakMode = 0;
//            [footView addSubview:imgBtn];
//            [footView addSubview:foLabel];
//            footView.backgroundColor = [UIColor whiteColor];
//            return footView;
//        }
//        return nil;
//    }
//    return nil;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewOne]) {
        TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"forIndexPath:indexPath];
        if (self.listDataArr.count > 0) {
            RiverListModel *model = self.listDataArr[indexPath.row];
            cell.textLabel.text = model.RiverName;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        
    } else if ([tableView isEqual:self.tableViewTwo]){
        if (indexPath.section == 0) {
            WaterBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell"forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row==self.InformationDataArr.count-1) {
                cell.titLable.textColor = [UIColor redColor];
                cell.ceontentLab.textColor = [UIColor redColor];
            }
            cell.titLable.text = _baseTitleArray[indexPath.row];
            cell.ceontentLab.adjustsFontSizeToFitWidth = YES;
            if (_InformationDataArr.count > 0) {
                cell.ceontentLab.text = self.InformationDataArr[indexPath.row];
            }
            return cell;
        } else {
            ReportOneTableViewCell *cell = [ReportOneTableViewCell ReportOneTableViewCell:self.tableViewTwo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labTitle.font = [UIFont systemFontOfSize:15];
            cell.labTitle.text = F(@"   %@", self.FileNameArr[indexPath.row]);
            cell.labTitle.numberOfLines = 0;
            cell.labTitle.textColor = UIColorFromRGB(0x3E81CB);
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewOne]) {
        self.baseTitleArray = [NSMutableArray arrayWithObjects:@"河道名称:",@"所在镇村:",@"河道起点:",@"河道终点:",@"河道长度:",@"河长姓名:",@"河长电话:", nil];
        if (self.listDataArr.count > 0) {
            [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
            RiverListModel *model = self.listDataArr[indexPath.row];
            [self sendDetailInformation:model.ID];
        }
        
    }else if ([tableView isEqual:self.tableViewTwo]){
        if (indexPath.section == 0) {
            //            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.InformationDataArr[indexPath.section][indexPath.row]];
            //            UIWebView *callWebview = [[UIWebView alloc]init];
            //            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            //            [self.view addSubview:callWebview];
            if (indexPath.row==self.InformationDataArr.count-1) {
                NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.InformationDataArr[indexPath.row]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        } else {
            PDFWebViewViewController *webViewVC = [[PDFWebViewViewController alloc] init];
            webViewVC.urlStr = F(@"%@", self.FileUrlArr[indexPath.row]);
            webViewVC.TitleStr = F(@"%@", self.FileNameArr[indexPath.row]);
            [self presentViewController:webViewVC animated:YES completion:nil];
        }
    }
    
}

//信息
- (void)sendDetailInformation:(NSString *)RiverID {
    [self.InformationDataArr removeAllObjects];
    [self.FileUrlArr removeAllObjects];
    [self.FileNameArr removeAllObjects];
    
//    NSMutableArray *dataArray0 = [NSMutableArray arrayWithCapacity:1];
//    NSMutableArray *dataArray1 = [NSMutableArray arrayWithCapacity:1];
//    NSMutableArray *dataArray2 = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *param = @{
                            @"RiverID":RiverID
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetRiverInfoByID", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"information" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
//                self.photoURLStr = F(@"%@", dic[@"FileUrl"]);
//                if (self.photoURLStr.length > 0) {
//                     self.PicNameStr  = F(@"%@.pdf",dic[@"FileName"]);
//                }else{
//                    self.PicNameStr = @"暂无";
//                }
                for (NSDictionary *fileDic in dic[@"RiverPolicy"]) {
                    [self.FileUrlArr addObject:fileDic[@"FileUrl"]];
                    [self.FileNameArr addObject:fileDic[@"FileName"]];
                }
                
                RiverListModel *listModel = [[RiverListModel alloc] initWithDic:dic];
                if (![dic[@"RiverName"] isEqual:[NSNull null]]) {
                    [self.InformationDataArr addObject:listModel.RiverName];
                } else {
                    [self.InformationDataArr addObject:@""];
                }
//                if (![dic[@"WaterTypeName"] isEqual:[NSNull null]]) {
//                    [dataArray0 addObject:listModel.WaterTypeName];
//                } else {
//                    [dataArray0 addObject:@""];
//                }
                if (![dic[@"FlowTown"] isEqual:[NSNull null]]) {
                    [self.InformationDataArr addObject:listModel.FlowTown];//所在镇村
                } else {
                    [self.InformationDataArr addObject:@""];
                }
                
                if (![dic[@"RiverStartPoint"] isEqual:[NSNull null]]) {
                    [self.InformationDataArr addObject:listModel.RiverStartPoint];
                } else {
                    [self.InformationDataArr addObject:@""];
                }
                if (![dic[@"RiverEndPoint"] isEqual:[NSNull null]]) {
                    [self.InformationDataArr addObject:listModel.RiverEndPoint];
                } else {
                    [self.InformationDataArr addObject:@""];
                }
                if (![dic[@"RiverLength"] isEqual:[NSNull null]]) {
                    [self.InformationDataArr addObject:F(@"%@ km", listModel.RiverLength)];
                } else {
                    [self.InformationDataArr addObject:@""];
                }
                
                
                if (![dic[@"RiverLongName"] isEqual:[NSNull null]]) {
                    [self.InformationDataArr addObject:listModel.RiverLongName];
                } else {
                    [self.InformationDataArr addObject:@""];
                }
                
                if (![dic[@"RiverLongPhone"] isEqual:[NSNull null]]) {
                    [self.InformationDataArr addObject:listModel.RiverLongPhone];
                } else {
                    [self.InformationDataArr addObject:@""];
                }
                
                
//                [self.InformationDataArr addObject:dataArray0];
//                [self.InformationDataArr addObject:dataArray1];
//                [self.InformationDataArr addObject:dataArray2];
            }
        }
        [CustomHUD dismiss];
        [self.tableViewTwo reloadData];
        NSLog(@"河道信息信息信息==========%@", result);
    } orFail:^(NSError *error) {
        [CustomHUD dismiss];
        NSLog(@"%@", error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)imageClickBtn:(UIButton *)sender {
    if (self.photoURLStr.length > 0) {
        PDFWebViewViewController *webViewVC = [[PDFWebViewViewController alloc] init];
        webViewVC.urlStr = self.photoURLStr;
        webViewVC.TitleStr = self.PicNameStr;
        [self presentViewController:webViewVC animated:YES completion:nil];
    }
  
}

@end
