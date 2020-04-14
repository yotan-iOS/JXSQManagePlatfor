//
//  JBOperationListViewController.h
//  BGRuralDomesticWaste
//
//  Created by 吴坤 on 2017/8/26.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBOperationListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *dealingNum;
@property (weak, nonatomic) IBOutlet UILabel *overNum;

@property (nonatomic,copy) NSString *pushTyID;

@end
