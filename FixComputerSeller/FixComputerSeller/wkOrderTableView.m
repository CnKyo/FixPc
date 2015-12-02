//
//  wkOrderTableView.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/7.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "wkOrderTableView.h"
#import "wkOrderCell.h"
#import "wkOrderDetailViewController.h"
#import "wkOrderTableViewCell.h"
#import "tongjiViewController.h"
#import "feiyongViewController.h"
@interface wkOrderTableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation wkOrderTableView
{

    UIView *mTopView;

    UITableView *mTableView;
    
    CGFloat cellH;
    ///0：待完成；1：已完成；2：退订订单
    int mStatus;
    UIButton *tempBtn;
    UIImageView *lineImage;
    BOOL _bneedhidstatusbar;


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    else{
        [mTableView headerBeginRefreshing];
    }

//    [self showFrist];



//    [mTableView headerBeginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"e点修";
    self.hiddenBackBtn = YES;
    self.hiddenRightBtn = YES;
    self.rightBtnTitle = @"统计";
    self.hiddenlll = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    mStatus = 0;
    
    [self initView];

    

    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(callBack)name:@"back"object:nil];


}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)callBack{
    
    NSLog(@"this is Notification.");

    [mTableView headerBeginRefreshing];
    
}

- (void)initView{
    
    mTopView = [UIView new];
    mTopView.hidden = NO;
    mTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mTopView];

    
    mTableView = [UITableView new];
    
    self.tableView = mTableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
//    UINib *nib = [UINib nibWithNibName:@"wkOrderCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.haveFooter = YES;
    self.haveHeader = YES;
//    [self.tableView headerBeginRefreshing];
    
    [self.view addSubview:mTableView];

    [mTopView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(mTableView.top).with.offset(0);
        make.height.offset(@50);
    }];
    
    
    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mTopView.bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view.bottom).offset(-50);
    }];
    
    [self loadTopView];

}
- (void)setUpTableView{
    
}
#pragma mark----初始化顶部2个按钮
-(void)loadTopView
{
    
    float x = 0;
    for (int i =0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, DEVICE_Width/3-20, 45)];
        [btn setTitle:@"待完成" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:M_CO forState:UIControlStateNormal];
        [mTopView addSubview:btn];
        if (i==0) {
            tempBtn = btn;
            lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 3)];
            lineImage.backgroundColor = M_CO;
            lineImage.center = btn.center;
            CGRect rect = lineImage.frame;
            rect.origin.y = 47;
            lineImage.frame = rect;
            [mTopView addSubview:lineImage];
        }
       else if (i==1) {
            [btn setTitle:@"已完成" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1] forState:UIControlStateNormal];

        }
        else
        {
            [btn setTitle:@"退订订单" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1] forState:UIControlStateNormal];
            // paixuImage.backgroundColor = [UIColor redColor];
            
        }
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(topbtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        x+=DEVICE_Width/3;
    }
    
    UIImageView *xianimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, DEVICE_Width, 1)];
    xianimg.backgroundColor  = COLOR(232, 232, 232);
    [mTopView addSubview:xianimg];

    
}

