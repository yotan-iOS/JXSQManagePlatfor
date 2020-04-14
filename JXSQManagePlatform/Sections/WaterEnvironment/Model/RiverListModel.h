//
//  RiverListModel.h
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/21.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiverListModel : NSObject
- (instancetype)initWithDic:(NSDictionary *)dic;
//河长信息列表
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *RiverName;
@property (nonatomic, copy) NSString *DictName;
@property (nonatomic, copy) NSString *RiverLevel;
@property (nonatomic, copy) NSString *RiverCount;
//河长信息
@property (nonatomic, copy) NSString *WaterTypeName;
@property (nonatomic, copy) NSString *RiverStartPoint;
@property (nonatomic, copy) NSString *RiverEndPoint;
@property (nonatomic, copy) NSString *RiverLength;
@property (nonatomic, copy) NSString *RiverLongName;
@property (nonatomic, copy) NSString *RiverLongPhone;
@property (nonatomic, copy) NSString *FlowTown;
@property (nonatomic, copy) NSString *PicUrl;

//人工采样数据
@property (nonatomic, copy) NSString *Month;
@property (nonatomic, copy) NSString *COD;
@property (nonatomic, copy) NSString *NH3;
@property (nonatomic, copy) NSString *TP;
@property (nonatomic, copy) NSString *RealWaterLevelName;

@end
