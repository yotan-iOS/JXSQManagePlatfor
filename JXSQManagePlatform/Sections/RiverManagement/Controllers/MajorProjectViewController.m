//
//  MajorProjectViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/18.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "MajorProjectViewController.h"
#import "MajorProjectTableViewCell.h"
#import "PlanDetailViewController.h"
#import "ProjectModel.h"
#import "MajorTableViewCell.h"
@interface MajorProjectViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *dataManger;
}
@property (nonatomic,copy) NSString *mdata;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIView *headerView;


@end

@implementation MajorProjectViewController
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    [self getData];
}

-(void)getData{
    [CustomHUD showIndicatorWithStatus:@"努力加载中"];
    [gs_HttpManager httpManagerPostParameter:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"ProjectID", nil] toHttpUrlStr:F(@"%@/getKProject",BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"projectList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                ProjectModel *model = [[ProjectModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.sectionArray addObject:model];
            }
            
        }
        [CustomHUD dismiss];
        [self.tableView1 reloadData];
        NSLog(@"列表 === %@", result);
        
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
  
    
    
}
//站点列表
- (void)sendTownThreeListStation:(NSString *)ProjectID {
     [CustomHUD showIndicatorWithStatus:@"努力加载中"];
    NSDictionary *param = @{@"ProjectID":ProjectID};
    
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetProjectPlanByProjectID",BaseRequestUrl)  isCacheorNot:NO targetViewController:self andUrlFunctionName:@"prowoList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                ProjectModel *model = [[ProjectModel alloc]init];
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

#pragma mark - UITableViewDataSource UITableViewDelegate
-(void)createTableView{
    int h = NAVIHEIGHT;
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT*0.3, HT-h)];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.dataSource = self;
    _tableView1.estimatedRowHeight = 60;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView1.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.view addSubview:_tableView1];
    
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake((WT*0.3),h,WT*0.7 , HT-h)];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView1.dataSource = self;
    _tableView1.estimatedRowHeight = 60;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView2.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
    [self.view addSubview:_tableView2];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WT*0.3, h,1, HT-h)];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([tableView isEqual:self.tableView1]) {
//        return 55;
//    } else if ([tableView isEqual:self.tableView2]) {
//        return 40;
//    }
//    return 0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView1]) {
        UILabel *Lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView1.frame.size.width, self.tableView1.frame.size.height)];
        Lab.text = @"项目列表";
        Lab.font = [UIFont systemFontOfSize:15];
        Lab.textAlignment = NSTextAlignmentCenter;
        Lab.backgroundColor = UIColorFromRGB(0xF6F6F6);
        return Lab;
    }else if([tableView isEqual:self.tableView2]){
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView2.frame.size.width, self.tableView2.frame.size.height);
        self.headerView.backgroundColor =  UIColorFromRGB(0xF6F6F6);;
        return self.headerView;
        
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView1]) {
        static NSString *identfy = @"cell1";
    
        MajorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MajorTableViewCell" owner:self options:nil]lastObject];
        }
        if (self.sectionArray.count > 0) {
            ProjectModel *model = self.sectionArray[indexPath.row];
             cell.titLab.text  = F(@"%@",model.ProjectName);
        }
       

        return cell;
        
    }else if ([tableView isEqual:self.tableView2]){
        static NSString *identfy = @"cell2";
        MajorProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MajorProjectTableViewCell" owner:self options:nil]lastObject];
        }
     
        if (self.dataArray.count > 0) {
            ProjectModel *model = self.dataArray[indexPath.row];
            cell.planIDLab.text = F(@"%@", model.PlanNo);
            if ([F(@"%@", model.PlanType) isEqualToString:@"1"]) {
                cell.planTypeLab.text = @"年计划";
                cell.yearLab.text = F(@"%@年", model.Year);
                cell.monthLab.text = @"一";
            }else{
                cell.planTypeLab.text = @"月计划";
                cell.monthLab.text = F(@"%@月", model.Month);
                 cell.yearLab.text = @"一";
            }
            
        }
        
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView1]) {
        self.dataArray = nil;
        if (self.sectionArray.count  > 0) {
            ProjectModel *model = self.sectionArray[indexPath.row];
            [self sendTownThreeListStation:model.ProjectID];
        }
        
    } else if ([tableView isEqual:self.tableView2]) {
        PlanDetailViewController *plan = [[PlanDetailViewController alloc]init];
        ProjectModel *model = self.dataArray[indexPath.row];
        plan.planIDStr = F(@"%@",model.ID);
        plan.title = model.ProjectName;
        [self.navigationController pushViewController:plan animated:YES];
    
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
