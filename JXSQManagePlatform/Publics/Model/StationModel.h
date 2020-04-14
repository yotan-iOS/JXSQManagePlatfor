//
//  StationModel.h
//  LWIntelligenceOperations
//
//  Created by 吴坤 on 17/5/17.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationModel : NSObject
//环保法规
@property(nonatomic,copy)NSString *RegulationsName;
@property(nonatomic, strong) NSMutableArray *RegulationsNameArr;
@property(nonatomic,copy)NSString *ReleaseTime;
@property(nonatomic, strong) NSMutableArray *ReleaseTimeArr;
@property(nonatomic,copy)NSString *ReleaseDepart;
@property(nonatomic, strong) NSMutableArray *ReleaseDepartArr;
@property(nonatomic,copy)NSString *Attachment;
@property(nonatomic, strong) NSMutableArray *AttachmentArr;
@property(nonatomic, strong) NSMutableArray *HasDataFlgArr;
@property(nonatomic, strong) NSMutableArray *HasVideoFlagArr;
//获取二级列表
@property(nonatomic, copy) NSString *SiteTypeID;
@property(nonatomic, strong) NSMutableArray *SiteTypeIDArr;
@property(nonatomic, copy) NSString *SiteTypeName;
@property(nonatomic, strong) NSMutableArray *SiteTypeNameArr;
@property(nonatomic, strong) NSMutableArray *SiteClassIDArrTwo;
//获取三级站点列表
@property(nonatomic, copy) NSString *SiteID;
@property(nonatomic, strong) NSMutableArray *SiteIDArr;
@property(nonatomic, copy) NSString *SiteName;
@property(nonatomic, strong) NSMutableArray *SiteNameArr;
@property(nonatomic, copy) NSString *SiteClassID;
@property(nonatomic, strong) NSMutableArray *SiteClassIDArr;
@property(nonatomic, copy) NSString *SiteTypeIDThree;
@property(nonatomic, strong) NSMutableArray *SiteTypeIDArrThree;

//乡镇列表
@property(nonatomic, copy) NSString *StreetID;
@property(nonatomic, strong) NSMutableArray *StreetIDArr;
@property(nonatomic, copy) NSString *StreetName;
@property(nonatomic, strong) NSMutableArray *StreetNameArr;
@property(nonatomic, copy) NSString *SiteCount;
@property(nonatomic, strong) NSMutableArray *SiteCountArr;
//status：1.未处理 0.已处理
@property(nonatomic, copy) NSString *Status;
@property(nonatomic, strong) NSMutableArray *StatusArr;

@property(nonatomic, copy) NSString *RecordID;
@property(nonatomic, strong) NSMutableArray *RecordIDArr;



//交办
@property(nonatomic, copy) NSString *AlarmType;
@property(nonatomic, copy) NSString *ErrCodeList;
@property(nonatomic, copy) NSString *ErrContentList;
@property(nonatomic, copy) NSString *PushID;
@property(nonatomic, copy) NSString *PushStatus;
@property(nonatomic, copy) NSString *UrgencyDays;
@property(nonatomic, copy) NSString *AlarmTime;
@property(nonatomic, copy) NSString *InsertDate;
@property(nonatomic, copy) NSString *Lastdate;
@property(nonatomic, copy) NSString *ErrMsg;
@property(nonatomic, copy) NSString *OperationUserID;
@property(nonatomic, copy) NSString *DelayTag;
@property(nonatomic, copy) NSString *DelayDays;

//
@property(nonatomic, copy) NSString *HandingCount;
@property(nonatomic, copy) NSString *OverdueCount;

@property(nonatomic, copy) NSString *DealEndTime;
@property(nonatomic, copy) NSString *PushComment;
@property(nonatomic, copy) NSString *PushStatusName;
///


@property(nonatomic, copy) NSString *OperationUserName;
@property(nonatomic, copy) NSString *OperationCompanyID;
@property(nonatomic, copy) NSString *OperationCompanyName;
@property(nonatomic, copy) NSString *PhoneNumber;
@property(nonatomic, copy) NSString *VideoNetStatus;
@property(nonatomic, copy) NSString *NetStatus;
@property(nonatomic, copy) NSString *FanNumber;
@property(nonatomic, copy) NSString *RefluxNumber;
@property(nonatomic, copy) NSString *LiftingNumber;

@end
