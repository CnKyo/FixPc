//
//  myMessageViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/23.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "myMessageViewController.h"
#import "messageTableViewCell.h"
#import "msgDetailView.h"
#import "WebVC.h"

#import "UIView+Additions.h"
#import "UIViewExt.h"
@interface myMessageViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation myMessageViewController{
    ///底部视图
    UIView *bottomView;
    ///是否选中
    BOOL isSelected;
    
    NSString *sss;
    
    CGFloat cellH;
    
    UITableView *mTableView;


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self.isStoryBoard = YES;
    return [super initWithCoder:aDecoder];
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"我的消息";
    self.hiddenlll = YES;

    

    mTableView = [UITableView new];
    [self.view addSubview:mTableView];
    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view.bottom).offset(0);
    }];
    self.tableView = mTableView;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UINib *nib = [UINib nibWithNibName:@"messageTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.haveFooter = YES;
    self.haveHeader = YES;
    [self.tableView headerBeginRefreshing];    // Do any additional setup after loading the view.
    self.rightBtnImage = [UIImage imageNamed:@"lajitong"];


}
#pragma mark ----顶部刷新数据
- (void)headerBeganRefresh{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeClear];
    self.page = 1;
    [SMessageInfo getMsgList:self.page block:^(SResBase *resb, NSArray *all) {
        [self headerEndRefresh];
        
        [self.tempArray removeAllObjects];
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray:all];
            MLLog(@"获取到的数据:%@",self.tempArray);
            [SVProgressHUD dismiss];
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
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeClear];
    self.page ++;
    [SMessageInfo getMsgList:self.page block:^(SResBase *resb, NSArray *all) {
        [self footetEndRefresh];
        if (resb.msuccess) {
            
            [self.tempArray addObjectsFromArray:all];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 74;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageTableViewCell *cell = (messageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    SMessageInfo *Smsg = self.tempArray[indexPath.row];
    
    
    NSArray *timeArr = [Smsg.mCreateTime componentsSeparatedByString:@" "];
    
    cell.msgTitleLb.text = Smsg.mTitle;
    cell.msgContentLb.text = Smsg.mContent;
    cell.timeLb.text = [timeArr objectAtIndex:0];
    
    UIImage *ptai = [UIImage imageNamed:@"platform"];
    UIImage *sjia = [UIImage imageNamed:@"merchants"];
    
    cell.mMsgType.image = Smsg.mType == 1 ? ptai:sjia;

    if (Smsg.mStatus == 0) {
        MLLog(@"~~~~~:%d",Smsg.mStatus);
        cell.mPoint.hidden = NO;
        
    }
    if(Smsg.mStatus == 1){
        MLLog(@"~~~~~:%d",Smsg.mStatus);
        cell.mPoint.hidden = YES;
        
    }
    
    cell.selectedBtn.tag = indexPath.row;
    
    if (Smsg.mChecked) {
        [cell.selectedBtn setImage:[UIImage imageNamed:@"22"] forState:UIControlStateNormal];
    }else{
        [cell.selectedBtn setImage:[UIImage imageNamed:@"22-1"] forState:UIControlStateNormal];
    }
    
    [cell.selectedBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    return cell;
    
}

- (void)checkClick:(UIButton *)sender{

    SMessageInfo *Smsg = self.tempArray[sender.tag];
    Smsg.mChecked = !Smsg.mChecked;
    
    messageTableViewCell *cell = (messageTableViewCell*)[sender findSuperViewWithClass:[messageTableViewCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMessageInfo *Smsg = self.tempArray[indexPath.row];
    
    [SMessageInfo readSomeMsg:@[ [NSNumber numberWithInt: Smsg.mId] ] block:^(SResBase *retobj) {
        
        if (retobj.msuccess) {
            Smsg.mStatus = 1;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            if (Smsg.mType == 1)
            {///状态为1，打开新界面，展示消息详情
                UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                msgDetailView *mmm =[secondStroyBoard instantiateViewControllerWithIdentifier:@"msgD"];
                mmm.Smsg = Smsg;
                [self.navigationController pushViewController:mmm animated:YES];
                
            }
            if (Smsg.mType == 3)
            {///3为订单消息,args为订单id???
                
                
            }if(Smsg.mType == 2)
            {///状态为2，打开html界面
                WebVC *webView = [[WebVC alloc]init];
                webView.mName = @"消息详情";
                webView.mUrl = Smsg.mArgs;
                [self pushViewController:webView];
            }
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        }
        
    }];
    

}

#pragma mark-----全部设为已读
- (void)rightBtnTouched:(id)sender{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (SMessageInfo *sm in self.tempArray) {
        
        if( sm.mChecked )
            [arr addObject:[NSNumber numberWithInt:sm.mId]];
    }
    
    if( arr.count == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请至少选中一条消息"];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"正在操作中..." maskType:SVProgressHUDMaskTypeClear];
    
    [SMessageInfo delMessages:arr block:^(SResBase *retobj) {
        
        if (retobj.msuccess) {
            
            NSMutableArray * tt  = NSMutableArray.new;
            for ( SMessageInfo* one in self.tempArray ) {
                if( !one.mChecked )
                    [tt addObject:one];
            }
            self.tempArray = tt;
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        }
    }];

   
    [mTableView reloadData];
    
}

#pragma mark 列表删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMessageInfo *Smsg = self.tempArray[indexPath.row];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arr addObject:[NSNumber numberWithInt:Smsg.mId]];
    
    [SMessageInfo delMessages:arr block:^(SResBase *retobj) {
        
        if (retobj.msuccess) {
            [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
            
            [self.tempArray removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        }
    }];

    
//    [Smsg delThis:^(SResBase *resb) {
//        if (resb.msuccess) {
//            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
//            
//            [self.tempArray removeObjectAtIndex:indexPath.row];
//            [tableView beginUpdates];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [tableView endUpdates];
//            
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:resb.mmsg];
//        }
//    }];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
}
//#pragma mark----列表动画？
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    //1. Setup the CATransform3D structure
//    CATransform3D rotation;
//    rotation                = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34            = 1.0/ -600;
//    
//    
//    //2. Define the initial state (Before the animation)
//    cell.layer.shadowColor  = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha              = 0;
//    
//    cell.layer.transform    = rotation;
//    cell.layer.anchorPoint  = CGPointMake(0, 0.5);
//    
//    
//    //3. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform    = CATransform3DIdentity;
//    cell.alpha              = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
//    
//}
@end
