//
//  HandlingOperationDetailViewController.h
//  BGRuralDomesticWaste
//
//  Created by 吴坤 on 2017/8/31.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationModel.h"
@interface HandlingOperationDetailViewController : UIViewController
@property(nonatomic,strong)StationModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *otherLable;
@property(nonatomic,copy)NSString *errContentString;
@property (strong, nonatomic) IBOutlet UIView *displayView;

@end
