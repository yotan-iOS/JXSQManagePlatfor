//
//  GSPViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2018/7/20.
//  Copyright © 2018年 yotan. All rights reserved.
//

#import "GSPViewController.h"
#import "DMDropDownMenu.h"
#import "HXPhotoView.h"
#import "GSPModel.h"
//#import "YZLocationManager.h"
@interface GSPViewController ()<BMKGeoCodeSearchDelegate,DMDropDownMenuDelegate,HXPhotoViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
{
//    CLLocationManager *locationManager;
    DataSource *dataManger;
}
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic, strong)UIScrollView *bgScrollView;
@property(nonatomic, strong)UIView *backGroundView;
@property(nonatomic, strong)UILabel *addressLabel;
@property(nonatomic, strong)UILabel *jWlable;
@property(nonatomic, strong)UILabel *userLabel;
@property(nonatomic, strong)HXPhotoManager *photoManager;
@property(nonatomic, strong)HXPhotoView *postPhotoView;
@property(nonatomic, strong)UIButton *sendButton;
//选择的图片
@property (nonatomic, strong) NSMutableArray *selectImgArray;
@property (nonatomic, strong) NSMutableArray *fileNameArray;//存取图片name
@property (nonatomic, strong) NSMutableArray *fileNameUrlArray;
@property (nonatomic, strong) NSMutableArray *fileDataArray; //存取base64数据

@property (nonatomic, copy)NSString *imageBase64Str;
//@property (nonatomic, strong) YZLocationManager *manager;
@property (nonatomic, copy) NSString *DetailedAddressStr;
@property (nonatomic, copy) NSString *latitudeStr;
@property (nonatomic, copy) NSString *longitudeStr;

@property(nonatomic,strong)DMDropDownMenu *dropTownMeu;
@property (nonatomic,strong)NSArray *riverDArr;
@property (nonatomic,copy)NSString *riverID;
@property (nonatomic,assign)BOOL isUpload;
@property (nonatomic,assign)BOOL isReUpload;
@property (nonatomic,copy)NSString *listIDstr;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;

@end

@implementation GSPViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    dataManger = [DataSource sharedDataSource];
    [self uploadInfoViewControllerData];
    [self sendRequestForData];

    //初始化BMKLocationService
//    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
//    _geoCodeSearch.delegate = self;
 
   _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService setDesiredAccuracy:kCLLocationAccuracyBest];//设置定位精度
       //启动LocationService
    [_locService startUserLocationService];

}

// 如果页面加载过程需要读取数据, 则写在这个地方。
- (void)uploadInfoViewControllerData {
    self.selectImgArray = [NSMutableArray new];
    self.fileNameArray = [NSMutableArray new];
    self.fileNameUrlArray = [NSMutableArray new];
    self.fileDataArray = [NSMutableArray new];
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _bgScrollView.backgroundColor = [UIColor whiteColor];
//        self.bgScrollView.frame = CGRectMake(0, 64, WT, HT-64);
        if (@available(iOS 11.0, *)) {
            self.bgScrollView.frame = CGRectMake(0, NAVIHEIGHT, WT, HT-NAVIHEIGHT);
        }else {
            self.bgScrollView.frame = CGRectMake(0, 0, WT, HT-NAVIHEIGHT);
        }
        [self.view addSubview:_bgScrollView];
    }
    return _bgScrollView;
}

-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor grayColor];
        _addressLabel.font = [UIFont systemFontOfSize:16];
        [self.backGroundView addSubview:_addressLabel];
        
    }
    return _addressLabel;
}

-(UILabel *)userLabel{
    if (!_userLabel) {
        _userLabel = [[UILabel alloc]init];
        _userLabel.textColor =  [UIColor grayColor];
        _userLabel.font = [UIFont systemFontOfSize:16];
        [self.backGroundView addSubview:_userLabel];
        
    }
    return _userLabel;
}


