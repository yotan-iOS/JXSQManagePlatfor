//
//  SimpleDemoViewController.m
//  SimpleDemo
//
//  Created by apple on 11-4-2.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
#import "SimpleDemoViewController.h"
#import "hcnetsdk.h"
#import "HikDec.h"
#import "OtherTest.h"
#import "VoiceTalk.h"
#import "Preview.h"
#import "EzvizTrans.h"
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <net/if.h>
#include <map>

@implementation SimpleDemoViewController

@synthesize m_playView;

@synthesize m_playButton;
@synthesize m_loginButton;
@synthesize m_captureButton;
@synthesize m_ptzButton;
@synthesize m_ptzCenter;
@synthesize m_ptzRight;
@synthesize leftUpPtz;
@synthesize upPtz;
@synthesize rightUpPtz;

@synthesize m_lUserID;
@synthesize m_lRealPlayID;
@synthesize m_lPlaybackID;
@synthesize m_bPreview;
@synthesize m_bRecord;
@synthesize m_bPTZL;
@synthesize m_bVoiceTalk;
@synthesize m_bStopPlayback;


SimpleDemoViewController *g_pController = NULL;

int g_iStartChan = 0;
int g_iPreviewChanNum = 0;

void g_fExceptionCallBack(DWORD dwType, LONG lUserID, LONG lHandle, void *pUser)
{
    NSLog(@"g_fExceptionCallBack Type[0x%x], UserID[%d], Handle[%d]", dwType, lUserID, lHandle);
}



