//
//  HandOverViewController.h
//  Witwater
//
//  Created by 吴坤 on 16/12/5.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationModel.h"
@interface HandOverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contenView;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UITextView *tfView;
@property(nonatomic,copy)NSString *idString;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *dueTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@property (strong, nonatomic) IBOutlet UIView *displayView;
@property(nonatomic,strong)StationModel *model;
@property(nonatomic,copy)NSString *errcontentStr;
@end
