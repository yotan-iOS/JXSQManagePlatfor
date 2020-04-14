//
//  RiverMessageViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/5.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverMessageViewController.h"
#import "RiverMessageTableViewCell.h"
#import "RiverMessageModel.h"
#import "AFJsonManager.h"
@interface RiverMessageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *datamanger;
}
@property (weak, nonatomic) IBOutlet UITableView *myListTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *phoneNum;
@end

@implementation RiverMessageViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.riverLevelLab.hidden = YES;
    self.riverLeveLable.hidden = YES;
    datamanger = [DataSource sharedDataSource];
    [_myListTableView registerNib:[UINib nibWithNibName:@"RiverMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellmessag"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY/MM/dd";
    self.dateLab.text = [formatter stringFromDate:[NSDate date]];
    [self requestData];
}
//拨打电话
- (IBAction)makePhoneCallAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneNumLab.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}

-(void)requestData{
    
    NSDictionary *param = @{
                            @"action":@"9",
                            @"method":F(@"{userID:%@}",datamanger.UserID)
                            };
 
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseRiverMURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"rmg-line" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
            NSLog(@"----dicData%@",dicData);
            RiverMessageModel *model = [[RiverMessageModel alloc]init];
            [model setValuesForKeysWithDictionary:dicData[@"Result"]];
            [self getDataForLab:model];
            if (model.Rank.count > 0) {
                for (NSDictionary *dic in model.Rank) {
                    RiverMessageModel *cellmodel = [[RiverMessageModel alloc]init];
                    [cellmodel setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:cellmodel];
                }
            }
        }else{
          NSLog(@"请求失败---%@---%@",datamanger.UserID,param);
        }
        
        [self.myListTableView reloadData];
       
        
        
    } orFail:^(NSError *error) {
        NSLog(@"error%@", error);
    }];


    
}
-(void)getDataForLab:(RiverMessageModel *)model{
    self.userNameLab.text = datamanger.realNameStr;
    self.phoneNumLab.text = model.RiverLongPhone;
    self.riverNameLab.text = model.RiverName;
    self.riverLengthLab.text = model.RiverLength;
    self.riverLevelLab.text = model.WaterLevel;
    self.walkLengthLab.text=  F(@"%@ 公里",  model.PatrolLength);
    NSMutableAttributedString *PatrolLengthStr = [[NSMutableAttributedString alloc] initWithString:self.walkLengthLab.text];
    [PatrolLengthStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:[self.walkLengthLab.text rangeOfString:model.PatrolLength]];
    self.walkLengthLab.attributedText = PatrolLengthStr;
    
    self.allLenthLab.text =  F(@"%@ 圈",model.EarthCircle);
    NSMutableAttributedString *EarthCircleStr = [[NSMutableAttributedString alloc] initWithString:self.allLenthLab.text];
    [EarthCircleStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:[self.allLenthLab.text rangeOfString:model.EarthCircle]];
    self.allLenthLab.attributedText = EarthCircleStr;
    self.allLenthLab.hidden = YES;
    self.totalTimeLab.text =  F(@"%@ 天",model.TimeLength);
    NSMutableAttributedString *TimeLengthStr = [[NSMutableAttributedString alloc] initWithString:self.totalTimeLab.text];
    [TimeLengthStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:[self.totalTimeLab.text rangeOfString:model.TimeLength]];
    self.totalTimeLab.attributedText = TimeLengthStr;
    
    self.dealNumLab.text = F(@"%@ 单",model.AllPatrolCount);
    NSMutableAttributedString *AllPatrolCountStr = [[NSMutableAttributedString alloc] initWithString:self.dealNumLab.text];
    [AllPatrolCountStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:[self.dealNumLab.text rangeOfString:model.AllPatrolCount]];
    self.dealNumLab.attributedText = AllPatrolCountStr;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RiverMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellmessag" forIndexPath:indexPath];
    RiverMessageModel *model = self.dataArray[indexPath.row];
    if ([model.No intValue] == 1) {
        cell.icon.image = [UIImage imageNamed:@"gold_medal"];
    } else if ([model.No intValue] == 2) {
        cell.icon.image = [UIImage imageNamed:@"silver_medal"];
    } else if ([model.No intValue] == 3) {
        cell.icon.image = [UIImage imageNamed:@"bronze_medal"];
    }
    
    cell.nameLab.text = model.Name;
    cell.patrolLengthLab.text = F(@"%@ 公里", model.Length);
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
