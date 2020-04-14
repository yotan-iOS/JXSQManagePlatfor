//
//  HistorysViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/20.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "HistorysViewController.h"
#import "HistorysTableViewCell.h"
#import "SupervisinModel.h"
@interface HistorysViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArray
;
@property(nonatomic,assign)NSInteger pageIdex;
@end

@implementation HistorysViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _dataArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createTableview];
    self.view.frame = CGRectMake(0, 40-NAVIHEIGHT, WT, HT - 40-NAVIHEIGHT);
    self.view.backgroundColor = UIColorFromRGB(0xF0F0F0);
     self.pageIdex = 0;
    [self refleshData];
}
-(void)refleshData{
    
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置上拉加载更多
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
       
        [weakSelf requestData];
         self.pageIdex++;
    }];
    NSLog(@"pageIdex---%ld",self.pageIdex);
    [self.listTableView.mj_footer beginRefreshing];
}
//获取数据
-(void)requestData{
    [gs_HttpManager httpManagerPostParameter:[NSDictionary dictionaryWithObjectsAndKeys:@"10",@"PageSize",F(@"%ld", self.pageIdex),@"PageIndex",@"",@"projectid", nil] toHttpUrlStr:F(@"%@/GetSuperviseInfoByPage",BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"PageList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                SupervisinModel *model = [[SupervisinModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                
            }
            
        }
        [self.listTableView reloadData];

        [self.listTableView.mj_footer endRefreshing];
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [self.listTableView.mj_footer endRefreshing];
      
    }];
    
    
    
}

-(void)createTableview{
    
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WT, HT - 40-NAVIHEIGHT) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTableView];
    self.listTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.listTableView registerNib:[UINib nibWithNibName:@"HistorysTableViewCell" bundle:nil] forCellReuseIdentifier:@"history"];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HistorysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xF0F0F0);
    cell.contentTfView.delegate = self;
    cell.changeTfView.delegate = self;
    cell.contentTfView.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
    cell.contentTfView.layer.borderWidth = 1.f;
    cell.changeTfView.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
  cell.changeTfView.layer.borderWidth = 1.f;
    if (self.dataArray.count > 0) {
        SupervisinModel *model = self.dataArray[indexPath.row];
        
        cell.projectNameLab.text = model.ProjectName;
        cell.StatusLab.text = [self getStatusWithStutusID:F(@"%@", model.status)];
        cell.changeTfView.text = model.rectificationmsg;
        cell.contentTfView.text = model.reportcontent;
        cell.endTimeLab.text =  model.endtime;
        cell.nameLab.text = [F(@"%@", model.supervisionresource) integerValue]==1 ? @"巡查人员":@"领导批示";
    }
    return cell;
    
}
-(NSString *)getStatusWithStutusID:(NSString *)statusID{
    NSString *status = nil;
    switch ([statusID integerValue]) {
        case 0:
            status = @"未下发";
            break;
        case 1:
            status = @"已下发";
            break;
        case 2:
            status = @"处理中";
            break;
        case 3:
            status = @"已整理";
            break;
            
        default:
            status = @"已关闭";
            break;
    }
    
    return status;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
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