-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"上 传" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:UIColorFromRGB(0x6495ed)];
        _sendButton.clipsToBounds = YES;
        _sendButton.layer.cornerRadius = 8;
        [_sendButton addTarget:self action:@selector(upLoadInfoDataWithSendButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendButton;
}


-(void)configerSubUI{
    
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, self.bgScrollView.frame.size.width-30, HT-30-NAVIHEIGHT)];//
    _backGroundView.backgroundColor = [UIColor whiteColor];
    _backGroundView.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
    _backGroundView.layer.borderWidth = 0.6;
    _backGroundView.layer.cornerRadius = 5;
    [self.bgScrollView addSubview:_backGroundView];
    
    UILabel *townLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 50, 30)];
    townLab.text = @"河道：";
    townLab.textAlignment = NSTextAlignmentLeft;
    townLab.textColor = [UIColor grayColor];
    townLab.font = [UIFont systemFontOfSize:16];
    [self.backGroundView addSubview:townLab];
    self.dropTownMeu = [[DMDropDownMenu alloc]initWithFrame:CGRectMake(CGRectGetMaxX(townLab.frame),  15, (WT-135)/2.0,30)];
    self.dropTownMeu.delegate = self;
    [self.backGroundView addSubview:self.dropTownMeu];
    NSMutableArray *tarr = [NSMutableArray new];
    NSMutableArray *tDarr = [NSMutableArray new];
    for (GSPModel *model in self.riverDArr) {
        [tarr addObject:model.RiverName];
        [tDarr addObject:model.RiverID];
    }
    self.riverID = tDarr.firstObject;
    [self.dropTownMeu setListArray:tarr];
    [self isUploadGSP];
    UILabel *addressDescLabel = [[UILabel alloc]init];
    addressDescLabel.frame = CGRectMake(5, CGRectGetMaxY(townLab.frame)+15, 50, 30);
    addressDescLabel.text = @"地址：";
    addressDescLabel.textAlignment = NSTextAlignmentLeft;
    addressDescLabel.textColor = [UIColor grayColor];
    addressDescLabel.font = [UIFont systemFontOfSize:16];
    [self.backGroundView addSubview:addressDescLabel];
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(addressDescLabel.frame)+5,CGRectGetMaxY(townLab.frame)+15,WT- 40-50, 30);
    self.addressLabel.text = @"获取定位中...";
    
    UILabel *userDescLabel = [[UILabel alloc]init];
    userDescLabel.frame = CGRectMake(5, CGRectGetMaxY(addressDescLabel.frame)+12,50, 30);
    userDescLabel.text = @"用户：";
    userDescLabel.textAlignment = NSTextAlignmentLeft;
    userDescLabel.textColor = [UIColor grayColor];
    userDescLabel.font = [UIFont systemFontOfSize:16];
    [self.backGroundView addSubview:userDescLabel];
    self.userLabel.text = dataManger.realNameStr;
    self.userLabel.frame = CGRectMake(CGRectGetMaxX(userDescLabel.frame)+5, CGRectGetMaxY(addressDescLabel.frame)+12,WT-90, 30);
    
    UILabel *jWlab = [[UILabel alloc]init];
    jWlab.frame = CGRectMake(5, CGRectGetMaxY(userDescLabel.frame)+12,68, 30);
    jWlab.text = @"经纬度：";
    jWlab.textAlignment = NSTextAlignmentLeft;
    jWlab.textColor = [UIColor grayColor];
    jWlab.font = [UIFont systemFontOfSize:16];
    [self.backGroundView addSubview:jWlab];
    _jWlable = [[UILabel alloc]init];
    _jWlable.frame = CGRectMake(CGRectGetMaxX(jWlab.frame)+5, CGRectGetMaxY(userDescLabel.frame)+12,WT-100, 30);
    _jWlable.textAlignment = NSTextAlignmentLeft;
    _jWlable.textColor = [UIColor grayColor];
    _jWlable.font = [UIFont systemFontOfSize:16];
    [self.backGroundView addSubview:_jWlable];
    
    UILabel *uploadeDescLabel = [[UILabel alloc]init];
    uploadeDescLabel.frame =CGRectMake( 5, CGRectGetMaxY(jWlab.frame)+12,WT-40, 30);
    uploadeDescLabel.text = @"上传图片：";
    uploadeDescLabel.textAlignment = NSTextAlignmentLeft;
    uploadeDescLabel.textColor = [UIColor grayColor];
    uploadeDescLabel.font = [UIFont systemFontOfSize:16];
    [self.backGroundView addSubview:uploadeDescLabel];
    [self.backGroundView addSubview:self.postPhotoView];
    self.postPhotoView.frame =CGRectMake( 5, CGRectGetMaxY(uploadeDescLabel.frame)+12,WT-50, 100);
    [self.backGroundView addSubview:self.sendButton];
    self.sendButton.frame = CGRectMake(110, CGRectGetMaxY(self.postPhotoView.frame) + 50, WT - 220, 44);
}

