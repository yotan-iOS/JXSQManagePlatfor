//
//  HandInOverTwoViewController.h
//  Witwater
//
//  Created by 吴坤 on 16/12/5.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationModel.h"
@interface HandInOverTwoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *dayView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *tfView;
@property (weak, nonatomic) IBOutlet UITextView *contentfView;
@property (weak, nonatomic) IBOutlet UILabel *tfLable;
@property (weak, nonatomic) IBOutlet UILabel *contentfLab;
@property(nonatomic,copy)NSString *idStr;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,strong)StationModel *model;
@end
