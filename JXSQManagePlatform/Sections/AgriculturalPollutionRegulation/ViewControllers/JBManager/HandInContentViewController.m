//
//  HandInContentViewController.m
//  Witwater
//
//  Created by 吴坤 on 16/12/3.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "HandInContentViewController.h"
#import <MessageUI/MessageUI.h>
#import "HandleManagerCollectionViewCell.h"
#import "ZJBLStoreShopTypeAlert.h"
#import "UrgencyModel.h"
@interface HandInContentViewController ()<MFMessageComposeViewControllerDelegate,UITextViewDelegate,MKMessagePhotoViewDelegate,NSXMLParserDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    DataSource *datamanager;
}
@property(nonatomic,copy)NSString *tfString;
@property(nonatomic,copy)NSString *mdata;
@property(nonatomic,strong)NSMutableArray *urgencyArray;

@property(nonatomic,strong)NSMutableArray *phoneNum;
@property(nonatomic,strong)NSMutableArray *errCodeArray;

@property (nonatomic, retain) UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableDictionary *tyDic;
@property(nonatomic,strong)NSMutableDictionary *contentDic;
@property(nonatomic,copy)NSString *typeID;
@property(nonatomic,copy)NSString  *urlStr;
@property(nonatomic,strong)NSMutableDictionary *ErrCategoryDic;
@property(nonatomic,strong)NSMutableDictionary *ErrCotentDic;
@property(nonatomic,copy)NSString  *UrgencyIDstr;
@property(nonatomic,strong)NSMutableArray *errcomnetArr;
@end

