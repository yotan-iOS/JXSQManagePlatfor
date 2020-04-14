//
//  MineViewController.h
//  Witwater
//
//  Created by 吴坤 on 17/1/13.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MagicalRecord/MagicalRecord.h>
//#import "Latitude_and_longitude+CoreDataClass.h"
//#import "Patrol_record+CoreDataClass.h"
#import "UIViewController+CBPopup.h"
#import "HelpViewController.h"

@interface MineViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (assign, nonatomic) CBPopupViewAligment popAligment;

@end
