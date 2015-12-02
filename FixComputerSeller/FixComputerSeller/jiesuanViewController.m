//
//  jiesuanViewController.m
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/14.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "jiesuanViewController.h"
#import "leftCell.h"
#import "orderFeiyong.h"
@interface jiesuanViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation jiesuanViewController
{
    UITableView *mTableView;
    
    orderFeiyong *mJiesuanView;
    
    int sunNum;
    float sumPrice;
}



- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"e点修";
    self.hiddenRightBtn = YES;

    [self initView];
}
- (void)initView{
    
    mTableView = [UITableView new];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    UINib *nib2 = [UINib nibWithNibName:@"rightCell" bundle:nil];
    [mTableView registerNib:nib2 forCellReuseIdentifier:@"rightcell"];
    
    mJiesuanView = [orderFeiyong shareJiesuan];

    [self.view addSubview:mJiesuanView];
    
    [mTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view.right).with.offset(0);
        make.top.offset(64);
        make.bottom.equalTo(mJiesuanView.top).with.offset(0);

    }];

    [mJiesuanView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view.right).with.offset(0);
        make.top.equalTo(mTableView.bottom).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.offset(65);

    }];
    
    
    for (int i = 0; i < [_mTemArry count]; i ++) {
        
        SOrderGood *good = [_mTemArry objectAtIndex:i];
        sunNum+=good.mNum;
        sumPrice+=(good.mPrice*good.mNum);
    }
    
    
    mJiesuanView.mTotleNum.text = [NSString stringWithFormat:@"已选择%d项",sunNum];
    mJiesuanView.mTotlePrice.text = [NSString stringWithFormat:@"共计¥%.2f元",sumPrice];
   
    [mJiesuanView.mDoneBtn addTarget:self action:@selector(DeletAll) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)DeletAll{

    for (int i = 0; i < [_mTemArry count]; i++) {
        
         SOrderGood *good = [_mTemArry objectAtIndex:i];
         good.mNum = 0;
    }
    
    [_mTemArry removeAllObjects];
    [mTableView reloadData];
    
     [self addEmptyViewWithImg:@"ic_empty"];
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

    return _mTemArry.count;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        
    return 100;

    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    leftCell *cell = (leftCell *)[tableView dequeueReusableCellWithIdentifier:@"rightcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    SOrderGood *ordergoods = [_mTemArry objectAtIndex:indexPath.row];
    
   
    cell.mRightName.text = ordergoods.mName;
    
//    cell.mOldPrice.text = [NSString stringWithFormat:@"进货价：¥%.2f",ordergoods.mMarketPrice];
//    cell.mOldPrice.strikeThroughEnabled = YES;
    
    NSString *price = [NSString stringWithFormat:@"现价：¥%.2f",ordergoods.mPrice];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttribute:NSForegroundColorAttributeName value:COLOR(144, 145, 146) range:NSMakeRange(0,3)];
    
    cell.mNowPrice.attributedText = str;
    cell.mAddBtn.tag = indexPath.row;
    cell.mDelBtn.tag = indexPath.row;
    cell.mAddBtn.indexPath = indexPath;
    cell.mDelBtn.indexPath = indexPath;
    
    [cell.mAddBtn addTarget:self action:@selector(AddClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.mDelBtn addTarget:self action:@selector(DelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (ordergoods.mNum == 0) {
        cell.mDelBtn.hidden = YES;
        cell.mRightNum.hidden = YES;
    }else{
        cell.mDelBtn.hidden = NO;
        cell.mRightNum.hidden = NO;
        cell.mRightNum.text = [NSString stringWithFormat:@"%d",ordergoods.mNum];
    }

    
    return cell;

}

- (void)AddClick:(CellButton *)sender{
    
    leftCell *rightcell = (leftCell *)[mTableView cellForRowAtIndexPath:sender.indexPath];

    rightcell.mDelBtn.hidden = NO;
    rightcell.mRightNum.hidden = NO;
    
    int index = (int)sender.tag;
    
    SOrderGood *ordergoods = [_mTemArry objectAtIndex:index];
    
    ordergoods.mNum ++;

    rightcell.mRightNum.text = [NSString stringWithFormat:@"%d", ordergoods.mNum];
    
    sunNum ++ ;
    sumPrice += ordergoods.mPrice;
    mJiesuanView.mTotleNum.text = [NSString stringWithFormat:@"已选择%d项",sunNum];
    mJiesuanView.mTotlePrice.text = [NSString stringWithFormat:@"共计¥%.2f元",sumPrice];
    
}
- (void)DelClick:(CellButton *)sender{
    
     leftCell *rightcell = (leftCell *)[mTableView cellForRowAtIndexPath:sender.indexPath];
    
    
    int index = (int)sender.tag;
    
    SOrderGood *ordergoods = [_mTemArry objectAtIndex:index];
    
    if (ordergoods.mNum>0) {
        ordergoods.mNum --;
        rightcell.mRightNum.text = [NSString stringWithFormat:@"%d",ordergoods.mNum];
        if (ordergoods.mNum ==0) {
            rightcell.mDelBtn.hidden = YES;
            rightcell.mRightNum.hidden = YES;
            
        }
    }
    
    if (sunNum>0) {
        
        sunNum -- ;
        
        sumPrice -= ordergoods.mPrice;
    }
    mJiesuanView.mTotleNum.text = [NSString stringWithFormat:@"已选择%d项",sunNum];
    mJiesuanView.mTotlePrice.text = [NSString stringWithFormat:@"共计¥%.2f元",sumPrice];
    
}



@end
