//
//  HandOverViewController.m
//  Witwater
//
//  Created by 吴坤 on 16/12/5.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "HandOverViewController.h"
#import "MKComposePhotosView.h"
#import "MKMessagePhotoView.h"
#import "HandInOverTwoViewController.h"

#import "HXPhotoView.h"
#import "HXPhotoManager.h"

#define KWIDTH [UIScreen mainScreen].bounds.size.width
@interface HandOverViewController ()<MKMessagePhotoViewDelegate,UITextViewDelegate,NSXMLParserDelegate,HXPhotoViewDelegate>{
    DataSource *datamanager;

}

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic, strong) MKMessagePhotoView *photosView;
@property (nonatomic, strong)HandInOverTwoViewController *handTwo;
@property (nonatomic, strong)UILabel *lab;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, copy)NSString *labString;
@property(nonatomic,strong)NSMutableArray *photoNameArr;
@property (nonatomic, copy)NSString *fileNameStr;
@property(nonatomic,strong) NSArray *fileNameArr;


@property(nonatomic, strong)HXPhotoManager *photoManager;
@property(nonatomic, strong)HXPhotoView *postPhotoView;
//选择的图片
@property (nonatomic, strong) NSMutableArray *selectImgArray;
@property (nonatomic, strong) NSMutableArray *fileNameArray;//存取图片name
@property (nonatomic, strong) NSMutableArray *fileNameUrlArray;
@property (nonatomic, strong) NSMutableArray *fileDataArray; //存取base64数据
@end

@implementation HandOverViewController




-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
//-(NSMutableArray *)photoNameArr{
//    
//    if (!_photoNameArr) {
//        self.photoNameArr = [NSMutableArray arrayWithCapacity:1];
//    }
//    return _photoNameArr;
//}
// 如果页面加载过程需要读取数据, 则写在这个地方。
- (void)uploadInfoViewControllerData {
    self.selectImgArray = [NSMutableArray new];
    self.fileNameArray = [NSMutableArray new];
    self.fileNameUrlArray = [NSMutableArray new];
    self.fileDataArray = [NSMutableArray new];
    //初始化多选数组
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [CustomHUD dismiss];

   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self uploadInfoViewControllerData];
    // Do any additional setup after loading the view from its nib.
    datamanager  =[DataSource sharedDataSource];
    self.displayView.frame  = CGRectMake(0, NAVIHEIGHT+IphoneX_TH, self.view.frame.size.width , self.view.frame.size.height-NAVIHEIGHT-IphoneX_TH-IphoneX_BH);
    [self.view addSubview:self.displayView];
    [self configerViewCorner];
     [self setUpPhotosView];
    self.tfView.delegate = self;
    //    选中的颜色
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:nil size:16],NSFontAttributeName,nil];
    [_segement setTitleTextAttributes:dic forState:UIControlStateSelected];
    //    未选中的颜色
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x009FF2),UITextAttributeTextColor,[UIFont fontWithName:nil size:16],NSFontAttributeName,nil];
    _segement.tintColor = UIColorFromRGB(0x009FF2);
    [_segement setTitleTextAttributes:dics forState:UIControlStateNormal];
    [self getData];
}
-(void)configerViewCorner{
    
    self.contenView.layer.borderWidth = 1;
    self.contenView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contenView.layer.masksToBounds = YES;
    self.contenView.layer.cornerRadius = 5;
    
    self.pictureView.layer.borderWidth = 1;
    self.pictureView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pictureView.layer.masksToBounds = YES;
    self.pictureView.layer.cornerRadius = 5;
    
//
    
}

#pragma mark -相册视图
-(void)setUpPhotosView
{
//    if (!self.photosView)
//    {
//
//        self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(0,30,WT, 80)];
//        [self.pictureView addSubview:self.photosView];
//
//        self.photosView.delegate = self;
//    }
//
   [self.pictureView addSubview:self.postPhotoView];
}

//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)addUIImagePicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

- (IBAction)selectHandAndInAction:(id)sender {
 
    
    UISegmentedControl* control = (UISegmentedControl*)sender;
    
    switch (control.selectedSegmentIndex) {
        case 0:
            
        {
            self.handTwo.view.hidden = YES;
           
        }
            break;
            
        default:
        {
            if (!self.handTwo) {
                _handTwo = [[HandInOverTwoViewController alloc]init];
                [self addChildViewController:_handTwo];
                
                [self.view addSubview:_handTwo.view];
                _handTwo.model = self.model;
              
            }

            self.handTwo.view.hidden = NO;
        }
            break;
    }

}


