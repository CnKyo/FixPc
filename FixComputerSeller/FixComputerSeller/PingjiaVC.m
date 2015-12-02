//
//  PingjiaVC.m
//  ShuFuJiaSeller
//
//  Created by 周大钦 on 15/9/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "PingjiaVC.h"
#import "PingJiaCell.h"
#import "feedbackViewController.h"

@interface PingjiaVC ()<UITableViewDataSource,UITableViewDelegate>{

    int nowSelect;
    NSMutableDictionary *tempDic;
    UIButton *tempBtn;
    
    UIView *line;
    SRate *myRate;
    
    float hao;
    float zhong;
    float cha;
}

@end

@implementation PingjiaVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"用户评价";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    
    self.tableView = _mTableView;
    UINib *nib = [UINib nibWithNibName:@"PingJiaCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.haveHeader = YES;
    self.haveFooter = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView headerBeginRefreshing];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(10, 52, DEVICE_Width/4-20, 3)];
    line.backgroundColor = COLOR(123, 176, 70);
    [_mHeadView addSubview:line];
    tempBtn = _mAllBT;
    
    nowSelect = 0;
    hao = 0.0;
    zhong = 0.0;
    cha = 0.0;
    tempDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
}

- (void)loadTopView{
    
   [_mImg sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead.png"]];
    _mImg.layer.masksToBounds = YES;
    _mImg.layer.cornerRadius = 32.5;
    _mName.text = [SUser currentUser].mUserName;
    
    _mBghao.layer.masksToBounds = YES;
    _mBghao.layer.cornerRadius = 0.1;
    _mBghao.layer.borderColor = COLOR(188, 189, 190).CGColor;
    _mBghao.layer.borderWidth = 0.5;
    
    _mBgzhong.layer.masksToBounds = YES;
    _mBgzhong.layer.cornerRadius = 0.1;
    _mBgzhong.layer.borderColor = COLOR(188, 189, 190).CGColor;
    _mBgzhong.layer.borderWidth = 0.5;
    
    _mBgCha.layer.masksToBounds = YES;
    _mBgCha.layer.cornerRadius = 0.1;
    _mBgCha.layer.borderColor = COLOR(188, 189, 190).CGColor;
    _mBgCha.layer.borderWidth = 0.5;
    
    
    hao = (float)myRate.mCommentGoodCount/myRate.mCommentTotalCount;
    zhong = (float)myRate.mCommentNeutralCount/myRate.mCommentTotalCount;
    cha = (float)myRate.mCommentBadCount/myRate.mCommentTotalCount;
    
    if (myRate.mCommentTotalCount == 0) {
        hao = 0;
        zhong = 0;
        cha = 0;
    }
    
    [_mAllBT setTitle:[NSString stringWithFormat:@"全部%d",myRate.mCommentTotalCount] forState:UIControlStateNormal];
    [_mHaoBT setTitle:[NSString stringWithFormat:@"好评%d",myRate.mCommentGoodCount] forState:UIControlStateNormal];
    [_mZhongBT setTitle:[NSString stringWithFormat:@"中评%d",myRate.mCommentNeutralCount] forState:UIControlStateNormal];
    [_mChaBT setTitle:[NSString stringWithFormat:@"差评%d",myRate.mCommentBadCount] forState:UIControlStateNormal];
    
    UIView *view = [[UIView alloc] initWithFrame:_mBghao.frame];
    view.backgroundColor = COLOR(111, 175, 34);
    CGRect rect = view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = _mBghao.frame.size.width*hao;
    view.frame = rect;
    [_mBghao addSubview:view];
    
    _mHaolb.text = [NSString stringWithFormat:@"%.1f%%",hao*100];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:_mBgzhong.frame];
    view2.backgroundColor = COLOR(111, 175, 34);
    CGRect rect2 = view2.frame;
    rect2.origin.x = 0;
    rect2.origin.y = 0;
    rect2.size.width = _mBgzhong.frame.size.width*zhong;
    view2.frame = rect2;
    [_mBgzhong addSubview:view2];
    
    _mZhonglb.text = [NSString stringWithFormat:@"%.1f%%",zhong*100];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:_mBgCha.frame];
    view3.backgroundColor = COLOR(111, 175, 34);
    CGRect rect3 = view3.frame;
    rect3.origin.x = 0;
    rect3.origin.y = 0;
    rect3.size.width = _mBgCha.frame.size.width*cha;
    view3.frame = rect3;
    [_mBgCha addSubview:view3];
    
    _mChalb.text = [NSString stringWithFormat:@"%.1f%%",cha*100];
    
}

