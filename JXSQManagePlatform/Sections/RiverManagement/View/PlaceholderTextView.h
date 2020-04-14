//
//  ReportThreeTableViewCell.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  带默认提示的textView
 */


@class PlaceholderTextView;

@interface PlaceholderTextView : UITextView<UITextViewDelegate>

@property (copy, nonatomic) NSString *placeholder;
@property (assign, nonatomic) NSInteger maxLength;//最大长度
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) UILabel *wordNumLabel;

//文字输入
@property (copy, nonatomic) void(^didChangeText)(PlaceholderTextView *textView);
- (void)didChangeText:(void(^)(PlaceholderTextView *textView))block;

@end
