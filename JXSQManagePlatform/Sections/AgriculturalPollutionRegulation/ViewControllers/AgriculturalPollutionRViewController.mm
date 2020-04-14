//
//  AgriculturalPollutionRViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2018/11/24.
//  Copyright © 2018年 yotan. All rights reserved.
//

#import "AgriculturalPollutionRViewController.h"
#import "SimpleDemoViewController.h"
#import "JBManagerListViewController.h"
#import "JBOperationListViewController.h"
@interface AgriculturalPollutionRViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>{
    DataSource *dataManager;
}
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSMutableArray *MenuNameOArr;
@property (nonatomic, strong) NSMutableArray *MenuIconOArr;

@end

@implementation AgriculturalPollutionRViewController
- (NSMutableArray *)MenuNameOArr {
    if (!_MenuNameOArr) {
        self.MenuNameOArr = [NSMutableArray array];
    }
    return _MenuNameOArr;
}
- (NSMutableArray *)MenuIconOArr {
    if (!_MenuIconOArr) {
        self.MenuIconOArr = [NSMutableArray array];
    }
    return _MenuIconOArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataManager = [DataSource sharedDataSource];
    [self configerCollectionUI];
    
    NSArray *cmArr = dataManager.cmListArr;
    if (cmArr.count>=1&&[dataManager.moduleArr containsObject:@"农污监管"]) {
        for (NSDictionary *dic in cmArr.lastObject) {
            [self.MenuNameOArr addObject:dic[@"MenuName"]];
            [self.MenuIconOArr addObject:dic[@"MenuIcon"]];
        }
    }
}

-(void)configerCollectionUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor  = [UIColor whiteColor ];
    [self.collectionView registerClass:[HomeViewCell class] forCellWithReuseIdentifier:@"aprcell"];
    [_collectionView registerClass:[HomeHeaderViewCell class] forCellWithReuseIdentifier:@"scroll"];
    [self.view addSubview:self.collectionView];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (0 == section) {
        return 1;
    }
    return 3;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
    
    HomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"aprcell" forIndexPath:indexPath];
    cell.layer.borderColor = UIColorFromRGB(0xCDD1D0).CGColor;
    cell.layer.borderWidth = 0.3;
    
    
    for (UIView *subView in cell.subviews) {
        if ([subView isMemberOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        } else if ([subView isMemberOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
//        NSArray *imageArr = [[NSArray alloc] initWithObjects:@"人工采样",@"污水泵站",@"引清泵站", nil];
//        UIImage *image = [UIImage imageNamed:self.MenuIconOArr[indexPath.row]];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:self.MenuIconOArr[indexPath.row]];
    
    imageView.frame = CGRectMake((WT/3 - 40)/2, 18, 40, 40);
    [cell addSubview:imageView];
//    NSArray *titleArr = [[NSArray alloc] initWithObjects:@"实时数据",@"一键巡检",@"巡检登记", nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, WT/3.0, 10)];
    if(WT < 350) {
        label.font = [UIFont systemFontOfSize:14];
    } else {
        label.font = [UIFont systemFontOfSize:16];
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.MenuNameOArr[indexPath.row];
    
    [cell addSubview:label];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            dataManager.tagString = @"50";
            dataManager.siteClassID = @"6";
            TwoListViewController *twList = [[TwoListViewController alloc]init];
            twList.title = @"实时数据";
            [self.navigationController pushViewController:twList animated:YES];
        } else if (indexPath.row==1){
            dataManager.tagString = @"51";
            TwoListViewController *twList = [[TwoListViewController alloc]init];
            twList.title = @"一键巡查";
            [self.navigationController pushViewController:twList animated:YES];
        } else {
            if ([dataManager.GroupID isEqualToString:@"14"]) {
                dataManager.tagString = @"53";
                JBOperationListViewController *operationlist = [[JBOperationListViewController alloc]init];
                operationlist.pushTyID = @"Handling";
                operationlist.title = @"巡检登记";
                [self.navigationController pushViewController:operationlist animated:YES];
            }else{
                dataManager.tagString = @"52";
                TwoListViewController *twList = [[TwoListViewController alloc]init];
                twList.title = @"巡检登记";
                [self.navigationController pushViewController:twList animated:YES];
            }
        }
    }
    
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
//隐藏导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
