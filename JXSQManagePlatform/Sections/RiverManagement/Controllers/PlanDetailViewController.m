//
//  PlanDetailViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/18.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "PlanDetailViewController.h"
#import "PlanDetailTableViewCell.h"
#import "ProjectModel.h"
@interface PlanDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *dataManger;
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property(nonatomic,assign)CGFloat wt;


@end

@implementation PlanDetailViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.title = @"重点项目进度";
    if (WT > 414) {
        _wt = WT;
    }else{
        _wt = 1.3*WT;
    }
    [self createTableView];
    [self getData];
}

-(void)getData{
    [CustomHUD showIndicatorWithStatus:@"努力加载中"];
    [gs_HttpManager httpManagerPostParameter:[NSDictionary dictionaryWithObjectsAndKeys:self.planIDStr,@"PlanID", nil] toHttpUrlStr:F(@"%@/GetProjectFinishByID",BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"plantList" success:^(id result) {
        NSDictionary *dicData = result[@"Data"];
        if ([result[@"Status"] isEqualToString:@"OK"]&&[result[@"Msg"] isEqualToString:@"成功"]) {
            NSDictionary *planDic = dicData[@"ProjectPlan"];
            
            self.projectNameLab.text =  F(@"%@",planDic[@"ProjectName"]);
             self.planIDLab.text = planDic[@"PlanNo"];
             self.contentlab.text = planDic[@"Commont"];
             self.MoneyLab.text = F(@"%@(万元)",planDic[@"Investment"]);
             self.yearLab.text = [F(@"%@",planDic[@"PlanType"]) integerValue] == 1 ? F(@"%@年",planDic[@"Year"]):@"一";
             self.monthLab.text = [F(@"%@",planDic[@"PlanType"]) integerValue] == 0 ?  F(@"%@月",planDic[@"Month"]):@"一";
            self.planTypeLab.text = [F(@"%@",planDic[@"PlanType"]) integerValue] ==1 ? @"年计划":@"月计划";
                
            for (NSDictionary *dic in dicData[@"ProjectFinish"]) {
                ProjectModel *model = [[ProjectModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
        }
        [CustomHUD dismiss];
        [self.tableView1 reloadData];
        NSLog(@"plan列表 === %@", result);
      
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
    
    
    
}

#pragma mark - UITableViewDataSource UITableViewDelegate
-(void)createTableView{
 
    UIScrollView *scrollew = [[UIScrollView alloc]initWithFrame:CGRectMake(0,NAVIHEIGHT+160, WT, HT-NAVIHEIGHT-160)];
    scrollew.contentSize = CGSizeMake(_wt, HT-NAVIHEIGHT-160);
    [self.view addSubview:scrollew];
    
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _wt, HT-160-NAVIHEIGHT)];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView1.rowHeight = UITableViewAutomaticDimension;
    _tableView1.estimatedRowHeight = 60;
    _tableView1.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    self.tableHeaderView.frame = CGRectMake(0, NAVIHEIGHT,WT, 160);
   [self.view addSubview: self.tableHeaderView];
    
    [scrollew addSubview:_tableView1];
    for (int i = 0; i < 14; i++) {
        UILabel *lab = [self.tableHeaderView viewWithTag:400+i];
        lab.layer.borderWidth = 0.5f;
        lab.layer.borderColor = UIColorFromRGB(0xF5F4F5).CGColor;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return  self.dataArray.count;
   
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//        return 40;
//   
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
        self.headerView.frame = CGRectMake(0, 0, self.tableView1.frame.size.width, self.tableView1.frame.size.height);
        self.headerView.backgroundColor =  UIColorFromRGB(0xF6F6F6);;
        return self.headerView;
        

  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
       static NSString *identfy = @"cellplan";
        PlanDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PlanDetailTableViewCell" owner:self options:nil]lastObject];
        }
        
        if (self.dataArray.count > 0) {
            ProjectModel *model = self.dataArray[indexPath.row];
            cell.ProgressIDLab.text =  F(@"%@",model.ID);
            cell.handleName.text = model.RealName;
            cell.handleDateLab.text = model.ReportDate;
            cell.progressContentLab.text = model.Comment;
            cell.progressLab.text = model.Progress;
            cell.moneyLab.text =  F(@"%@(万元)",model.CompleteInvestment);
            
        }
        
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
 
    
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
