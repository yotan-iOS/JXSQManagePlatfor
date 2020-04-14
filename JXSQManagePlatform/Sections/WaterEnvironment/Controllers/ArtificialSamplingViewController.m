//
//  ArtificialSamplingViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/20.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "ArtificialSamplingViewController.h"
#import "BaseIfonSearchViewController.h"
#import "TableViewCell1.h"
#import "WaterBaseTableViewCell.h"
#import "RiverListModel.h"
#import "PDFWebViewViewController.h"
@interface ArtificialSamplingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewTwo;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) BaseIfonSearchViewController *searchVC;
//@property (nonatomic, strong) NSArray<NSArray*> *baseTitleArray;
@property (nonatomic, strong) NSMutableArray *baseTitleArray;
@property (nonatomic, strong) NSMutableArray *listDataArr;
@property (nonatomic, strong) NSMutableArray *InformationDataArr;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, copy) NSString *photoURLStr;
@property (nonatomic, copy) NSString *PicNameStr;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic,strong)NSMutableArray *flagArray;
@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *FileNameArr;
@property (nonatomic, strong) NSMutableArray *FileUrlArr;

@end

@implementation ArtificialSamplingViewController
//河道基本信息
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
- (NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        self.sectionArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _sectionArr;
}
-(NSMutableArray *)flagArray{
    if (!_flagArray) {
        self.flagArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _flagArray;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//      self.baseTitleArray = [NSArray arrayWithObjects:@[@"河道名称:",@"所在镇村:"],@[@"河道起点:",@"河道终点:",@"河道长度:"],@[@"河长姓名:",@"河长电话:"], nil];
    self.baseTitleArray = [NSMutableArray arrayWithObjects:@"河道名称:",@"所在镇村:",@"河道起点:",@"河道终点:",@"河道长度:",@"河长姓名:",@"河长电话:", nil];
    _dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
 
    // Do any additional setup after loading the view from its nib.
    [self createSearhBut];
    [self createTableView];
    [self getDataForRivierClassLever];
}
// 获取河道等级
-(void)getDataForRivierClassLever{
    
    [gs_HttpManager httpManagerPostParameter:nil toHttpUrlStr:F(@"%@/GetRiverLevelCount", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"levercount" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                RiverListModel *listModel = [[RiverListModel alloc] initWithDic:dic];
                
                  [self.sectionArr addObject:listModel];
                  [self.flagArray addObject:@"0"];
//                [self sendRiverBaseInformationWithClass:F(@"%@",dic[@"RiverLevel"])];
                NSLog(@"RiverLevel---%@---",dic[@"RiverLevel"]);
                
            }
        }
        self.flagArray[0] = @"1";
        [self getAllRiverData];
        [CustomHUD dismiss];
       
        
        NSLog(@"河道基本信息列表=======---sectionArr==--=%@-----%@", result, ((RiverListModel *)self.sectionArr.firstObject).DictName);
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
        [CustomHUD dismiss];
    }];
    

}
//获取所有的河流的数据
-(void)getAllRiverData{
    
    NSDictionary *param = @{
                            @"RiverType":@"",@"RiverLevel":@""
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetALLRiverInfo", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"base" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                RiverListModel *listModel = [[RiverListModel alloc] initWithDic:dic];
                [self.dataArr addObject:listModel];
            }
            for (int i = 0; i < self.sectionArr.count; i++) {
                RiverListModel *lisModel = self.sectionArr[i];
                NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1];
                [self.listDataArr addObject:array2];
            for (RiverListModel *model in self.dataArr) {
                if ([F(@"%@", lisModel.RiverLevel) isEqualToString:F(@"%@", model.RiverLevel)]) {
                    [self.listDataArr[i] addObject:model];
                    
                }
            }
           
        }
        }
        [CustomHUD dismiss];
        [self.tableViewOne reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableViewOne selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        RiverListModel *model = self.listDataArr[0][0];
        [self sendDetailInformation:model.ID];
        NSLog(@"河道基本信息列表==listDataArr========%@", result);
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
        [CustomHUD dismiss];
    }];
    
}

