//
//  RiverHandleInViewController.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiverHandleInViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextView *handleContentTF;
@property (weak, nonatomic) IBOutlet UIView *pictureView;

@end
