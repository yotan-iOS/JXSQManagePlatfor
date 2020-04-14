//
//  PatrolRecordModel.h
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/11/9.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatrolRecordModel : NSObject
@property(nonatomic,copy)NSString *RowIndex;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *RiverID;
@property(nonatomic,copy)NSString *Weather;
@property(nonatomic,copy)NSString *EndPoint;
@property(nonatomic,copy)NSString *RiverName;
@property(nonatomic,copy)NSString *LinePoints;
@property(nonatomic,copy)NSString *ConvertPoints;
@property(nonatomic,copy)NSString *PatrolID;
@property(nonatomic,strong)NSArray *CallName;

@property(nonatomic,copy)NSString *Address;
@property(nonatomic,copy)NSString *StartTime;
@property(nonatomic,copy)NSString *LengthOfTime;
@property(nonatomic,copy)NSString *PatrolRiverDistance;
@property(nonatomic,copy)NSString *PatorlPath;
@property(nonatomic,copy)NSString *EndTime;
@property(nonatomic,copy)NSString *DelFlg;
@end