//清楚预置点
- (void)ptzClearPRESETClickedUp{
    if(!NET_DVR_PTZPreset_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, GOTO_PRESET, 1)) {
        NSLog(@"start GOTO_PRESET failed with[%d]", NET_DVR_GetLastError());
    }
}
// capture button click
-(IBAction)captureBtnClicked:(id)sender
{
    NSLog(@"captureBtnClicked");
    if (m_lRealPlayID < 0) {
        NSLog(@"Please start realplay first!");
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    char szFileName[256] = {0};
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    date = [formatter stringFromDate:[NSDate date]];
   
    sprintf(szFileName, "%s/%s.bmp", (char*)documentsDirectory.UTF8String, (char*)date.UTF8String);
    NSLog(@"m_lRealPlayID--%d---%s",m_lRealPlayID,szFileName);
//    if(NET_DVR_CapturePictureBlock(m_lRealPlayID, szFileName, 0))
//    {
//        NSLog(@"NET_DVR_CapturePicture succ[%s]", szFileName);
//        NSString *str  = [NSString stringWithFormat:@"%s",szFileName];
//        self.savedImage = [[UIImage alloc] initWithContentsOfFile:str];
//        UIImageWriteToSavedPhotosAlbum(self.savedImage, self, nil, NULL);
//        //        [YJProgressHUD showSuccess:@"截图已存入相册"];
//        DataSource *dataSource = [DataSource sharedDataSource];
//        if ([dataSource.tagString isEqualToString:@"51"]) {
//            //            NSData *fileData = UIImageJPEGRepresentation(self.savedImage, 0.2);
//            //            NSString *fileString = [fileData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            NSString *filename = [NSString stringWithFormat:@"%@.bmp",date];
//            self.imgName = filename;
//            [self alert:@"提示" message:@"现场照片已抓拍，是否进入交办功能？"];
//        }else{
//            [YJProgressHUD showSuccess:@"截图已存入相册"];
//        }
//        [formatter release];
//        [self.savedImage release];
//    }
//    else
//    {
//        NSLog(@"NET_DVR_CapturePicture failed[%d]", NET_DVR_GetLastError());
//             [YJProgressHUD showError:@"截图保存失败"];
//    }
    if(NET_DVR_CapturePictureBlock(m_lRealPlayID, szFileName, 0))
    {
        NSLog(@"NET_DVR_CapturePicture succ[%s]", szFileName);
    }
    else
    {
        NSLog(@"NET_DVR_CapturePicture failed[%d]", NET_DVR_GetLastError());
    }
    
    
    self.savedImage = [self openglSnapshotImage];
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    NSData *imgdata = UIImageJPEGRepresentation(self.savedImage, 1.0);
    [library writeImageDataToSavedPhotosAlbum:imgdata metadata:nil completionBlock:nil];

    UIImageWriteToSavedPhotosAlbum(self.savedImage, self, nil, NULL);
    DataSource *dataSource = [DataSource sharedDataSource];
    if ([dataSource.tagString isEqualToString:@"51"]) {
        NSString *filename = [NSString stringWithFormat:@"%@.bmp",date];
        self.imgName = filename;
        [self alert:@"提示" message:@"现场照片已抓拍，是否进入交办功能？"];
    }else{
        [YJProgressHUD showSuccess:@"截图已存入相册"];
    }
    
    

    return;
}


// preview button Click
-(IBAction) playerBtnClicked:(id)sender {
	NSLog(@"liveStreamBtnClicked");
	
    if(g_iPreviewChanNum > 1) {
        if(!m_bPreview) {
            int iPreviewID[MAX_VIEW_NUM] = {0};
            m_lRealPlayID = startPreview(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, m_playView, 0);
            m_lRealPlayID = iPreviewID[0];
            m_bPreview = true;
            [m_playButton setTitle:@"Stop Preview" forState:UIControlStateNormal];
        } else {
            stopPreview(0);
            m_bPreview = false;
            [m_playButton setTitle:@"Start Preview" forState:UIControlStateNormal];
        }
    } else {
        if(!m_bPreview)
        {
            m_lRealPlayID = startPreview(m_lUserID, g_iStartChan+[self.CamIndexCode intValue]-1, m_playView, 0);
                m_bPreview = true;
                [m_playButton setTitle:@"Stop Preview" forState:UIControlStateNormal];
        }
        else
        {
            stopPreview(0);
            m_bPreview = false;
            [m_playButton setTitle:@"Start Preview" forState:UIControlStateNormal];
        }
    }
    //隐藏button
    m_playButton.hidden = YES;
}

//start player
- (void) startPlayer {
	[self performSelectorOnMainThread:@selector(playerPlay) 
						   withObject:nil
						waitUntilDone:NO];
}
- (bool) loginNormalDevice {
    //  Get value   218.108.63.142    27098     admin      a1234567   iP:39.155.253.194 Port:20012 UsrName:admin Password:a1234567
    NSString * iP  = self.videoIP;
    NSString *port = self.videoPort;
    NSString  *usrName = self.videoName;
    NSString *password = self.videoPassword;

    
    DeviceInfo *deviceInfo = [[DeviceInfo alloc] init];
    deviceInfo.chDeviceAddr = iP;
    deviceInfo.nDevicePort = [port integerValue];
    deviceInfo.chLoginName = usrName;
    deviceInfo.chPassWord = password;
    
    // device login
    NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
    
    // encode type
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    m_lUserID = NET_DVR_Login_V30((char*)[deviceInfo.chDeviceAddr UTF8String],
                                  deviceInfo.nDevicePort,
                                  (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc],
                                  (char*)[deviceInfo.chPassWord UTF8String],
                                  &logindeviceInfo);
    
    printf("iP:%s\n", (char*)[deviceInfo.chDeviceAddr UTF8String]);
    printf("Port:%d\n", deviceInfo.nDevicePort);
    printf("UsrName:%s\n", (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc]);
    printf("Password:%s\n", (char*)[deviceInfo.chPassWord UTF8String]);
    
    // login on failed
    if (m_lUserID == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:kWarningTitle
                              message:kLoginDeviceFailMsg
                              delegate:nil
                              cancelButtonTitle:kWarningConfirmButton
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return false;
    }
    
    if(logindeviceInfo.byChanNum > 0)
    {
        g_iStartChan = logindeviceInfo.byStartChan;
        g_iPreviewChanNum = logindeviceInfo.byChanNum;
    }
    else if(logindeviceInfo.byIPChanNum > 0)
    {
        g_iStartChan = logindeviceInfo.byStartDChan;
        g_iPreviewChanNum = logindeviceInfo.byIPChanNum + logindeviceInfo.byHighDChanNum * 256;
    }
    
    return true;
}
- (bool) loginEZVIZDevice {
    NET_DVR_OPEN_EZVIZ_USER_LOGIN_INFO struLoginInfo = {0};
    NET_DVR_DEVICEINFO_V30 struDeviceInfo = {0};
        
    sprintf(struLoginInfo.sEzvizServerAddress, "pbdev.ys7.com");
    struLoginInfo.wPort = 443;
    sprintf(struLoginInfo.sAccessToken, "at.bt7wddra6zcmuzs8dgsigxes5118s7ej-7p0aqoy9qr-17h7lx5-63cdp4wrc");
    sprintf(struLoginInfo.sAppID, "com.hik.visualintercom");
    sprintf(struLoginInfo.sFeatureCode, "226f102a99ad0e078504d380b9ddf760");
    sprintf(struLoginInfo.sUrl, "/api/device/transmission");
    sprintf(struLoginInfo.sDeviceID, "111111223");
    sprintf(struLoginInfo.sClientType, "0");
    sprintf(struLoginInfo.sOsVersion, "5.0.1");
    sprintf(struLoginInfo.sNetType, "UNKNOWN");
    sprintf(struLoginInfo.sSdkVersion, "v.5.1.5.30");
        
    m_lUserID = NET_DVR_CreateOpenEzvizUser(&struLoginInfo, &struDeviceInfo);
    NSLog(@"0000000000000 NET_DVR_CreateEzvizUser[%d] with[%d]", m_lUserID, NET_DVR_GetLastError());
        
    // login on failed
    if (m_lUserID == -1) {
        DWORD dwRet = -1;
        dwRet = NET_DVR_GetLastError();
        UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:kWarningTitle
                                message:kLoginDeviceFailMsg
                                delegate:nil
                                cancelButtonTitle:kWarningConfirmButton
                                otherButtonTitles:nil];
        [alert show];
        [alert release];
        return false;
    }
    return true;
}

