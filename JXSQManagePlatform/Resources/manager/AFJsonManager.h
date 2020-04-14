//
//  AFJsonManager.h
//  Witwater
//
//  Created by 吴坤 on 17/1/17.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFJsonManager : NSObject
/*
 GET请求方法
 @param urlStr :数据请求接口
 @param dic :数据请求接口的传入参数
 @param finish:数据请求成功后的回调
 @param conError:数据请求失败后的回调
 */

+(void)requestGETWithURLString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id respondObject))finish conError:(void(^)(NSError *error))conError;
/*
 POST请求方法
 @param urlStr :数据请求接口
 @param dic :数据请求接口的传入参数
 @param finish:数据请求成功后的回调
 @param conError:数据请求失败后的回调
 */
+(void)requestPOSTWithURLString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id respondObject))finish conError:(void(^)(NSError *error))conError;
@end
