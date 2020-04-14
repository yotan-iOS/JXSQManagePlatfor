//
//  RiverTaskDetailViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/5.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverTaskDetailViewController.h"
#import "TaskDetailTableViewCell.h"
#import "TaskDetailModle.h"
#import "RiverHandleInViewController.h"
@interface RiverTaskDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *datamanger;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSArray *titArray;

@property(nonatomic,strong)NSMutableArray<NSMutableArray *> *datasource;
@end

@implementation RiverTaskDetailViewController

-(NSMutableArray<NSMutableArray *> *)datasource{
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:1];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    datamanger = [DataSource sharedDataSource];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titArray = @[@"记录标号:",@"交办问题:",@"交办期限:",@"交办时间:"];
    [_myTableView registerNib:[UINib nibWithNibName:@"TaskDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    [self requestData];
}
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/RiverManagement?action=16&method={siteID:10,status:1}
-(void)requestData{
    NSDictionary *param = @{
                            @"action":@"16",
                            @"method":F(@"{siteID:%@,status:%@,userID:%@,recordID:%@}",self.siteIDstr,self.status,datamanger.UserID,self.recodeID)
                            };
   
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseRiverMURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"detailline" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Result"]) {

                NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:1];
                [dataArray addObject:dic[@"RecordID"]];
                [dataArray addObject:dic[@"PushComment"]];
                [dataArray addObject:dic[@"UrgencyDays"]];
                [dataArray addObject:dic[@"PushTime"]];
                [self.datasource addObject:dataArray];
            }
          
             NSLog(@"二级列表_datasource--%@", _datasource);
        }
        [self.myTableView reloadData];
        
        
        
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titLab.text = self.titArray[indexPath.row];
    cell.contentLab.text = self.datasource[indexPath.section][indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.status isEqualToString:@"1"]) {
        RiverHandleInViewController *handle = [[RiverHandleInViewController alloc]init];
        handle.dataArray = self.datasource[indexPath.section];
        handle.title = self.title;
        [self.navigationController pushViewController:handle animated:YES];
    } else if ([self.status isEqualToString:@"2"]) {
        [YJProgressHUD showSuccess:@"任务已经完成"];
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
