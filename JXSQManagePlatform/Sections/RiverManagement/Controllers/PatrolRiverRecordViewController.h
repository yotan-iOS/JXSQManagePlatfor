//
//  PatrolRiverRecordViewController.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/11/9.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolRiverRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (strong, nonatomic) IBOutlet UIView *headerView;
- (IBAction)startAction:(id)sender;
- (IBAction)endAction:(id)sender;
- (IBAction)searchAction:(id)sender;

@end
