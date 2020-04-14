//
//  LYUserInfoManager.h
//  BuleSeaFirstAPP
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYUserInfoManager : NSObject
//单例
+ (LYUserInfoManager *) shareInfoManager;
//判断是否是第一次运行
- (BOOL) ifFirstRun;

//存储账号和密码
- (void) saveUserName:(NSString *)userName userPassword:(NSString *)password;
//取账号
- (NSString *) getUserName;
//取密码
- (NSString *) getUserPassword;

//存储用户token信息
- (void) saveUserToken:(NSString *)token;
//获取用户token信息
- (NSString *)getUserToken;

//存储用户的个人参数等
- (void) saveUserHeaderImage:(NSString *)headerImage userLevel:(NSString *)level userID:(NSString *)userID;
//获得头像
- (NSString *)getUserHeaderImage;
//获得级别
- (NSString *)getUserLevel;
//获得id
- (NSString *)getUserID;

//注销账户信息
- (void) cancelLYUserInfoManager;
@end
