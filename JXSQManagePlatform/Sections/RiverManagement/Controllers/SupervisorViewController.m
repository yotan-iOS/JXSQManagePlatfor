//
//  SupervisorViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/19.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "SupervisorViewController.h"
#import "SupervisorTableViewCell.h"
#import "SupervisorOneTableViewCell.h"
#import "HistorysViewController.h"
#import "ProjectModel.h"
@interface SupervisorViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    DataSource *datamanger;
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)HistorysViewController *historyVc;
@property(nonatomic,strong)NSArray<NSArray*> *cellTitleArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *dateStr;
@property(nonatomic,copy)NSString *projectName;
@property(nonatomic,strong)NSMutableArray *projectNameArr;
@property(nonatomic,strong)NSMutableArray *typeNameArr;
@property(nonatomic,copy)NSString *statusStr;
@property(nonatomic,copy)NSString *handleName;
@property(nonatomic,copy)NSString *tfChange;
@property(nonatomic,copy)NSString *tfContent;
@property(nonatomic,strong)NSMutableDictionary *projectDic;
@end

@implementation SupervisorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.projectDic = [NSMutableDictionary dictionaryWithCapacity:1];
    self.cellTitleArray = [NSArray arrayWithObjects:@[@"所属项目:",@"状态:",@"限期时间:"],@[@"整改要求:",@"处理内容:"], nil];
    datamanger = [DataSource sharedDataSource];
    [self createSegement];
    [self creteTableView];
    RadioButton *radion = [self.headerView viewWithTag:200];
    radion.selected = YES;
    _handleName = @"1";
    [self requestDataForProjectID];
    NSLog(@"datamanger---%@",datamanger.UserID);
}
-(void)requestDataForProjectID{
    
    [gs_HttpManager httpManagerPostParameter:nil toHttpUrlStr:F(@"%@/GetAllKeyProject",BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"NoneList" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {

                [_projectDic setObject:F(@"%@", dic[@"ProjectID"]) forKey:dic[@"ProjectName"]];
                
            }
            
        }
        [CustomHUD dismiss];

        
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
    }];

    
    
}

- (void)createSegement {
    NSArray *array = [NSArray arrayWithObjects:@"督导添加",@"督导历史", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(WT/2.0 - 100, 2+NAVIHEIGHT+3, 200, 30);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont boldSystemFontOfSize:15],
                         NSFontAttributeName,nil];
    
    [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    segment.backgroundColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(HandleChanges:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = UIColorFromRGB(0x2ab1e7);
    [self.view addSubview: segment];
}
- (void)HandleChanges:(UISegmentedControl *)segemet {
   
        [_myTableView removeFromSuperview];
        [self.historyVc removeFromParentViewController];
        [self.historyVc.view removeFromSuperview];
        switch (segemet.selectedSegmentIndex) {
            case 0:
            {
                //添加
                [self.view addSubview:_myTableView];
                
            }
                break;
            case 1:
            {
                //历史数据
                self.historyVc = [[HistorysViewController alloc]init];
                [self addChildViewController:self.historyVc];
                [self.view addSubview:self.historyVc.view];
                               
            }
                break;
                
            default:
                break;
        }
        
    
}
- (void)creteTableView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT+4+36, WT, HT - 40-NAVIHEIGHT) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    _myTableView.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2);
    //UITableViewCellSeparatorStyleSingleLine;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [_myTableView registerNib:[UINib nibWithNibName:@"SupervisorTableViewCell" bundle:nil] forCellReuseIdentifier:@"upervisorcell"];
      [_myTableView registerNib:[UINib nibWithNibName:@"SupervisorOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"upervisoronecell"];
    _myTableView.scrollEnabled = NO;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellTitleArray[section].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellTitleArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 80;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 100;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        self.headerView.frame = CGRectMake(0, 0, WT, 40);
        return self.headerView;
    }else{
        return nil;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        self.footerView.frame = CGRectMake(0, 0, WT, 100);
        return self.footerView;
    }else{
        return nil;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    if (indexPath.section == 0) {
        SupervisorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upervisorcell"forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titLable.text = self.cellTitleArray[indexPath.section][indexPath.row];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = indexPath.row + 100;

         but.frame =  CGRectMake(100, 5,WT - 150 , 30);
        [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
        but.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
        but.layer.borderWidth = 1.f;
        [but setTitle:@"请选择" forState:UIControlStateNormal];
        if (but.tag == 102) {
            [but setTitle:timeStr forState:UIControlStateNormal];
            self.dateStr = timeStr;
        }
        [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:but];

        
        
        return cell;
    }else{
        SupervisorOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upervisoronecell"forIndexPath:indexPath];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titLables.text = self.cellTitleArray[indexPath.section][indexPath.row];
        cell.texfTF.delegate = self;
        cell.texfTF.tag = 300+indexPath.row;
        
        return cell;
    }

    
}
- (void)TimeAction:(UIButton *)sender {
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"时间： %@",date);
        [sender setTitle:date forState:UIControlStateNormal];
        [sender setTitle:date forState:UIControlStateNormal];
        self.dateStr = date;
    }];
    datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
    [datepicker show];
    
}
- (void)btnAction:(UIButton *)sender {
    NSArray *arr = self.projectDic.allKeys ;
      datamanger.idLeft = @"left";
    [ZJBLStoreShopTypeAlert showWithTitle:@"选择所属项目" titles:arr selectIndex:^(NSInteger selectIndex) {
        
      
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
        [sender setTitle:selectValue forState:UIControlStateNormal];
          self.projectName = _projectDic[selectValue];
        NSLog(@"projectName--%@",self.projectName );
       
    } showCloseButton:YES];
    
    
}
- (void)typeBtnAction:(UIButton *)sender {
    self.typeNameArr = [@[@"未下发",@"已下发",@"处理中",@"已整改",@"已关闭"]mutableCopy];
    
    NSArray *arr = self.typeNameArr;
    
    [ZJBLStoreShopTypeAlert showWithTitle:@"选择状态" titles:arr selectIndex:^(NSInteger selectIndex) {
        self.statusStr = F(@"%ld",selectIndex);
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
        [sender setTitle:selectValue forState:UIControlStateNormal];
        
        
    } showCloseButton:YES];
    
    
}

