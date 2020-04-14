//
//  HisDataWorkChartModel.h
//  HaiNanAPP
//
//  Created by ghost on 2017/12/26.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HisDataWorkChartModel : NSObject
@property (nonatomic, copy) NSString *xAxisDataStr;
@property (nonatomic, strong) NSMutableArray *xAxisDataArr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *nameArrTab;
@property (nonatomic, copy) NSString *dataStr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataArrTab;
@end
