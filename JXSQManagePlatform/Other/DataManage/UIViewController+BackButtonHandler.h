//
//  UIViewController+BackButtonHandler.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/11/10.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional

- (BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