-(void)getData{
    CGFloat h = 0 ;
    if (WT > 414) {
        h  = WT;
    }else{
        h = 1.5*WT;
    }
    self.myScroller.contentSize = CGSizeMake(h ,self.myScroller.frame.size.height);
   _lab = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0, h, self.myScroller.frame.size.height)];
    _lab.font = [UIFont systemFontOfSize:15];
    [self.myScroller addSubview:_lab];
    self.dateTimeLab.text = F(@"%@", [[self.model.InsertDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19]);
    self.dueTimeLab.text = F(@"%@",[self.model.DealEndTime stringByReplacingOccurrencesOfString:@"T" withString:@" "]);
    _lab.text  = self.errcontentStr;

   
}
- (IBAction)upDataToyu:(id)sender {

//    NSArray *imageDataArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"imageData"];
    if (self.fileDataArray.count > 0) {
        [self sendUploadPhotos];
    } else {
        [YJProgressHUD showError:@"请先拍照或选取照片"];
    }

    
}
- (void)sendUploadPhotos {
    //上传图片
    [CustomHUD showIndicatorWithStatus:@"正在上传。。。"];

//    self.fileNameArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"fileName"];
//    NSArray *imageDataArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"imageData"];
    for (int i = 0; i < self.fileDataArray.count; i++) {
        [self uploadImageWithData:self.fileDataArray[i] filename:self.fileNameArray[i] count:i+1];
        
    }
}

-(void)delingAction{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dateStr = [dateFormater stringFromDate:date];

    _fileNameStr = [_fileNameArray componentsJoinedByString:@";"];
    NSString *delyStr = @"0";
    NSString *dalyDays = @"0";
    if ([F(@"%@",self.model.PushStatus) isEqualToString:@"22"]) {
        delyStr = F(@"%@",self.model.DelayTag);
        dalyDays = F(@"%@",self.model.DelayDays);
    }
    self.urlStr = F(@"%@/VillagePushManagement",BaseRequestUrl);
   
    NSDictionary *param =   [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"action", F(@"{ID:%@,StatusBefore:%@,Status:%@,PushStatus:%@,OperationUserDoTime:%@,ImgPath:%@,DelayTag:%@,DelayDays:%@,Describe:%@,UpdUser:%@}",F(@"%@",self.model.PushID),F(@"%@",self.model.PushStatus),@"1",@"2",dateStr,_fileNameStr,delyStr,dalyDays,self.tfView.text,datamanager.UserID),@"method", nil];

    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"errList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        
        if ([status isEqualToString:@"OK"]) {
            [YJProgressHUD showError:@"上报成功"];
            
        }else{
            [YJProgressHUD showError:@"申请失败"];
        }
        
        [CustomHUD dismiss];

        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"上报失败"];
         [CustomHUD dismiss];

        
    }];
    

}

-(void)uploadImageWithData:(NSString *)fileData filename:(NSString *)filename count:(int)count{
    
//    self.photoNameArr = [NSMutableArray arrayWithCapacity:1];
//    NSString *fileString = [fileData base64Encoding];
    NSDictionary *param = @{
                            @"filename":filename,
                            @"image":fileData,
                            @"tag":@"10",
                            };
    
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:uploadImagePath isCacheorNot:NO targetViewController:self andUrlFunctionName:@"photo" success:^(id result) {
        
        //                NSLog(@"踩踩踩++++++++%@", result);
             if (count==_fileNameArray.count) {
                 [YJProgressHUD showSuccess:@"图片上传成功"];
                 [self delingAction];
             }
        
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
     
    }];
    
}



- (IBAction)unDone:(id)sender {
     [self alert:@"提示" message:@"确定不做处理？"];
}


-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0 )
    {
        _placeHolderLabel.text = @"请添加交办内容";
    }
    else
    {
        _placeHolderLabel.text = @"";
    }
}

