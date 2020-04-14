//
//  HandInOverTwoViewController.m
//  Witwater
//
//  Created by 吴坤 on 16/12/5.
//  Copyright © 2016年 QIcareful. All rights reserved.
//

#import "HandInOverTwoViewController.h"

@interface HandInOverTwoViewController ()<UITextViewDelegate>
@property (nonatomic,copy) NSString *urlStr;
@end

@implementation HandInOverTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0,151+NAVIHEIGHT+IphoneX_TH, WT, HT - 151-NAVIHEIGHT-IphoneX_BH-IphoneX_TH);
    [self configerViewCorner];
    self.tfView.delegate = self;
    self.contentfView.delegate = self;
}
-(void)configerViewCorner{
    
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    
    self.dayView.layer.borderWidth = 1;
    self.dayView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.dayView.layer.masksToBounds = YES;
    self.dayView.layer.cornerRadius = 5;
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0 )
    {
        _tfLable.text = @"添加申请天数";
        _contentfLab.text = @"添加申请内容";
    }
    else
    {
        _tfLable.text = @"";
        _contentfLab.text = @"";
    }
    
}
- (IBAction)handInSQ:(id)sender {
    if (self.tfView.text > 0) {
        [self applactionDelay];
    }else{
        [YJProgressHUD showError:@"请填写申请天数"];
    }
   
  
}
-(void)applactionDelay{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dateStr = [dateFormater stringFromDate:date];
    self.urlStr = F(@"%@/VillagePushManagement",BaseRequestUrl);
    //
//    NSLog(@"PushID--%@----%@----%@----%@----%@",F(@"%@",self.model.PushID),F(@"%@",self.model.PushStatus),dateStr,self.tfView.text,self.contentfView.text);
    NSDictionary *param =   [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"action", F(@"{ID:%@,StatusBefore:%@,Status:%@,PushStatus:%@,OperationUserDoTime:%@,ImgPath:%@,DelayTag:%@,DelayDays:%@,Describe:%@,UpdUser:%@}",F(@"%@",self.model.PushID),F(@"%@",self.model.PushStatus),@"1",@"21",dateStr,@"0",@"1",self.tfView.text,self.contentfView.text,[DataSource sharedDataSource].UserID),@"method", nil];
//    NSLog(@"PushStatus---%@",self.model.PushStatus);
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:self.urlStr isCacheorNot:NO targetViewController:self andUrlFunctionName:@"dalyList" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@", dicData[@"Status"]);
        
        if ([status isEqualToString:@"OK"]) {
            [YJProgressHUD showError:@"申请成功"];
        }else{
            [YJProgressHUD showError:@"申请失败"];
        }
        
    } orFail:^(NSError *error) {
        NSLog(@"级列表%@", error);
        
        [YJProgressHUD showError:@"申请失败"];
        
    }];

    
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

@end
