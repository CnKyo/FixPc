//
//  feiyongViewController.m
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/11.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "feiyongViewController.h"
#import "leftCell.h"
#import "orderFeiyong.h"
#import "JSBadgeView.h"
#import "wkOrderDetailViewController.h"


#import "jiesuanViewController.h"
@interface feiyongViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation feiyongViewController
{

    UITableView *leftTable;
    UITableView *rightTable;
    
    orderFeiyong *mBottomView;
    
    orderFeiyong *mSearchView;
    
    int leftSelect;
    
    NSIndexPath *leftIndexPath;
    int sunNum;
    float sumPrice;
    
    JSBadgeView *badgeView;
    
    BOOL isSearch;
    NSArray *searchArry;
    
    NSMutableArray *mainAry;


}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [leftTable reloadData];
    
    [rightTable reloadData];
    
    sunNum = 0;
    sumPrice = 0;
    for (int i = 0; i < [mainAry count]; i ++) {
    
        SOrderGood *good = [mainAry objectAtIndex:i];
        sunNum+=good.mNum;
        sumPrice+=(good.mPrice*good.mNum);
    }
    
    if (sunNum == 0) {
        badgeView.hidden = YES;
    }else{
        badgeView.hidden = NO;
    }
    
    mBottomView.mTotleNum.text = [NSString stringWithFormat:@"已选择%d项",sunNum];
    mBottomView.mTotlePrice.text = [NSString stringWithFormat:@"共计¥%.2f元",sumPrice];
    badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
}