-(void)headerBeganRefresh
{
    self.page = 1;
    
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [[SUser currentUser] getDetail:[SUser currentUser].mStaffId block:^(SResBase *resb, SRate *rate) {
        
        if (resb.msuccess) {
            
            myRate = rate;
            [self loadTopView];
            
        }
    }];
    
    [[SUser currentUser] getMyRate:self.page type:nowSelect block:^(SResBase *resb, NSArray *all){
        
        [self headerEndRefresh];
        
        if (resb.msuccess) {
            
            [SVProgressHUD dismiss];
            
            NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
            
            [tempDic setObject:all forKey:key2];
            
            if (all.count==0) {
                [self addEmptyViewWithImg:@"ic_empty"];
            }else
            {
                [self removeEmptyView];
            }
            [self.tableView reloadData];
            
            
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if ( all.count == 0 )
        {
            [self addEmptyViewWithImg:@"ic_empty"];
        }
        else
        {
            [self removeEmptyView];
        }
        
        [self.tableView reloadData];
        
    }];
    
    
    
}

- (void)footetBeganRefresh{
    
    
    
    self.page ++;
    
    [[SUser currentUser] getMyRate:self.page type:nowSelect block:^(SResBase *resb, NSArray *all){
        [self footetEndRefresh];
        
        if (resb.msuccess) {
            
            
            NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
            
            NSArray *oldarr = [tempDic objectForKey:key2];
            
            if (all.count!=0) {
                [self removeEmptyView];
                
                
                NSMutableArray *array = [NSMutableArray array];
                if (oldarr) {
                    [array addObjectsFromArray:oldarr];
                }
                [array addObjectsFromArray:all];
                [tempDic setObject:array forKey:key2];
            }else
            {
                if(!oldarr||oldarr.count==0)
                {
                    [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
                }
                else
                    [SVProgressHUD showSuccessWithStatus:@"暂无新数据"];
                //   [self addEmptyView:@"暂无数据"];
                
            }
            [self.tableView reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            
        }
    }];
    
}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    return arr.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PingJiaCell *cell = (PingJiaCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    
    SRate *rate = [arr objectAtIndex:indexPath.row];
    
    cell.mName.text = rate.mUserName;
    if ([rate.mResult isEqualToString:@"good"]) {
        cell.mGrade.text = @"好评";
    }else if ([rate.mResult isEqualToString:@"neutral"]){
        cell.mGrade.text = @"中评";
    }else if ([rate.mResult isEqualToString:@"bad"]){
        cell.mGrade.text = @"差评";
    }
    
    cell.mContent.text = rate.mContent;
    cell.mTime.text = rate.mCreateTime;
    if (rate.mReply.length>0) {
        cell.mReply.text = [NSString stringWithFormat:@"商家回复：%@",rate.mReply];
        cell.mReplyBT.hidden = YES;
        cell.mReplyTime.text = rate.mReplyTime;
    }else{
        cell.mReply.text = @"";
        cell.mReplyBT.hidden = NO;
        cell.mReplyTime.text = @"";
    }
    cell.mType.text = rate.mGoodsName;
    cell.mReplyBT.tag = indexPath.row;
    [cell.mReplyBT addTarget:self action:@selector(ReplyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

- (void)ReplyClick:(UIButton *)sender{

    
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    
    SRate *rate = [arr objectAtIndex:sender.tag];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    feedbackViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"xxx"];
    viewController.mRate = rate;
    
    [self.navigationController pushViewController:viewController animated:YES];
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

- (IBAction)ButtonClick:(id)sender {
    
    UIButton *btn = sender;
    
    if (btn.tag ==1) {
        NSLog(@"left");
        nowSelect = 0;
    }
    else if(btn.tag == 2)
    {
        nowSelect = 1;
        NSLog(@"mid");
    }
    else if(btn.tag == 3)
    {
        nowSelect = 2;
        NSLog(@"right");
        
    }else{
        nowSelect = 3;
        NSLog(@"right");
    }
    NSString *key1 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    
    if (![tempDic objectForKey:key1]) {
        
        [self.tableView headerBeginRefreshing];
    }
    else
    {
        NSArray *ary = [tempDic objectForKey:key1];
        if (ary.count>0) {
            [self removeEmptyView];
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        }else{
            [self addEmptyViewWithImg:@"ic_empty"];
        }
        [self.tableView reloadData];
    }
    
    [tempBtn setTitleColor:COLOR(93, 94, 95) forState:UIControlStateNormal];
    [sender setTitleColor:COLOR(123,176,70) forState:UIControlStateNormal];
    tempBtn = sender;
    //  lineImage.center = sender.center;
    
    [UIView animateWithDuration:0.2 animations:^{
        line.center = btn.center;
        CGRect arect = line.frame ;
        arect.origin.y = 52;
        
        line.frame = arect;
    }];
}
@end
