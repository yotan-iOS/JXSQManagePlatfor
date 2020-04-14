//
//  RecodViewController.m
//  LWIntelligenceOperations
//
//  Created by ghost on 2017/6/1.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "RecodViewController.h"
#import "RecodTableViewCell.h"
#import "RecodCountModel.h"
@interface RecodViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString *mdata;
@property(nonatomic,strong) RecodCountModel *rcModel;
@property(nonatomic,copy)NSString *startStr;
@property(nonatomic,copy)NSString *endStr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)int butTypeId;
@property (strong, nonatomic) IBOutlet UIView *header;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UIView *backGroundView;
@property (nonatomic) JHUD *hudView;
@end

@implementation RecodViewController
- (RecodCountModel *)rcModel{
    if (!_rcModel) {
        self.rcModel = [[RecodCountModel alloc] init];
    }
    return _rcModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view from its nib.
    //    [self configerBut];
    self.title = @"登录记录";
    [self readDataForJBYT];
    
}
- (void)readDataForJBYT {
    DataSource *dataSource = [DataSource sharedDataSource];
    NSDictionary *param = @{
                            @"action":@"4",
                            @"method":F(@"{userName:%@}", dataSource.SignInName),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:SystemSettingsURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"gaimima" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.rcModel.DataTimesArr addObject:dic[@"DateTimes"]];
                [self.rcModel.RealNameArr addObject:dic[@"RealName"]];
                [self.rcModel.OsNameArr addObject:dic[@"OsName"]];
            }
            
            [self hide];
            [self creattableview];
        }
        
    } orFail:^(NSError *error) {
        [self hide];
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}
-(void)creattableview{
    CGFloat h = 0;
    if (IOS_VERSION >= 11.0) {
        h = NAVIHEIGHT;
    }
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT,HT-h) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"RecodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.myTableView];
    self.header.frame = CGRectMake(0, h, WT, 30);
    self.myTableView.tableHeaderView = self.header;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rcModel.DataTimesArr.count;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//   //
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.rcModel.DataTimesArr.count > 0) {
        cell.index.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
        cell.systemLab.text = self.rcModel.OsNameArr[indexPath.row];
        cell.dateLab.text = self.rcModel.DataTimesArr[indexPath.row];
        
    }
    return cell;
}

- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    CGFloat h = 0;
    if (IOS_VERSION > 11.0) {
        h = 64;
    }
    self.hudView = [[JHUD alloc]initWithFrame:CGRectMake(0, h, WT, HT-h)];
    [self circleAnimation];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)circleAnimation {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loadinggif3" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    self.hudView.gifImageData = data;
    self.hudView.indicatorViewSize = CGSizeMake(110, 110); 
    self.hudView.messageLabel.text = @"努力加载中....";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeGifImage];
}
- (void)hide {
    [self.hudView hide];
    
}
@end
