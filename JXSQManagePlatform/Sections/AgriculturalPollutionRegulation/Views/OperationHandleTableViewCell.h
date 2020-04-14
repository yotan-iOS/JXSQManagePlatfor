//
//  OperationHandleTableViewCell.h
//  BGRuralDomesticWaste
//
//  Created by 吴坤 on 2017/8/26.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationHandleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *siteNameLab;
@property (weak, nonatomic) IBOutlet UILabel *errorContentLab;
@property (weak, nonatomic) IBOutlet UILabel *errorDays;
@property (weak, nonatomic) IBOutlet UILabel *instertimeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end