-(void)topbtnTouched:(UIButton *)sender
{
    
    if (tempBtn == sender&&sender.tag !=12) {
        return;
    }
    else
    {
        if (sender.tag ==10) {
            NSLog(@"left");
            mStatus = 0;

        }
        if (sender.tag == 11) {
            NSLog(@"mid");
            mStatus = 1;

        }
        if (sender.tag == 12)
        {
            NSLog(@"right");
            mStatus = 2;

        }
  
        [self.tableView headerBeginRefreshing];
        
        [mTableView reloadData];
        
        [tempBtn setTitleColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1] forState:UIControlStateNormal];
        [sender setTitleColor:M_CO forState:UIControlStateNormal];
        tempBtn = sender;
        CGRect rect = lineImage.frame;
        rect.origin.y = 42;
        float x = sender.center.x;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect arect = lineImage.frame ;
            arect.origin.x = x-lineImage.frame.size.width/2;
            lineImage.frame = arect;
        }];
        
    }

}
#pragma mark ----顶部刷新数据
- (void)headerBeganRefresh{
    
    self.page=1;
    
    [[SUser currentUser]getMyOrders:mStatus page:self.page block:^(SResBase *resb, NSArray *all) {
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        if (resb.msuccess) {
            
            [self.tempArray addObjectsFromArray:all];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeEmptyView];
        }
        [self.tableView reloadData];
    }];

    
}
#pragma mark----地步刷新
-(void)footetBeganRefresh
{
    self.page++;
    
    [[SUser currentUser]getMyOrders:mStatus page:self.page block:^(SResBase *resb, NSArray *all) {
        [self footetEndRefresh];
        if (resb.msuccess) {
            
            [self.tempArray addObjectsFromArray:all];
            
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeEmptyView];
        }
    }];
    [self.tableView reloadData];
    
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.tempArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [wkOrderTableViewCell hdf_heightForIndexPath:indexPath configBlock:^(UITableViewCell *cell) {
        wkOrderTableViewCell *txcell = (wkOrderTableViewCell *)cell;
        
        txcell.wkOrder = self.tempArray[indexPath.row];
    }];
//    return 330;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseCellId = @"cell";
    
    wkOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    if (!cell)
    {
        cell = [[wkOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.wkOrder = self.tempArray[indexPath.row];

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOrder *sorder = self.tempArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    wkOrderDetailViewController *o = [wkOrderDetailViewController new];
    o.wkorder = sorder;
    o.wkorder.mId = sorder.mId;
//    o.wkArgs = sorder.mId;
    [self pushViewController:o];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showFrist
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* v = [def objectForKey:@"showed"];
    NSString* nowver = [Util getAppVersion];
    if( ![v isEqualToString:nowver] )
    {
        UIScrollView* firstview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        firstview.showsHorizontalScrollIndicator = NO;
        firstview.backgroundColor = [UIColor colorWithRed:0.937 green:0.922 blue:0.918 alpha:1.000];
        firstview.pagingEnabled = YES;
        firstview.bounces = NO;
        NSArray* allimgs = [self getFristImages];
        
        CGFloat x_offset = 0.0f;
        CGRect f;
        UIImageView* last = nil;
        for ( NSString* oneimgname in allimgs ) {
            UIImageView* itoneimage = [[UIImageView alloc] initWithFrame:firstview.bounds];
            itoneimage.image = [UIImage imageNamed: oneimgname];
            f = itoneimage.frame;
            f.origin.x = x_offset;
            itoneimage.frame = f;
            x_offset += firstview.frame.size.width;
            [firstview addSubview: itoneimage];
            last  = itoneimage;
        }
        UITapGestureRecognizer* guset = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fristTaped:)];
        last.userInteractionEnabled = YES;
        [last addGestureRecognizer: guset];
        
        CGSize cs = firstview.contentSize;
        cs.width = x_offset;
        firstview.contentSize = cs;
        
        _bneedhidstatusbar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
        
        [((UIWindow*)[UIApplication sharedApplication].delegate).window addSubview: firstview];
    }
    
}
-(void)fristTaped:(UITapGestureRecognizer*)sender
{
    UIView* ttt = [sender view];
    UIView* pview = [ttt superview];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect f = pview.frame;
        f.origin.y = -pview.frame.size.height;
        pview.frame = f;
        
    } completion:^(BOOL finished) {
        
        [pview removeFromSuperview];
        
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        NSString* nowver = [Util getAppVersion];
        [def setObject:nowver forKey:@"showed"];
        [def synchronize];
        _bneedhidstatusbar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        
    }];
}
-(NSArray*)getFristImages
{
    if( DeviceIsiPhone() )
    {
        return @[@"replash-1.png",@"replash.png"];
    }
    else
    {
        return @[@"replash-1.png",@"replash.png"];
    }
    
}

- (void)rightBtnTouched:(id)sender{
//    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    tongjiViewController *ttt =[secondStroyBoard instantiateViewControllerWithIdentifier:@"tongji"];
//    [self.navigationController pushViewController:ttt animated:YES];

    feiyongViewController *f = [feiyongViewController new];
    [self pushViewController:f];
    
}

@end
