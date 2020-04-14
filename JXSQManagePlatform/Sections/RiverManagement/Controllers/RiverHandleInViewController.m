//
//  RiverHandleInViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverHandleInViewController.h"
#import "TaskDetailTableViewCell.h"

@interface RiverHandleInViewController ()<UITableViewDelegate,UITableViewDataSource,MKMessagePhotoViewDelegate>{
    DataSource *datamanger;
}
@property(nonatomic,strong)NSArray *titArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) MKMessagePhotoView *photosView;

@end

@implementation RiverHandleInViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    datamanger = [DataSource sharedDataSource];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configerBtn];
    _titArray = @[@"记录标号:",@"交办问题:",@"交办期限:",@"交办时间:"];
    [_tableView registerNib:[UINib nibWithNibName:@"TaskDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    
}
-(void)configerBtn{
    
    for (int i = 0; i < 3; i++) {
        UIButton *but = [self.footerView viewWithTag:105+i];
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 5;
    }
    self.handleContentTF.layer.borderColor = [UIColor grayColor].CGColor;
    self.handleContentTF.layer.borderWidth = 1.0f;
     [self.handleContentTF setPlaceholderWithText:@"请填写内容" Color:UIColorFromRGB(0xC7C7C7)];
    [self setUpPhotosView];
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section== 0) {
        UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WT, 10)];
        aview.backgroundColor = UIColorFromRGB(0xECEBEB);
        return aview;
    }else if(section==1){
       _footerView.frame = CGRectMake(0, 0, WT, 330);
         return _footerView;
    }
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
         return 10;
    }else{
        return 330;
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
       return self.dataArray.count;
    }else{
        return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titLab.text = self.titArray[indexPath.row];
    cell.contentLab.text = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark -相册视图
-(void)setUpPhotosView
{
    if (!self.photosView)
    {
        self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(10,0,WT-40, 90)];
        [self.pictureView addSubview: self.photosView];
        self.photosView.delegate = self;
    }
    
}
- (void)handlePictures{
    //上传图片
    NSArray *fileNameArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"fileName"];
    NSArray *imageDataArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"imageData"];
    NSString *fileNameStr;
    for (int i = 0; i < fileNameArr.count; i++) {
        [self uploadImageWithData:imageDataArr[i] filename:fileNameArr[i]];
        if (i==0) {
            fileNameStr = fileNameArr[0];
        }else{
            
            fileNameStr  =  [fileNameStr stringByAppendingString:[NSString stringWithFormat:@";%@",fileNameArr[i]]];
            
        }
       
    }
     [self handleInWithImage:fileNameStr];
}
//上传图片http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx?op=uploadResume
-(void)uploadImageWithData:(NSData *)fileData filename:(NSString *)filename{
  NSString* fileString = [fileData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];

    
    NSDictionary *param = @{
                            @"filename":filename,
                            @"image":fileString,
                            @"tag":@"10",
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:uploadImagePath isCacheorNot:NO targetViewController:self andUrlFunctionName:@"photo" success:^(id result) {
        [YJProgressHUD showSuccess:@"数据成功"];
//        NSLog(@"踩踩踩++++++++%@", result);
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
    
}
- (IBAction)handleInAction:(UIButton *)sender {
    //上报
    [self handlePictures];
    
}
- (IBAction)putInOverTimeAction:(UIButton *)sender {
    ///延期的天数
    [self alert:@"申请延期" message:nil];
    
}
- (IBAction)backAction:(UIButton *)sender {
    //返回
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alert.textFields.firstObject;
        [self applyForOverDay:userNameTextField.text];
    }];
    [alert addAction:OKAction];
    //定义第一个输入框；
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入延期天数";
    }];
    //增加取消按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}
//上报
-(void)handleInWithImage:(NSString *)imagefile {
    NSDictionary *param = @{
                            @"action":@"17",
                            @"method":F(@"{recordID:%@,dealImg:%@,dealResult:%@}",self.dataArray.firstObject,imagefile,self.handleContentTF.text)
                            };
    
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseRiverMURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"detailline" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
            [YJProgressHUD showSuccess:@"上报成功"];
        }else{
            [YJProgressHUD showSuccess:@"上报失败"];
        }
        
    } orFail:^(NSError *error) {
       [YJProgressHUD showSuccess:@"上报失败"];
    }];
    
}
//申请延期
//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx/RiverManagement?action=18&method={recordID:9,delay:2}
-(void)applyForOverDay:(NSString *)day{
    NSDictionary *param = @{
                            @"action":@"18",
                            @"method":F(@"{recordID:%@,delay:%@}",self.dataArray.firstObject,day)
                            };
    
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseRiverMURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"detailline" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]&&[dicData[@"Msg"]isEqualToString:@"成功"]) {
            [YJProgressHUD showSuccess:@"申请成功"];
        }else{
            [YJProgressHUD showSuccess:@"申请失败"];
        }

    } orFail:^(NSError *error) {
       [YJProgressHUD showSuccess:@"申请失败"];
    }];
    
}
//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)addUIImagePicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
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
