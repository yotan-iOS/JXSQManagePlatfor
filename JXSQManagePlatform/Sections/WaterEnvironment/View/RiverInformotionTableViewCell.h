//
//  RiverInformotionTableViewCell.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/19.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiverInformotionTableViewCell : UITableViewCell
+ (instancetype)RiverInformotionTableViewCell:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UILabel *mouthLabel;
@property (strong, nonatomic) IBOutlet UILabel *CODLabel;
@property (strong, nonatomic) IBOutlet UILabel *NHLabel;
@property (strong, nonatomic) IBOutlet UILabel *TPLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;


@end
