//
//  ComplaintDetailViewController.h
//  Witwater
//
//  Created by 吴坤 on 17/1/17.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintDetailViewController : UIViewController
@property (nonatomic, copy) NSString *IdStr;

@property (nonatomic, copy) NSString *num;//编号
@property (nonatomic, copy) NSString *time;//投诉时间
@property (nonatomic, copy) NSString *titlecom;//主题
@property (nonatomic, copy) NSString *river;//河道河段
@property (nonatomic, copy) NSString *context;//内容
@property (nonatomic, copy) NSString *photo;//照片
@property (nonatomic, copy) NSString *nameStr;//人
@property (nonatomic, copy) NSString *ImgUrlStr;//图片链接
@end
