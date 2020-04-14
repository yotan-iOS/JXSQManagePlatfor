//
//  HistorysTableViewCell.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/20.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistorysTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *changeTfView;
@property (weak, nonatomic) IBOutlet UITextView *contentTfView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;
@property (weak, nonatomic) IBOutlet UILabel *StatusLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end
