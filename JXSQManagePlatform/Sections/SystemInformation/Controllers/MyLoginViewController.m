//
//  MyLoginViewController.m
//  PuYangJiangGovernance
//
//  Created by 吴坤 on 17/4/8.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "MyLoginViewController.h"
#import "LYUserInfoManager.h"
#import "HomeViewController.h"
//#import <RongIMKit/RongIMKit.h>
//获取手机型号需要导入
#import "sys/utsname.h"
//获取运行商需要导入
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "SAMKeychain.h"
@interface MyLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *pass;

@property (nonatomic, copy) NSString *bundleIdentifier;
@property (nonatomic, strong) NSMutableArray *allUserArr;
@end

@implementation MyLoginViewController
- (NSMutableArray *)allUserArr{
    if (!_allUserArr) {
        self.allUserArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _allUserArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.remberBtn.adjustsImageWhenHighlighted = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"rememberbtn"] == nil) {
        [defaults setInteger:0 forKey:@"rememberbtn"];
        [self.remberBtn setImage:[UIImage imageNamed:@"unrepass"] forState:UIControlStateNormal];
    }else if ([@"1" isEqualToString:F(@"%@", [defaults objectForKey:@"rememberbtn"])]) {
        [self.remberBtn setImage:[UIImage imageNamed:@"repass"] forState:UIControlStateNormal];
        self.pass = [defaults objectForKey:@"pass"];
        self.passwordTF.text = self.pass;
        self.UserName = [defaults objectForKey:@"username"];
        self.userNameTF.text = self.UserName;
    }else {
        [self.remberBtn setImage:[UIImage imageNamed:@"unrepass"] forState:UIControlStateNormal];
    }


    //配制texfied的属性
    [self configerUserNameTFAndPassTF];
}
- (void)configerUserNameTFAndPassTF{
    if (WT < 350) {
        self.userNameTF.frame = CGRectMake(0, 0, 220*WT/320.0, 30);
        self.userLine.frame = CGRectMake(0, CGRectGetMaxY(self.userNameTF.frame), 220*WT/320.0, 1);
        self.passwordTF.frame = CGRectMake(0, CGRectGetMaxY(self.userLine.frame)+10, 220*WT/320.0, 30);
        
        self.passLine.frame = CGRectMake(0, CGRectGetMaxY(self.passwordTF.frame), 220*WT/320.0, 1);
        self.remberBtn.frame = CGRectMake(80*WT/320.0, CGRectGetMaxY(self.passLine.frame)+10, 150*WT/320.0, 20);
        self.loginBtn.frame = CGRectMake(36*WT/320.0, CGRectGetMaxY(self.remberBtn.frame)+30, 150*WT/320.0, 40);
    } else if (WT > 350 && WT < 500) {
        self.userNameTF.frame = CGRectMake(0, 0, 242*WT/320.0, 30);
        self.userLine.frame = CGRectMake(0, CGRectGetMaxY(self.userNameTF.frame), 242*WT/320.0, 1);
        self.passwordTF.frame = CGRectMake(0, CGRectGetMaxY(self.userLine.frame)+10, 242*WT/320.0, 30);
        
        self.passLine.frame = CGRectMake(0, CGRectGetMaxY(self.passwordTF.frame), 242*WT/320.0, 1);
        self.remberBtn.frame = CGRectMake(120*WT/320.0, CGRectGetMaxY(self.passLine.frame)+10, 150*WT/320.0, 20);
        self.loginBtn.frame = CGRectMake(48*WT/320.0, CGRectGetMaxY(self.remberBtn.frame)+30, 150*WT/320.0, 40);
    } else {
        self.userNameTF.frame = CGRectMake(0, 0, 277*WT/320.0, 30);
        self.userLine.frame = CGRectMake(0, CGRectGetMaxY(self.userNameTF.frame), 277*WT/320.0, 1);
        self.passwordTF.frame = CGRectMake(0, CGRectGetMaxY(self.userLine.frame)+10, 277*WT/320.0, 30);
        
        self.passLine.frame = CGRectMake(0, CGRectGetMaxY(self.passwordTF.frame), 277*WT/320.0, 1);
        self.remberBtn.frame = CGRectMake(175*WT/320.0, CGRectGetMaxY(self.passLine.frame)+10, 150*WT/320.0, 20);
        self.loginBtn.frame = CGRectMake(65*WT/320.0, CGRectGetMaxY(self.remberBtn.frame)+30, 150*WT/320.0, 40);
    }
    
    
    self.userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTF.placeholder = @"请输入账号";
    self.userNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *userlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    userlab.textAlignment = NSTextAlignmentLeft;
    userlab.text = @"账户:";
    userlab.textColor = [UIColor whiteColor];
    [self.userNameTF.leftView addSubview:userlab];
    
    
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.placeholder = @"请输入密码";
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    [self.TFbackView addSubview:self.passwordTF];
    
    UILabel *passlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    passlab.text = @"密码:";
    passlab.textAlignment = NSTextAlignmentLeft;
    passlab.textColor = [UIColor whiteColor];
    [self.passwordTF.leftView addSubview:passlab];
    
    self.userNameTF.delegate = self;
    _userNameTF.tag = 911;
    [_userNameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.passwordTF.delegate = self;
    _passwordTF.tag = 912;
    _passwordTF.secureTextEntry = YES;
    [_passwordTF addTarget:self action:@selector(textFieldChangedPass:) forControlEvents:UIControlEventEditingChanged];
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.borderWidth = 1;
    [self GetTheLoginAccount];
}

static NSString * extracted() {
//    return SystemSettingsURLStr;
    return F(@"%@/SetUp", RequestURL);
}

- (void)readDataForLogin{
    DataSource *dataSource = [DataSource sharedDataSource];
    NSDictionary *param = @{
                            @"action":@"1",
                            @"method":F(@"{userName:%@,passWord:%@}", self.UserName,self.pass),
                            };

    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:extracted() isCacheorNot:NO targetViewController:self andUrlFunctionName:@"denglu" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            if ([dicData[@"Msg"] isEqualToString:@"成功"]) {
               
                NSDictionary *dic = dicData[@"Result"];
            
                if (![dic[@"UserID"] isKindOfClass:[NSNull class]]) {
                    dataSource.UserID = dic[@"UserID"];
                }else{
                    dataSource.UserID = @"-";
                }
                if (![dic[@"UserName"]isKindOfClass:[NSNull class]]) {
                   dataSource.SignInName = dic[@"UserName"];
                }else{
                    dataSource.SignInName = @"-";
                }
                if (![dic[@"RealName"]isKindOfClass:[NSNull class]]) {
                    dataSource.realNameStr = dic[@"RealName"];
                }else{
                    dataSource.realNameStr = @"-";
                }
                if (![dic[@"GroupType"]isKindOfClass:[NSNull class]]) {
                    dataSource.groupType = dic[@"GroupType"];
                }else{
                    dataSource.groupType = @"-";
                }
    
                if (![dic[@"GroupName"]isKindOfClass:[NSNull class]]) {
                       dataSource.GroupName = dic[@"GroupName"];
                }else{
                    dataSource.GroupName = @"-";
                }
                if (![dic[@"RiverID"]isKindOfClass:[NSNull class]]) {
                    dataSource.RiverID = dic[@"RiverID"];
                }else{
                    dataSource.RiverID = @"-";
                }
                if (![dic[@"RiverName"]isKindOfClass:[NSNull class]]) {
                    dataSource.RiverName = dic[@"RiverName"];
                }else{
                    dataSource.RiverName = @"-";
                }
                if (![dic[@"GroupID"] isKindOfClass:[NSNull class]]) {
                    dataSource.GroupID = dic[@"GroupID"];
                }else{
                    dataSource.GroupID = @"-";
                }
              
                if (![dic[@"RiverLength"]isKindOfClass:[NSNull class]]) {
                     dataSource.RiverLength = dic[@"RiverLength"];
                }else{
                    dataSource.RiverLength = @"-";
                }
                
                for (NSDictionary *menDic in dicData[@"MeanList"]) {
                    [dataSource.moduleArrIcon addObject:[menDic[@"MenuIcon"] stringByReplacingOccurrencesOfString:MenuIconURL withString:@""] ];
                    [dataSource.moduleArr addObject:menDic[@"MenuName"]];
                    [dataSource.cmListArr addObject:menDic[@"cmList"]];
                }

             
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if ([@"1" isEqualToString:F(@"%@", [defaults objectForKey:@"rememberbtn"])]) {
                    [self.remberBtn setImage:[UIImage imageNamed:@"repass"] forState:UIControlStateNormal];
                    [defaults setObject:self.pass forKey:@"pass"];
                    [defaults setObject:self.UserName forKey:@"username"];
                    
                    [defaults synchronize];
                    [SAMKeychain setPassword:self.pass forService:self.bundleIdentifier account:self.UserName];
                } else {
                    [self.remberBtn setImage:[UIImage imageNamed:@"unrepass"] forState:UIControlStateNormal];
                    [defaults setInteger:0 forKey:@"rememberbtn"];
                    [SAMKeychain deletePasswordForService:self.bundleIdentifier account:self.UserName];
                }
                
                
                
                
                // 跳转到程序界面(
                RootTabViewController *rootVC =  [[RootTabViewController alloc]init];
               [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                [self SetLoginLogSendMyApiRequest:nil];
            } else {
                [YJProgressHUD showError:@"请输入正确的用户名或密码"];
            }
            
        }else{
            [YJProgressHUD showError:@"请输入用户名或密码"];
        }
         [CustomHUD dismiss];
    } orFail:^(NSError *error) {
        NSLog(@"网络请求失败%@", error);
        [YJProgressHUD showError:@"数据获取失败"];
         [CustomHUD dismiss];
    }];

}


