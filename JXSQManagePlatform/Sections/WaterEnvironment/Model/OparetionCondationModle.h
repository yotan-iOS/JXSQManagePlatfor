//
//  OparetionCondationModle.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/10/10.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OparetionCondationModle : NSObject
@property(nonatomic,copy)NSString *SiteName;
@property(nonatomic,copy)NSString *TimeStamp;
@property(nonatomic,copy)NSString *NetStatus;
@property(nonatomic,strong)NSArray *Equipment;
@property(nonatomic,copy)NSString *EquipmentName;
@property(nonatomic,copy)NSString *EquipmentStatus;

@end
