//
//  AppDelegate.m
//  JXSQManagePlatform
//
//  Created by 吴坤 on 2017/7/1.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <MagicalRecord/MagicalRecord.h>
@interface AppDelegate (){
    BMKMapManager *mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    
    [self setAppWindows];
    [self setRootViewController];
    [gs_ReachabilityManager startMonitoring];
    [gs_HttpManager httpManagerGSNetworkReachabilityManage];
    
    // 要使用地图，首先需要BMKMapManager
    mapManager = [[BMKMapManager alloc]init];
    // opjKbnaurpRq5OHBBx8yrTXg9fnFbkLt填入验证码, 如需要使用网络和授权验证服务，则需要设置代理信息   uglwHzBeh6QkmfOwWBge3Nt1tgcwcBcf  测试环境nmwdmy06RLqmCXHHzfpGN9qA5e5zOhMR
    BOOL ret = [mapManager start:@"uglwHzBeh6QkmfOwWBge3Nt1tgcwcBcf" generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"地图管理器初始化失败");
    }
    else{
        NSLog(@"初始化成功");
    }
    [Bugly startWithAppId:@"0e96c28ca4"];
    [self VersonUpdate];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"RiverTourRecord.sqlite"];
    
    return YES;
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

-(void)VersonUpdate{
    //定义的app的地址1259098757
    NSString *urld = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@""];
    
    //网络请求app的信息，主要是取得我说需要的Version
    NSURL *url = [NSURL URLWithString:urld];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        
        if (data) {
            
            //data是有关于App所有的信息
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
                
                //请求的有数据，进行版本比较
                [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
    }];
    
    [task resume];
}

-(void)receiveData:(id)sender
{
    //获取APP自身版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *versionArray = [sender[@"version"] componentsSeparatedByString:@"."];
    
    
    if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
        
        if ([localArray[0] intValue] <  [versionArray[0] intValue]) {
            [self updateVersion];
        }else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue]) {
                [self updateVersion];
            }else if ([localArray[1] intValue] ==  [versionArray[1] intValue]){
                if ([localArray[2] intValue] <  [versionArray[2] intValue]) {
                    [self updateVersion];
                }
            }
        }
    }
}
-(void)updateVersion{
    NSString *msg = [NSString stringWithFormat:@"发现新版本,请及时更新,否则会影响您的正常使用!"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"你的app在商店的下载地址"]];
        //        [[UIApplication sharedApplication]openURL:url];
    }];
    [alertController addAction:otherAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
