//
//  OperatingModeViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/10/7.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "OperatingModeViewController.h"
#import "WaterBaseTableViewCell.h"
#import "OparetionCondationModle.h"
@interface OperatingModeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    DataSource *datamanger;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titArray;
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation OperatingModeViewController
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titArray = @[@"站点名称:",@"所属乡镇:",@"最新更新时间:",@"通讯状态"];
    datamanger = [DataSource sharedDataSource];
    [self createTableView];
    [self getDataForBQ];
}
-(void)getDataForBQ{
    NSDictionary *param = @{@"siteid":datamanger.siteIDString,@"sitetypeid":datamanger.siteClassID};
    self.urlString = F(@"%@/GetOperatingMode",BaseRequestUrl);
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlString isCacheorNot:NO targetViewController:self andUrlFunctionName:@"eeline" success:^(id result) {
        NSDictionary *dicData = result[@"Data"];
        if ([result[@"Status"] isEqualToString:@"OK"]&&[result[@"Msg"] isEqualToString:@"成功"]) {
              [self.dataArray addObject:dicData[@"SiteName"]];
              [self.dataArray addObject:@"乍浦镇"];
              [self.dataArray addObject:dicData[@"TimeStamp"]];
              [self.dataArray addObject:dicData[@"NetStatus"]];
            for (NSDictionary *dic in dicData[@"Equipment"]) {
                OparetionCondationModle *model = [[OparetionCondationModle alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
                
            }
            
        }
        [self.tableView reloadData];
        
        
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
    }];
    
    
}
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WT, HT) style:UITableViewStyleGrouped];
    if (IOS_VERSION >=11.0) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"WaterBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellgk"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.dataArray.count;
    }else{
        return self.dataArr.count;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [[UIView alloc] init];
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [[UIView alloc] init];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WaterBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellgk"forIndexPath:indexPath];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section ==0) {
       
          cell.titLable.text = self.titArray[indexPath.row];
        if (indexPath.row == 3) {
            UIImageView *imagV = [[UIImageView alloc]initWithFrame:CGRectMake(150, 10, 20, 20)];
            [cell addSubview:imagV];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(imagV.frame.origin.x+20,imagV.frame.origin.y ,40, imagV.frame.size.height)];
            lab.font = [UIFont systemFontOfSize:13];
            lab.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:lab];
            
            if ([F(@"%@",self.dataArray[indexPath.row]) isEqualToString:@"1"]) {
                //正常
                imagV.image = [UIImage imageNamed:@"运行1.png"];
                lab.text = @"正常";
            }else if([F(@"%@",self.dataArray[indexPath.row]) isEqualToString:@"0"]){
                //异常
                imagV.image = [UIImage imageNamed:@"停止1.png"];
                lab.text = @"停止";
            }
            
            cell.ceontentLab.hidden = YES;
            
        }else{
          
            cell.ceontentLab.text = self.dataArray[indexPath.row];
        }
    }
    if (indexPath.section == 1) {
        if (self.dataArr.count >0) {
             OparetionCondationModle *model = self.dataArr[indexPath.row];
    
               cell.titLable.text = F(@"%@",model.EquipmentName) ;
           
         
            UIImageView *imagV = [[UIImageView alloc]initWithFrame:CGRectMake(150, 10, 20, 20)];
            [cell addSubview:imagV];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(imagV.frame.origin.x+20,imagV.frame.origin.y ,40, imagV.frame.size.height)];
            lab.font = [UIFont systemFontOfSize:13];
            lab.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:lab];
            if ([F(@"%@",model.EquipmentStatus) isEqualToString:@"1"]) {
                //正常
                imagV.image = [UIImage imageNamed:@"运行1.png"];
                lab.text = @"运行";
            }else if([F(@"%@",model.EquipmentStatus) isEqualToString:@"2"]){
                //异常
                imagV.image = [UIImage imageNamed:@"故障1.png"];
                lab.text = @"故障";
            }else if([F(@"%@",model.EquipmentStatus) isEqualToString:@"3"]){
                //停止
                imagV.image = [UIImage imageNamed:@"停止1.png"];
                lab.text = @"停止";
            }
            
            
            cell.ceontentLab.hidden = YES;
        }
       
    }
      
      
    
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