//
//- (void)sendRiverBaseInformationWithClass:(NSString *)siteClass {
//    NSLog(@"----siteClass----%@",siteClass);
//    NSMutableArray *empty = [NSMutableArray arrayWithCapacity:1];
//    NSDictionary *param = @{
//                            @"RiverType":@"",@"RiverLevel":siteClass
//                            };
//    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetALLRiverInfo", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"base" success:^(id result) {
//        NSDictionary *dicData = result;
//        NSString *status = F(@"%@",dicData[@"Status"]);
//        if ([status isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
//            for (NSDictionary *dic in dicData[@"Data"]) {
//                RiverListModel *listModel = [[RiverListModel alloc] initWithDic:dic];
//                [empty addObject:listModel];
//            }
//            [self.dataDic setValue:empty forKey:siteClass];
//            [self.listDataArr addObject:empty];
//        }
//
//        [CustomHUD dismiss];
//
//        NSLog(@"河道基本信息列表==listDataArr========%@", result);
//    } orFail:^(NSError *error) {
//        NSLog(@"%@", error);
//[CustomHUD dismiss];
//    }];
//}
//区
-(void)configeSectionWithindex:(NSInteger)index{
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    UIImageView *imag = [self.view viewWithTag:1300+index];
    NSLog(@"dataDic---%@",self.dataDic.allKeys);
    NSArray *arr1;
    if (self.listDataArr.count > 0 ) {
       arr1  = self.listDataArr[index];
    }
    
    for (int i = 0; i < arr1.count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:index];
        [indexArray addObject:path];
    }
    if ([self.flagArray[index] isEqualToString:@"0"]) {
        
        self.flagArray[index]  = @"1";
       
//        [self.tableViewOne reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
      
//        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            imag.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
//        } completion:NULL];
        imag.image = [UIImage imageNamed:@"下边.png"];
        NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:index];//刷新第二个section
        [self.tableViewOne reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else{
        
        self.flagArray[index]  = @"0";
         imag.image = [UIImage imageNamed:@"右边.png"];
//            [self.tableViewOne reloadData];
//        [_tableViewOne reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
        /*---------------------------------------
         旋转箭头图标
         --------------------------------------- */
//        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            imag.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
//        } completion:NULL];
        NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:index];//刷新第二个section
        [self.tableViewOne reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
//基本信息
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
//                      self.PicNameStr = F(@"%@.pdf", dic[@"FileName"]);
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
        NSLog(@"%@", error);
        [CustomHUD dismiss];
    }];
}
-(void)createTableView{
    int h = NAVIHEIGHT+90;;
    _tableViewOne = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT/3.0, HT-h)];
    _tableViewOne.delegate = self;
    _tableViewOne.dataSource = self;
    _tableViewOne.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewOne.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [_tableViewOne registerClass:[TableViewCell1 class]  forCellReuseIdentifier:@"cell1"];
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
- (void)textFieldChangedSearch:(UITextField *)textField {
    NSLog(@"dvccccccccccccccccc=--------%@", textField.text);
}
-(void)searchAction:(UIButton *)sender{
//    [self.tableViewOne removeFromSuperview];
//    [self.tableViewTwo removeFromSuperview];
    _searchVC = [[BaseIfonSearchViewController alloc]init];
//    _searchVC.view.frame = CGRectMake(0, CGRectGetMaxY(_searchTF.frame)+20, WT, HT-CGRectGetMaxY(_searchTF.frame));
    [_searchVC sendTownListStation:self.searchTF.text];//调用搜索接口
//    [self addChildViewController:_searchVC];
//    [self.view addSubview:_searchVC.view];
    [self.navigationController pushViewController: _searchVC animated:YES];
    
    
}



