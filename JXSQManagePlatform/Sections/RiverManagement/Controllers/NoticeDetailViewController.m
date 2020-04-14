//
//  NoticeDetailViewController.m
//  JXSQManagePlatform
//
//  Created by ghost on 2017/9/14.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "InformationModel.h"
@interface NoticeDetailViewController ()<UITextViewDelegate>
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation NoticeDetailViewController
- (NSMutableArray *)detailArray {
    if (!_detailArray) {
        self.detailArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _detailArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CustomHUD showIndicatorWithStatus:@"努力加载中..."];
    [self sendDetailViewRequest];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WT, HT)];
    [self.view addSubview:_webView];
}
- (void)sendDetailViewRequest {
    NSDictionary *param = @{
                            @"id":self.IDStr,
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/getNoticeByID", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"Content" success:^(id result) {
        NSDictionary *dicData = result;
        if ([dicData[@"Status"] isEqualToString:@"OK"]) {
            NSDictionary *dic = dicData[@"Data"];
            self.commitStr = dic[@"Comment"];
        }
        NSLog(@"获取通知公告列表 ====%@", result);
        
        //        [self creatViewTextSet];
        [CustomHUD dismiss];
        [_webView loadHTMLString:self.commitStr baseURL:nil];
    } orFail:^(NSError *error) {
        [YJProgressHUD showError:@"数据请求失败,请检查网络"];
        [CustomHUD dismiss];
        NSLog(@"%@", error);
    }];
}
- (void)creatViewTextSet {
    /*
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[self.commitStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];

    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, 64+20, WT-20, HT-64-40);
//    textView.font = [UIFont systemFontOfSize:20];
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 0.5f;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 10;
    textView.delegate = self;
    textView.editable = NO;
//    textView.text = self.commitStr;
    textView.attributedText = attrStr;
    [self.view addSubview:textView];
     */
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
#pragma mark = UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

@end
