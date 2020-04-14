//
//  ComplainViewController.m
//  Witwater
//
//  Created by 吴坤 on 17/1/17.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import "ComplainViewController.h"
#import "ComplainTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ComplaintDetailViewController.h"
#import "InformationModel.h"
@interface ComplainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *listTableView;

@property(nonatomic,strong)UILabel *nothingLab;
@property(nonatomic,strong) UIImageView *imagV;

@property(nonatomic,copy)NSString *sortParamsIdStr;
@property(nonatomic,copy)NSString *sortTypeStr;

@property (nonatomic, strong) InformationModel *complainModel;
@end


@implementation ComplainViewController
//投诉
- (InformationModel *)complainModel {
    if (!_complainModel) {
        self.complainModel = [[InformationModel alloc] init];
    }
    return _complainModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendListComplainRequest];
    self.title = @"公众投诉";
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = UIColorFromRGB(0xF0F0F0);
    
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    [self createTableViewSet];
}
- (void)createTableViewSet {
    CGFloat h = 0;
    if (IOS_VERSION >= 11) {
        h=NAVIHEIGHT;
    }
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT, HT-h) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_listTableView];
    [self.listTableView registerNib:[UINib nibWithNibName:@"ComplainTableViewCell" bundle:nil]  forCellReuseIdentifier:@"cell"];
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    _listTableView.mj_header = header;
}
- (void)headerClick {
    [self sendListComplainRequest];
    
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.listTableView.mj_header endRefreshing];
}
- (void)sendListComplainRequest {
    [self.complainModel.IDArr removeAllObjects];
    [self.complainModel.ComplaintNumArr removeAllObjects];
    [self.complainModel.ComplaintNameArr removeAllObjects];
    [self.complainModel.ComplaintTittleArr removeAllObjects];
    [self.complainModel.ComplaintTimeArr removeAllObjects];
//    [self.complainModel.ComplaintSiteIDArr removeAllObjects];
//    [self.complainModel.SiteNameArr removeAllObjects];
    [self.complainModel.ComplaintContentArr removeAllObjects];
    [self.complainModel.PictureArr removeAllObjects];
    [self.complainModel.StatusArr removeAllObjects];
    [self.complainModel.ImgUrlArr removeAllObjects];
    NSDictionary *param = @{
                            @"status":@""
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/getComplainInfoList", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Construction" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                self.listTableView.emptyView.hidden = YES;
                
                [self.complainModel.IDArr addObject:dic[@"ID"]];
                [self.complainModel.ComplaintNumArr addObject:dic[@"ComplainNo"]];
                [self.complainModel.ComplaintNameArr addObject:dic[@"ComplainRiver"]];//所属河道
                [self.complainModel.ComplaintTittleArr addObject:dic[@"ComplainTitle"]];
                [self.complainModel.ComplaintTimeArr addObject:dic[@"ComplainDate"]];
//                [self.complainModel.ComplaintSiteIDArr addObject:dic[@"ComplaintSiteID"]];
//                [self.complainModel.SiteNameArr addObject:dic[@"ComplainTitle"]];
                [self.complainModel.ComplaintContentArr addObject:dic[@"ComplainComment"]];
                [self.complainModel.PictureArr addObject:dic[@"ComplainPic"]];
                [self.complainModel.StatusArr addObject:dic[@"StatusName"]];//Status
                [self.complainModel.ImgUrlArr addObject:dic[@"PicUrl"]];
            }
        }
        
        if(!((NSDictionary *)dicData[@"Data"]).count){
            [self.listTableView addEmptyViewWithImageName:@"" title:@"暂无数据"];
            self.listTableView.emptyView.hidden = NO;
        }
        
        [self.listTableView reloadData];
//        NSLog(@"水质信息数据========================%@", result);
        [CustomHUD dismiss];
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
        [CustomHUD dismiss];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.complainModel.IDArr.count;
    
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComplainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.riverNameLab.text = F(@"%@", self.complainModel.ComplaintNumArr[indexPath.section]);
    cell.compStatusLab.textColor = UIColorFromRGB(0x4AB9E6);
    cell.compStatusLab.text = F(@"%@", self.complainModel.StatusArr[indexPath.section]);
    
    cell.titleNameLabel.text = @"所属河道";
    NSArray *pathArr = [F(@"%@", self.complainModel.PictureArr[indexPath.section]) componentsSeparatedByString:@";"];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:F(@"%@%@", self.complainModel.ImgUrlArr[indexPath.section],pathArr[0])]]];
    if (image) {
         [cell.conImageV setImage:image];
    }else{
        cell.conImageV.image = [UIImage imageNamed:@"wt"];
    }
   
    cell.titleLab.text = F(@"%@", self.complainModel.ComplaintTittleArr[indexPath.section]);
    cell.contentLab.text = F(@"%@", self.complainModel.ComplaintContentArr[indexPath.section]);
    cell.timeLab.text = F(@"%@", self.complainModel.ComplaintTimeArr[indexPath.section]);
    cell.riverDistrict.text = F(@"%@", self.complainModel.ComplaintNameArr[indexPath.section]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ComplaintDetailViewController *detailVC = [[ComplaintDetailViewController alloc]init];
    detailVC.IdStr = F(@"%@", self.complainModel.IDArr[indexPath.section]);
//    detailVC.title = F(@"%@", self.complainModel.SiteNameArr[indexPath.section]);
    [self.navigationController pushViewController:detailVC animated:YES];
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
