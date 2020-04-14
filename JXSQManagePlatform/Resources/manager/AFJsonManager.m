//
//  AFJsonManager.m
//  Witwater
//
//  Created by 吴坤 on 17/1/17.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import "AFJsonManager.h"

@implementation AFJsonManager
//GET请求
+(void)requestGETWithURLString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id respondObject))finish conError:(void(^)(NSError *error))conError{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //格式转换
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    [manager GET:urlStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          conError(error);
    }];
    
}
//POST请求
+(void)requestPOSTWithURLString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id respondObject))finish conError:(void (^)(NSError *))conError{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [manager POST:urlStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
         finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          conError(error);
    }];
    
    
    
}

@end