- (IBAction)loginAction:(id)sender {
    //
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    DataSource *dataSource = [DataSource sharedDataSource];
    dataSource.SignInName = self.UserName;
    dataSource.SignInPass = self.pass;
    [self readDataForLogin];

}
- (IBAction)remberAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([@"1" isEqualToString:F(@"%@", [defaults objectForKey:@"rememberbtn"])]) {
        [self.remberBtn setImage:[UIImage imageNamed:@"unrepass"] forState:UIControlStateNormal];
        [defaults setInteger:0 forKey:@"rememberbtn"];
    } else {//arrow_down
        [self.remberBtn setImage:[UIImage imageNamed:@"repass"] forState:UIControlStateNormal];
        [defaults setInteger:1 forKey:@"rememberbtn"];
        [defaults setObject:self.pass forKey:@"pass"];
        [defaults setObject:self.UserName forKey:@"username"];
        [defaults synchronize];
    }

    
}
- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textFieldChanged:(UITextField *)textField {
    self.UserName = textField.text;
    if (textField.text.length == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"pass"];
        [defaults setObject:nil forKey:@"username"];
        
        self.pass = @"";
        _passwordTF.text = self.pass;
        
//        if ([@"1" isEqualToString:F(@"%@", [defaults objectForKey:@"rememberbtn"])]) {
            [self.remberBtn setImage:[UIImage imageNamed:@"unrepass"] forState:UIControlStateNormal];
            [defaults setInteger:0 forKey:@"rememberbtn"];
//        } else {
//            [self.remberBtn setImage:[UIImage imageNamed:@"repass"] forState:UIControlStateNormal];
//            [defaults setInteger:1 forKey:@"rememberbtn"];
//            [defaults setObject:self.pass forKey:@"pass"];
//            [defaults setObject:self.UserName forKey:@"username"];
//            [defaults synchronize];
//        }
        
    }
    NSLog(@"UserName:%@",self.UserName);
}
- (void)textFieldChangedPass:(UITextField *)textField {
    
    self.pass = textField.text;
    NSLog(@"pass:%@",self.pass);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//获取设备登录信息
- (void)SetLoginLogSendMyApiRequest:(id)sender {
    DataSource *datamanger = [DataSource sharedDataSource];
    NSDateFormatter *dataformatter = [[NSDateFormatter alloc]init];
    dataformatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    _currentDateStr = [dataformatter stringFromDate:[NSDate date]];
    //    设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名字--------%@", deviceName);
    //    //运营商
    //    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    //    CTCarrier *carrier = info.subscriberCellularProvider;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _PhoneType = @"iPhone";
    } else {
        _PhoneType = @"iPad";
    }
    //手机型号
    NSString *phoneModel = [self iphoneType];//方法在下面
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //获取设备的唯一标识符
    //        NSString *UUID = [[NSUUID UUID] UUIDString];
    //    NSString *UUID = [self uuid];
    
    NSDictionary *param = @{
                            @"action":@"3",
                            @"method":F(@"{userName:%@,realName:%@,dateTimes:%@,osName:%@,phoneFactory:%@,phoneType:%@,sDKVersion:%@,systemVersion:%@}", datamanger.SignInName, datamanger.realNameStr,_currentDateStr,deviceName, @"Apple", phoneModel, @"0", phoneVersion),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:SystemSettingsURLStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"denglujilu" success:^(id result) {
        NSLog(@"登录信息上传成功%@", result);
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPodTouch6G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad4";
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPadAir2";
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPadmini4";
    //iPad Pro
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhoneSimulator";
    return platform;
    
}
- (void)GetTheLoginAccount {
    [self.allUserArr removeAllObjects];
    self.bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    self.bundleIdentifier = @"JXGQ";
    //    [SAMKeychain deletePasswordForService:self.bundleIdentifier account:@"tangsl"];
    NSArray *arr = [SAMKeychain accountsForService:self.bundleIdentifier];
    for (NSDictionary *dic in arr) {
        [self.allUserArr addObject:dic[@"acct"]];
    }
    NSLog(@"-------------- %@", self.allUserArr);
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
    [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
    [options setValue:nil forKey:ACOUseSourceFont];
    _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.userNameTF inViewController:self withOptions:options];
    _autoCompleter.tabDelegate = self;
    _autoCompleter.suggestionsDictionary = self.allUserArr;  //@[@"test",@"admin",@"assss",@"wdhg"];
    [self.TFbackView addSubview:_autoCompleter];
}
#pragma mark - AutocompletionTableViewDelegate
- (void)autoCompletionTableView:(AutocompletionTableView *)completionView deleteString:(NSString *)sString {
    NSLog(@"------------ %@", sString);
}
//点击序号
- (void)autoCompletionTableView:(AutocompletionTableView *)completionView didSelectString:(NSString *)sString {
    NSLog(@"============== %@", sString);
    _userNameTF.text = sString;
    self.UserName = sString;
    
    self.pass = [SAMKeychain passwordForService:self.bundleIdentifier account:sString];
    _passwordTF.text = self.pass;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([@"1" isEqualToString:F(@"%@", [defaults objectForKey:@"rememberbtn"])]) {
        [self.remberBtn setImage:[UIImage imageNamed:@"unrepass"] forState:UIControlStateNormal];
        [defaults setInteger:0 forKey:@"rememberbtn"];
    } else {
        [self.remberBtn setImage:[UIImage imageNamed:@"repass"] forState:UIControlStateNormal];
        [defaults setInteger:1 forKey:@"rememberbtn"];
        [defaults setObject:self.pass forKey:@"pass"];
        [defaults setObject:self.UserName forKey:@"username"];
        [defaults synchronize];
    }
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [_autoCompleter hideOptionsView];
}

@end
