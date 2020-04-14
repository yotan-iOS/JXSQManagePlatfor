//
//  RiverTourReportViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverTourReportViewController.h"
#import "ReportOneTableViewCell.h"

#import "HXPhotoView.h"
#import "HXPhotoManager.h"
@interface RiverTourReportViewController ()<UITableViewDelegate, UITableViewDataSource,HXPhotoViewDelegate>
//UIImagePickerControllerDelegate UINavigationControllerDelegate
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *PatrolContentIDArr;
@property (nonatomic, strong) NSMutableArray *PatrolContentArr;


@property(nonatomic, strong)HXPhotoManager *photoManager;
@property(nonatomic, strong)HXPhotoView *postPhotoView;
//选择的图片
@property (nonatomic, strong) NSMutableArray *selectImgArray;
@property (nonatomic, strong) NSMutableArray *fileNameArray;//存取图片name
@property (nonatomic, strong) NSMutableArray *fileNameUrlArray;
@property (nonatomic, strong) NSMutableArray *fileDataArray; //存取base64数据
@property(nonatomic,assign)float imgHight;
@property(nonatomic,copy)NSString *rightIDStr;
@property(nonatomic,assign)NSInteger i_mycount;
@end

@implementation RiverTourReportViewController
- (NSMutableArray *)PatrolContentIDArr{
    if (!_PatrolContentIDArr) {
        self.PatrolContentIDArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _PatrolContentIDArr;
}
- (NSMutableArray *)PatrolContentArr{
    if (!_PatrolContentArr) {
        self.PatrolContentArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _PatrolContentArr;
}

// 如果页面加载过程需要读取数据, 则写在这个地方。
- (void)uploadInfoViewControllerData {
    self.selectImgArray = [NSMutableArray new];
    self.fileNameArray = [NSMutableArray new];
    self.fileNameUrlArray = [NSMutableArray new];
    self.fileDataArray = [NSMutableArray new];
    //初始化多选数组
    _selectIndexs = [NSMutableArray new];
    _selectContentIDArr = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"巡河上报";
     _imgHight = (WT-20)/3.0+15;
    //初始化多选数组
    [self uploadInfoViewControllerData];
    // Do any additional setup after loading the view from its nib.
    [self readDataRiverContent];
    NSLog(@"地址不知道 ============== %@+%@+%@", _AddressStr, _longitudeStr, _latitudeStr);
}

- (void)setCreatTabelView {
//      _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WT, 150)];
//      _photoImage.userInteractionEnabled = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, WT, HT-NAVIHEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xF9F9F9);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)readDataRiverContent {
    NSDictionary *param = @{
                            @"action":@"11",
                            @"method":F(@"{riverID:%@}", @"1"),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:BaseRiverMURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Content" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            for (NSDictionary *dic in dicData[@"Result"]) {
                [self.PatrolContentIDArr addObject:dic[@"PatrolContentID"]];
                [self.PatrolContentArr addObject:F(@"%@",dic[@"PatrolContent"]) ];
                if ([dic[@"PatrolContent"]isEqualToString:@"正常"]) {
                    self.rightIDStr = F(@"%@",dic[@"PatrolContentID"]);
                }
                
            }
            NSLog(@"%@",dicData[@"Result"]);
        }
        [self.tableView reloadData];
        NSLog(@"获取巡河上报的内容 ====%@", self.PatrolContentArr);
        [self setCreatTabelView];
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
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
#warning mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else if (indexPath.section == 1) {
        return 35;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            return _imgHight;
        } else {
            return 50;
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 1) {
            return 150;
        } else {
            return 50;
        }
    } else {
        return 60;
    }
}
#warning mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else if (section == 1) {
        return self.PatrolContentIDArr.count;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        return 2;
    } else {
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSource *dataSour = [DataSource sharedDataSource];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ReportOneTableViewCell *cell = [ReportOneTableViewCell ReportOneTableViewCell:self.tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.labTitle.text = dataSour.RiverName;
            cell.labTitle.textAlignment = NSTextAlignmentCenter;
            return cell;
        } else if (indexPath.row == 5){
            ReportOneTableViewCell *cell = [ReportOneTableViewCell ReportOneTableViewCell:self.tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.labTitle.text = @"   巡河信息(可多选):";
            return cell;
 
        } else {
            ReportTwoTableViewCell *cell = [ReportTwoTableViewCell ReportTwoTableViewCell:self.tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateTime = [formatter stringFromDate:[NSDate date]];
            if (indexPath.row == 1) {
                cell.shijianLabel.text = @"时间:";
                cell.timeLabel.text = dateTime;
            } else if (indexPath.row == 2) {
                cell.shijianLabel.text = @"巡河人:";
                cell.timeLabel.text = dataSour.realNameStr;
            } else if (indexPath.row == 3) {
                cell.shijianLabel.text = @"经度:";
                cell.timeLabel.text = _longitudeStr;
            } else if (indexPath.row == 4) {
                cell.shijianLabel.text = @"纬度:";
                cell.timeLabel.text = _latitudeStr;
            }
            
            return cell;
        }
    } else if (indexPath.section == 1) {
        NSString * cellid = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        ValidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ValidateTableViewCell_iPhone" owner:nil options:nil] firstObject];
            } else {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ValidateTableViewCell_iPad" owner:nil options:nil] firstObject];
            }
            
        }
        cell.nameRadio.text = self.PatrolContentArr[indexPath.row];
        cell.accessoryType = UIAccessibilityTraitNone;
        cell.imageView_check.hidden = NO;
        for (NSIndexPath *index in _selectIndexs) {
            if ([indexPath isEqual: index]) {
                cell.imageView_check.hidden = YES;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        return cell;
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            ReportOneTableViewCell *cell = [ReportOneTableViewCell ReportOneTableViewCell:self.tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.labTitle.text = @"   巡河照片:";
            return cell;
        } else if (indexPath.row == 1) {
            ReportPhotoTableViewCell *cell = [ReportPhotoTableViewCell ReportPhotoTableViewCell:self.tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
             [cell.contentView addSubview:self.postPhotoView];
            return cell;
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            ReportOneTableViewCell *cell = [ReportOneTableViewCell ReportOneTableViewCell:self.tableView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.labTitle.text = @"   照片描述:";
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *ID = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            PlaceholderTextView *textView = [[PlaceholderTextView alloc]init];
            textView.placeholderLabel.font = [UIFont systemFontOfSize:15];
            textView.placeholder = @"照片描述(100个字以内)";
            textView.font = [UIFont systemFontOfSize:15];
            textView.frame = CGRectMake(0, 0, WT, 150);
            textView.maxLength = 100;
            textView.layer.cornerRadius = 5.f;
            textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
            textView.layer.borderWidth = 0.5f;
            if (self.describe.length > 0) {
                textView.text = self.describe;
            }
            
            [cell addSubview:textView];
            
            [textView didChangeText:^(PlaceholderTextView *textView) {
                self.describe = textView.text;
                
                NSLog(@"描述=======%@===%@",self.describe, textView.text);
            }];
            return cell;
        }
    } else if (indexPath.section == 4) {

        ReportButtonTableViewCell *cell = [ReportButtonTableViewCell ReportButtonTableViewCell:self.tableView];
        self.cellClickBtn = @"0";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.clickBtn setTitle:@"上报" forState:UIControlStateNormal];
        [cell.clickBtn addTarget:self action:@selector(reportClickeBtn:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ValidateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) { //如果为选中状态
            cell.accessoryType = UITableViewCellAccessoryNone; //切换为未选中
            [_selectIndexs removeObject:indexPath]; //数据移除
            [_selectContentIDArr removeObject:self.PatrolContentIDArr[indexPath.row]];
            cell.imageView_check.hidden = NO;
            
        }else { //未选中
            cell.accessoryType = UITableViewCellAccessoryCheckmark; //切换为选中
            [_selectIndexs addObject:indexPath]; //添加索引数据到数组
            [_selectContentIDArr addObject:self.PatrolContentIDArr[indexPath.row]];
            cell.imageView_check.hidden = YES;
        }
         NSLog(@" %@============ %@", _selectIndexs, _selectContentIDArr);
    }
}
- (void)TakingPicturesClickeBtn:(UIButton *)sender {
}
- (void)reportClickeBtn:(UIButton *)sender {
    if ([self.cellClickBtn isEqualToString:@"0"]) {
        if (_selectContentIDArr.count > 0) {
            if ([self.selectContentIDArr containsObject:self.rightIDStr]) {
                if (self.describe.length <= 0) {
                    self.describe = @"";
                }
                  [self handlePictures]; 
            }else{
                if (self.describe.length > 0) {
                     [self handlePictures];
                }else{
                  
                    [YJProgressHUD showError:@"添加描述内容"];
                }
            }
          
        }else{
            [YJProgressHUD showError:@"添加上报内容"];
        }
    }
    
    
    
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
        self.postPhotoView.frame = CGRectMake(10, 10, WT-20, (WT-20)/3.0);
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
                
//                [self.fileNameUrlArray addObject:fileNameUrl];
//                NSString *fileStr = [NSString stringWithFormat:@"%@",fileNameUrl];
//                NSArray *array = [fileStr componentsSeparatedByString:@"IMG_"];
//                NSArray *last_arr = [array.lastObject componentsSeparatedByString:@"."];
//                NSString *nameImage = [NSString stringWithFormat:@"IMG_%@.JPG",[last_arr firstObject]];
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

- (void)handlePictures{
    //上传图片
    NSArray *fileNameArr = self.fileNameArray;
    NSArray *imageDataArr = self.fileDataArray;
    [CustomHUD showIndicatorWithStatus:@"正在努力上传图片..."];
    NSString *fileNameStr =  [fileNameArr componentsJoinedByString:@";"];
    self.i_mycount = 0;
    for (int i = 0; i < fileNameArr.count; i++) {
        [self uploadImageWithbase64Data:imageDataArr[i] filename:fileNameArr[i]];
    }
    self.upload_imgestr = fileNameStr;
    if (!self.upload_imgestr) {
        [CustomHUD dismiss];
//        self.cellClickBtn = @"1";
//        [self sendMyApiRequestWithImagePath:fileNameStr];
        [YJProgressHUD showError:@"请添加照片"];
    }

  
}
//上传图片http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx?op=uploadResume
- (void)uploadImageWithbase64Data:(NSString *)base64data filename:(NSString *)filename{
    NSDictionary *param = @{
                            @"filename":filename,
                            @"image":base64data,
                            @"tag":@"10",
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:uploadImagePath isCacheorNot:NO targetViewController:self andUrlFunctionName:@"photo" success:^(id result) {
        self.i_mycount++;
                NSLog(@"踩踩踩++++++++%@", result);
        if (self.i_mycount==self.fileNameArray.count) {
            self.cellClickBtn = @"1";
            [self sendMyApiRequestWithImagePath:self.upload_imgestr];
        }

    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"图片上传失败,请重新上报"];
        NSLog(@"%@", error);
        self.cellClickBtn = @"0";
        [CustomHUD dismiss];
    }];
    
}


- (void)sendMyApiRequestWithImagePath:(NSString *)imagePath {
     [CustomHUD dismiss];
    NSLog(@"+++++++++++++++ %@", self.describe);
    DataSource *dataSource = [DataSource sharedDataSource];
    NSDictionary *param = @{
                            @"action":@"10",
                            @"method":F(@"{riverID:%@,userID:%@,patrolContentID:%@,PatrolCheckID:%@,picPath:%@,describe:%@,Address:%@,longitude:%@,latitude:%@}", dataSource.RiverID, dataSource.UserID, [_selectContentIDArr componentsJoinedByString:@";"], self.CheckID, imagePath, self.describe, self.AddressStr, self.longitudeStr, self.latitudeStr),
                            };
    //http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx?op=RiverManagement
    //BaseRiverMURLStr
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/RiverManagement",RequestURL) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Content" success:^(id result) {
//        [YJProgressHUD showSuccess:@"上报成功"];
        [self showPrompt:@"信息上报成功!"];
        NSLog(@"成功----------------------- %@", result);
        self.cellClickBtn = @"0";
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"失败======%@", error);
        self.cellClickBtn = @"0";
        
    }];
}
- (void)showPrompt:(NSString *)promptrMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:promptrMsg preferredStyle:UIAlertControllerStyleAlert];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:true completion:nil];
}
@end
