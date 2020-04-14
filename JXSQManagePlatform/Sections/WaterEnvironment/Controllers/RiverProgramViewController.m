//
//  RiverProgramViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/5.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverProgramViewController.h"
#import "WaterBaseTableViewCell.h"
#import "SimpleDemoViewController.h"
#import "WaterEnModel.h"
#import "OperatingModeViewController.h"
//#import "WorkingHistoryViewController.h"
#import "EquipmentMonitoringViewController.h"
@interface RiverProgramViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *datamanger;
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSArray<NSArray*> *cellTitleArray;

@property(nonatomic,strong)NSMutableArray *dataArray;
//@property(nonatomic,strong)NSMutableArray *dataArray1;
//@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray<NSMutableArray *> *dataArr;
//@property (nonatomic, strong) PlayerDemoViewController *playVC;
@property(nonatomic,strong)OperatingModeViewController *operatinVC;
//@property(nonatomic,strong)WorkingHistoryViewController *workHistory;
@property(nonatomic,strong) EquipmentMonitoringViewController *workHistory;
@end

@implementation RiverProgramViewController

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataArray;
}

-(NSMutableArray<NSMutableArray *> *)dataArr{
    
    if (!_dataArr) {
        
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cellTitleArray = [NSArray arrayWithObjects:@[@"站点名称:",@"终端编号:"],@[@"负责人:",@"联系电话:",@"管理部门:",@"所属乡镇:",@"所属河道:"],@[@"站点经度:",@"站点纬度:",@"站点位置:"], nil];
    
    datamanger = [DataSource sharedDataSource];
    
    [self createSegement];
  
    [self creteTableView];
    [self requestData];
   
}
-(void)addChildViewControllers{
    _operatinVC = [[OperatingModeViewController alloc]init];
    _operatinVC.siteID = datamanger.siteIDString;
    _operatinVC.view.frame = CGRectMake(0, 44+NAVIHEIGHT, WT, HT-34-NAVIHEIGHT);
    [self addChildViewController:_operatinVC];

}
-(void)addChileViewControllerForHistory{
    _workHistory = [[EquipmentMonitoringViewController alloc]init];
    _workHistory.SiteIDStr = datamanger.siteIDString;
    _workHistory.typeStr  = datamanger.siteClassID;
    _workHistory.view.frame = CGRectMake(0, 44+NAVIHEIGHT, WT, HT-34-NAVIHEIGHT);
    [self addChildViewController:_workHistory];
}
-(void)createSegement{
    NSArray *array ;
    if ([datamanger.tagString isEqualToString:@"3"]) {
        array= [NSArray arrayWithObjects:@"基本信息",@"站点工况", nil];
    }else{
         array= [NSArray arrayWithObjects:@"站点信息",@"设备监控", nil];
    }
   
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(WT/2.0 - 80, 2+NAVIHEIGHT, 160, 36);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont boldSystemFontOfSize:15],
                         NSFontAttributeName,nil];
    
    [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    segment.backgroundColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(HandleChanges:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = UIColorFromRGB(0x2ab1e7);
    [self.view addSubview: segment];
}
-(void)HandleChanges:(UISegmentedControl *)segemet{
    
    [_myTableView removeFromSuperview];
    [_operatinVC.view removeFromSuperview];
    [_operatinVC removeFromParentViewController];
    [_workHistory.view removeFromSuperview];
    [_workHistory removeFromParentViewController];
    switch (segemet.selectedSegmentIndex) {
        case 0: {
            //基本信息
            
            [self.view addSubview:_myTableView];
            
        }
         
            break;
        case 1: {
            
          
            //站点工况
          
            if ([datamanger.tagString isEqualToString:@"3"]) {
                   [self addChildViewControllers];
                  [self.view addSubview:self.operatinVC.view];
            }else{
                   [self addChileViewControllerForHistory];
                [self.view addSubview:self.workHistory.view];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}
-(void)creteTableView{
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT+4+36, WT, HT - 40-NAVIHEIGHT) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    [_myTableView registerNib:[UINib nibWithNibName:@"WaterBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"watercell"];
}
//基本信息
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/WaterEnvironment?action=3&method={siteTypeID:2,siteID:13}
- (void)requestData{
    NSMutableArray *dataArray0 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *dataArray1 = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *dataArray2 = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *param = @{
                            @"action":@"3",
                            @"method":F(@"{siteTypeID:%@,siteID:%@}", datamanger.siteClassID,datamanger.siteIDString),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/WaterEnvironment", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"rvier-line" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
            WaterEnModel *model = [[WaterEnModel alloc]init];
            [model setValuesForKeysWithDictionary:dicData[@"Result"]];
            
            [dataArray0 addObject:self.title];
            [dataArray0 addObject:model.SerialNo];
            [dataArray1 addObject:model.ResponsiblePerson];
            [dataArray1 addObject:model.Phone];
            [dataArray1 addObject:model.DeptName];
            [dataArray1 addObject:model.TownName];
            [dataArray1 addObject:model.RiverName];
//            NSString *location = F(@"%@,%@", model.SiteLat,model.SiteLong);
            
            [dataArray2 addObject:model.SiteLong];
            [dataArray2 addObject:model.SiteLat];
            [dataArray2 addObject:model.SiteAddress];
            
            [self.dataArr addObject:dataArray0];
            [self.dataArr addObject:dataArray1];
            [self.dataArr addObject:dataArray2];
        }
        [self.myTableView reloadData];
         NSLog(@"0000000000 -------%@", result);
        
        
    } orFail:^(NSError *error) {
        NSLog(@"1111111111 %@", error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellTitleArray[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cellTitleArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WaterBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"watercell"forIndexPath:indexPath];
    cell.titLable.text = _cellTitleArray[indexPath.section][indexPath.row];
    if (_dataArr.count > 0) {
        cell.ceontentLab.text = _dataArr[indexPath.section][indexPath.row];
    }

    return cell;
}
@end