// login button click
- (void) loginBtnClicked {
    NSLog(@"loginBtnClicked");
    
    if (m_lUserID == -1) {
        // init
        BOOL bRet = NET_DVR_Init();
        if (!bRet)
        {
            NSLog(@"NET_DVR_Init failed");
        }
        NET_DVR_SetExceptionCallBack_V30(0, NULL, g_fExceptionCallBack, NULL);
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        const char* pDir = [documentPath UTF8String];
        NET_DVR_SetLogToFile(3, (char*)pDir, true);
        
        if([self loginNormalDevice]) {
            [m_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        }
    } else {
        NET_DVR_Logout(m_lUserID);
//        NET_DVR_DeleteOpenEzvizUser(m_lUserID);
        NET_DVR_Cleanup();
        m_lUserID = -1;
        [m_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }	
}

//stop preview
- (void) stopPlay {
	if (m_lRealPlayID != -1) {
		NET_DVR_StopRealPlay(m_lRealPlayID);
		m_lRealPlayID = -1;		
	}
}

//stop playback
- (void) stopPlayback {
    if (m_lPlaybackID != -1) {
        NET_DVR_StopPlayBack(m_lPlaybackID);
        m_lPlaybackID = -1;
    }
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad  {
    DataSource *datasoure = [DataSource sharedDataSource];
    if ([datasoure.tagString isEqualToString:@"11"]) {
        self.title = self.videoTitle;
        self.m_playView.frame = CGRectMake(0, NAVIHEIGHT, WT, 300*HT/568.0);
        self.m_playButton.frame = CGRectMake(0, NAVIHEIGHT, WT, 300*HT/568.0);
    } else {
        self.m_playView.frame = CGRectMake(0, 0, WT, 280*HT/568.0);
        self.m_playButton.frame = CGRectMake(0, 0, WT, 280*HT/568.0);
    }
    
    self.view.backgroundColor = UIColorFromRGB(0x3FB3E6);
    
    
    m_lUserID = -1;
    m_lRealPlayID = -1;
    m_lPlaybackID = -1;
    m_bRecord = false;
    m_bPTZL = false;
    
    
    int nWidth = m_playView.frame.size.width / 2;
    int nHeight = m_playView.frame.size.height / 2;
    for(int i = 0; i < MAX_VIEW_NUM; i++) {
        m_multiView[i] = [[UIView alloc] initWithFrame:CGRectMake((i%(MAX_VIEW_NUM/2)) * nWidth, (i/(MAX_VIEW_NUM/2)) * nHeight, nWidth - 1, nHeight - 1)];
        m_multiView[i].backgroundColor = [UIColor clearColor];
        [m_playView addSubview:m_multiView[i]];
    }
    
    
    g_pController = self;
    
	[super viewDidLoad];
//    if ([datasoure.tagString isEqualToString:@"2"]) {
//        [CustomHUD showIndicator];
//    }
    [self sendSitIDVideoRequeset];
    if ([datasoure.tagString isEqualToString:@"51"]) {
         [self twoviewChoose];
    }else{
        [self oneChooseView];
    }
   
}
- (void)sendSitIDVideoRequeset {
    DataSource *dataSour = [DataSource sharedDataSource];
    NSString *actionId = [[NSString alloc] init];
    NSString *urlStr = [[NSString alloc] init];
    if ([dataSour.tagString isEqualToString:@"11"]) {////河长管理 实时视频
        actionId = @"8";
        urlStr = BaseRiverMURLStr;
    } else {//水环境
        actionId = @"6";
        urlStr = BaseWaterEnURLStr;
    }
    NSDictionary *param = @{
                            @"action":F(@"%@", actionId),
                            @"method":F(@"{siteID:%@}", self.siteID),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"statemmm" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            NSDictionary *dic = dicData[@"Result"];
            self.videoIP = dic[@"CamIP"];
            self.videoPort = dic[@"CamPhonePort1"];
            self.videoName = dic[@"CamUser"];
            self.videoPassword = dic[@"CamPass"];
            self.CamIndexCode = dic[@"CamIndexCode1"];
        }
        NSLog(@"videoIP--%@videoPort---%@CamIndexCode---%@",self.videoIP,self.videoPort,self.CamIndexCode);
        if (self.CamIndexCode.length>0) {
            [self loginBtnClicked];
            [self playerBtnClicked:nil];
        }else{
            
//            [self alert:@"提示" message:@"暂无视频"];
            [YJProgressHUD showError:@"暂无视频"];
        }
        
        
    } orFail:^(NSError *error) {
        [MBProgressHUD showError:@"数据请求失败,请检查网络"];
        NSLog(@"%@", error);
    }];
}
- (void)didReceiveMemoryWarning  {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload  {

	if (m_lRealPlayID != -1)
	{
		NET_DVR_StopRealPlay(m_lRealPlayID);
		m_lRealPlayID = -1;
	}
    
    if(m_lPlaybackID != -1)
    {
        NET_DVR_StopPlayBack(m_lPlaybackID);
        m_lPlaybackID = -1;
    }
    
    if(m_lUserID != -1)
    {
        NET_DVR_Logout(m_lUserID);
        NET_DVR_Cleanup();
        m_lUserID = -1;
    }
}


// hide copy and paste button
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	[UIMenuController sharedMenuController].menuVisible = NO;
	
	return YES;
}

- (void)dealloc {
	if (m_playView != nil) {
		[m_playView release];
		m_playView = nil;
	}
	
    [_oneView release];
    [super dealloc];
}
//view
- (void)oneChooseView {
    DataSource *datasoure = [DataSource sharedDataSource];
    if ([datasoure.tagString isEqualToString:@"11"]){
        _oneView.frame = CGRectMake(0, 370*HT/568.0, WT, 400);
    } else {
        _oneView.frame = CGRectMake(0, 300*HT/568.0, WT, 400);
    }
    
    self.leftUpPtz.frame = CGRectMake(40*WT/320.0, 5*WT/320.0, 40.1*WT/320.0, 40.1*WT/320.0);
    self.upPtz.frame = CGRectMake(CGRectGetMaxX(self.leftUpPtz.frame)+25*WT/320.0, 5*WT/320.0, 40.1*WT/320.0, 40.1*WT/320.0);
    self.rightUpPtz.frame = CGRectMake(CGRectGetMaxX(self.upPtz.frame)+25*WT/320.0, 5*WT/320.0, 40.1*WT/320.0, 40.1*WT/320.0);
    self.zoominPtz.frame = CGRectMake(CGRectGetMaxX(self.rightUpPtz.frame)+25*WT/320.0, 5*WT/320.0, 40.1*WT/320.0, 40.1*WT/320.0);

    m_ptzButton.frame = CGRectMake(40*WT/320.0, CGRectGetMaxY(self.leftUpPtz.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    m_ptzCenter.frame = CGRectMake(CGRectGetMaxX(m_ptzButton.frame)+25*WT/320.0, CGRectGetMaxY(self.leftUpPtz.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    m_ptzRight.frame = CGRectMake(CGRectGetMaxX(m_ptzCenter.frame)+25*WT/320.0, CGRectGetMaxY(self.leftUpPtz.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    self.zoomOouPtz.frame = CGRectMake(CGRectGetMaxX(m_ptzRight.frame)+25*WT/320.0, CGRectGetMaxY(self.leftUpPtz.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    self.leftDownPtz.frame = CGRectMake(40*WT/320.0, CGRectGetMaxY(m_ptzButton.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    self.downPtz.frame = CGRectMake(CGRectGetMaxX(self.leftDownPtz.frame)+25*WT/320.0, CGRectGetMaxY(m_ptzButton.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    self.rightDownPtz.frame = CGRectMake(CGRectGetMaxX(self.downPtz.frame)+25*WT/320.0, CGRectGetMaxY(m_ptzButton.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    self.m_captureButton.frame = CGRectMake(CGRectGetMaxX(self.rightDownPtz.frame)+25*WT/320.0, CGRectGetMaxY(m_ptzButton.frame)+10, 40.1*WT/320.0, 40.1*WT/320.0);
    
    [self.view addSubview:self.oneView];
}

- (void)twoviewChoose {
    self.twoView = [[UIView alloc] init];
    _twoView.frame = CGRectMake(0, 380*HT/568, SCREEN_WIDTH, 200);
    if (WTALL < 350) {
        m_ptzBegin.frame = CGRectMake(SCREEN_WIDTH/3-40.1*WT/320.0-5, 28, 40.1*WT/320.0, 40.1*WT/320.0);
    } else if (WTALL >350 && WTALL < 500) {
        m_ptzBegin.frame = CGRectMake(SCREEN_WIDTH/3-40.1*WT/320.0, 28, 40.1*WT/320.0, 40.1*WT/320.0);
    } else {
        m_ptzBegin.frame = CGRectMake(SCREEN_WIDTH/3-40.1*WT/320.0+40, 28, 40.1*WT/320.0, 40.1*WT/320.0);
    }
    m_ptzEnd.frame = CGRectMake(CGRectGetMaxX(m_ptzBegin.frame)+40.1, 28, 40.1*WT/320.0, 40.1*WT/320.0);
    m_captureButton.frame = CGRectMake(CGRectGetMaxX(m_ptzEnd.frame)+40.1, 28, 40.1*WT/320.0, 40.1*WT/320.0);
    [self.twoView addSubview:m_ptzBegin];
    [self.twoView addSubview:m_ptzEnd];
    [self.twoView addSubview:m_captureButton];
    [self.view addSubview:_twoView];
}

//点击返回停止视频播放
- (void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self ptzClearPRESETClickedUp];
        NSLog(@"clicked navigationbar back button");
        if(g_iPreviewChanNum > 1) {
            if(m_bPreview)
            {
                for(int i = 0; i < MAX_VIEW_NUM; i++)
                {
                    stopPreview(i);
                }
                m_bPreview = false;
                [m_playButton setTitle:@"Start Preview" forState:UIControlStateNormal];
            }
            else
            {
                int iPreviewID[MAX_VIEW_NUM] = {0};
                for(int i = 0; i < MAX_VIEW_NUM; i++)
                {
                    iPreviewID[i] = startPreview(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, m_multiView[i], i);
                }
                m_lRealPlayID = iPreviewID[0];
                m_bPreview = true;
                [m_playButton setTitle:@"Stop Preview" forState:UIControlStateNormal];
            }
        }
        else
        {
            if(m_bPreview)
            {
                stopPreview(0);
                m_bPreview = false;
                [m_playButton setTitle:@"Start Preview" forState:UIControlStateNormal];
            }
            else
            {
                m_lRealPlayID = startPreview(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, m_playView, 0);
                m_bPreview = true;
                [m_playButton setTitle:@"Stop Preview" forState:UIControlStateNormal];
                
            }
        }
    }
}

- (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    // 设置popover指向的item
    alert.popoverPresentationController.sourceView = m_captureButton;
    alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
        HandInContentViewController *handCntent = [[HandInContentViewController alloc]init];
        handCntent.idString = self.siteID;
        handCntent.titString = self.title;
        handCntent.imgs = self.savedImage;
        handCntent.imagPathStr = self.imgName;
        handCntent.stationModel = self.stationModel;
        [self.navigationController pushViewController:handCntent animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
        [YJProgressHUD showSuccess:@"截图已存入相册"];
    }]];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
//左
- (IBAction)ptzBtnClicked:(id)sender {
    NSLog(@"ptzBtnClicked");
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan + [self.CamIndexCode intValue]-1, PAN_LEFT, 0)) {
        NSLog(@"start PAN_LEFT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start PAN_LEFT succ");
    }
}

- (IBAction)ptzBtnClickedUp:(id)sender {
    NSLog(@"ptzBtnClickedUp");
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, PAN_RIGHT, 1)) {
        NSLog(@"stop PAN_RIGHT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop PAN_RIGHT succ");
    }
}
//中
- (IBAction)ptzCenterClicked:(id)sender {
    NSLog(@"ptzBtnClickedUp");
    if(!NET_DVR_PTZPreset_Other(m_lUserID, g_iStartChan + [self.CamIndexCode intValue]-1, GOTO_PRESET, 1)){
        NSLog(@"PTZPreset_Other GOTO_PRESET failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"PTZPreset_Other GOTO_PRESET succ");
    }
}

- (IBAction)ptzCenterClickedUp:(id)sender {
    NSLog(@"ptzBtnClickedUp");
    if(!NET_DVR_PTZPreset_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, GOTO_PRESET, 2)) {
        NSLog(@"PTZPreset_Other GOTO_PRESET failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"PTZPreset_Other GOTO_PRESET succ");
    }
}

//右
- (IBAction)ptzRightClocked:(id)sender {
    NSLog(@"ptzBtnClicked");
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, PAN_RIGHT, 0)) {
        NSLog(@"start PAN_RIGHT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start PAN_RIGHT succ");
    }
}

- (IBAction)ptzRightClockedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, PAN_LEFT, 1)) {
        NSLog(@"stop PAN_LEFT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop PAN_LEFT succ");
    }
}
//左上
- (IBAction)ptzLeftUpClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, UP_LEFT, 0)) {
        NSLog(@"start UP_LEFT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start UP_LEFT succ");
    }
}

- (IBAction)ptzLeftUpClickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, DOWN_RIGHT, 1)) {
        NSLog(@"stop DOWN_RIGHT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop DOWN_RIGHT succ");
    }
}
//上
- (IBAction)ptzUpClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, TILT_UP, 0)) {
        NSLog(@"start TILT_UP failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start TILT_UP succ");
    }
}

