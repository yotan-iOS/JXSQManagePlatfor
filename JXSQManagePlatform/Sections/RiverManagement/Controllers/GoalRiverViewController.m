//
//  GoalRiverViewController.m
//  Witwater
//
//  Created by ghost on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GoalRiverViewController.h"
#import "TargetPhotoViewController.h"
@interface GoalRiverViewController ()
@property (nonatomic, strong) NSMutableArray *stationArr;
@property (nonatomic, strong) NSMutableArray *PicUrlArr;
@property (nonatomic, strong) NSMutableArray *IDArr;
@end

@implementation GoalRiverViewController
//河道目标
- (NSMutableArray *)stationArr{
    if (!_stationArr) {
        self.stationArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _stationArr;
}
- (NSMutableArray *)PicUrlArr{
    if (!_PicUrlArr) {
        self.PicUrlArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _PicUrlArr;
}
- (NSMutableArray *)IDArr{
    if (!_IDArr) {
        self.IDArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _IDArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    [self sendRequestRevierStrategy];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"一河一策";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contentrvc"];
}
- (void)sendRequestRevierStrategy {
    [gs_HttpManager httpManagerPostParameter:nil toHttpUrlStr:F(@"%@/getRiverPolicyList", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Content" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.stationArr addObject:dic[@"RiverSubName"]];
                [self.PicUrlArr addObject:dic[@"PicUrl"]];
                [self.IDArr addObject:dic[@"ID"]];
            }
        }
        [self.tableView reloadData];
        [CustomHUD dismiss];
        NSLog(@"获取巡河上报的内容 ====%@", result);
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.stationArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentrvc" forIndexPath:indexPath];    
    cell.textLabel.text = self.stationArr[indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TargetPhotoViewController *targetPVC = [[TargetPhotoViewController alloc] init];
    targetPVC.title = self.stationArr[indexPath.row];
//    targetPVC.imageString = self.PicUrlArr[indexPath.row];
    targetPVC.riverID = self.IDArr[indexPath.row];
    [self.navigationController pushViewController:targetPVC animated:YES];
    NSLog(@"/////////////");
}
/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
