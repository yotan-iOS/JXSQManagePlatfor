//
//  RecodCountModel.m
//  LWIntelligenceOperations
//
//  Created by ghost on 2017/6/1.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "RecodCountModel.h"

@implementation RecodCountModel
-(NSMutableArray *)DataTimesArr{
    if (!_DataTimesArr) {

        self.DataTimesArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _DataTimesArr;
}
-(NSMutableArray *)RealNameArr{
    if (!_RealNameArr) {
        
        self.RealNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _RealNameArr;
}
-(NSMutableArray *)OsNameArr{
    if (!_OsNameArr) {
        
        self.OsNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _OsNameArr;
}

@end