@implementation HandInContentViewController
-(NSMutableArray *)urgencyArray{
    
    if (!_urgencyArray) {
        self.urgencyArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _urgencyArray;
}
-(NSMutableArray *)phoneNum{
    
    if (!_phoneNum) {
        self.phoneNum = [NSMutableArray arrayWithCapacity:1];
    }
    return _phoneNum;
}
-(NSMutableArray *)errCodeArray{
    
    if (!_errCodeArray) {
        self.errCodeArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _errCodeArray;
}
-(NSMutableDictionary *)tyDic{
    if (!_tyDic) {
        self.tyDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _tyDic;
}
-(NSMutableDictionary *)contentDic{
    if (!_contentDic) {
        self.contentDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _contentDic;
}

-(NSMutableDictionary *)ErrCategoryDic{
    if (!_ErrCategoryDic) {
        self.ErrCategoryDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _ErrCategoryDic;
}
-(NSMutableDictionary *)ErrCotentDic{
    if (!_ErrCotentDic) {
        self.ErrCotentDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _ErrCotentDic;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([datamanager.tagString isEqualToString:@"51"]) {
          self.stextf.frame = CGRectMake((SCREEN_WIDTH-10)/3.0, 31, SCREEN_WIDTH-10-CGRectGetMaxX(self.photo.frame), (SCREEN_HEIGHT-215-64-IphoneX_TH-IphoneX_BH)/3.0-31);
    }
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view from its nib.
    self.errcomnetArr = [NSMutableArray new];
    [self createSecondView];
    datamanager = [DataSource sharedDataSource];
     self.stextf.delegate = self;
    self.stextf.placeholder = @"请输入内容...";
    self.displayView.frame = CGRectMake(0, NAVIHEIGHT+IphoneX_TH, WT, HT-NAVIHEIGHT-IphoneX_BH-IphoneX_TH);
    [self.view addSubview:self.displayView];
    [self layoutCollection];
    [self getDataForGJ];
    self.typeID = @"2";
    [self getDataForErrCotent];
    [self getDataForUrgencyDays];
    if ([datamanager.tagString isEqualToString:@"51"]) {
        self.sotherLab.hidden = YES;
        self.title = self.titString;
        self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 33,(SCREEN_WIDTH-10)/3.0, self.stextf.frame.size.height-31)];
        self.photo.image = self.imgs;
        self.photo.userInteractionEnabled = YES;
        UIView *picview = [self.view viewWithTag:501];
        [picview addSubview:self.photo];

      
    }

}

#pragma mark -相册视图
-(void)setUpPhotosView {
    if (!self.photosView) {
//        DataSource *datasource = [DataSource sharedDataSource];
//        datasource.identfyStr = @"arg";
        self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(8,20,110, 85)];
        if (self.photo.image) {
            self.photosView.hidden = YES;
        }
        UIView *aview = [self.view viewWithTag: 801];
        [aview addSubview:self.photosView];
        self.photosView.delegate = self;
    }
    
}
//获取预警类型
-(void)getDataForGJ{
    self.urlStr = F(@"%@/GetApErrCategoryList",BaseRequestUrl);
    
    [gs_HttpManager httpManagerPostParameter:nil toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"ggjmList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.ErrCategoryDic setValue:F(@"%@",dic[@"ErrCategoryNumber"] ) forKey:F(@"%@", dic[@"ErrCategoryName"])];
            }
        }
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        
    }];
   
    
    
}
//获取紧急天数
-(void)getDataForUrgencyDays{
    self.urgencyArray = nil;
    self.urlStr = F(@"%@/GetApUrgencyInfoList",BaseRequestUrl);
    NSDictionary *param = @{@"AlarmType":self.typeID};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"ggjmList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        
        if ([status isEqualToString:@"OK"]) {
            
            for (NSDictionary *dic in dicData[@"Data"]) {
                UrgencyModel *model = [[UrgencyModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.urgencyArray addObject:model];
            }
        }
        UrgencyModel *model = self.urgencyArray.firstObject;
        NSString *urg = F(@"%@",model.UrgencyDays);
        if ([model.UrgencyDays integerValue] < 10) {
            urg = F(@" %@",model.UrgencyDays);
        }
        self.UrgencyIDstr = F(@"%@",model.UrgencyNumber);
        self.smessageLab.text = F(@"紧急程度:%@,处理天数:%@天",model.UrgencyName,urg);
        UIButton *but = [self.view viewWithTag:203];
        but.selected = YES;
        [self configerUrgencyBtn];
        //        NSLog(@"*****%@",self.urgencyArray);
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        
    }];
    
    
}
//获取预警内容
-(void)getDataForErrCotent{
    self.ErrCotentDic = nil;
    self.tyDic = nil;
    self.urlStr = F(@"%@/GetApErrCodeList",BaseRequestUrl);
    NSDictionary *param = @{@"AlarmType":self.typeID};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"gcjmList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        
        if ([status isEqualToString:@"OK"]) {
            
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self.ErrCotentDic setValue:F(@"%@",dic[@"ErrCode"] ) forKey:F(@"%@", dic[@"ErrCotent"])];
            }
        }
        if ([F(@"%@",self.stationModel.FanNumber) isEqualToString:@"1"]) {
            [self.ErrCotentDic removeObjectForKey:@"2#风机过载"];
            [self.ErrCotentDic removeObjectForKey:@"3#风机过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#风机过载"];
        }else if([F(@"%@",self.stationModel.FanNumber) isEqualToString:@"0"]){
            [self.ErrCotentDic removeObjectForKey:@"1#风机过载"];
            [self.ErrCotentDic removeObjectForKey:@"2#风机过载"];
            [self.ErrCotentDic removeObjectForKey:@"3#风机过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#风机过载"];
        }else  if([F(@"%@",self.stationModel.FanNumber) isEqualToString:@"2"]){
            [self.ErrCotentDic removeObjectForKey:@"3#风机过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#风机过载"];
        }else  if([F(@"%@",self.stationModel.FanNumber) isEqualToString:@"3"]){
            [self.ErrCotentDic removeObjectForKey:@"4#风机过载"];
        }
        
        if([F(@"%@",self.stationModel.RefluxNumber) isEqualToString:@"1"]){
            [self.ErrCotentDic removeObjectForKey:@"2#回流泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"3#回流泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#回流泵过载"];
        }else if([F(@"%@",self.stationModel.RefluxNumber) isEqualToString:@"0"]){
            [self.ErrCotentDic removeObjectForKey:@"1#回流泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"2#回流泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"3#回流泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#回流泵过载"];
        }else  if([F(@"%@",self.stationModel.RefluxNumber) isEqualToString:@"2"]){
            [self.ErrCotentDic removeObjectForKey:@"3#回流泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#回流泵过载"];
        }else  if([F(@"%@",self.stationModel.RefluxNumber) isEqualToString:@"3"]){
            [self.ErrCotentDic removeObjectForKey:@"4#回流泵过载"];
        }
        
         if([F(@"%@",self.stationModel.LiftingNumber) isEqualToString:@"1"]){
            [self.ErrCotentDic removeObjectForKey:@"2#提升泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"3#提升泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#提升泵过载"];
        }else if([F(@"%@",self.stationModel.LiftingNumber) isEqualToString:@"0"]){
            [self.ErrCotentDic removeObjectForKey:@"1#提升泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"2#提升泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"3#提升泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#提升泵过载"];
        }else  if([F(@"%@",self.stationModel.LiftingNumber) isEqualToString:@"2"]){
            [self.ErrCotentDic removeObjectForKey:@"3#提升泵过载"];
            [self.ErrCotentDic removeObjectForKey:@"4#提升泵过载"];
        }else  if([F(@"%@",self.stationModel.LiftingNumber) isEqualToString:@"3"]){
            [self.ErrCotentDic removeObjectForKey:@"4#提升泵过载"];
        }

        for (int i = 0; i < self.ErrCotentDic.allKeys.count; i++) {
            [self.tyDic setValue:@"0" forKey:F(@"%d", i)];
        }

        [self layoutCollection];
      [self.collectionView reloadData];
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];

    }];
    
}

