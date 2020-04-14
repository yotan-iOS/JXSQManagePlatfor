//
//  InformationModel.h
//  BGRuralDomesticWaste
//
//  Created by ghost on 2017/8/29.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject

@property (nonatomic, strong) NSMutableArray *IDArr;
@property (nonatomic, strong) NSMutableArray *ComplaintNumArr;//编号
@property (nonatomic, strong) NSMutableArray *ComplaintNameArr;//投诉人
@property (nonatomic, strong) NSMutableArray *ComplaintTittleArr;//投诉主题
@property (nonatomic, strong) NSMutableArray *ComplaintTimeArr;//投诉时间
//@property (nonatomic, strong) NSMutableArray *ComplaintSiteIDArr;//投诉站点ID
//@property (nonatomic, strong) NSMutableArray *SiteNameArr;//站点名字
@property (nonatomic, strong) NSMutableArray *ComplaintContentArr;//投诉内容
@property (nonatomic, strong) NSMutableArray *PictureArr;//图片名
@property (nonatomic, strong) NSMutableArray *StatusArr;//状态
@property (nonatomic, strong) NSMutableArray *ImgUrlArr;//图片链接

//通知公告
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *ClassID;
@property (nonatomic, copy) NSString *ClassName;
@property (nonatomic, copy) NSString *PolicyLevel;
@property (nonatomic, copy) NSString *PolicyLevelName;
@property (nonatomic, copy) NSString *PolicyFile;
@property (nonatomic, copy) NSString *Comment;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
