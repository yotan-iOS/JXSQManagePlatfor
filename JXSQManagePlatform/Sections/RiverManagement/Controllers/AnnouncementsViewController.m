//
//  AnnouncementsViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/14.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "AnnouncementsViewController.h"
#import "ListNoticeTableViewCell.h"
#import "InformationModel.h"
#import "NoticeDetailViewController.h"
@interface AnnouncementsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sourceData;
@end

@implementation AnnouncementsViewController
- (NSMutableArray *)sourceData {
    if (!_sourceData) {
        self.sourceData = [NSMutableArray arrayWithCapacity:1];
    }
    return _sourceData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通知公告";
    [self createTableViewSet];
    [self sendNoticeListRequest];
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
}
- (void)createTableViewSet {
    CGFloat h = 0;
    if (IOS_VERSION >= 11.0) {
        h=NAVIHEIGHT;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT, HT-h) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    _tableView.mj_header = header;
}
- (void)headerClick {
    [self sendNoticeListRequest];
    
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.tableView.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendNoticeListRequest {
    [self.sourceData removeAllObjects];
    [gs_HttpManager httpManagerPostParameter:nil toHttpUrlStr:F(@"%@/getNoticeList", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Content" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                InformationModel *mDetail = [[InformationModel alloc] initWithDic:dic];
                [self.sourceData addObject:mDetail];
            }
        }
        if (self.sourceData.count==0) {
            UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100,100)];
            imgv.center = self.tableView.center ;
            imgv.image = [UIImage imageNamed:@"zwsj"];
            [self.tableView addSubview:imgv];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgv.frame), CGRectGetMaxY(imgv.frame), 100, 30)];
            lab.text = @"暂无数据";
            lab.font = [UIFont systemFontOfSize:14];
            lab.textAlignment = NSTextAlignmentCenter;
            [self.tableView addSubview:lab];
        }
        [self.tableView reloadData];
        [CustomHUD dismiss];
        NSLog(@"获取通知公告列表 ====%@", result);
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
        [CustomHUD dismiss];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceData.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListNoticeTableViewCell *cell = [ListNoticeTableViewCell ListNoticeTableViewCell:self.tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InformationModel *model = self.sourceData[indexPath.row];
    cell.titleLable.text = model.Title;
    cell.noticeLabel.text = model.ClassName;
    cell.contextLable.text = F(@"内容概要:%@", model.Comment);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
    InformationModel *model = self.sourceData[indexPath.row];
    detailVC.title = model.Title;
    detailVC.IDStr = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