- (IBAction)typeBtnAction:(id)sender {
    NSArray *arr = self.ErrCategoryDic.allKeys;

    [ZJBLStoreShopTypeAlert showWithTitle:@"选择告警类型" titles:arr selectIndex:^(NSInteger selectIndex) {
        
       
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
        [self.alarmTy setTitle:selectValue forState:UIControlStateNormal];
        self.typeID = self.ErrCategoryDic[selectValue];
         NSLog(@"选择了第%@个", self.typeID);
//        [self getDataForErrCotent];
        [self getDataForUrgencyDays];
    } showCloseButton:YES];
    
 
}

-(void)createSecondView{
   
    for (int i = 0; i  < 4; i++) {
     UIView *aview = [self.view viewWithTag:500+ i];
        aview.layer.borderWidth = 1;
        aview.layer.borderColor = [UIColor lightGrayColor].CGColor;
        aview.layer.masksToBounds = YES;
        aview.layer.cornerRadius = 10;
    }
    
    
}
- (void)layoutCollection {
    //创建UICollectionView对象,添加到根视图上
    [_collectionView removeFromSuperview];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5 , 30,WT-10,(HT-264)/3.0-30) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    //item
    [_collectionView registerNib:[UINib nibWithNibName:@"HandleManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"mcell"];  
    [self.contentView addSubview:_collectionView];
    
}



#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.ErrCotentDic.allKeys.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    HandleManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mcell" forIndexPath:indexPath];
    if (self.ErrCotentDic.allKeys.count > 0) {
         cell.contentLab.text = self.ErrCotentDic.allKeys[indexPath.row];
    }
   
  
    if ([self.tyDic[F(@"%ld", indexPath.row)] isEqualToString:@"0"]) {
        cell.iconImag.image = [UIImage imageNamed:@"unselect01"];
    }else if ([self.tyDic[F(@"%ld", indexPath.row)] isEqualToString:@"1"]){
         cell.iconImag.image = [UIImage imageNamed:@"select01"];
    }
        return cell;

}