- (void)alert:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        dateFormater.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        NSString *dateStr = [dateFormater stringFromDate:date];
        self.urlStr = F(@"%@/VillagePushManagement",BaseRequestUrl);
        NSDictionary *param =   [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"action", F(@"{ID:%@,StatusBefore:%@,Status:%@,PushStatus:%@,OperationUserDoTime:%@,ImgPath:%@,DelayTag:%@,DelayDays:%@,Describe:%@,UpdUser:%@}",F(@"%@",self.model.PushID),F(@"%@",self.model.PushStatus),@"1",@"11",dateStr,@"",@"",@"",self.tfView.text,datamanager.UserID),@"method", nil];
        [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"errList" success:^(id result) {
            NSDictionary *dicData = result;
            NSString *status = F(@"%@", dicData[@"Status"]);
            
            if ([status isEqualToString:@"OK"]) {
                [YJProgressHUD showError:@"提交成功"];
                
            }
        } orFail:^(NSError *error) {
            NSLog(@"级列表%@", error);
            [YJProgressHUD showError:@"提交失败"];
        }];
        
        
    }];
    [alert addAction:ok];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -相册视图

-(HXPhotoManager *)photoManager{
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.openCamera = YES;
        _photoManager.cacheAlbum = YES;
        _photoManager.lookLivePhoto = NO;
        _photoManager.outerCamera = YES;
        _photoManager.open3DTouchPreview = NO;
        _photoManager.cameraType = HXPhotoManagerCameraTypeSystem;
        _photoManager.photoMaxNum =3;
        _photoManager.maxNum = 3;
        _photoManager.saveSystemAblum = NO;
        _photoManager.selectTogether = NO;
        _photoManager.UIManager.navBar = ^(UINavigationBar *navBar) {
            navBar.translucent = NO;
            [navBar setBarTintColor:UIColorFromRGB(0x25293c)];
        };
        _photoManager.UIManager.navLeftBtnTitleColor = UIColorFromRGB(0xffffff);
        _photoManager.UIManager.navRightBtnNormalBgColor = UIColorFromRGB(0x6d75a4);
        _photoManager.UIManager.navTitleColor = UIColorFromRGB(0xffffff);
        _photoManager.UIManager.fullScreenCameraNextBtnBgColor = UIColorFromRGB(0x6d75a4);
    }
    return _photoManager;
}

