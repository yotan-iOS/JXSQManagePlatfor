//
//  EndRiverViewController.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/5.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndRiverViewController : UIViewController
@property (nonatomic, copy) NSString *lengthStr;
@property (nonatomic, copy) NSString *distanceStr;

@property (nonatomic, copy) NSString *allPathStr;
@property (nonatomic, strong) NSArray *PathArray;
@property (nonatomic, strong) NSArray *arrayCut;

@property (nonatomic, copy) NSString *TourRiverResultsStr;
@end
