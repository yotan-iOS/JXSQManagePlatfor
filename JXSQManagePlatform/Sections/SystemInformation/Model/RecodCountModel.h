//
//  RecodCountModel.h
//  LWIntelligenceOperations
//
//  Created by ghost on 2017/6/1.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecodCountModel : NSObject
@property (nonatomic, copy) NSString *DataTimes;
@property (nonatomic, strong) NSMutableArray *DataTimesArr;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, strong) NSMutableArray *RealNameArr;
@property (nonatomic, copy) NSString *OsName;
@property (nonatomic, strong) NSMutableArray *OsNameArr;
@end
