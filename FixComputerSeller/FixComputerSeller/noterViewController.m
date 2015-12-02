//
//  noterViewController.m
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "noterViewController.h"
#import "noterCell.h"
@interface noterViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation noterViewController
{
    int page;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"公告";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    CGRect rect = CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-60);
    
    [self loadTableView:rect delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor whiteColor];

    self.haveFooter = YES;
    self.haveHeader = YES;
    [self.tableView headerBeginRefreshing];
    
    UINib *nib = [UINib nibWithNibName:@"noterCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----顶部刷新数据
- (void)headerBeganRefresh{
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    page=1;
    
    [SNote getNotes:[SUser currentUser].mUserId andPage:page block:^(SResBase *resb, NSArray *all) {
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
    page++;
    
    [SNote getNotes:[SUser currentUser].mUserId andPage:page block:^(SResBase *resb, NSArray *all) {
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
    
    return 80;
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseCellId = @"cell";
    
    noterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    if (!cell)
    {
        cell = [[noterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    SNote *sn = self.tempArray[indexPath.row];
    cell.mTitle.text = sn.mTitle;
    cell.mTime.text = [NSString stringWithFormat:@"%d",sn.mTime];
    cell.mContent.text = sn.mContent;
    
    return cell;
    
    
}

@end
