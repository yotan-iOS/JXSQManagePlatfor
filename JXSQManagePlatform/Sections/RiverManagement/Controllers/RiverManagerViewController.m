//
//  RiverManagerViewController.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/1.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverManagerViewController.h"
#import "RiverTaskViewController.h"
#import "RiverMessageViewController.h"
#import "RiverJBStatisticsViewController.h"
#import "RiverCruiseViewController.h"
#import "NavigationListViewController.h"
#import "GoalRiverViewController.h"
#import "ComplainViewController.h"
#import "AnnouncementsViewController.h"
#import "MajorProjectViewController.h"
#import "SupervisorViewController.h"
#import "PatrolRiverRecordViewController.h"
#import "GSPViewController.h"
@interface RiverManagerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>{
    DataSource *dataManager;
}
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) NSMutableArray *MenuNameOArr;
@property (nonatomic, strong) NSMutableArray *MenuIconOArr;
@end

@implementation RiverManagerViewController
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
    
    for (int i = 0; i < dataManager.moduleArr.count; i++) {
        if ([dataManager.moduleArr[i] isEqualToString:@"河长管理"]) {
            for (NSDictionary *dic in dataManager.cmListArr[i]) {
                [self.MenuNameOArr addObject:dic[@"MenuName"]];
                [self.MenuIconOArr addObject:dic[@"MenuIcon"]];
            }
        }
    }
    
}
- (void)layoutCollection {
    //创建UICollectionView对象,添加到根视图上
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WT, HT-49) collectionViewLayout:layout];
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
    if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"河长巡河"]) {
        dataManager.tagString = @"7";
        dataManager.siteClassID = @"1";
        RiverCruiseViewController *cruiseVC = [[RiverCruiseViewController alloc] init];
        [self.navigationController pushViewController:cruiseVC animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"河长信息"]) {
        dataManager.tagString =  @"8";
        dataManager.siteClassID = @"2";
        NSLog(@"河长信息");
        RiverMessageViewController *riveMS = [[RiverMessageViewController alloc]init];
        riveMS.title  = @"河长信息";
        [self.navigationController pushViewController:riveMS animated:NO];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"河长任务"]) {
        dataManager.tagString = @"9";
        dataManager.siteClassID = @"3";
        RiverTaskViewController *twList = [[RiverTaskViewController alloc]init];
        twList.title = @"河长任务列表";
        [self.navigationController pushViewController:twList animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"巡河记录"]) {
        dataManager.tagString = @"20";
        PatrolRiverRecordViewController *ptarol = [[PatrolRiverRecordViewController alloc] init];
        ptarol.title = @"巡河轨迹";
        [self.navigationController pushViewController:ptarol animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"在线水质"]) {
        dataManager.tagString = @"10";
        //                dataManager.siteClassID = @"4";
        NavigationListViewController *nav = [[NavigationListViewController alloc]init];
        nav.title = @"在线水质";
        [self.navigationController pushViewController:nav animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"实时视频"]) {
        dataManager.tagString = @"11";
        dataManager.siteClassID = @"5";
        NavigationListViewController *nav = [[NavigationListViewController alloc]init];
        nav.title = @"实时视频";
        [self.navigationController pushViewController:nav animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"交办统计"]) {
        dataManager.tagString = @"12";
        RiverJBStatisticsViewController *jbVc = [[RiverJBStatisticsViewController alloc]init];
        [self.navigationController pushViewController:jbVc animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"公众投诉"]) {
        dataManager.tagString = @"13";
        ComplainViewController *complainVC = [[ComplainViewController alloc] init];
        [self.navigationController pushViewController:complainVC animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"电子导航"]) {
        dataManager.tagString = @"14";
        NavigationListViewController *nav = [[NavigationListViewController alloc]init];
        nav.title = @"电子导航";
        [self.navigationController pushViewController:nav animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"通知公告"]) {
        dataManager.tagString = @"15";
        AnnouncementsViewController *noticeVC = [[AnnouncementsViewController alloc] init];
        [self.navigationController pushViewController:noticeVC animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"河长督导"]) {
        dataManager.tagString = @"17";
        SupervisorViewController *superVC = [[SupervisorViewController alloc] init];
        superVC.title = @"河长督导";
        [self.navigationController pushViewController:superVC animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"重点项目进度跟踪"]) {
        dataManager.tagString = @"18";
        MajorProjectViewController *major = [[MajorProjectViewController alloc]init];
        major.title = @"重点项目进度跟踪";
        [self.navigationController pushViewController:major animated:YES];
    } else if ([self.MenuNameOArr[indexPath.row] isEqualToString:@"公示牌"]) {
        GSPViewController *gspVC = [[GSPViewController alloc] init];
        gspVC.title = @"公示牌";
        [self.navigationController pushViewController:gspVC animated:YES];
    }
    
