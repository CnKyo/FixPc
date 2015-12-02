//
//  setServiceTimeView.m
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "setServiceTimeView.h"
#import "setTimeCell.h"
#import "editAndAddController.h"
#import "leaveViewController.h"
@interface setServiceTimeView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation setServiceTimeView
{
    
    UIButton *addBtn;
    BOOL    _maybereload;

}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"服务时间设置";
    self.hiddenlll = YES;
//    self.rightBtnTitle = @"请假";
    
    CGRect rect = CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height);
    
    [self loadTableView:rect delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor whiteColor];

    
//    addBtn = [UIButton new];
//    addBtn.frame = CGRectMake(15, DEVICE_Height-50, DEVICE_Width-30, 45);
//    addBtn.layer.masksToBounds = YES;
//    addBtn.layer.cornerRadius = 4;
//    addBtn.backgroundColor  = M_CO;
//    [addBtn setTitle:@"添加" forState:0];
//    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:addBtn];
    
    UINib *nib = [UINib nibWithNibName:@"setTimeCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    [self loadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if( _maybereload )
    {
        _maybereload = NO;
        [self loadData];
    }
    [self loadData];
}
-(void)loadData
{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    [[SUser currentUser]getTimeSet:^(SResBase *resb, NSArray *all) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            
            [self.tempArray removeAllObjects];
            [self.tempArray addObjectsFromArray: all];
            
            [self.tableView reloadData];
            if (self.tempArray.count == 0) {
                [self addKEmptyView:nil];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus: resb.mmsg];
            [self addKEmptyView:nil];
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
    
    return self.tempArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseCellId = @"cell";
    STimeSet* obj = self.tempArray[ indexPath.row ];

    setTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    if (!cell)
    {
        cell = [[setTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.mWeek.text = obj.mWeek;
    
    cell.mTime.text = obj.mShifts;
    
    return cell;
    
    
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    STimeSet* oneojb = self.tempArray[ indexPath.row ];
//
//    editAndAddController *e = [editAndAddController new];
//    e.mType = 0;
//    e.mallTimeinfo = oneojb;
//    e.mUnSelectWeek = [self getUnSelectWeek:oneojb];
//    [self pushViewController:e];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)rightBtnTouched:(id)sender{
//    MLLog(@"请假");
//    
//    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    leaveViewController *lll =[secondStroyBoard instantiateViewControllerWithIdentifier:@"leave"];
//    
//    [self.navigationController pushViewController:lll animated:YES];
//    
//}
- (void)addAction:(UIButton *)sender{
    MLLog(@"添加");
    editAndAddController *e = [editAndAddController new];
    e.mUnSelectWeek = [self getUnSelectWeek:nil];
    e.mType = 1;
    _maybereload = YES;

    [self pushViewController:e];
}
-(NSArray*)getUnSelectWeek:(STimeSet*)oneojb
{
    NSMutableArray* ff = NSMutableArray.new;
    for ( STimeSet* one in self.tempArray )
    {
        if( one == oneojb ) continue;
        for ( id oneid in one.mWeekInfo ) {
            [ff addObject: oneid ];
        }
    }
    return ff;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    STimeSet *oneob = self.tempArray[indexPath.row];
    
    [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeClear];
    [oneob delThis:^(SResBase *retobj) {
        
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
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
@end
