//
//  WaterENViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/4.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "WaterENViewController.h"
#import "WaterBaseTableViewCell.h"
#import "RealTimeDataViewController.h"
#import "WaterEnModel.h"
#import "SimpleDemoViewController.h"
@interface WaterENViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *datamanger;
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSArray<NSArray*> *cellTitleArray;
@property(nonatomic,strong)RealTimeDataViewController *realTimeVc;
@property(nonatomic,strong) SimpleDemoViewController *playVC;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray<NSMutableArray *> *dataArr;
@end

@implementation WaterENViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (NSMutableArray<NSMutableArray *> *)dataArr{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.view.backgroundColor = [UIColor whiteColor];
    self.cellTitleArray = [NSArray arrayWithObjects:@[@"站点名称:",@"终端编号:"],@[@"负责人:",@"联系电话:",@"管理部门:",@"所属乡镇:",@"所属河道:"],@[@"站点经度:",@"站点纬度:",@"站点位置:"], nil];
    
    datamanger = [DataSource sharedDataSource];
    
    [self createSegement];
    
    [self creteTableView];
    [self requestData];
}
- (void)createSegement {
    NSArray *array;
    if ([datamanger.tagString isEqualToString:@"1"]) {
        array = [NSArray arrayWithObjects:@"基本信息",@"实时数据", nil];
    } else {
        if ([_dataFlags isEqualToString:@"1"]&&[_videoFlags isEqualToString:@"1"]) {
              array = [NSArray arrayWithObjects:@"基本信息",@"实时数据",@"视频中心", nil];
        }else if(![_dataFlags isEqualToString:@"1"]&&[_videoFlags isEqualToString:@"1"]){
            array = [NSArray arrayWithObjects:@"基本信息",@"视频中心", nil];
        }else if ([_dataFlags isEqualToString:@"1"]&&![_videoFlags isEqualToString:@"1"]){
             array = [NSArray arrayWithObjects:@"基本信息",@"实时数据", nil];
        }else{
            
        }
      
    }
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(WT/2.0 - 150, 2+NAVIHEIGHT, 300, 36);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont boldSystemFontOfSize:15],
                         NSFontAttributeName,nil];
    
    [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    segment.backgroundColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(HandleChanges:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = UIColorFromRGB(0x2ab1e7);
    [self.view addSubview: segment];
}
- (void)HandleChanges:(UISegmentedControl *)segemet {
    if ([datamanger.tagString isEqualToString:@"1"]) {
        [_myTableView removeFromSuperview];
        [_realTimeVc.view removeFromSuperview];
        [_realTimeVc removeFromParentViewController];
        switch (segemet.selectedSegmentIndex) {
            case 0:
            {
                //基本信息
                
                [self.view addSubview:_myTableView];
                
            }
                break;
            case 1:
            {
                //实时数据
                
                _realTimeVc = [[RealTimeDataViewController alloc]init];
                [self addChildViewController:_realTimeVc];
                _realTimeVc.siteID = _siteID;
                [self.view addSubview:self.realTimeVc.view];
                
            }
                break;
                
            default:
                break;
        }
        
    } else {
        [_myTableView removeFromSuperview];
        [_realTimeVc.view removeFromSuperview];
        [_playVC.view removeFromSuperview];
        [_playVC removeFromParentViewController];
        [_realTimeVc removeFromParentViewController];
        //有视频和数据的
        if ([_dataFlags isEqualToString:@"1"]&&[_videoFlags isEqualToString:@"1"]) {
            switch (segemet.selectedSegmentIndex) {
                case 0:
                {
                    //基本信息
                    
                    [self.view addSubview:_myTableView];
                    
                }
                    break;
                case 1:
                {
                    //实时数据
                    _realTimeVc = [[RealTimeDataViewController alloc]init];
                    [self addChildViewController:_realTimeVc];
                    _realTimeVc.siteID = _siteID;
                    
                    [self.view addSubview:self.realTimeVc.view];
                }
                    break;
                    
                    
                default:
                {//视频中心
                    _playVC = [[SimpleDemoViewController alloc]init];
                    _playVC.siteID = _siteID;
                    _playVC.view.frame = CGRectMake(0, 110, WT, HT-100);
                    [self addChildViewController:_playVC];
                    [self.view addSubview:self.playVC.view];
                }
                    break;
            }
  
        }else if(![_dataFlags isEqualToString:@"1"]&&[_videoFlags isEqualToString:@"1"]){//有视频没有数据
            //无数据
            switch (segemet.selectedSegmentIndex) {
                case 0:
                {
                    //基本信息
                    
                    [self.view addSubview:_myTableView];
                    
                }
                    break;
                case 1:
                {
                    ////视频中心
                    
                    _playVC = [[SimpleDemoViewController alloc]init];
                    _playVC.siteID = _siteID;
                    _playVC.view.frame = CGRectMake(0, 110, WT, HT-100);
                    [self addChildViewController:_playVC];
                    
                    [self.view addSubview:self.playVC.view];
                    
                }
                    break;
                    
                default:
                    break;
            }

        }else if ([_dataFlags isEqualToString:@"1"]&&![_videoFlags isEqualToString:@"1"]){//有数据没视屏
            switch (segemet.selectedSegmentIndex) {
                case 0:
                {
                    //基本信息
                    [self.view addSubview:_myTableView];
                }
                    break;
                case 1:
                {
                    //实时数据
                    _realTimeVc = [[RealTimeDataViewController alloc]init];
                    [self addChildViewController:_realTimeVc];
                    _realTimeVc.siteID = _siteID;
                    [self.view addSubview:self.realTimeVc.view];
                }
                    break;
                default:
                    break;
            }
        }
       
    }
}
- (void)creteTableView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT+4+36, WT, HT - 40-NAVIHEIGHT) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    [_myTableView registerNib:[UINib nibWithNibName:@"WaterBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"watercell"];
}
//基本信息
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/WaterEnvironment?action=3&method={siteTypeID:2,siteID:21}
-(void)requestData{
    NSLog(@"datamanger.siteIDString---%@,%@",datamanger.siteClassID,datamanger.siteIDString);
    NSMutableArray *dataArray0 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *dataArray1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *dataArray2 = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *param = @{
                            @"action":@"3",
                            @"method":F(@"{siteTypeID:%@,siteID:%@}", datamanger.siteClassID,datamanger.siteIDString),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseWaterEnURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"on-line" success:^(id result) {
        
        NSDictionary *dicData = result;
        if (![dicData[@"Status"] isKindOfClass:[NSNull class]] ) {
            if ([dicData[@"Status"] isEqualToString:@"OK"]) {
                WaterEnModel *model = [[WaterEnModel alloc]init];
                [model setValuesForKeysWithDictionary:dicData[@"Result"]];
                
                [dataArray0 addObject:self.title];
                [dataArray0 addObject:model.SerialNo];
                [dataArray1 addObject:model.ResponsiblePerson];
                [dataArray1 addObject:model.Phone];
                [dataArray1 addObject:model.DeptName];
                [dataArray1 addObject:model.TownName];
                [dataArray1 addObject:model.RiverName];
                
//                if (model.SiteLong.length > 0 && model.SiteLat.length > 0) {
//                    NSString *location = F(@"%@,%@  (经度,纬度)", model.SiteLong,model.SiteLat);
//                    [dataArray2 addObject:location];
//                }
                
                [dataArray2 addObject:model.SiteLong];
                [dataArray2 addObject:model.SiteLat];
                [dataArray2 addObject:model.SiteAddress];
                
                [self.dataArr addObject:dataArray0];
                [self.dataArr addObject:dataArray1];
                [self.dataArr addObject:dataArray2];
            } 
        }
  
        
        
        
        [self.myTableView reloadData];
        
        
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr[section].count > 0) {
        return _dataArr[section].count;
    } else {
        return _cellTitleArray[section].count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArr.count > 0) {
        return _dataArr.count;
    } else {
        return _cellTitleArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    WaterBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"watercell"forIndexPath:indexPath];
    cell.titLable.text = _cellTitleArray[indexPath.section][indexPath.row];
    if (_dataArr.count > 0) {
       cell.ceontentLab.text = _dataArr[indexPath.section][indexPath.row];
    } else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.ceontentLab.text = self.title;
        }
        
    }
    
    return cell;
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