//    switch (indexPath.row) {
//        case 0:
//        {//河长巡河
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]) {
//                dataManager.tagString = @"7";
//                dataManager.siteClassID = @"1";
//                RiverCruiseViewController *cruiseVC = [[RiverCruiseViewController alloc] init];
//                [self.navigationController pushViewController:cruiseVC animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//        case 1:
//        {
//            NSLog(@"GroupName--%@",dataManager.GroupName);
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]) {
//                dataManager.tagString =  @"8";
//                dataManager.siteClassID = @"2";
//                NSLog(@"河长信息");
//                RiverMessageViewController *riveMS = [[RiverMessageViewController alloc]init];
//                riveMS.title  = @"河长信息";
//                [self.navigationController pushViewController:riveMS animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//        case 2:
//            NSLog(@"河长任务");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]) {
//                dataManager.tagString = @"9";
//                dataManager.siteClassID = @"3";
//                RiverTaskViewController *twList = [[RiverTaskViewController alloc]init];
//                twList.title = @"河长任务列表";
//                [self.navigationController pushViewController:twList animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//
//        case 4:
//            NSLog(@"在线水质");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"10";
////                dataManager.siteClassID = @"4";
//                NavigationListViewController *nav = [[NavigationListViewController alloc]init];
//                nav.title = @"在线水质";
//                [self.navigationController pushViewController:nav animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//        }
//            break;
//        case 5:
//            NSLog(@"实时视频");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"11";
//                dataManager.siteClassID = @"5";
//                NavigationListViewController *nav = [[NavigationListViewController alloc]init];
//                nav.title = @"实时视频";
//                [self.navigationController pushViewController:nav animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//        }
//
//            break;
//        case 6:
//            NSLog(@"交办统计");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]) {
//                dataManager.tagString = @"12";
//                RiverJBStatisticsViewController *jbVc = [[RiverJBStatisticsViewController alloc]init];
//
//                [self.navigationController pushViewController:jbVc animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//
//        case 7:
//            NSLog(@"公众投诉");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"13";
//                ComplainViewController *complainVC = [[ComplainViewController alloc] init];
//                [self.navigationController pushViewController:complainVC animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//        case 8:
//            NSLog(@"电子导航");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"14";
//                NavigationListViewController *nav = [[NavigationListViewController alloc]init];
//                nav.title = @"电子导航";
//                [self.navigationController pushViewController:nav animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//        case 9:
//            NSLog(@"通知公告");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"15";
//                AnnouncementsViewController *noticeVC = [[AnnouncementsViewController alloc] init];
//                [self.navigationController pushViewController:noticeVC animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//        case 3:
//            NSLog(@"巡河记录");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]) {
//                dataManager.tagString = @"20";
//                PatrolRiverRecordViewController *ptarol = [[PatrolRiverRecordViewController alloc] init];
//                ptarol.title = @"巡河轨迹";
//                [self.navigationController pushViewController:ptarol animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//        }
//            break;
//        case 10:
//            NSLog(@"河长督导");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"17";
//                SupervisorViewController *superVC = [[SupervisorViewController alloc] init];
//                superVC.title = @"河长督导";
//                [self.navigationController pushViewController:superVC animated:YES];
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//        case 11:
//            NSLog(@"重点项目进度跟踪");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"18";
//                MajorProjectViewController *major = [[MajorProjectViewController alloc]init];
//                major.title = @"重点项目进度跟踪";
//                [self.navigationController pushViewController:major animated:YES];
//
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//
//        case 12:
//            NSLog(@"剿灭劣五类进度跟踪");
//        {
//            if ([dataManager.GroupName isEqualToString:@"河长用户"]||[dataManager.GroupName isEqualToString:@"超级管理员"]) {
//                dataManager.tagString = @"19";
//            } else {
//                [YJProgressHUD showError:@"您不是河长用户"];
//            }
//
//
//        }
//            break;
//
//        default:
//            break;
//    }
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }
    return self.MenuNameOArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        HomeHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scroll" forIndexPath:indexPath];
        NSArray *imagesURLStrings = @[
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
//    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"patrolriver",@"riverinfo",@"mytask",@"path",@"onlinequality",@"onlinecam",@"jbtj",@"公众投诉", @"电子导航",@"通知公告",@"河长督导",@"重点项目进度跟踪",@"", nil];
//    UIImage *image = [UIImage imageNamed:imageArr[indexPath.row]];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:self.MenuIconOArr[indexPath.row]];
    imageView.frame = CGRectMake((WT/3 - 40)/2, 18, 40, 40);
    [cell addSubview:imageView];
//    NSArray *titleArr = [[NSArray alloc] initWithObjects:@"河长巡河",@"河长信息",@"河长任务",@"巡河记录",@"在线水质",@"实时视频",@"交办统计",@"公众投诉",@"电子导航",@"通知公告",@"河长督导",@"重点项目进度跟踪",@"", nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, WT/3.0, 10)];
    if(WT < 350) {
        label.font = [UIFont systemFontOfSize:13];
    } else if (WT > 350 && WT < 400){
        label.font = [UIFont systemFontOfSize:15];
    } else {
        label.font = [UIFont systemFontOfSize:16];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.MenuNameOArr[indexPath.row];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
