//
//  NavigationSearchViewController.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/23.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationSearchViewController : UIViewController
@property (strong, nonatomic) UITableView *tableView;
- (void)sendTownListStation:(NSString *)keyboardStr;
@end