-(HXPhotoView *)postPhotoView{
    if (!_postPhotoView) {
        _postPhotoView = [HXPhotoView photoManager:self.photoManager];
        self.postPhotoView.frame = CGRectMake(5, 32, WT-20, (WT-20)/3.0);
        _postPhotoView.delegate = self;
        _postPhotoView.Spacing = kFit(5);
        _postPhotoView.LineNum = 3;
        _postPhotoView.backgroundColor = [UIColor whiteColor];
    }
    return _postPhotoView;
}
#pragma mark- HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    [self.selectImgArray removeAllObjects];
    if (self.fileNameArray.count > 0){
        [self.fileNameArray removeAllObjects];
    }
    if (self.fileNameUrlArray.count > 0) {
        [self.fileNameUrlArray removeAllObjects];
    }
    
    if (self.fileDataArray.count > 0) {
        [self.fileDataArray removeAllObjects];
    }
    // 判断照片、视频 或 是否是通过相机拍摄的
    [allList enumerateObjectsUsingBlock:^(HXPhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.type == HXPhotoModelMediaTypeCameraVideo) {
            // 通过相机录制的视频
        }else if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
            // 通过相机拍摄的照片
            if (model.previewPhoto) {
                NSData *uploadData = UIImageJPEGRepresentation(model.previewPhoto, 0.2);
                [self.selectImgArray addObject: uploadData];
                NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
                dateformate.dateFormat = @"yyyyMMddHHmmss";
                NSString*nameImage = [dateformate stringFromDate:[NSDate date]];
                [self.fileNameArray addObject: F(@"IMG_%@.PNG",nameImage)];
                NSString *fileString = [uploadData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
                [self.fileDataArray addObject:fileString];
            }else if (model.thumbPhoto) {
                NSData *uploadData = UIImageJPEGRepresentation(model.thumbPhoto, 0.2);
                [self.selectImgArray addObject: uploadData];
                NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
                dateformate.dateFormat = @"yyyyMMddHHmmss";
                NSString*nameImage = [dateformate stringFromDate:[NSDate date]];
                [self.fileNameArray addObject: F(@"IMG_%@.PNG",nameImage)];
                NSString *fileString = [uploadData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
                [self.fileDataArray addObject:fileString];
            }
        }else if (model.type == HXPhotoModelMediaTypePhoto) {
            // 相册里的照片
            [HXPhotoTools FetchPhotoDataForPHAsset:model.asset completion:^(NSData *imageData, NSDictionary *info) {
                [self.selectImgArray addObject:imageData];
                NSURL *fileNameUrl = [info objectForKey: @"PHImageFileURLKey"];
                
                NSString *fileStr;
                
                NSString *suffix = [fileNameUrl pathExtension];
                if ([suffix isEqualToString:@"heic"]||[suffix isEqualToString:@"heif"]||[suffix isEqualToString:@"HEIF"] || [suffix isEqualToString:@"HEIC"]) {
                    NSURL *nameUrl;
                    if ([suffix isEqualToString:@"heic"]) {
                        nameUrl = [NSURL URLWithString:[[fileNameUrl absoluteString] stringByReplacingOccurrencesOfString:@"heic" withString:@"jpg"]];
                    } else if ([suffix isEqualToString:@"heif"]) {
                        nameUrl = [NSURL URLWithString:[[fileNameUrl absoluteString] stringByReplacingOccurrencesOfString:@"heif" withString:@"jpg"]];
                    } else if ([suffix isEqualToString:@"HEIF"]) {
                        nameUrl = [NSURL URLWithString:[[fileNameUrl absoluteString] stringByReplacingOccurrencesOfString:@"HEIF" withString:@"jpg"]];
                    } else if ([suffix isEqualToString:@"HEIC"]) {
                        nameUrl = [NSURL URLWithString:[[fileNameUrl absoluteString] stringByReplacingOccurrencesOfString:@"HEIC" withString:@"jpg"]];
                    }
                    [self.fileNameUrlArray addObject:nameUrl];
                    fileStr = [NSString stringWithFormat:@"%@",nameUrl];
                } else {
                    [self.fileNameUrlArray addObject:fileNameUrl];
                    fileStr = [NSString stringWithFormat:@"%@",fileNameUrl];
                }
                
                NSArray *array = [fileStr componentsSeparatedByString:@"IMG_"];
                NSString *nameImage = [NSString stringWithFormat:@"IMG_%@",[array lastObject]];
                [self.fileNameArray addObject:nameImage];
                
//                [self.fileNameUrlArray addObject:fileNameUrl];
//                NSString *fileStr = [NSString stringWithFormat:@"%@",fileNameUrl];
//                NSArray *array = [fileStr componentsSeparatedByString:@"IMG_"];
//                NSString *nameImage = [NSString stringWithFormat:@"IMG_%@",[array lastObject]];
//                [self.fileNameArray addObject:nameImage];
                NSString *fileString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
                [self.fileDataArray addObject:fileString];
            }];
        }else if (model.type == HXPhotoModelMediaTypePhotoGif) {
            // 相册里的GIF图
            [HXPhotoTools FetchPhotoDataForPHAsset:model.asset completion:^(NSData *imageData, NSDictionary *info) {
                [self.selectImgArray addObject:imageData];
                NSURL *fileNameUrl = [info objectForKey: @"PHImageFileURLKey"];
                [self.fileNameUrlArray addObject:fileNameUrl];
                NSString *fileStr = [NSString stringWithFormat:@"%@",fileNameUrl];
                NSArray *array = [fileStr componentsSeparatedByString:@"IMG_"];
                NSString *nameImage = [NSString stringWithFormat:@"IMG_%@",[array lastObject]];
                [self.fileNameArray addObject:nameImage];
                NSString *fileString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
                [self.fileDataArray addObject:fileString];
            }];
        }else if (model.type == HXPhotoModelMediaTypeLivePhoto) {
            // 相册里的livePhoto
            [self fetchImageWithAsset:model.asset imageBlock:^(NSData *imageData) {
                [self.selectImgArray addObject:imageData];
                NSString *fileString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
                [self.fileDataArray addObject:fileString];
            }];
        }
    }];
}


/** 通过资源获取图片的数据 @param mAsset 资源文件 @param imageBlock 图片数据回传 */
- (void)fetchImageWithAsset:(PHAsset*)mAsset imageBlock:(void(^)(NSData*))imageBlock {
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (orientation != UIImageOrientationUp) {
            UIImage* image = [UIImage imageWithData:imageData];
            //            image = [image fixOrientation]; // 新的 数据信息 （不准确的）
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        // 直接得到最终的 NSData 数据
        if (imageBlock) {
            imageBlock(imageData);
            
        } }];
    
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"networkPhotoUrl--------%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"frame----%@",NSStringFromCGRect(frame));
    //    self.postPhotoView.frame = frame;
    //    _imgHight = frame.size.height+15;
    //    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:2];
    //    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
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
