//
//  MyLoginViewController.h
//  PuYangJiangGovernance
//
//  Created by 吴坤 on 17/4/8.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutocompletionTableView.h"
@interface MyLoginViewController : UIViewController<AutocompletionTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *remberBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (nonatomic, copy) NSString *currentDateStr;//当前时间
@property (nonatomic, copy) NSString *PhoneType;


@property (nonatomic, strong) AutocompletionTableView *autoCompleter;


@property (strong, nonatomic) IBOutlet UILabel *userLine;
@property (strong, nonatomic) IBOutlet UILabel *passLine;

@property (strong, nonatomic) IBOutlet UIView *TFbackView;

//- (void)GetTheLoginAccount;

@end
