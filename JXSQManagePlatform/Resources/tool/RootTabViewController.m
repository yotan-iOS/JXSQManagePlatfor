//
//  RootTabViewController.m
//  MyApp
//
//  Created by liaowentao on 17/3/29.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

#import "RootTabViewController.h"
#import "LWTNavigationViewController.h"
#import "UITabBarItem+WebCache.h"
# define kTabbarSelectTintColor [UIColor brownColor]
# define kTabbarNormalTintColor [UIColor blackColor]

@interface RootTabViewController ()<UITabBarControllerDelegate>

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    // Do any additional setup after loading the view.
    
}

/**构建视图*/
- (void)buildUI{
    DataSource *dataSour = [DataSource sharedDataSource];
    
    self.tabBar.translucent     = NO;
    self.tabBar.backgroundImage = [CommonMethods createImageWithColor:[UIColor clearColor]];
    self.tabBar.shadowImage     = [CommonMethods createImageWithColor:[UIColor grayColor]];
    NSArray *normalItems;//未选中图片
    NSArray *selectItmes;//选中图片
    NSArray *controllClass;//类名
    NSArray * itemTitles;//tabbar
    if (dataSour.moduleArr.count > 0 && dataSour.moduleArr.count < 2) {
        normalItems       = @[dataSour.moduleArrIcon.firstObject,@"tab_contact_unselect"];
        selectItmes       = @[[dataSour.moduleArrIcon.firstObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],@"tab_contact_select"];
        if ([dataSour.moduleArr.firstObject isEqualToString:@"水环境"]) {
            controllClass     = @[@"RiverManagerViewController",@"MineViewController"];
        } else if([dataSour.moduleArr.firstObject isEqualToString:@"河长管理"]){
            controllClass     = @[@"HomeViewController",@"MineViewController"];
        }else{
              controllClass     = @[@"AgriculturalPollutionRViewController",@"MineViewController"];
        }
        
        itemTitles        = @[dataSour.moduleArr.firstObject,@"系统设置"];
    } else if (dataSour.moduleArr.count == 2) {
        if (![dataSour.moduleArr containsObject: @"水环境"]) {
            normalItems       = @[dataSour.moduleArrIcon.firstObject,dataSour.moduleArrIcon.lastObject,@"tab_contact_unselect"];
            selectItmes       = @[[dataSour.moduleArrIcon.firstObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],[dataSour.moduleArrIcon.lastObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],@"tab_contact_select"];
            controllClass     = @[@"RiverManagerViewController",@"AgriculturalPollutionRViewController",@"MineViewController"];
            itemTitles        = @[dataSour.moduleArr.firstObject,dataSour.moduleArr.lastObject,@"系统设置"];
        }else if (![dataSour.moduleArr containsObject: @"河长管理"]){
            normalItems       = @[dataSour.moduleArrIcon.firstObject,dataSour.moduleArrIcon.lastObject,@"tab_contact_unselect"];
            selectItmes       = @[[dataSour.moduleArrIcon.firstObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],[dataSour.moduleArrIcon.lastObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],@"tab_contact_select"];
            controllClass     = @[@"HomeViewController",@"AgriculturalPollutionRViewController",@"MineViewController"];
            itemTitles        = @[dataSour.moduleArr.firstObject,dataSour.moduleArr.lastObject,@"系统设置"];
        }else{
            normalItems       = @[dataSour.moduleArrIcon.firstObject,dataSour.moduleArrIcon.lastObject,@"tab_contact_unselect"];
            selectItmes       = @[[dataSour.moduleArrIcon.firstObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],[dataSour.moduleArrIcon.lastObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],@"tab_contact_select"];
            controllClass     = @[@"HomeViewController",@"RiverManagerViewController",@"MineViewController"];
            itemTitles        = @[dataSour.moduleArr.firstObject,dataSour.moduleArr.lastObject,@"系统设置"];
        }
        
    } else if(dataSour.moduleArr.count == 3){
        normalItems       = @[dataSour.moduleArrIcon.firstObject,dataSour.moduleArrIcon[1], dataSour.moduleArrIcon.lastObject,@"tab_contact_unselect"];
        selectItmes       = @[[dataSour.moduleArrIcon.firstObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],[dataSour.moduleArrIcon[1] stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],[dataSour.moduleArrIcon.lastObject stringByReplacingOccurrencesOfString:@".png" withString:@"_active.png"],@"tab_contact_select"];
        controllClass     = @[@"HomeViewController",@"RiverManagerViewController",@"AgriculturalPollutionRViewController",@"MineViewController"];
        itemTitles        = @[dataSour.moduleArr.firstObject,dataSour.moduleArr[1],dataSour.moduleArr.lastObject,@"系统设置"];
    }else{
        normalItems       = @[@"tab_contact_unselect"];
        selectItmes       = @[@"tab_contact_select"];
        controllClass     = @[@"MineViewController"];
        itemTitles        = @[@"系统设置"];
    }
    
    self.delegate               = self;
    
    NSMutableArray * controllers = [[NSMutableArray alloc]init];
    for (int i = 0; i < normalItems.count; i++)
    {
        
        UIViewController * homeview =[[NSClassFromString(controllClass[i]) alloc]init];
        LWTNavigationViewController * navigation =[[LWTNavigationViewController alloc]initWithRootViewController:homeview];
        
//        if (i < normalItems.count-1) {
//            NSURL *urlUN = [NSURL URLWithString:normalItems[i]];
//            NSURL *seurl = [NSURL URLWithString:selectItmes[i]];
//            navigation.tabBarItem.image                     = [[UIImage imageWithData:[NSData dataWithContentsOfURL:urlUN]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            navigation.tabBarItem.selectedImage             = [[UIImage imageWithData:[NSData dataWithContentsOfURL:seurl]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        } else {
//            navigation.tabBarItem.image                     = [[UIImage imageNamed:normalItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            navigation.tabBarItem.selectedImage             = [[UIImage imageNamed:selectItmes[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        }
        if (i < normalItems.count) {
            navigation.tabBarItem.image                     = [[UIImage imageNamed:normalItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navigation.tabBarItem.selectedImage             = [[UIImage imageNamed:selectItmes[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        
        navigation.tabBarItem.titlePositionAdjustment   = UIOffsetMake(0,-3);
        [controllers addObject:navigation];
        
        // 设置文字的样式
        NSMutableDictionary *textAttrs                  = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName]       = kTabbarNormalTintColor;
        NSMutableDictionary *selectTextAttrs            = [NSMutableDictionary dictionary];
        selectTextAttrs[NSForegroundColorAttributeName] = kTabbarSelectTintColor;
        [homeview.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
       
        [homeview.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
        // 设置tabbaritem 的title
        navigation.tabBarItem.title                     = itemTitles[i];
    }
    self.viewControllers = controllers;
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
