//
//  StatisticalViewCell.h
//  Witwater
//
//  Created by ghost on 2016/11/30.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *oneLable;
@property (strong, nonatomic) IBOutlet UILabel *twoLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeLable;
@property (strong, nonatomic) IBOutlet UILabel *fourLable;
+ (instancetype)StatisticalViewCell:(UITableView *)tableView;
@end
