//
//  UIControl+UIControl_buttonCon.h
//  JXSQManagePlatform
//
//  Created by TestGhost on 2018/4/4.
//  Copyright © 2018年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (UIControl_buttonCon)
@property (nonatomic, assign) NSTimeInterval cs_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval cs_acceptEventTime;

@end
