//
//  SupervisinModel.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/9/21.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupervisinModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *projectid;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *rectificationmsg;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *DictName;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *reportcontent;
@property (nonatomic, copy) NSString *supervisionresource;
@property (nonatomic, copy) NSString *createuser;
@property (nonatomic, copy) NSString *createtime;
@end