- (void)initData{
    
    mainAry = [[NSMutableArray alloc] initWithCapacity: 0];

    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    
    [SOrderGoodsList getGoodsItems:nil typeid:0 block:^(SResBase *resb, NSArray *all) {
        
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            
            self.tempArray = [[NSMutableArray alloc] initWithArray:all];
            
            [self initView];
            [leftTable reloadData];
            [rightTable reloadData];
            
            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [leftTable selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            
        }

        
    }];

}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"e点修";
    self.hiddenRightBtn = YES;
    
    leftSelect = 0;
    sunNum = 0;

    // Do any additional setup after loading the view.
    
    
    
    
    [self initData];
    
}
- (void)initView{

    leftTable = [UITableView new];
    leftTable.backgroundColor = [UIColor colorWithRed:0.953 green:0.937 blue:0.933 alpha:1];
    leftTable.frame = CGRectMake(0, 64, DEVICE_Width/3, DEVICE_InNavBar_Height-70);
    leftTable.delegate = self;
    leftTable.dataSource = self;
    [self.view addSubview:leftTable];
    
   
    
    rightTable = [UITableView new];
    rightTable.frame = CGRectMake(leftTable.mright, 64, DEVICE_Width-DEVICE_Width/3, DEVICE_InNavBar_Height-70);
    rightTable.delegate = self;
    rightTable.dataSource = self;
    [self.view addSubview:rightTable];
    
    mSearchView = [orderFeiyong shareSearch];
//    mSearchView.mSearchTx.delegate = self;
    [mSearchView.mSearchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    rightTable.tableHeaderView = mSearchView;
    
    UINib *nib = [UINib nibWithNibName:@"leftCell" bundle:nil];
    [leftTable registerNib:nib forCellReuseIdentifier:@"leftcell"];
    
    
    UINib *nib2 = [UINib nibWithNibName:@"rightCell" bundle:nil];
    [rightTable registerNib:nib2 forCellReuseIdentifier:@"rightcell"];

    
    mBottomView = [orderFeiyong shareBottom];
    [mBottomView.mShopingCar addTarget:self action:@selector(mShopingCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mBottomView];
    
    [mBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.offset(90);
    }];
    
    badgeView = [[JSBadgeView alloc] initWithParentView:mBottomView.mShopingCar alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgePositionAdjustment = CGPointMake(-10, 10);
    badgeView.badgeStrokeWidth = 5;
    badgeView.hidden = YES;
    
    mBottomView.mTotlePrice.text = [NSString stringWithFormat:@"共计¥%.2f元",sumPrice];

    mBottomView.mTotleNum.text = [NSString stringWithFormat:@"已选择%d项",sunNum];
    
    [mBottomView.mDoneBtn addTarget:self action:@selector(PlaceOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)PlaceOrder:(UIButton *)sender{
    
    [mainAry removeAllObjects];
    
    for (int i = 0; i < [self.tempArray count]; i++) {
        
        SOrderGoodsList *catlog = [self.tempArray objectAtIndex:i];
        
        for (int j = 0; j < catlog.mSubGoods.count; j++) {
            
            SOrderGood *goods = [catlog.mSubGoods objectAtIndex:j];
            
            if (goods.mNum>0) {
                [mainAry addObject:goods];
            }
        }
    }
    
    [SVProgressHUD showWithStatus:@"操作中" maskType:SVProgressHUDMaskTypeClear];
    [_mTepOrder dealItem:mainAry andOrderId:_mTepOrder.mId andTotlePrice:sumPrice block:^(SResBase *resb) {
        
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            
            wkOrderDetailViewController *orderDetail = [[wkOrderDetailViewController alloc] init];
            orderDetail.wkorder = _mTepOrder;
            NSMutableArray* vcs = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [vcs removeLastObject];
            [vcs addObject:orderDetail];
            [self.navigationController setViewControllers:vcs  animated:NO];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            
        }

    }];
    
    
}

- (void)searchAction:(UIButton *)sender{

    [mSearchView.mSearchTx resignFirstResponder];
    
    SOrderGoodsList *orderlist = [self.tempArray objectAtIndex:leftSelect];
    
    [SVProgressHUD showWithStatus:@"搜索中.." maskType:SVProgressHUDMaskTypeClear];
    
    [SOrderGoodsList getGoodsItems:mSearchView.mSearchTx.text typeid:orderlist.mTypeId block:^(SResBase *resb, NSArray *all) {
        
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            
            searchArry = [[NSMutableArray alloc] initWithArray:all];
        
            isSearch = YES;
            [rightTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            
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
    if (tableView == leftTable) {
        
        return [self.tempArray count];
        
    }else if (tableView == rightTable){
        
        SOrderGoodsList *orderlist = [self.tempArray objectAtIndex:leftSelect];
        
        
        
        if (isSearch) {
            orderlist = [searchArry objectAtIndex:0];

        }
        return [orderlist.mSubGoods count];

    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftTable) {
        
        return 45;
        
    }else if (tableView == rightTable){
        
        return 75;
    }
    
    return 0;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftTable) {
        
        leftCell *cell = (leftCell *)[tableView dequeueReusableCellWithIdentifier:@"leftcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor colorWithRed:0.953 green:0.937 blue:0.933 alpha:1];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:cell.bounds];
        imgV.image = [UIImage imageNamed:@"11-1(1)-1"];
        cell.selectedBackgroundView = imgV;
        
        SOrderGoodsList *orderlist = [self.tempArray objectAtIndex:indexPath.row];
        cell.mLeftName.text = orderlist.mName;
        
        if ([orderlist getNum]>0) {
            cell.mLeftNum.hidden = NO;
        }else{
            cell.mLeftNum.hidden = YES;
        }
        [cell.mLeftNum setTitle:[NSString stringWithFormat:@"%d",[orderlist getNum]] forState:UIControlStateNormal] ;
        
        if (indexPath.row == 0) {
            
            leftIndexPath = indexPath;
            
        }
        
        return cell;
        
    }else if (tableView == rightTable){
        
        leftCell *cell = (leftCell *)[tableView dequeueReusableCellWithIdentifier:@"rightcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SOrderGoodsList *orderlist = [self.tempArray objectAtIndex:leftSelect];
        SOrderGood *ordergoods = [orderlist.mSubGoods objectAtIndex:indexPath.row];
        
        if (isSearch) {
            orderlist = [searchArry objectAtIndex:0];
            ordergoods = [orderlist.mSubGoods objectAtIndex:indexPath.row];
        }
        cell.mRightName.text = ordergoods.mName;
//        cell.mOldPrice.hidden = YES;
//        cell.mOldPrice.text = [NSString stringWithFormat:@"进货价：¥%.2f",ordergoods.mMarketPrice];
//        cell.mOldPrice.strikeThroughEnabled = YES;
        
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
    
    return nil;
}


- (void)AddClick:(CellButton *)sender{
    
    leftCell *rightcell = (leftCell *)[rightTable cellForRowAtIndexPath:sender.indexPath];
    leftCell *leftcell = (leftCell *)[leftTable cellForRowAtIndexPath:leftIndexPath];
    rightcell.mDelBtn.hidden = NO;
    rightcell.mRightNum.hidden = NO;
    
    int index = (int)sender.tag;
    
    SOrderGoodsList *orderlist = [self.tempArray objectAtIndex:leftSelect];
    SOrderGood *ordergoods = [orderlist.mSubGoods objectAtIndex:index];
    
    ordergoods.mNum ++;
    leftcell.mLeftNum.hidden = NO;
    rightcell.mRightNum.text = [NSString stringWithFormat:@"%d", ordergoods.mNum];
    [leftcell.mLeftNum setTitle:[NSString stringWithFormat:@"%d",[orderlist getNum]] forState:UIControlStateNormal] ;
    
    
    sunNum ++ ;
    sumPrice += ordergoods.mPrice;
    mBottomView.mTotlePrice.text = [NSString stringWithFormat:@"共计¥%.2f元",sumPrice];
    badgeView.hidden = NO;
    badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
    
    mBottomView.mTotleNum.text = [NSString stringWithFormat:@"已选择%d项",sunNum];
   
    
}
- (void)DelClick:(CellButton *)sender{
    
    leftCell *rightcell = (leftCell *)[rightTable cellForRowAtIndexPath:sender.indexPath];
    leftCell *leftcell = (leftCell *)[leftTable cellForRowAtIndexPath:leftIndexPath];

    
    int index = (int)sender.tag;
    
    
    SOrderGoodsList *orderlist = [self.tempArray objectAtIndex:leftSelect];
    SOrderGood *ordergoods = [orderlist.mSubGoods objectAtIndex:index];
    
    if (ordergoods.mNum>0) {
        ordergoods.mNum --;
        rightcell.mRightNum.text = [NSString stringWithFormat:@"%d",ordergoods.mNum];
        if (ordergoods.mNum ==0) {
            rightcell.mDelBtn.hidden = YES;
            rightcell.mRightNum.hidden = YES;
            
        }
    }
    
   
        
    [leftcell.mLeftNum setTitle:[NSString stringWithFormat:@"%d",[orderlist getNum]] forState:UIControlStateNormal] ;
    
    if ([orderlist getNum] ==0) {
        leftcell.mLeftNum.hidden = YES;
    }
    
    
    
    
    if (sunNum>0) {
        sunNum -- ;
        badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
        
        sumPrice -= ordergoods.mPrice;
        mBottomView.mTotlePrice.text = [NSString stringWithFormat:@"共计¥%.2f元",sumPrice];
        if (sunNum == 0) {
            
            badgeView.hidden = YES;
        }
    }
    mBottomView.mTotleNum.text = [NSString stringWithFormat:@"已选择%d项",sunNum];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == leftTable) {
        
        leftSelect = (int)indexPath.row;
        
        leftIndexPath = indexPath;
        
        isSearch = NO;
        
        [rightTable reloadData];
        
        NSLog(@"%d",leftSelect);
        
    }

}

#pragma mark----购物车
- (void)mShopingCarAction:(UIButton *)sender{
    
    if(sunNum < 1){
        
        [SVProgressHUD showErrorWithStatus:@"您还没有添加商品"];
        return;
    }
    
    [mainAry removeAllObjects];
    
    for (int i = 0; i < [self.tempArray count]; i++) {
        
        SOrderGoodsList *catlog = [self.tempArray objectAtIndex:i];
        
        for (int j = 0; j < catlog.mSubGoods.count; j++) {
            
            SOrderGood *goods = [catlog.mSubGoods objectAtIndex:j];
            
            if (goods.mNum>0) {
                
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//                [dic setObject:goods forKey:@"goods"];
//                [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"superid"];
                [mainAry addObject:goods];
            }
        }
    }

    
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    jiesuanViewController *ttt =[secondStroyBoard instantiateViewControllerWithIdentifier:@"jiesuan"];
    ttt.mTemArry = mainAry;
    [self.navigationController pushViewController:ttt animated:YES];
}
@end
