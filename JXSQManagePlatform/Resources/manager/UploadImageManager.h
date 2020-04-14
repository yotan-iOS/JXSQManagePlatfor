//
//  UploadImageManager.h
//  HNManagerRiver
//
//  Created by 吴坤 on 16/10/25.
//  Copyright © 2016年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImageManager : NSObject
-(void)webserviceUploadImageWithUrl:(NSString *)url params:(NSDictionary *)params;
@end
