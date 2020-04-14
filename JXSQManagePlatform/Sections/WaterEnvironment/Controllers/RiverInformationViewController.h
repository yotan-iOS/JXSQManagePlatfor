//
//  RiverInformationViewController.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/19.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiverInformationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *headerTabView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) UILabel *annotationLab;
@property (nonatomic, strong) NSMutableArray *CODArr;
@property (nonatomic, strong) NSMutableArray *NHArr;
@property (nonatomic, strong) NSMutableArray *TPArr;
@property (nonatomic, strong) NSMutableArray *dateArr;

@end
