//
//  ProjectModel.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/18.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject
//计划ID
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *PlanNo;
@property (nonatomic, copy) NSString *PlanType;
//项目ID
@property (nonatomic, copy) NSString *ProjectID;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *Month;
@property (nonatomic, copy) NSString *Year;
@property (nonatomic, copy) NSString *Investment;

@property (nonatomic, copy) NSString *FinishType;
@property (nonatomic, copy) NSString *PlanID;
@property (nonatomic, copy) NSString *Progress;
@property (nonatomic, copy) NSString *Comment;
@property (nonatomic, copy) NSString *ReportDate;
@property (nonatomic, copy) NSString *CompleteInvestment;
@property (nonatomic, copy) NSString *RealName;
@end
