//
//  TargetPhotoViewController.m
//  Witwater
//
//  Created by ghost on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TargetPhotoViewController.h"

@interface TargetPhotoViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TargetPhotoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
//    [self sendRequestRevierFile];
    // Do any additional setup after loading the view.
    [self initImageView];
}
- (void)sendRequestRevierFile {
    NSDictionary *param = @{
                            @"id":self.riverID
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/getRiverPolicyByID", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Content" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            NSDictionary *dic = dicData[@"Data"];
            self.imageString = dic[@"PicUrl"];
            self.title = dic[@"RiverSubName"];
        }
        [self initImageView];
        [CustomHUD dismiss];
        NSLog(@"获取巡河上报的内容 ====%@", result);
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}
- (void)initImageView {
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    //添加图片
    _imageView = [[UIImageView alloc] init];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageString]]];
    _imageView.image = image;
    _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    _scrollView.contentSize = image.size;
    _scrollView.delegate = self;
    _scrollView.zoomScale = 1;
    _scrollView.maximumZoomScale = 7.0;
    _scrollView.minimumZoomScale = 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
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