#pragma mark - UICollectionViewFlowLayoutDelegate
//边界缩进
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0.01, 0, 0.01);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}
//设置item
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(self.collectionView.frame.size.width / 2 -0.03, 30*HT/568);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HandleManagerCollectionViewCell *cell = (HandleManagerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if ([self.tyDic[F(@"%ld", indexPath.row)] isEqualToString:@"0"]) {
        cell.iconImag.image = [UIImage imageNamed:@"select01"];
        if (self.ErrCotentDic.allKeys.count > 0) {
             self.smessageLab.text = [NSString stringWithFormat:@"%@ %@",self.smessageLab.text,self.ErrCotentDic.allKeys[indexPath.row]];
        }
        [self.errcomnetArr addObject:self.ErrCotentDic.allKeys[indexPath.row]];
        [self.tyDic setValue:@"1" forKey:F(@"%ld", indexPath.row)];
    }else{
        cell.iconImag.image = [UIImage imageNamed:@"unselect01"];
         [self.tyDic setValue:@"0" forKey:F(@"%ld", indexPath.row)];
        if (self.ErrCotentDic.allKeys.count > 0) {
          self.smessageLab.text = [self.smessageLab.text stringByReplacingOccurrencesOfString:self.ErrCotentDic.allKeys[indexPath.row] withString:@""];
        }
        [self.errcomnetArr removeObject:self.ErrCotentDic.allKeys[indexPath.row]];
       
    }
   
    
}

-(void)configerUrgencyBtn{
    for (int i =0; i < self.urgencyArray.count; i++) {
        RadioButton *btn = [self.view viewWithTag:203+i];
        [btn addTarget:self action:@selector(handleUrgenctAction:) forControlEvents:UIControlEventTouchUpInside];
        UrgencyModel *model = self.urgencyArray[i];
        NSString *titStr = F(@"%@(%@天)", model.UrgencyName,model.UrgencyDays);
        [btn setTitle:titStr forState:UIControlStateNormal];
    }
    
}

-(void)handleUrgenctAction:(RadioButton *)sender{
    NSInteger index = sender.tag - 203;
    if (self.urgencyArray.count>=index+1) {
        UrgencyModel *model  = self.urgencyArray[index];
        
        NSString *str = [self.smessageLab.text substringFromIndex:16];
        NSString *urg = F(@"%@",model.UrgencyDays);
        if ([model.UrgencyDays integerValue] < 10) {
            urg = F(@" %@",model.UrgencyDays);
        }
        self.UrgencyIDstr = F(@"%@",model.UrgencyNumber);
        self.smessageLab.text = [F(@"紧急程度:%@,处理天数:%@天",model.UrgencyName,urg) stringByAppendingString:str];
//        self.smessageLab.text = F(@"紧急程度:%@,处理天数:%@天",model.UrgencyName,urg);
    } else {
        NSString *str = [self.smessageLab.text substringFromIndex:16];
        self.UrgencyIDstr = F(@"%@",@"4");
        self.smessageLab.text = [F(@"紧急程度:%@,处理天数: %@天",@"高",@"6") stringByAppendingString:str];
//        self.smessageLab.text = F(@"紧急程度:%@,处理天数: %@天",@"高",@"6");
    }
}


