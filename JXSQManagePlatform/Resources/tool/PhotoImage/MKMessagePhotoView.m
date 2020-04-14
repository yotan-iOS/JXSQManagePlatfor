//
//  MKMessagePhotoView.h
//
//  Created by Mory on 16/3/12.
//  Copyright © 2016年 MCWonders. All rights reserved.
//


#import "MKMessagePhotoView.h"
//#import "UploadImageManager.h"
#define ItemWidth ([UIScreen mainScreen].bounds.size.width-40) / 3.0
#define ItemHeight 100

//图片路径
#define  ImagePath  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Documents"]
#define KWIDTH [UIScreen mainScreen].bounds.size.width

@interface MKMessagePhotoView ()
{
    NSInteger MaxItemCount;
}
/**
 *  这是背景滚动视图
 */
@property (nonatomic,strong) UIScrollView  *photoScrollView;
@property (nonatomic ,strong)MKComposePhotosView *photoItem;
@property (nonatomic, strong )NSMutableArray *array;
@property (nonatomic,strong) NSMutableArray *imgsArr;
@property (nonatomic,strong) NSMutableArray *imagePath;
@property (nonatomic,strong) NSMutableArray *imageDataArr;
@end
static int k = 10000;
@implementation MKMessagePhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    

    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH-40, 100)];
    _photoScrollView.contentSize = CGSizeMake(WT*2, 90);
    _itemArray = [NSMutableArray arrayWithCapacity:0];
    _array = [NSMutableArray arrayWithCapacity:0];
    _imgsArr = [NSMutableArray arrayWithCapacity:0];
    _imagePath = [NSMutableArray arrayWithCapacity:0];
    _imageDataArr = [NSMutableArray arrayWithCapacity:0];
    [self addSubview:_photoScrollView];
    
    [self initlizerScrollView:_array];
}

///调用布局
-(void)initlizerScrollView:(NSArray *)imgList{
   
        MaxItemCount = 5;
     ///移除之前添加的图片缩略图
     [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     for(int i=0;i<imgList.count;i++){
     
     _photoItem = [[MKComposePhotosView alloc]initWithFrame:CGRectMake(5+ i * (ItemWidth+10), 5, ItemWidth+10 , ItemHeight)];
     _photoItem.delegate = self;
     _photoItem.index = i;
     _photoItem.image = (UIImage *)[imgList objectAtIndex:i];
     [self.photoScrollView addSubview:_photoItem];
     [self.itemArray addObject:_photoItem];
     }
     if(imgList.count<MaxItemCount){
     UIButton *btnphoto=[UIButton buttonWithType:UIButtonTypeCustom];
     [btnphoto setFrame:CGRectMake((ItemWidth+15) * imgList.count+5, 5, 80, 90)];//
     [btnphoto setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
     [btnphoto setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateSelected];
     [btnphoto addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
     [self.photoScrollView addSubview:btnphoto];
     }
     
     NSInteger count = MIN(imgList.count +1, MaxItemCount);
     NSUserDefaults *imgPath = [NSUserDefaults standardUserDefaults];
     [imgPath setInteger:count forKey:@"imagecount"];
     [imgPath synchronize];
     [self.photoScrollView setContentSize:CGSizeMake(5 + (ItemWidth)*count, 0)];

    
    
}
-(void)openMenu{

    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"打开相册", nil];
//,@"从手机相册获取"
    myActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [myActionSheet showInView:self];

    
    
}
//下拉菜单的点击响应事件
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if(buttonIndex == myActionSheet.cancelButtonIndex){
//        NSLog(@"取消");
//    }
//    switch (buttonIndex) {
//        case 0:
//            [self takePhoto];
//            break;
//        case 1:
//            [self localPhoto];
//            break;
//        default:
//            break;
//    }
//}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == myActionSheet.cancelButtonIndex){
     
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
    
    
}

//开始拍照
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
       
        [self.delegate addUIImagePicker:picker];
    
    }else{
        
    }
}


#pragma mark - ImagePicker delegate
//相机照完后点击use  后触发的方法 开始上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [_array addObject:image];

    [self initlizerScrollView:_array];
    //压缩图片方法
    NSData *imageData=UIImageJPEGRepresentation(image, 0.1);
    
    [self imageWithImageData:imageData];

}

//打开相册，可以多选
-(void)localPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    
    picker.maximumNumberOfSelection = 5;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    
    [self.delegate addPicker:picker];
    
    
}

/**
 * 得到选中的图片
 */
#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (int i =0; i< assets.count; i++) {
        
        ALAsset *asset = assets[i];
        ///获取到相册图片
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [_array addObject:tempImg];
        //压缩图片方法
        NSData *imageData=UIImageJPEGRepresentation(tempImg, 0.1);
        ///循环获得图片,并将其写入沙盒
        [self imageWithImageData:imageData];
        
    }
    
    [self initlizerScrollView:_array];
 
    [picker dismissViewControllerAnimated:YES completion:nil];

}


/// 将原始图片转化为NSData数据,写入沙盒

- (void)imageWithImageData:(NSData *)imageData{
    
    k++;
    /// 创建存放原始图的文件夹--->Documents
    NSFileManager * fileManager = [NSFileManager defaultManager];
    ///判断有无文件夹
    if (![fileManager fileExistsAtPath:ImagePath]) {
        
        [fileManager createDirectoryAtPath:ImagePath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    dataFormatter.dateFormat = @"YYYYMMddHHmmss";
    NSString *dateStr = [dataFormatter stringFromDate:date];
    ///获取沙盒目录
    filePath=[ImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"maikejia%d.png",k]];
    [imageData writeToFile:filePath atomically:NO];
   

    [_imgsArr addObject:[NSString stringWithFormat:@"%@%d.png",dateStr,k]];
    [_imagePath addObject:filePath];
    [_imageDataArr addObject:imageData];
    NSUserDefaults *imgPath = [NSUserDefaults standardUserDefaults];
    [imgPath setObject:_imagePath forKey:@"imagePath"];
    [imgPath setObject:_imgsArr forKey:@"fileName"];
    [imgPath setObject:_imageDataArr forKey:@"imageData"];
    [imgPath synchronize];
    
    
    DataSource *mger = [DataSource sharedDataSource];
    mger.imgFile = [NSString stringWithFormat:@"%@%d.png",dateStr,k];
//    [self uploadImageWithData:imageData filename:[NSString stringWithFormat:@"%@%d.png",dateStr,k]];
  
}

//-(void)uploadImageWithData:(NSData *)fileData filename:(NSString *)filename{
//    
//    NSString *fileString = [fileData base64Encoding];
//    UploadImageManager *upload = [[UploadImageManager alloc]init];
//    [upload webserviceUploadImageWithUrl:@"uploadResume" params:@{@"filename":filename,@"image":fileString,@"tag":@"0"}];
//    
//}



#pragma mark - MKComposePhotosViewDelegate

///删除已选中图片并从新写入沙盒
-(void)MKComposePhotosView:(MKComposePhotosView *)MKComposePhotosView didSelectDeleBtnAtIndex:(NSInteger)Index{
    [_array removeObjectAtIndex:Index];
    [self initlizerScrollView:_array];
   
    /// 创建存放原始图的文件夹--->Documents
    NSFileManager * fileManager = [NSFileManager defaultManager];

    ///先删除原来沙盒里的文件
    [fileManager removeItemAtPath:ImagePath error:nil];
    for (int i = 0; i < _array.count; i++) {
        
        NSData *imgData =UIImageJPEGRepresentation([_array objectAtIndex:i], 0.1);
        
        [self imageWithImageData:imgData];
    }

}



@end