//来源选择
- (IBAction)handleNameSeclectAction:(RadioButton *)sender {
    NSInteger index = sender.tag - 200;
     _handleName = F(@"%ld", index +1);
//    switch (index) {
//        case 0:
//        {
//            _handleName = F(@"%ld", index +1);
//        }
//            break;
//            
//        default:
//        {
//            _handleName = sender.titleLabel.text;
//        }
//            break;
//    }
//    
//    _handleName = sender.titleLabel.text;
    NSLog(@"_handleName%@",_handleName);
}
//所属项目/状态/限期时间选择
-(void)butAction:(UIButton *)sender{
   
    NSInteger idnex = sender.tag - 100;
      NSLog(@"%ld",idnex);
    switch (idnex) {
        case 0:
        {

                [self btnAction:sender];
        }
            break;
        case 1:
        {

            [self typeBtnAction:sender];
            
        }
            break;
        default:
        {
            [self TimeAction:sender];

        }
            break;
    }
}
//textView delegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.tag == 300) {
        self.tfChange  = textView.text;
    }else if (textView.tag == 301){
        self.tfContent = textView.text;
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//上报
- (IBAction)handleAction:(UIButton *)sender {
    NSLog(@"%@---%@",self.tfContent,self.tfChange);
    [self handleInDD];
}
//取消
- (IBAction)concelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)handleInDD{
    
    [CustomHUD showIndicatorWithStatus:@"正在上传"];
    NSLog(@"%@---%@----%@----%@---%@----%@----%@---",self.projectName,self.tfChange,self.statusStr,self.dateStr,_handleName,datamanger.UserID,self.tfContent);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.projectName,@"projectid",self.tfChange,@"rectificationmsg",self.statusStr,@"status",self.dateStr,@"endtime",_handleName,@"supervisionresource",datamanger.UserID,@"createuser",self.tfContent,@"reportcontent",nil];
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/InsertSuperviseInfo",BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"InsertList" success:^(id result) {
         [CustomHUD dismiss];
        [YJProgressHUD showError:@"上传成功"];
    } orFail:^(NSError *error) {
      
    [YJProgressHUD showError:@"上传失败"];
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

@end
