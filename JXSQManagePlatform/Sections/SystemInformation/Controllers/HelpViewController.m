//
//  HelpViewController.m
//  JXSQManagePlatform
//
//  Created by TestGhost on 2018/9/8.
//  Copyright © 2018年 yotan. All rights reserved.
//

#import "HelpViewController.h"

// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \


@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableViewHelp;
@property (nonatomic, strong) NSMutableArray *phoneArr;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneArr = [NSMutableArray arrayWithObjects:@"13586450824", @"18868332043",@"317043", nil];
    // Do any additional setup after loading the view from its nib.
    self.tableViewHelp = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 285, HT/5+30) style:UITableViewStylePlain];
    self.tableViewHelp.dataSource = self;
    self.tableViewHelp.delegate = self;
    [self.view addSubview:self.tableViewHelp];
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
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"联系电话:";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.phoneArr.count;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"helpCell"];
    cell.textLabel.text = self.phoneArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kPreventRepeatClickTime(2);
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[indexPath.row]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    NSLog(@"电话: %@", self.phoneArr[indexPath.row]);
}

@end
