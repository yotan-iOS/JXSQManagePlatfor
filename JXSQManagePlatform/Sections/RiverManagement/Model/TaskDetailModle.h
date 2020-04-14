//
//  TaskDetailModle.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/5.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDetailModle : NSObject
@property(nonatomic,copy)NSString *RecordID;
@property(nonatomic,copy)NSString *PushComment;
@property(nonatomic,copy)NSString *UrgencyDays;
@property(nonatomic,copy)NSString *PushTime;
@property(nonatomic,copy)NSString *DelayTag;
@property(nonatomic,copy)NSString *Delay;

@end
