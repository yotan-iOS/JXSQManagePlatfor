//
//  DataSource.m
//  Witwater
//
//  Created by gaoqi on 2016/10/28.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
+(DataSource*)sharedDataSource {
    static DataSource *dataSource = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dataSource = [DataSource new];
    });
    return dataSource;
}
- (NSMutableArray *)AllTheData {
    if (!_AllTheData) {
        self.AllTheData = [NSMutableArray array];
    }
    return _AllTheData;
}
- (NSMutableArray *)dataSouce {
    if (!_dataSouce) {
        self.dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
-(NSMutableArray *)datalong {
    if (!_datalong) {
        self.datalong = [NSMutableArray array];
    }
    return _datalong;
}
-(NSMutableArray *)locationArrayM {
    if (!_locationArrayM) {
        self.locationArrayM = [NSMutableArray array];
    }
    return _locationArrayM;
}

///
-(NSMutableArray *)cmListArr {
    if (!_cmListArr) {
        self.cmListArr = [NSMutableArray array];
    }
    return _cmListArr;
}
-(NSMutableArray *)moduleArr {
    if (!_moduleArr) {
        self.moduleArr = [NSMutableArray array];
    }
    return _moduleArr;
}
-(NSMutableArray *)moduleArrIcon {
    if (!_moduleArrIcon) {
        self.moduleArrIcon = [NSMutableArray array];
    }
    return _moduleArrIcon;
}

@end
