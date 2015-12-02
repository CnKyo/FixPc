//
//  dateViewController.m
//  O2O_PaoTuiSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "dateViewController.h"
#import "DatingCell.h"
#import "wkOrderDetailViewController.h"
#import "feedbackViewController.h"
@interface dateViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation dateViewController
{
    
    UIScrollView* _topselev;
    UIView* _lineview;
    UIButton* _lastcliecke;
    NSDate* _lastget;
    
    BOOL    _bdoing;
    
    int         _userid;
    
    
    BOOL    _nowseleted;

    
    UITableView *mTableView;
    
    int mDate;
    SchedulDate *mList;
    
    NSMutableArray *mHeaderTimeArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( [SUser isNeedLogin] )
    {
        [self gotoLoginVC];
        return;
    }else{
        [self loadDat];
    }
    

}
-(void)loadDat
{
    [self hiddenEmptyView];
    
    [SchedulDate getSchedulesWithDate:0 block:^(SResBase *resb, NSArray *mDateList) {
    
        [mTableView headerEndRefreshing];
        [self.tempArray removeAllObjects];
        [mHeaderTimeArr removeAllObjects];
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [mHeaderTimeArr addObjectsFromArray:[resb.mdata objectForKey:@"time"]];
            [self.tempArray addObjectsFromArray:mDateList];
            [self initTopView];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            [self addEmptyView:nil];
        }
        
        if ( mDateList == 0 ) {
            
            [self addEmptyView:nil];
        }
        else
        {
            [self removeEmptyView];
        }
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"日程安排";
    self.hiddenBackBtn = YES;
    self.hiddenRightBtn = YES;
    self.hiddenlll = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    mHeaderTimeArr = [NSMutableArray new];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initTopView{

    mDate = 0;

    _topselev = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_Width, 60)];
    _topselev.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topselev];
    float x = 0;
    float   w = _topselev.frame.size.width/4;
    for (int i = 0;i<mHeaderTimeArr.count;i++) {
        
        UIButton* btall = [[UIButton alloc]initWithFrame:CGRectMake(x, 5, w, 50)];
        btall.titleLabel.numberOfLines = 2;
        btall.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btall setTitle:[NSString stringWithFormat:@"%@",[Util DateTimeInt:[mHeaderTimeArr[i] intValue]]] forState:UIControlStateNormal];
        [btall setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btall addTarget:self action:@selector(topclicked:) forControlEvents:UIControlEventTouchUpInside];
        btall.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        btall.tag = i;
        
        [_topselev addSubview:btall];
        
        x +=w;
        UIView* vline = [[UIView alloc]initWithFrame:CGRectMake(x-0.5f, 0, 0.5, 60)];
        vline.backgroundColor = [UIColor colorWithRed:0.906 green:0.902 blue:0.898 alpha:1.000];
        [_topselev addSubview:vline];
        
        _lastcliecke = nil;

    }
    
    _topselev.contentSize = CGSizeMake(x, 60);

    
    _lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 57,_topselev.frame.size.width/4, 2)];
    _lineview.backgroundColor = M_CO;
    
    UIView* vv =[[UIView alloc]initWithFrame:CGRectMake(0, 59, _topselev.frame.size.width, 0.5f)];
    vv.backgroundColor = [UIColor colorWithRed:0.867 green:0.859 blue:0.859 alpha:1.000];
    [_topselev addSubview:vv];
    [_topselev addSubview:_lineview];
    

    mTableView = [UITableView new];
    
    self.tableView = mTableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.haveHeader = YES;
    
    UINib* nib = [UINib nibWithNibName:@"dateCell" bundle:nil];
    [mTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topselev.bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view.bottom).offset(-50);
    }];
}

-(void)topclicked:(UIButton*)sender
{
    if( _lastcliecke == sender) return;
    
    [_lastcliecke setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:_lineview.backgroundColor forState:UIControlStateNormal];
    _lastcliecke = sender;
    _lineview.tag = sender.tag - 50;
    
    [UIView animateWithDuration:0.15 animations:^{
        
        CGRect f = _lineview.frame;
        f.origin.x = _lastcliecke.frame.origin.x;
        _lineview.frame = f;
        
    }];
    
    mDate = [mHeaderTimeArr[sender.tag] intValue];
    
    [mTableView headerBeginRefreshing];
}

-(void)headerBeganRefresh
{
    [self hiddenEmptyView];
    [SchedulDate getSchedulesWithDate:mDate block:^(SResBase *resb, NSArray *mDateList) {
        
        [mTableView headerEndRefreshing];
        [self.tempArray removeAllObjects];
        [mHeaderTimeArr removeAllObjects];
        if( resb.msuccess )
        {
            
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self.tempArray addObjectsFromArray:mDateList];
            [mHeaderTimeArr addObjectsFromArray:[resb.mdata objectForKey:@"time"]];

            [mTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];

        }
        
        if ( self.tempArray == 0 ) {
            
            [self addEmptyView:nil];
        }
        else
        {
            [self removeEmptyView];
        }
        
    }];
    
    
}
#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return self.tempArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    SchedulDate *mSchedule = self.tempArray[section];
    return mSchedule.mDateStr;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SchedulDate *mSchedule = self.tempArray[section];
    return mSchedule.mTimeArr.count;


}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* Rcell = nil;
    
    SchedulDate *mSchedule = self.tempArray[indexPath.section];
    SScheduleItem *mSSc = mSchedule.mTimeArr[indexPath.row];
    
    Rcell = @"cell";
    
    DatingCell* cell = [tableView dequeueReusableCellWithIdentifier:Rcell];
    
    if (mSSc.mSrvName ) {
        cell.mName1.text = [NSString stringWithFormat:@"%@%@",mSSc.mSrvName,mSSc.mPhone];
        
    }else{
        cell.mName1.text = @"暂无";
        
    }
    if (mSSc.mBuyRemark) {
        cell.mNote1.text = mSSc.mBuyRemark;
        
    }else{
        cell.mNote1.text = @"备注：暂无";
        
    }
    
    
    cell.mAddress1.text = mSSc.mAddress;
    MLLog(@"id是：%d",mSSc.mOrderId);
    cell.mNoteBtn1.mOrder.mId = mSSc.mOrderId;
    [cell.mNoteBtn1 addTarget:self action:@selector(noteAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SchedulDate *mSchedule = self.tempArray[indexPath.section];
    SScheduleItem *mSSc = mSchedule.mTimeArr[indexPath.row];
    
    wkOrderDetailViewController *w = [wkOrderDetailViewController new];
    w.wkorder = SOrder.new;
    w.wkorder.mId = mSSc.mOrderId;
    [self pushViewController:w];
    
    
}
- (void)noteAction:(cusTomeBtn *)sender{
    
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    feedbackViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"xxx"];
    lll.mType = 1;
    lll.mOrder = sender.mOrder;
    MLLog(@"id是：%d",sender.mOrder.mId);
    lll.mOrder.mId = sender.mOrder.mId;
    [self.navigationController pushViewController:lll animated:YES];

}
@end
