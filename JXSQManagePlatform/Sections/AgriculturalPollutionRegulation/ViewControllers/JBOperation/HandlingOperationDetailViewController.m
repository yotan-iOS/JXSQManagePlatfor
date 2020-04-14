
//
//  HandlingOperationDetailViewController.m
//  BGRuralDomesticWaste
//
//  Created by 吴坤 on 2017/8/31.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "HandlingOperationDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface HandlingOperationDetailViewController ()<UIScrollViewDelegate>{

}
@property (nonatomic,copy) NSString *urlStr;
@property(nonatomic,strong)NSArray *imagPathArr;
@property(nonatomic,strong)  UILabel *lab;
@property(nonatomic,strong)  NSString *descrstr;
@end

@implementation HandlingOperationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    self.displayView.frame = CGRectMake(0, NAVIHEIGHT+IphoneX_TH, self.view.frame.size.width, self.view.frame.size.height-NAVIHEIGHT-IphoneX_TH-IphoneX_BH);
    [self.view addSubview:self.displayView];

    
    [self getdata];
    
}
//
-(void)getdata{
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
 
    self.urlStr = F(@"%@/GetApPushInfoByID",BaseRequestUrl);
    NSDictionary *param = @{@"PushID":F(@"%@",self.model.PushID)};
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"oneList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        
        if ([status isEqualToString:@"OK"]) {
            
            for (NSDictionary *dic in dicData[@"Data"]) {
                [self configerPictureViewWithPotoPath:F(@"%@", dic[@"ImgPath"])];
//                NSLog(@"dic----%@",F(@"%@", dic[@"ImgPath"]));
                self.descrstr = dic[@"Describe"];
            }
            
        }
        [CustomHUD dismiss];
        [self configerLable];
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
        [CustomHUD dismiss];
   
        
    }];

    
}
-(void)configerPictureViewWithPotoPath:(NSString *)poto{

    _imagPathArr = [poto componentsSeparatedByString:@";"];
//    NSLog(@"_imagPathArr%@",_imagPathArr);
        UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(1, 35, WT, (HT-150)/3.0)];
        scroller.showsVerticalScrollIndicator = NO;
        NSInteger scrolleWT = (_imagPathArr.count)*98+8+90;
        if (scrolleWT > WT) {
            scroller.contentSize = CGSizeMake(scrolleWT, 120);
        }else{
            scroller.contentSize = CGSizeMake(WT, 120);
        }
        
        [_pictureView addSubview:scroller];
        
        
        for (int i = 0; i < _imagPathArr.count; i++) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*98 +8, 0, 90, 120)];
            [imgV sd_setImageWithURL:[NSURL URLWithString:F(@"%@%@",KImagePath,_imagPathArr[i])]];
            imgV.userInteractionEnabled = YES;
            imgV.backgroundColor = [UIColor lightGrayColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTapAction:)];
            imgV.tag = 1000 + i;
            [imgV addGestureRecognizer:tap];
            [scroller addSubview:imgV];
            
            
        }
        
    

}
-(void)configerLable{

    self.otherLable.text = self.descrstr;
    //self.model.ErrMsg.length > 0?self.model.ErrMsg : @"无内容";
self.timeLab.text = F(@"%@", [[self.model.InsertDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19]);
self.limitTimeLab.text = F(@"%@",[self.model.DealEndTime stringByReplacingOccurrencesOfString:@"T" withString:@" "]);
self.contentLab.text = self.errContentString;

}

-(void)changeTapAction:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 1000;
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WT, HT)];
    
    aview.backgroundColor = [UIColor blackColor];
    
    UIScrollView *imageScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WT, HT)];
    imageScroller.delegate = self;
    
    imageScroller.pagingEnabled = YES;
    imageScroller.contentOffset = CGPointMake(WT*index, 130);
    imageScroller.contentSize = CGSizeMake(WT*(_imagPathArr.count), HT);
    for (int i = 0; i < _imagPathArr.count; i++) {
        UIImageView *imgVC = [[UIImageView alloc]init];
        imgVC.tag = 2000 + i;
        imgVC.frame = CGRectMake(40+WT*i, 130,WT - 80 , HT -240);
        SDWebImageManager *manger = [SDWebImageManager sharedManager];
    
        [manger downloadImageWithURL:[NSURL URLWithString:F(@"%@%@",KImagePath,_imagPathArr[i])] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
               imgVC.image = image;
        }];
        [imageScroller  addSubview:imgVC];
    }
    _lab = [[UILabel alloc]initWithFrame:CGRectMake(WT/2.0-50, HT-100, 100, 30)];
    
    _lab.textColor = [UIColor whiteColor];
    _lab.textAlignment = NSTextAlignmentCenter;
    
    _lab.text = [NSString stringWithFormat:@"%ld / %ld",index+1,_imagPathArr.count];
    
    [aview addSubview:imageScroller];
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissActioon:)];
    
    [aview addGestureRecognizer:tap0];
    
    [self.view addSubview:aview];
    [self.view addSubview:_lab];
}


-(void)dismissActioon:(UITapGestureRecognizer *)tap{
    
    UIView *aview = tap.view;
    [_lab removeFromSuperview];
    
    [aview removeFromSuperview];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //及时获取scrollView的偏移量
    
    int index = fabs(scrollView.contentOffset.x)/WT + 1;
    _lab.text = [NSString stringWithFormat:@"%d / %ld",index,_imagPathArr.count];
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
