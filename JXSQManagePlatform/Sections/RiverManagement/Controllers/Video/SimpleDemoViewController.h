//
//  SimpleDemoViewController.h
//  SimpleDemo
//
//  Created by apple on 11-4-2.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"
#import "HandInContentViewController.h"
#import "StationModel.h"
#define RTP

@interface SimpleDemoViewController : UIViewController 
{
	
	IBOutlet UIButton		*m_playButton;	
    IBOutlet UIButton       *m_loginButton;
    
    IBOutlet UIButton       *m_captureButton;
    IBOutlet UIButton       *m_ptzButton;
    IBOutlet UIButton *m_ptzRight;
    IBOutlet UIButton *m_ptzCenter;
    IBOutlet UIButton *upPtz;
    IBOutlet UIButton *leftUpPtz;
    IBOutlet UIButton *rightUpPtz;
    IBOutlet UIButton *leftDownPtz;
    IBOutlet UIButton *downPtz;
    IBOutlet UIButton *rightDownPtz;
    IBOutlet UIButton *zoominPtz;
    IBOutlet UIButton *zoomOouPtz;
    
    IBOutlet UIButton *m_ptzBegin;
    IBOutlet UIButton *m_ptzEnd;
	UIView                  *m_playView;
    UIView                  *m_multiView[4];
	
	id                      m_playThreadID;
	bool					m_bThreadRun;
	int                     m_lUserID;
	int                     m_lRealPlayID;
    int                     m_lPlaybackID;
    bool                    m_bPreview;
    bool                    m_bRecord;
    bool                    m_bPTZL;
    bool                    m_bVoiceTalk;
    bool                    m_bStopPlayback;
    
    }
@property (retain, nonatomic) IBOutlet UIView *oneView;
@property (strong, nonatomic) IBOutlet UIView *twoView;


@property (nonatomic, retain) IBOutlet UIView	    *m_playView;

@property (nonatomic, retain) IBOutlet UIButton		*m_playButton;
@property (nonatomic, retain) IBOutlet UIButton        *m_loginButton;
@property (nonatomic, retain) IBOutlet UIButton     *m_captureButton;
@property (nonatomic, retain) IBOutlet UIButton     *m_ptzButton;

@property (strong, nonatomic) IBOutlet UIButton *m_ptzCenter;
@property (strong, nonatomic) IBOutlet UIButton *m_ptzRight;
@property (strong, nonatomic) IBOutlet UIButton *leftUpPtz;
@property (strong, nonatomic) IBOutlet UIButton *upPtz;
@property (strong, nonatomic) IBOutlet UIButton *rightUpPtz;
@property (strong, nonatomic) IBOutlet UIButton *leftDownPtz;
@property (strong, nonatomic) IBOutlet UIButton *downPtz;
@property (strong, nonatomic) IBOutlet UIButton *rightDownPtz;
@property (strong, nonatomic) IBOutlet UIButton *zoominPtz;
@property (strong, nonatomic) IBOutlet UIButton *zoomOouPtz;


@property (nonatomic, retain) id m_playThreadID;
@property bool m_bThreadRun;
@property int m_lUserID;
@property int m_lRealPlayID;
@property int m_lPlaybackID;
@property bool m_bPreview;
@property bool m_bRecord;
@property bool m_bPTZL;
@property bool m_bVoiceTalk;
@property bool m_bStopPlayback;


-(IBAction) playerBtnClicked:(id)sender;

//-(IBAction) loginBtnClicked:(id)sender;
-(IBAction) captureBtnClicked:(id)sender;
//开始巡航
- (IBAction)ptzBeginCruiseClicked:(id)sender;
- (IBAction)ptzBeginCruiseClickedUp:(id)sender;
//结束巡航
- (IBAction)ptzEndCruiseClicked:(id)sender;
- (IBAction)ptzEndCruiseClickedUp:(id)sender;


//清楚预置点
- (void)ptzClearPRESETClickedUp;
//左
- (IBAction)ptzBtnClicked:(id)sender;
- (IBAction)ptzBtnClickedUp:(id)sender;
//中
- (IBAction)ptzCenterClicked:(id)sender;
- (IBAction)ptzCenterClickedUp:(id)sender;
//右
- (IBAction)ptzRightClocked:(id)sender;
- (IBAction)ptzRightClockedUp:(id)sender;
//左上
- (IBAction)ptzLeftUpClicked:(id)sender;
- (IBAction)ptzLeftUpClickedUp:(id)sender;
//上
- (IBAction)ptzUpClicked:(id)sender;
- (IBAction)ptzUpclickedUp:(id)sender;
//右上
- (IBAction)ptzRightUpClicked:(id)sender;
- (IBAction)ptzRightUpClickedUp:(id)sender;
//左下
- (IBAction)ptzLeftDownClicked:(id)sender;
- (IBAction)ptzLeftDownClickedUp:(id)sender;
//下
- (IBAction)ptzDownClicked:(id)sender;
- (IBAction)ptzDownClickedUp:(id)sender;
//右下
- (IBAction)ptzRightDownClicked:(id)sender;
- (IBAction)ptzRightDownClickedUp:(id)sender;
//放大
- (IBAction)ptzZoomInClicked:(id)sender;
- (IBAction)ptzZoomInClickedUp:(id)sender;
//缩小
- (IBAction)ptzZoomOutClicked:(id)sender;
- (IBAction)ptzZoomOutClickedUp:(id)sender;



- (bool) validateValue:(DeviceInfo*)deviceInfo;
- (bool) isValidIP:(NSString *)ipStr;
- (void) startPlay;
- (void) stopPlay;
- (void) startPlayback;
- (void) stopPlayback;

- (bool) loginNormalDevice;
- (bool) loginEZVIZDevice;


@property (nonatomic, copy) NSString *videoTitle;//获取标题
@property (nonatomic, copy) NSString *videoIP;//获取IP地址
@property (nonatomic, copy) NSString *videoPort;//获取端口号
@property (nonatomic, copy) NSString *videoPortStr;
@property (nonatomic, copy) NSString *videoName;//获取用户名
@property (nonatomic, copy) NSString *videoPassword;//获取密码
@property (nonatomic, copy) NSString *CamIndexCode;//通道号
@property (nonatomic, copy) NSString *vsData;

@property (nonatomic, strong) NSString *siteID;
@property (nonatomic, strong)UIImage *savedImage;
@property (nonatomic, copy)NSString *imgName;
@property (nonatomic, strong)StationModel *stationModel;
@end