- (IBAction)ptzUpclickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, TILT_DOWN, 1)) {
        NSLog(@"stop TILT_DOWN failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop TILT_DOWN succ");
    }
}
//右上
- (IBAction)ptzRightUpClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, UP_RIGHT, 0)) {
        NSLog(@"start UP_RIGHT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start UP_RIGHT succ");
    }
}

- (IBAction)ptzRightUpClickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, DOWN_LEFT, 1)) {
        NSLog(@"stop DOWN_LEFT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop DOWN_LEFT succ");
    }
}
//左下
- (IBAction)ptzLeftDownClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, DOWN_LEFT, 0)) {
        NSLog(@"start DOWN_LEFT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start DOWN_LEFT succ");
    }
}

- (IBAction)ptzLeftDownClickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, UP_RIGHT, 1)) {
        NSLog(@"stop UP_RIGHT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop UP_RIGHT succ");
    }
}
//下
- (IBAction)ptzDownClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, TILT_DOWN, 0)) {
        NSLog(@"start TILT_DOWN failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start TILT_DOWN succ");
    }
}
- (IBAction)ptzDownClickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, TILT_UP, 1)) {
        NSLog(@"stop TILT_UP failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop TILT_UP succ");
    }
}
//右下
- (IBAction)ptzRightDownClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, DOWN_RIGHT, 0)) {
        NSLog(@"start DOWN_RIGHT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start DOWN_RIGHT succ");
    }
}

