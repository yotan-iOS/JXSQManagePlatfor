//
//  ComplainTableViewCell.h
//  Witwater
//
//  Created by 吴坤 on 17/1/17.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *riverNameLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *conImageV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *riverDistrict;
@property (weak, nonatomic) IBOutlet UILabel *compStatusLab;

@property (strong, nonatomic) IBOutlet UILabel *titleNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *alamTypeLab;

@end
