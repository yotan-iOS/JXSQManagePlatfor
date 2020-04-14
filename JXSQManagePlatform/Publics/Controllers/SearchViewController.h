//
//  RecordDetailViewController.m
//  LWIntelligenceOperations
//
//  Created by ghost on 2017/6/12.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterENViewController.h"
#import "RiverProgramViewController.h"
#import "RiverTaskDetailViewController.h"
#import "RealTimeDataViewController.h"
#import "SimpleDemoViewController.h"
@interface SearchViewController :  UIViewController
@property (strong, nonatomic) UITableView *myTableView;
@property (nonatomic,copy) NSString *keyboardStr;

- (void)sendTownThreeListStation:(NSString *)keyboardStr;

@end
