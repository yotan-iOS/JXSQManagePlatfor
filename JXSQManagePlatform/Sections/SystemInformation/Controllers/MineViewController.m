
//
//  MineViewController.m
//  Witwater
//
//  Created by 吴坤 on 17/1/13.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import "MineViewController.h"
#import "MyLoginViewController.h"
#import "LoginTableViewCell.h"
#import "RecodViewController.h"
@interface MineViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
     DataSource *datasource;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *contentArr;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    self.popAligment = CBPopupViewAligmentCenter;
    datasource = [DataSource sharedDataSource];
    UIImageView *img = [self.view viewWithTag:800];
    
    if (WT > 414) {
        img.frame = CGRectMake(WT/2.0 - 125, (90*HT)/568, 250, 250);
    }else{
         img.frame = CGRectMake(WT/2.0 -75, (90*HT)/568, 150, 150);
    }
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, img.frame.origin.y+img.frame.size.height + 8, WT, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:16];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    if (WT <= 320) {
//        lab.hidden = YES;
//    }else{
//        lab.hidden = NO;
//    }
    lab.text = F(@"版本号:V  %@", app_Version);
    [self.headerView addSubview:lab];
    [self createTableView];
}

-(void)createTableView{
    
     _titleArr = @[@[@"账号:",@"用户名:",@"管理权限:"],@[@"修改密码",@"退出登录",@"登录记录",@"帮助"]];
//    [self.myTableView registerNib:[UINib nibWithNibName:@"LoginTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _myTableView.frame = CGRectMake(0, HT/2.0 - 10,WT, HT/2.0+10-44);
//    self.myTableView.scrollEnabled  = NO;
    [self.view addSubview:self.myTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return  10;
            break;
            
        default:
            return 10;
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return ((NSArray *)_titleArr[section]).count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    LoginTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (nil == cell) {
        cell= (LoginTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LoginTableViewCell" owner:self options:nil] lastObject];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
   
    cell.userNameLab.text = _titleArr[indexPath.section][indexPath.row];
    
    if (indexPath.section==0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
            {
                cell.contentLab.text = datasource.SignInName;
              
            }
                break;
            case 1:
            {
               
              cell.contentLab.text = datasource.realNameStr;
               
                
            }
                break;
            case 2:
            {
                cell.contentLab.text = datasource.GroupName;;
                
            }
                break;
            default:
                break;
        }
        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 1:
        {
            if (indexPath.row==0) {
                [self changPwdAction:nil];
            }else if (indexPath.row==1){
                DataSource *datasource = [DataSource sharedDataSource];
                if ([datasource.IsStart intValue] == 1 && [datasource.IsEnd intValue] == 0) {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在巡河中,如果切换账号请先结束巡河" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alertC addAction:actionCancel];
                    [self presentViewController:alertC animated:YES completion:nil];
                } else {
//                    [Patrol_record MR_truncateAll];
//                    [Latitude_and_longitude MR_truncateAll];
//                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    [datasource.cmListArr removeAllObjects];
                    [datasource.moduleArr removeAllObjects];
                    [datasource.moduleArrIcon removeAllObjects];
                    
                    MyLoginViewController *logVC = [[MyLoginViewController alloc]init];
                    [self presentViewController:logVC animated:YES completion:nil];
                }

            } else if (indexPath.row==2){
                RecodViewController *recodVC = [[RecodViewController alloc]init];
                [self.navigationController pushViewController:recodVC animated:YES];
            } else if (indexPath.row == 3) {
                HelpViewController *helpvc = [HelpViewController new];
                helpvc.view.backgroundColor = [UIColor cyanColor];
                
                helpvc.view.frame = CGRectMake(0, 0, 285, HT/5+30);
                helpvc.view.layer.cornerRadius = 4.0;
                helpvc.view.layer.masksToBounds = YES;
                
                [self cb_presentPopupViewController:helpvc animationType:CBPopupViewAnimationFade aligment:self.popAligment dismissed:nil];
            }
        }
            break;
               default:
            break;
    }
    
}


//登录
- (void)loginAction:(UIButton *)sender {
    MyLoginViewController *logVC = [[MyLoginViewController alloc]init];
    [self presentViewController:logVC animated:YES completion:nil];
}
//修改密码
- (void)changPwdAction:(UIButton *)sender {
    if (datasource.SignInName != nil && datasource.SignInName.length
         > 0) {
    
        [self alert:[NSString stringWithFormat:@"%@ 修改密码",datasource.SignInName] message:nil];
        
    }else{
        [self alerter:@"提示" message:@"请登录完成后,再修改密码"];
    }
    
    
}
//返回
- (void)backAction:(UIButton *)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//showSuccess:@"修改成功" http://111.3.68.233:40007/JXGQApi.asmx

-(void)changeDataWithUserName:(NSString *)username password:(NSString *)password{
    NSDictionary *param = @{
                            @"action":@"2",
                            @"method":F(@"{userName:%@,passWord:%@}", username, password),
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:SystemSettingsURLStr isCacheorNot:YES targetViewController:self andUrlFunctionName:@"gaimima" success:^(id result) {
        [self alerter:@"提示" message:@"密码修改成功"];
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
   
}

- (void)alerter:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:OKAction];
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)alert:(NSString *)title message:(NSString *)message{
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alert.textFields.firstObject;
       
        //获取第2个输入框；
        UITextField *passwordTextField = alert.textFields.lastObject;
       
        if ([userNameTextField.text isEqualToString:passwordTextField.text]) {
            if (userNameTextField.text.length==0) {
                 [self alerter:@"提示" message:@"输入的密码不能为空"];
            }else  if (userNameTextField.text.length<6) {
                [self alerter:@"提示" message:@"输入密码长度必须为6位或6位以上"];
            }else{
               [self changeDataWithUserName:datasource.SignInName password:passwordTextField.text];
            }
            
        }else{
            
            [self alerter:@"提示" message:@"两次输入不一样，请重新输入"];
        }
        
       
    }];
    [alert addAction:OKAction];
    //增加取消按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //定义第一个输入框；
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
//        textField.text = datasource.SignInName;
        if (textField.text.length == 0) {
            
             textField.placeholder = @"请输入新密码";
        }
       
    }];
    //定义第二个输入框；
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请确认密码";
    }];
        [self presentViewController:alert animated:YES completion:nil];
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
