//
//  ComplaintDetailViewController.m
//  Witwater
//
//  Created by 吴坤 on 17/1/17.
//  Copyright © 2017年 QIcareful. All rights reserved.
//

#import "ComplaintDetailViewController.h"
#import "CompDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface ComplaintDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, nonatomic) UITableView *myTableView;

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *pathArr;
@property (nonatomic, strong) NSMutableArray *imagArr;
@property (nonatomic, strong) UILabel *lab;
@end

@implementation ComplaintDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"投诉详情";
    [self createTableViewSet];
    [self sendDetailComplainRequest];
    
}
- (void)createTableViewSet {
    CGFloat h = 0;
    if (IOS_VERSION >= 11.0) {
        h=64;
    }
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, h, WT, HT-h) style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
   [self.myTableView registerNib:[UINib nibWithNibName:@"CompDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"detail"];
}
- (void)sendDetailComplainRequest {
    NSDictionary *param = @{
                            @"id":self.IdStr,
                            };
    [gs_HttpManager httpManagerPostParameter:param toHttpUrlStr:F(@"%@/getComplainInfoByID", BaseRequestUrl) isCacheorNot:NO targetViewController:self andUrlFunctionName:@"detail" success:^(id result) {
        NSDictionary *dicData = result;
        NSString *status = F(@"%@",dicData[@"Status"]);
        if ([status isEqualToString:@"OK"]) {
            NSDictionary *dic = dicData[@"Data"];
                self.num = dic[@"ComplainNo"];
                self.nameStr = dic[@"ComplainPerson"];
                self.titlecom = dic[@"ComplainTitle"];
                self.time = dic[@"ComplainDate"];
                self.river = dic[@"ComplainRiver"];
                self.context = dic[@"ComplainComment"];
                if (![dic[@"ComplainPic"]isKindOfClass:[NSNull class]]) {
                    self.photo = dic[@"ComplainPic"];
                } else {
                    self.photo = @"";
                }
                
                self.ImgUrlStr = dic[@"PicUrl"];
            }
            
        
        [self setViewInfomation];
        
        [self.myTableView reloadData];
        NSLog(@"投诉详情========================%@", result);
    } orFail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)setViewInfomation {
    self.imagArr = [NSMutableArray arrayWithCapacity:1];
    _arr = @[@"投诉人",@"投诉主题",@"投诉时间",@"投诉站点",@"投诉内容"];
    _dataArr = @[F(@"%@", self.nameStr),F(@"%@", self.titlecom),F(@"%@", self.time),F(@"%@", self.river),F(@"%@", self.context)];
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WT, 100)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WT, 50)];
    
    [header addSubview:headerView];
    headerView.backgroundColor = [UIColor colorWithRed:0.176 green:0.529 blue:0.772 alpha:0.2];
    
    UILabel *lab = [[UILabel alloc ]initWithFrame:CGRectMake(8, 0, 70,50)];
    lab.text = @"投诉编号";
    UILabel *lab0 = [[UILabel alloc ]initWithFrame:CGRectMake(98, 0, 150,50)];
    lab0.text = _num;
    
    [headerView addSubview:lab0];
    [headerView addSubview:lab];
    UILabel *lab1 = [[UILabel alloc ]initWithFrame:CGRectMake(8,50, 150,50)];
    lab1.text = @"投诉情况";
    lab1.textColor  = [UIColor colorWithRed:0.176 green:0.529 blue:0.772 alpha:0.8];
    [header addSubview:lab1];
    return header;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc]init];
    footer.backgroundColor = [UIColor whiteColor];
    if (self.photo.length > 0) {
        footer.frame = CGRectMake(1, 0, WT, 120);
        _pathArr = [self.photo componentsSeparatedByString:@";"];
        
        UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(1, 0, WT, 120)];
        scroller.showsVerticalScrollIndicator = NO;
        NSInteger scrolleWT = (_pathArr.count)*98+8+90;
        if (scrolleWT > WT) {
            scroller.contentSize = CGSizeMake(scrolleWT, 120);
        }else{
            scroller.contentSize = CGSizeMake(WT, 120);
        }
        
        [footer addSubview:scroller];
        
        
        for (int i = 0; i < _pathArr.count; i++) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*98 +8, 0, 90, 120)];
            NSString *url = [NSString stringWithFormat:@"%@%@",self.ImgUrlStr,_pathArr[i]];
            [imgV sd_setImageWithURL:[NSURL URLWithString:url]];
            
            imgV.userInteractionEnabled = YES;
            imgV.backgroundColor = [UIColor lightGrayColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTapAction:)];
            imgV.tag = 1000 + i;
            [imgV addGestureRecognizer:tap];
            [scroller addSubview:imgV];
            
            
        }
        
    }else{
        
        footer.frame = CGRectMake(0, 0, 0, 0);
    }
    return footer;
}
- (void)changeTapAction:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 1000;
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WT, HT)];
    
    aview.backgroundColor = [UIColor blackColor];
    
    UIScrollView *imageScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WT, HT)];
    imageScroller.delegate = self;
    
    imageScroller.pagingEnabled = YES;
    imageScroller.contentOffset = CGPointMake(WT*index, 130);
    imageScroller.contentSize = CGSizeMake(WT*(_pathArr.count), HT);
    for (int i = 0; i < _pathArr.count; i++) {
        UIImageView *imgVC = [[UIImageView alloc]init];
        imgVC.tag = 2000 + i;
        imgVC.frame = CGRectMake(40+WT*i, 130,WT - 80 , HT -240);
        SDWebImageManager *manger = [SDWebImageManager sharedManager];
        NSString *url = [NSString stringWithFormat:@"%@%@",self.ImgUrlStr,_pathArr[i]];
        [manger downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            imgVC.image = image;
        }];
        
        
        [imageScroller  addSubview:imgVC];
    }
    _lab = [[UILabel alloc]initWithFrame:CGRectMake(WT/2.0-50, HT-100, 100, 30)];
    
    _lab.textColor = [UIColor whiteColor];
    _lab.textAlignment = NSTextAlignmentCenter;
    
    _lab.text = [NSString stringWithFormat:@"%ld / %ld",index+1,_pathArr.count];
    
    [aview addSubview:imageScroller];
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissActioon:)];
    
    [aview addGestureRecognizer:tap0];
    
    [self.view addSubview:aview];
    [self.view addSubview:_lab];
}


-(void)dismissActioon:(UITapGestureRecognizer *)tap{
   
    UIView *aview = tap.view;
    [_lab removeFromSuperview];
  
    [aview removeFromSuperview];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //及时获取scrollView的偏移量

     int index = fabs(scrollView.contentOffset.x)/WT + 1;
     _lab.text = [NSString stringWithFormat:@"%d / %ld",index,_pathArr.count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.photo.length > 0) {
        return 120;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CompDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    cell.nameLab.text = _arr[indexPath.row];
    cell.contentLab.text = self.dataArr[indexPath.row];
    return cell;
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
