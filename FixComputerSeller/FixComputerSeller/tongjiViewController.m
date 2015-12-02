//
//  tongjiViewController.m
//  O2O_PaoTuiSeller
//
//  Created by 密码为空！ on 15/9/1.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "tongjiViewController.h"
#import "tongjiCell.h"

@interface tongjiViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation tongjiViewController
{

    UITableView *mTableView;

}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.hiddenlll = YES;
    if( _month == 0 )
    {
        self.Title =   self.mPageName = @"收入统计";
        self.rightBtnTitle = @"按月份";
    }
    else if ( _month == -1 )
    {
        self.Title =    self.mPageName = @"月份收入汇总";
        self.hiddenRightBtn = YES;
    }
    else if( _month > 0 || _month < 13 )
    {
        self.Title =   self.mPageName = [NSString stringWithFormat:@"%d年%d月",_myeaer,_month];
        self.hiddenRightBtn = YES;
    }
    else{
        MLLog(@"erro!!!!");
        [self showErrorStatus:@"运行错误：日期错误!!!!"];
    }
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    [self.navBar.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    self.navBar.rightBtn.frame = CGRectMake(DEVICE_Width-80, self.navBar.leftBtn.origin.y, 100, self.navBar.leftBtn.mheight);
    [self initView];

}
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = self.myTbale;
    if (_month == 0) {
        UINib *nib = [UINib nibWithNibName:@"tongjiCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"O_cell"];
    }
    if (_month == -1){
        UINib * nib = [UINib nibWithNibName:@"monthCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"m_cell"];
    }
    else if (_month > 0 || _month < 13 ){
        UINib *nib = [UINib nibWithNibName:@"tongjiCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"O_cell"];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.haveFooter = YES;
    self.haveHeader = YES;
    [self.tableView headerBeginRefreshing];
    
}

#pragma mark ----顶部刷新数据
- (void)headerBeganRefresh{
    
    self.page = 1;
    [SStatisic getStatisic:_myeaer month:_month page:self.page block:^(SResBase *resb, NSArray *all) {
        
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray:all];
            MLLog(@"取出来的统计数据是:%@",self.tempArray);
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if (self.tempArray.count == 0) {
            [self addEmptyViewWithImg:nil];
        }
        else{
            [self removeEmptyView];
        }
        
        [self.tableView reloadData];
    }];
}
-(void)footetBeganRefresh
{
    self.page ++;
    
    [SStatisic getStatisic:_myeaer month:_month page:self.page block:^(SResBase *resb, NSArray *all) {
        
        [self footetEndRefresh];
        if (resb.msuccess) {
            
            [self.tempArray addObjectsFromArray:all];
            [self.tableView reloadData];
            
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if (self.tempArray.count == 0) {
            [self addEmptyViewWithImg:nil];
        }
        else{
            [self removeEmptyView];
        }
    }];
}

#pragma mark ----列表代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Rcell = nil;
    
    if( _month == -1 )
    {
        Rcell = @"m_cell";
    }
    else
    {
        Rcell = @"O_cell";
    }
    SStatisic* obj = self.tempArray[indexPath.row];
    
    
    tongjiCell *cell = (tongjiCell *)[tableView dequeueReusableCellWithIdentifier:Rcell];
    
    if ( _month == -1 ) {
        cell.mYear.text = [NSString stringWithFormat:@"%d年",obj.mYear];
        cell.mMonth.text = [NSString stringWithFormat:@"%d月",obj.mMonth];
        cell.mDealNum.text = [NSString stringWithFormat:@"成交%d笔",obj.mNum];
        cell.mTotlePrice.text = [NSString stringWithFormat:@"¥%.02f元",obj.mTotal];
        
    }
    else
    {
        [cell.mHeaderImg sd_setImageWithURL:[NSURL URLWithString:obj.mImgURL] placeholderImage:[UIImage imageNamed:@"ic_default"]];
        cell.mServiceName.text = [NSString stringWithFormat:@"服务:%@",obj.mSrvName];
        cell.mTime.text = obj.mTimeStr;
        cell.mPrice.text = [NSString stringWithFormat:@"¥%.02f元",obj.mTotal];
        
        
    }
    cell.mHeaderImg.layer.masksToBounds = YES;
    cell.mHeaderImg.layer.cornerRadius = 3;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SStatisic* obj = self.tempArray[indexPath.row];
    
    if( _month == -1 )
        
    {

        UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        tongjiViewController *ttt =[secondStroyBoard instantiateViewControllerWithIdentifier:@"tongji"];
        ttt.month = obj.mMonth;
        ttt.myeaer = obj.mYear;

        [self.navigationController pushViewController:ttt animated:YES];
        
    }
    else if(_month == 0)
    {///进入统计详情页面
        
        //        orderMessageVC *orderVC = [[orderMessageVC alloc]init];
        //
        //        orderVC.mtagorder = SOrder.new;
        //
        //        orderVC.mtagorder.mId = obj.mOrderId;
        //
        //        [self pushViewController:orderVC];
    }
}
#pragma mark ----右侧按月份按钮事件
- (void)rightBtnTouched:(id)sender{

    
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    tongjiViewController *ttt =[secondStroyBoard instantiateViewControllerWithIdentifier:@"tongji"];
    ttt.month = -1;
    
    [self.navigationController pushViewController:ttt animated:YES];
    
    
}

@end