- (IBAction)ptzRightDownClickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, UP_LEFT, 1)) {
        NSLog(@"stop UP_LEFT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop UP_LEFT succ");
    }
}
//放大
- (IBAction)ptzZoomInClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, ZOOM_IN, 0)) {
        NSLog(@"start ZOOM_IN failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start ZOOM_IN succ");
    }
}

- (IBAction)ptzZoomInClickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, ZOOM_OUT, 1)) {
        NSLog(@"stop ZOOM_OUT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop ZOOM_OUT succ");
    }
}
//缩小
- (IBAction)ptzZoomOutClicked:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, ZOOM_OUT, 0)) {
        NSLog(@"start ZOOM_OUT failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start ZOOM_OUT succ");
    }
}

- (IBAction)ptzZoomOutClickedUp:(id)sender {
    if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan +[self.CamIndexCode intValue]-1, ZOOM_IN, 1)) {
        NSLog(@"stop ZOOM_IN failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"stop ZOOM_IN succ");
    }
}
- (IBAction)ptzBeginCruiseClicked:(UIButton *)sender {
    if(!NET_DVR_PTZCruise_Other(m_lUserID, g_iStartChan+[self.CamIndexCode intValue]-1, RUN_SEQ, 1, 1, 1)) {
        NSLog(@"start RUN_SEQ failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start RUN_SEQ succ");
    }
}
- (IBAction)ptzBeginCruiseClickedUp:(UIButton *)sender {
    if(!NET_DVR_PTZCruise_Other(m_lUserID, g_iStartChan+[self.CamIndexCode intValue]-1, RUN_SEQ, 32, 32, 255)) {
        NSLog(@"start RUN_SEQ failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start RUN_SEQ succ");
    }
}
- (IBAction)ptzEndCruiseClicked:(UIButton *)sender {
    if(!NET_DVR_PTZCruise_Other(m_lUserID, g_iStartChan+[self.CamIndexCode intValue]-1, STOP_SEQ, 1, 1, 1)) {
        NSLog(@"start STOP_SEQ failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start STOP_SEQ succ");
    }
}
- (IBAction)ptzEndCruiseClickedUp:(UIButton *)sender {
    if(!NET_DVR_PTZCruise_Other(m_lUserID, g_iStartChan+[self.CamIndexCode intValue]-1, STOP_SEQ, 1, 1, 1)) {
        NSLog(@"start STOP_SEQ failed with[%d]", NET_DVR_GetLastError());
    } else {
        NSLog(@"start STOP_SEQ succ");
    }
}
- (UIImage *)openglSnapshotImage {
    CGSize size = self.m_playView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = self.m_playView.frame;
    [self.m_playView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

@end