-(HXPhotoManager *)photoManager{
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.openCamera = YES;
        _photoManager.cacheAlbum = YES;
        _photoManager.lookLivePhoto = NO;
        _photoManager.outerCamera = YES;
        _photoManager.open3DTouchPreview = NO;
        _photoManager.cameraType = HXPhotoManagerCameraTypeSystem;
        _photoManager.photoMaxNum =1;
        _photoManager.maxNum = 1;
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
                
                //   NSString *fileStr = [NSString stringWithFormat:@"%@",fileNameUrl];
                NSArray *array = [fileStr componentsSeparatedByString:@"IMG_"];
                NSString *nameImage = [NSString stringWithFormat:@"IMG_%@",[array lastObject]];
                [self.fileNameArray addObject:nameImage];
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
    NSSLog(@"%@",NSStringFromCGRect(frame));
}

-(void)sendPictureDataRequest{
    [CustomHUD showIndicatorWithStatus:@"正在上传请等待..."];
    _imageBase64Str = self.fileDataArray.firstObject;
    NSString *fileName = self.fileNameArray.firstObject;
    NSDictionary *param = @{
                            @"filename":fileName,
                            @"image":_imageBase64Str,
                            @"tag":@"10",
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:uploadImagePath isCacheorNot:NO targetViewController:self andUrlFunctionName:@"photo" success:^(id result) {
        [self sendRequestDataImageName:fileName];
        
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        [CustomHUD dismiss];
        NSLog(@"%@", error);
        
    }];
}

-(void)upLoadInfoDataWithSendButton{
    if (self.isUpload) {
        if (_longitudeStr.length==0) {
            [YJProgressHUD showError:@"定位失败,请重新定位"];
            return;
        }
        if (_fileDataArray.count==0) {
            [YJProgressHUD showError:@"请先添加上传照片"];
            return;
        }else{
        
            [self sendPictureDataRequest];
           
        }
    }
   
}
-(void)sendRequestDataImageName:(NSString *)imageName{
    [CustomHUD dismiss];
    NSDictionary *param;
      if (self.isReUpload) {
           param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"action",F(@"{ID:%@,BulletinBoardLon:%@,BulletinBoardLat:%@,BulletinBoardImage:%@,AddUser:%@}",self.listIDstr,self.longitudeStr,self.latitudeStr,imageName,dataManger.UserID),@"method", nil];
      }else{
           param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"action",F(@"{RiverID:%@,BulletinBoardLon:%@,BulletinBoardLat:%@,BulletinBoardImage:%@,AddUser:%@}",self.riverID,self.longitudeStr,self.latitudeStr,imageName,dataManger.UserID),@"method", nil];
      }
  
//    NSDictionary *param = @{@"action":@"1",@"method":F(@"{RiverID:%@,BulletinBoardLon:%@,BulletinBoardLat:%@,BulletinBoardImage:%@,AddUser:%@}",self.riverID,self.longitudeStr,self.latitudeStr,imageName,dataManger.UserID)};
   
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/BulletinBoardManage", RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"oork" success:^(id result) {
        NSDictionary *dicData = result;
        
        if ([F(@"%@",dicData[@"Status"]) isEqualToString:@"OK"]&&[dicData[@"Msg"] isEqualToString:@"成功"]) {
            _isUpload = NO;
            [_sendButton setTitle:@"已上传" forState:UIControlStateNormal];
            [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sendButton setBackgroundColor:UIColorFromRGB(0x9F9F9F)];
            [YJProgressHUD showSuccess:@"上报成功"];
        } else {
            [YJProgressHUD showError:@"上报失败"];
        }
    } orFail:^(NSError *error) {
        NSLog(@"二级列表%@", error);
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
    }];
    
}

