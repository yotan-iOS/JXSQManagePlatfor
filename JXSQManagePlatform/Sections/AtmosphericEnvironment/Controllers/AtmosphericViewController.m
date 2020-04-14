//
//  AtmosphericViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/1.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "AtmosphericViewController.h"

@interface AtmosphericViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>{
    DataSource *dataManager;
}
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;


@end

@implementation AtmosphericViewController

//隐藏导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor redColor];
    dataManager = [DataSource sharedDataSource];
    [self layoutCollection];
}
- (void)layoutCollection {
    //创建UICollectionView对象,添加到根视图上
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    //item
    [_collectionView registerClass:[HomeViewCell class] forCellWithReuseIdentifier:@"item"];
    [_collectionView registerClass:[HomeHeaderViewCell class] forCellWithReuseIdentifier:@"scroll"];
    [self.view addSubview:_collectionView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            dataManager.tagString = @"15";
            [YJProgressHUD showError:@"功能正在开发中"];
        }
            
            NSLog(@"高空扬尘");
            break;
        case 1:
        {
            dataManager.tagString =  @"16";
            NSLog(@"汽车尾气");
            [YJProgressHUD showError:@"功能正在开发中"];
            
        }
            break;
        case 2:
            NSLog(@"燃油煤烟");
        {
            dataManager.tagString = @"17";
            [YJProgressHUD showError:@"功能正在开发中"];
            
        }
            break;
            
        case 3:
            NSLog(@"有机挥发物");
        {
            dataManager.tagString = @"18";
            [YJProgressHUD showError:@"功能正在开发中"];
        }
            break;
        case 4:
            NSLog(@"厨房油烟");
        {
            dataManager.tagString = @"19";
            [YJProgressHUD showError:@"功能正在开发中"];
           
        }
            
            break;
            
        default:
            break;
    }
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }
    return 6;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        HomeHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scroll" forIndexPath:indexPath];
        NSArray *imagesURLStrings =  @[
                                       @"banner1",
                                       @"banner2",
                                       @"banner3"
                                       ];
        self.bannerView.imageURLStringsGroup = imagesURLStrings;
        self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.bannerView.delegate = self;
        self.bannerView.currentPageDotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
        self.bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        CGFloat h=0;
        if (WT>700) {
            h = 309*HT/1024;
        }else{
            h = 129*HT/568;
        }
        
        SDCycleScrollView *banner2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, h) delegate:nil placeholderImage:nil];
        banner2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        banner2.imageURLStringsGroup = imagesURLStrings;
        [cell addSubview:banner2];
        cell.backgroundColor = [UIColor colorWithRed:0.4375 green:0.4375 blue:0.4375 alpha:1.0];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50*HT/568);
        titleLabel.center = banner2.center;
        titleLabel.text = @"嘉兴港区治水平台";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [banner2 addSubview:titleLabel];
        
        return cell;
    }
    HomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    cell.layer.borderColor = UIColorFromRGB(0xCDD1D0).CGColor;
    cell.layer.borderWidth = 0.3;
    
    
    for (UIView *subView in cell.subviews) {
        if ([subView isMemberOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        } else if ([subView isMemberOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"dust",@"automobileexhaust",@"fuelsoot",@"voc",@"kitchenfume",@"", nil];
    UIImage *image = [UIImage imageNamed:imageArr[indexPath.row]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((WT/3 - 40)/2, 18, 40, 40);
    [cell addSubview:imageView];
    NSArray *titleArr = [[NSArray alloc] initWithObjects:@"高空扬尘",@"汽车尾气",@"燃油煤烟",@"有机挥发物",@"厨房油烟",@"", nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, WT/3.0, 10)];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = titleArr[indexPath.row];
    [cell addSubview:label];
    
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
    CGFloat h=0;
    if (WT>700) {
        h = 309*HT/1024;
    }else{
        h = 129*HT/568;
    }
    
    if (0 == indexPath.section) {
        return CGSizeMake(self.view.frame.size.width, h);
    }
    return CGSizeMake(self.view.frame.size.width / 3 -0.03, 96);
}

@end
