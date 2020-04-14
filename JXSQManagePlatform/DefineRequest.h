//
//  DefineRequest.h
//  MyApp
//
//  Created by liaowentao on 17/3/27.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

#ifndef DefineRequest_h
#define DefineRequest
//列表一页请求数量
#define REQUEST_MIN_PAGE_NUM 10
//连接超时时间
#define RequestTimeOut 30
#if DEVELOPMENT //***************开发版本*************
//****************开发环境(个人服务器)************
//后台XXX
#define BaseURLString  @"http://192.168.1.175:8080/baidu/rest/post"
#else          //**************生产版本**************
#define BaseURLString @"https://www.baidu.com/rest/post"
#endif
//http://111.3.68.233:40007/JXGQApi.asmx
//http://218.108.63.142:7509/JXGQApi.asmx
//#define BaseRequestUrl @"http://218.108.63.142:7509/JXGQApi.asmx"
//#define RequestURL @"http://218.108.63.142:7509/JXGQApi.asmx"
#define BaseRequestUrl @"http://111.3.68.233:40007/JXGQApi.asmx"
#define RequestURL @"http://111.3.68.233:40007/JXGQApi.asmx"

//图标
#define MenuIconURL @"http://111.3.68.233:40001/images/"  //@"http://111.3.68.233:40001/images/"  //http://218.108.63.142:7508/images/

//http://218.108.63.142:8001/JXGQApi/JXGQApi.asmx
//水环境
#define BaseWaterEnURLStr  [NSString stringWithFormat:@"%@/WaterEnvironment?",RequestURL]
//农污水，地表水
//#define BaseWaterSiteInfo  [NSString stringWithFormat:@"%@/getSiteInfoByRiverID?",RequestURL]
//大气环境
#define BaseAirEnURLStr [NSString stringWithFormat:@"%@/WaterEnvironment?",RequestURL]
//河长管理
#define BaseRiverMURLStr [NSString stringWithFormat:@"%@/RiverManagement?",BaseRequestUrl]
//#define RiverURLStr @"http://111.3.68.233:40007/JXGQApi.asmx"

//展示
#define KImagePath [NSString stringWithFormat:@"http://218.108.63.142:7509/Upload/"]
#define KVoicePath [NSString stringWithFormat:@"http://218.108.63.142:7509/Music/"]
//上传图片
#define uploadImagePath [NSString stringWithFormat:@"%@/uploadResume",BaseRequestUrl]

//****************接口说明************
//获取用户信息
#define Request_type_getUserInfo @"getUserInfo"
//首页广告
#define Request_type_queryBannerByType @"queryBannerByType"

//系统设置
#define SystemSettingsURLStr [NSString stringWithFormat:@"%@/SetUp",BaseRequestUrl]
//http://111.3.68.233:40007/JXGQApi.asmx

#endif /* DefineRequest_h */