- (IBAction)handInAction:(id)sender {

    self.tfString =[NSString stringWithFormat:@"%@,%@",self.smessageLab.text,self.stextf.text];

    NSDate *date = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    dataFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dateStr = [dataFormatter stringFromDate:date];
    NSMutableString *Errstr = [[NSMutableString alloc]initWithCapacity:0];
 
    for (NSString *index in self.tyDic.allKeys) {
        if ([self.tyDic[index] isEqualToString:@"1"]) {
            
            NSString *str = self.ErrCotentDic.allValues[[index integerValue]];
            
            [Errstr appendFormat:@"%@,", str];
          
        }
    }

    if (self.smessageLab.text.length < 16) {
        [self alert:@"提示" message:@"请添加交办内容"];
    }else{
        NSString *textStr  = self.stextf.text;
        NSString *errcomnet = textStr.length > 0 ? F(@"%@;%@",[self.errcomnetArr componentsJoinedByString:@";"] ,textStr):[self.errcomnetArr componentsJoinedByString:@";"];
        NSString *errcodeStr = textStr.length > 0 ?  F(@"%@,%@",[Errstr substringToIndex:Errstr.length-1],@"9999"):[Errstr substringToIndex:Errstr.length-1];
        NSLog(@"siteIDsiteID---%@---%@---%@---%@---%@---%@---%@---%@---%@---%@---%@----%@",self.siteID,self.typeID,[Errstr substringToIndex:Errstr.length-1],self.UrgencyIDstr,dateStr,datamanager.UserID,datamanager.realNameStr,self.stationModel.OperationCompanyID,self.stationModel.OperationCompanyName,self.stationModel.OperationUserID,self.stationModel.OperationUserName,textStr);
        self.urlStr = F(@"%@/VillagePushManagement",BaseRequestUrl);
        NSDictionary *parrm = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"action",F(@"{SiteID:%@,AlarmType:%@,ErrCodeList:%@,ErrWarnTime:%@,Status:%@,PushStatus:%@,UrgencyID:%@,MsgType:%@,InsertDate:%@,PushUserID:%@,PushUserName:%@,ErrMsg:%@,OperationCompanyID:%@,OperationCompanyName:%@,OperationUserID:%@,OperationUserName:%@}", self.siteID,self.typeID,errcodeStr,dateStr,@"0",@"0",self.UrgencyIDstr,@"1",dateStr,datamanager.UserID,datamanager.realNameStr,errcomnet,@"0",@"0",@"0",@"运维"),@"method", nil];
        [gs_HttpManager httpManagerPostParameter:parrm toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"tgjmList" success:^(id result) {
            NSDictionary *dicData = result;
            NSString *status = F(@"%@", dicData[@"Status"]);
            
            if ([status isEqualToString:@"OK"]) {
                
              [YJProgressHUD showError:@"提交成功"];
                
            }else{
                 [YJProgressHUD showError:@"提交失败"];
            }
             
        } orFail:^(NSError *error) {
            NSLog(@"级列表%@", error);
          
              [YJProgressHUD showError:@"提交失败"];
        }];
        
    }
//    if ([MFMessageComposeViewController canSendText]) {
//        /** 创建短信界面(控制器*/
//        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc]init];
//        self.phoneNum = [[self.stationModel.PhoneNumber componentsSeparatedByString:@";"] mutableCopy];
//        controller.recipients = self.phoneNum;//短信接受者为一个NSArray数组
//        controller.body = [NSString stringWithFormat:@"%@的%@,你好我在站点巡检的时候发现你负责的%@站存在以下问题：%@",self.stationModel.OperationCompanyName,self.stationModel.OperationUserName,self.title,self.tfString];//短信内容
//        controller.messageComposeDelegate = self;
//        /** 取消按钮的颜色(附带,可不写) */
//        controller.navigationBar.tintColor = [UIColor redColor];
//        [self presentViewController:controller animated:YES completion:nil];
//    }else{
//        [self alert:@"提示" message:@"模拟器不支持发送短信"];
//    }
    //发送后台
    
  

}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            [self alert:@"提示" message:@"发送成功"];
            break;
        case MessageComposeResultFailed:
            [self alert:@"提示" message:@"发送失败"];
            break;
        case MessageComposeResultCancelled:
            [self alert:@"提示" message:@"发送取消"];
            break;
        default:
            break;
    }
    
}


- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([datamanager.tagString isEqualToString:@"51"]) {
        self.stextf.frame = CGRectMake((SCREEN_WIDTH-10)/3.0, 31, SCREEN_WIDTH-10-CGRectGetMaxX(self.photo.frame), (SCREEN_HEIGHT-215-64-IphoneX_TH-IphoneX_BH)/3.0-31);
      
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