//获取站点
-(void)sendRequestForData{
    NSDictionary *param = @{
                            @"userid":dataManger.UserID};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/GetRiverLongByUser", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"ssID" success:^(id result) {
        NSLog(@"选择那条河---%@",result);
        NSMutableArray *reverArray = [NSMutableArray new];
        if ([result[@"Status"] isEqualToString:@"OK"]&&[result[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in result[@"Data"]) {
                GSPModel *model = [[GSPModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [reverArray addObject:model];
            }
            
        }
        
        self.riverDArr = reverArray;
        [self configerSubUI];
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}


#pragma mark - DMDropDownMenuDelegate Delegate
- (void)selectIndex:(NSInteger)index AtDMDropDownMenu:(DMDropDownMenu *)dmDropDownMenu {
    NSMutableArray *tDarr = [NSMutableArray new];
    for (GSPModel *model in self.riverDArr) {
        [tDarr addObject:model.RiverID];
    }
    self.riverID = tDarr[index];
    [self isUploadGSP];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _locService.delegate = nil;
//    _geoCodeSearch.delegate = nil;
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

- (void)reverseGeoCodeCoordinate:(CLLocationCoordinate2D)coordinate{
    
    BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reversegeoCode = [[BMKReverseGeoCodeOption alloc]init];
    reversegeoCode.reverseGeoPoint = coordinate;
    BOOL flag = [geoCodeSearch reverseGeoCode:reversegeoCode];
    if (flag) {
        NSLog(@"反检索成功");
    }
    else
    {
        NSLog(@"反检索失败");
    }
}
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    self.longitudeStr  = F(@"%f", userLocation.location.coordinate.longitude);
    self.latitudeStr  = F(@"%f",  userLocation.location.coordinate.latitude);
    
    [self reverseGeoCodeCoordinate:userLocation.location.coordinate];
    [self.locService stopUserLocationService];
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.addressLabel.text = result.address;
        _jWlable.text = F(@"%@,%@",self.longitudeStr,self.latitudeStr);
    } else{
        self.addressLabel.text = @"未知位置";
    }
    
}


//p判断是否上传
-(void)isUploadGSP{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"action",F(@"{RiverID:%@,AddUser:%@}",self.riverID,dataManger.UserID),@"method", nil];
   
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/BulletinBoardManage", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"lisID" success:^(id result) {
  
        NSMutableArray *listArray = [NSMutableArray new];
        if ([result[@"Status"] isEqualToString:@"OK"]&&[result[@"Msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *dic in result[@"Result"]) {
                GSPModel *model = [[GSPModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [listArray addObject:model];
            }
        }
        _isReUpload = NO;
        _isUpload = YES;
        if (listArray.count > 0) {
            self.listIDstr = ((GSPModel *)listArray.firstObject).ID;
            [_sendButton setTitle:@"已上传" forState:UIControlStateNormal];
            [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sendButton setBackgroundColor:UIColorFromRGB(0x9F9F9F)];
            [self alert:@"提示" message:@"该河道公示牌已上传是否重新上传?"];
        }
    } orFail:^(NSError *error) {
       
        if (!self.riverID) {
             _isUpload = NO;
             [_sendButton setBackgroundColor:UIColorFromRGB(0x9F9F9F)];
              [YJProgressHUD showError:@"当前用户无上传权限"];
        }
        NSLog(@"%@", error);
    }];
}

- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tureanction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_sendButton setTitle:@"重新上传" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:UIColorFromRGB(0x6495ed)];
        self.isReUpload = YES;
        self.isUpload = YES;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isUpload  = NO;
    }];
    [alert addAction:tureanction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