#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableViewOne]) {
        NSArray *arr;
        if ( self.listDataArr.count > 0) {
            arr  = self.listDataArr[section];
        }
        return [_flagArray[section] integerValue] == 1 ? arr.count: 0;
    } else if([tableView isEqual:self.tableViewTwo]) {
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
//        return _baseTitleArray.count;
        return 2;
    }else if ([tableView isEqual:self.tableViewOne]){
        return _sectionArr.count;
        
    }
    return 0;
}
//返回行高
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
        
        return 40;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableViewTwo]) {
//        if (section == 0) {
            return 5;
//        } else {
//            return 50;
//        }
    }else if([tableView isEqual:self.tableViewOne]){
        return 5;
    }
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableViewTwo]) {
            UIView *heaerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewTwo.frame.size.width, 40)];
            heaerView.backgroundColor = UIColorFromRGB(0xF6F6F6);
            UILabel *heaLab = [[UILabel alloc] init];
            heaLab.frame = heaerView.frame;
            heaLab.backgroundColor = [UIColor clearColor];
        if (section == 0) {
            heaLab.text = @" 基本信息";
        } else {
            heaLab.text = @" 一河一策";
        }
        
            [heaerView addSubview:heaLab];
            return heaerView;
        
    }else if ([tableView isEqual:self.tableViewOne]){
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableViewOne.frame.size.width, 40)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *sectionLabe = [[UILabel alloc]initWithFrame:CGRectMake(self.tableViewOne.frame.size.width/5.0, 0,WT-self.tableViewOne.frame.size.width/5.0, 40)];
        sectionLabe.userInteractionEnabled = YES;
        if (self.sectionArr.count > 0) {
            RiverListModel *model = self.sectionArr[section];
            sectionLabe.text = F(@"%@ (%@)",F(@"%@", model.DictName),F(@"%@", model.RiverCount));
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        sectionLabe.tag = section + 1200;
        [sectionLabe addGestureRecognizer:tap];
        
        [header addSubview:sectionLabe];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.tableViewOne.frame.size.width/5.0-20, 12, 16, 16)];
        //the_arrow
        img.userInteractionEnabled = YES;
        if ([self.flagArray[section] isEqualToString:@"1"]) {
              img.image = [UIImage imageNamed:@"下边"];
        }else{
            img.image = [UIImage imageNamed:@"右边"];
        }
      
     
        img.tag = 1300+section;
        [header addSubview:img];
        
        
        return header;
    }
    return nil;
}
-(void)tapAction:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag - 1200;
    
    [self configeSectionWithindex:index];
   
  
   
    
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if ([tableView isEqual:self.tableViewTwo]) {
//        if (section == _baseTitleArray.count-1) {
//            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewTwo.frame.size.width, 100)];
//            footView.backgroundColor = [UIColor whiteColor];
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
//            [imgBtn setTitle:self.PicNameStr forState:UIControlStateNormal];
//            imgBtn.titleLabel.lineBreakMode = 0;
//            footView.backgroundColor = [UIColor whiteColor];
//            [footView addSubview:imgBtn];
//            [footView addSubview:foLabel];
//
//            return footView;
//        }else if ([tableView isEqual:self.tableViewOne]){
//            UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableViewOne.frame.size.width, 40)];
//            footer.backgroundColor = [UIColor whiteColor];
//            return footer;
//        }
//        return nil;
//    }
//    return nil;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewOne]) {
        
        TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        if (self.listDataArr.count > 0) {
            RiverListModel *model = self.listDataArr[indexPath.section][indexPath.row];
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
        
      return nil;
    }
    return nil;
}
//@"目标水质:"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewOne]) {
      
        if (self.listDataArr.count > 0) {
            [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
            RiverListModel *model = self.listDataArr[indexPath.section][indexPath.row];
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

- (void)imageClickBtn:(UIButton *)sender {
  
    if (self.photoURLStr.length > 0) {
    PDFWebViewViewController *webViewVC = [[PDFWebViewViewController alloc] init];
    webViewVC.urlStr = self.photoURLStr;
    webViewVC.TitleStr = self.PicNameStr;
    [self presentViewController:webViewVC animated:YES completion:nil];
    }
}
@end
