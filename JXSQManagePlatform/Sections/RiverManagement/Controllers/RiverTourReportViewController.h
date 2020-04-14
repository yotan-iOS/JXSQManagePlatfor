//
//  RiverTourReportViewController.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportTwoTableViewCell.h"
#import "ReportThreeTableViewCell.h"
#import "ValidateTableViewCell.h"
#import "ReportPhotoTableViewCell.h"
#import "PlaceholderTextView.h"
#import "ReportButtonTableViewCell.h"
#import "RadioButton.h"
#import "UploadImageManager.h"
@interface RiverTourReportViewController : UIViewController
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *patrolResult;
@property (nonatomic,strong) NSData *fileData;
@property (nonatomic,copy) NSString *upload_imgestr;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic, strong) UIImageView *photoImage;
@property (strong, nonatomic) NSMutableArray *selectIndexs;  //多选选中的行
@property (strong, nonatomic) NSMutableArray *selectContentIDArr;

@property (nonatomic,copy) NSString *CheckID;//开始之后的ID
@property (nonatomic,copy) NSString *AddressStr;
@property (nonatomic,copy) NSString *longitudeStr;
@property (nonatomic,copy) NSString *latitudeStr;
@property (nonatomic,copy) NSString *cellClickBtn;

@end
