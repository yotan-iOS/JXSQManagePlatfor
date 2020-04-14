//
//  LYUserInfoManager.m
//  BuleSeaFirstAPP
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LYUserInfoManager.h"

@implementation LYUserInfoManager

#pragma mark -- 单例
+ (LYUserInfoManager *) shareInfoManager{
    static LYUserInfoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LYUserInfoManager alloc]init];
    });
    return manager;
}
#pragma mark -- 是否第一次运行
- (BOOL) ifFirstRun{
    
    // 从本地取值
    BOOL isFirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstRun"];
    
    if (isFirstRun) {
        
        return NO;
        
    }else{
        
        //存储信息到本地
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstRun"];
        
        //及时保存
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        return YES;
        
    }
}
#pragma mark -- 存储账号和密码
- (void) saveUserName:(NSString *)userName userPassword:(NSString *)userPassword{
    
    [[NSUserDefaults standardUserDefaults]setValue:userName forKey:@"userName"];
    
    [[NSUserDefaults standardUserDefaults]setValue:userPassword forKey:@"userPassword"];
    
    //及时保存
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
#pragma mark -- 取账号
- (NSString *) getUserName{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    
    return userName;
    
}
#pragma mark -- 取密码
- (NSString *) getUserPassword{
    
    NSString *userPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"userPassword"];
    
    return userPassword;
    
}
#pragma mark -- 存储用户token
- (void) saveUserToken:(NSString *)token{
    
    [[NSUserDefaults standardUserDefaults]setValue:token forKey:@"token"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
#pragma mark -- 获取用户token
- (NSString *) getUserToken{
    
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    return userToken;
    
}
#pragma mark -- 存储用户的个人参数
- (void) saveUserHeaderImage:(NSString *)headerImage userLevel:(NSString *)level userID:(NSString *)userID{
    
    [[NSUserDefaults standardUserDefaults]setValue:headerImage forKey:@"headerImage"];
    
    [[NSUserDefaults standardUserDefaults]setValue:level forKey:@"level"];
    
    [[NSUserDefaults standardUserDefaults]setValue:userID forKey:@"userID"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
#pragma mark -- 获得头像
- (NSString *) getUserHeaderImage{
    
    NSString *headerImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerImage"];
    
    return headerImage;
    
}
#pragma mark -- 获得级别
- (NSString *) getUserLevel{
    
    NSString *userLevel = [[NSUserDefaults standardUserDefaults]objectForKey:@"level"];
    
    return userLevel;
    
}
#pragma mark -- 获得id
- (NSString *) getUserID{
    
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    return userID;
    
}
#pragma mark -- 注销账户信息
- (void) cancelLYUserInfoManager{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userPassword"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"headerImage"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"level"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
}
@end
