//
//  RiverListModel.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/21.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "RiverListModel.h"

@implementation RiverListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
