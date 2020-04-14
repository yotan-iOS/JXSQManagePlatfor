//
//  ReportPhotoTableViewCell.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/7/6.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportPhotoTableViewCell : UITableViewCell
+ (instancetype)ReportPhotoTableViewCell:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;

@end
