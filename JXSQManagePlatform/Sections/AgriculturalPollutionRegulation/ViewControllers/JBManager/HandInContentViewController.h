//
//  HandInContentViewController.h
//  Witwater
//
//  Created by 吴坤 on 16/12/3.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationModel.h"

@interface HandInContentViewController : UIViewController
@property(nonatomic,strong)NSString * titString;

@property(nonatomic,strong)NSString * idString;

@property (weak, nonatomic) IBOutlet PlaceholderTextView *stextf;
@property (weak, nonatomic) IBOutlet UILabel *sotherLab;

@property (weak, nonatomic) IBOutlet UILabel *smessageLab;
@property(nonatomic,copy)NSString *AlarmType;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *alarmTy;
@property (strong, nonatomic) IBOutlet UIView *displayView;
@property(nonatomic,copy)NSString *siteID;
@property(nonatomic,strong)StationModel *stationModel;

@property(nonatomic,strong)UIImage *imgs;
@property(nonatomic,copy)NSString *imagPathStr;
@property (strong, nonatomic) UIImageView *photo;
@property (nonatomic, strong) MKMessagePhotoView *photosView;

@end
