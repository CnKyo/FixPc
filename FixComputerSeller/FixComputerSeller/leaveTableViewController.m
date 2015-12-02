//
//  leaveTableViewController.m
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/24.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "leaveTableViewController.h"
#import "leaveCell.h"
#import "leaveDetailViewController.h"
@interface leaveTableViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation leaveTableViewController{
    UIButton *addBtn;
    BOOL isAll;

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self.isStoryBoard = YES;
    return [super initWithCoder:aDecoder];
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"请假列表";
    self.hiddenA = YES;
    self.hiddenB = YES;
    self.hiddenlll = YES;

    self.tableView = self.myTableView;
    self.haveFooter = YES;
    self.haveHeader = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    addBtn = [UIButton new];
    addBtn.frame = CGRectMake(15, DEVICE_Height-50, DEVICE_Width-30, 45);
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 4;
    addBtn.backgroundColor  = M_CO;
    [addBtn setTitle:@"删除" forState:0];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UINib *nib = [UINib nibWithNibName:@"leaveCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    [self.tableView headerBeginRefreshing];
    
    self.rightBtnTitle = @"全选";

    // Do any additional setup after loading the view.
}

- (void)rightBtnTouched:(id)sender{

    if (isAll) {
        for (SLeave *sm in self.tempArray) {
            sm.mSelected = NO;
        }
         isAll = NO;
        self.rightBtnTitle = @"全选";
    }else{
        for (SLeave *sm in self.tempArray) {
            sm.mSelected = YES;
        }
         isAll = YES;
        self.rightBtnTitle = @"取消";
    }
    
    
   
    [self.tableView reloadData];
}

#pragma mark ----顶部刷新数据
- (void)headerBeganRefresh{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeClear];
    self.page = 1;
    [[SUser currentUser]leaveList:self.page block:^(NSArray *arr, SResBase *resb) {
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray:arr];
            
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if ( self.tempArray.count == 0) {
            [self addEmptyViewWithImg:nil];
        }
        else{
            [self removeEmptyView];
        }
        [self.tableView reloadData];
    }];
}
#pragma mark----底部刷新
-(void)footetBeganRefresh
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeClear];
    self.page ++;
    
    [[SUser currentUser]leaveList:self.page block:^(NSArray *arr, SResBase *resb) {
        [self footetEndRefresh];
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray:arr];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
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
    return 90;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    leaveCell *cell = (leaveCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    SLeave *SLV = self.tempArray[indexPath.row];

    cell.mContent.text = SLV.mText;
//    cell.mLeaveTime.text = [Util startTimeStr:SLV.mStartTimeStr andEndTime:SLV.mEndTimeStr];
    cell.mLeaveTime.text = [NSString stringWithFormat:@"%@ 至 %@",SLV.mStartTimeStr,SLV.mEndTimeStr];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:SLV.mTimeStr];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy.MM.dd"];
    cell.mTime.text = [dateFormatter2 stringFromDate:date];
    
    cell.mSelectBtn.tag = indexPath.row;
    if (SLV.mSelected) {
        [cell.mSelectBtn setImage:[UIImage imageNamed:@"22"] forState:0];
    }
    else{
        [cell.mSelectBtn setImage:[UIImage imageNamed:@"22-1"] forState:0];

    }
    [cell.mSelectBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}
- (void)checkClick:(UIButton *)sender{
    
    SLeave *SLV = self.tempArray[sender.tag];
    SLV.mSelected = !SLV.mSelected;
    
    leaveCell *cell = (leaveCell*)[sender findSuperViewWithClass:[leaveCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLeave *SLV = self.tempArray[indexPath.row];
    leaveDetailViewController *lll = [[leaveDetailViewController alloc]init];
//    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    leaveDetailViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"ldd"];
    lll.ssl = SLV;
    [self.navigationController pushViewController:lll animated:YES];

}
#pragma mark 列表删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SLeave* obj = self.tempArray[ indexPath.row ];
    
    [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeClear];
    [SLeave delAll:@[ NumberWithInt( obj.mId) ] block:^(SResBase *resb) {
        
        if (resb.msuccess) {
            
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            
            [self.tempArray removeObjectAtIndex:indexPath.row];
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
}
- (void)addAction:(UIButton *)sender{
    MLLog(@"删除");
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (SLeave *sm in self.tempArray) {
        if( sm.mSelected )
            [arr addObject:[NSNumber numberWithInt:sm.mId]];
    }
    
    if( arr.count == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请至少选中一条消息"];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"正在操作中..." maskType:SVProgressHUDMaskTypeClear];
    
    [SLeave delAll:arr block:^(SResBase *resb) {
        
        if (resb.msuccess) {
            
            NSMutableArray * tt  = NSMutableArray.new;
            for ( SLeave* one in self.tempArray ) {
                if( !one.mSelected )
                    [tt addObject:one];
            }
            self.tempArray = tt;
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
    
    
    [self.tableView reloadData];


}
@end
