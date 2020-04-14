//
//  UploadImageManager.m
//  HNManagerRiver
//
//  Created by 吴坤 on 16/10/25.
//  Copyright © 2016年 yotan. All rights reserved.
//

#import "UploadImageManager.h"
#import "MBProgressHUD+MJ.h"
#import "AFHTTPSessionManager.h"
@implementation UploadImageManager

-(NSString*)arrayToDefaultSoapMessage:(NSDictionary*)dic methodName:(NSString*)methodName{
    NSArray *arr = [dic allKeys];
    if ([arr count]==0||arr==nil) {
        return [NSString stringWithFormat:[self methodSoapMessage:methodName],@""];
    }
    NSMutableString *msg=[NSMutableString stringWithFormat:@""];
    for (NSString *key in arr) {
        [msg appendFormat:@"<%@>",key];
        [msg appendString:[dic objectForKey:key]];
        [msg appendFormat:@"</%@>",key];
    }
    return [NSString stringWithFormat:[self methodSoapMessage:methodName],msg];
}

-(NSString*)methodSoapMessage:(NSString*)methodName{
    NSString *defaultWebServiceNameSpace = [NSString stringWithFormat:@"http://tempuri.org/"];
    NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,defaultWebServiceNameSpace];
    [soap appendString:@"%@"];
    [soap appendFormat:@"</%@>",methodName];
    return [NSString stringWithFormat:[self defaultSoapMesage],soap];
}

-(NSString*)defaultSoapMesage{
    NSString *soapBody=@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>%@</soap:Body></soap:Envelope>";
    return soapBody;
}

-(void)webserviceUploadImageWithUrl:(NSString *)url params:(NSDictionary *)params{
    NSString *KBASE_URL = RequestURL;
    NSString *soapMsg = [self arrayToDefaultSoapMessage:params methodName:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:300];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMsg;
    }];
    [manager POST:KBASE_URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [YJProgressHUD showError:@"图片上传失败"];
        NSLog(@"------------------%@",error);
    }];
    
    
    
}



@end
