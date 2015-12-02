//
//  editAndAddController.m
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "editAndAddController.h"
#import "timeSetHeader.h"
@interface editAndAddController ()

@end

@implementation editAndAddController
{
    UIScrollView *mScrollerView;
    
    timeSetHeader *mHeader;
    
    timeSetHeader *mBottom;
    
    timeSetHeader *mPopView;
    
    CGFloat sheight;
    
    NSArray *timeArr;
    
    UIButton *selectedBtn;
    
    NSMutableArray *timeData;
    
    
    NSArray *weekArr;
    NSMutableArray *weekData;
    
    UIButton    *mBottomBtn;
    
    NSMutableArray *imgArr;
    
    NSMutableArray  *ttArr;
    
    UIView *popview;
    
}
@synthesize mType;

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (mType == 0) {
        self.Title = self.mPageName = @"服务时间设置";
        
    }
    else{
        self.Title = self.mPageName = @"添加服务时间";
        
    }
    
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    // Do any additional setup after loading the view.
    timeData = [NSMutableArray new];
    weekData = [NSMutableArray new];
    imgArr = [NSMutableArray new];
    ttArr = [NSMutableArray new];

    [self initView];
    
}
- (void)initView{
    mHeader = [timeSetHeader shareView];
    mHeader.mWeek.text = _mallTimeinfo.mWeek;
    [mHeader.selectBtn addTarget:self action:@selector(repeatAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mHeader];
    
    mBottom = [timeSetHeader shareBottom];
    [mBottom.okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mBottom];
    
    mScrollerView = [UIScrollView new];
    [self.view addSubview:mScrollerView];
    
    [mHeader makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(mScrollerView.top).with.offset(0);
        make.height.offset(@125);
    }];
    
    [mBottom makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mScrollerView.bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.offset(@60);


    }];
    
    
       timeArr = @[@"00:00~00:30",@"00:30~01:00",@"01:00~01:30",@"01:30~02:00",@"02:00~02:30",@"02:30~03:00",@"03:00~03:30",@"03:30~04:00",@"04:00~04:30",@"04:30~05:00",@"05:00~05:30",@"05:30~06:00",@"06:00~06:30",@"06:30~07:00",@"07:00~07:30",@"07:30~08:00",@"08:00~08:30",@"08:30~09:00",@"09:00~09:30",@"09:30~10:00",@"10:00~10:30",@"10:30~11:00",@"11:00~11:30",@"11:30~12:00",@"12:00~12:30",@"12:30~13:00",@"13:00~13:30",@"13:30~14:00",@"14:00~14:30",@"14:30~15:00",@"15:00~15:30",@"15:30~16:00",@"16:00~16:30",@"16:30~17:00",@"17:00~17:30",@"17:30~18:00",@"18:00~18:30",@"18:00~19:00",@"19:00~19:30",@"19:30~20:00",@"20:00~20:30",@"20:30~21:00",@"21:00~21:30",@"21:30~22:00",@"22:00~22:30",@"22:30~23:00",@"23:00~23:30",@"23:30~00:00"];
    
    int x = 20;
    int y = 10;
    
    int w = DEVICE_Width/3-20;

    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    [mScrollerView addSubview:view];
    
    CGFloat h = 0.0;
    
    for (int i = 0 ; i<timeArr.count; i++) {
        
        selectedBtn = [UIButton new];
        selectedBtn.frame = CGRectMake(x, y, w, 40);
        [selectedBtn setTitleColor:[UIColor colorWithRed:0.282 green:0.282 blue:0.294 alpha:1] forState:0];
        [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        selectedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [selectedBtn setTitle:timeArr[i] forState:0];
        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"8-1"] forState:UIControlStateNormal];
        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"15-1"] forState:UIControlStateSelected];
        [mScrollerView addSubview:selectedBtn];
        [selectedBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *ss = [timeArr[i] substringToIndex:5];


        for ( int j = 0;j<_mallTimeinfo.mTimesInfo.count;j++ ) {
            
            if ([ss isEqualToString:_mallTimeinfo.mTimesInfo[j]]) {
                selectedBtn.enabled = 0;
                [selectedBtn setBackgroundImage:[UIImage imageNamed:@"15-1"] forState:0];
                [selectedBtn setTitleColor:[UIColor whiteColor] forState:0];
            }
            
            
        }
        
        MLLog(@"%@",timeArr[i]);
        x += w+10;
        if (x >= DEVICE_Width-w) {
            x=20;
            y+=50;
        }
        
        h = y;
        
    }
    
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mScrollerView).with.offset(0);
        make.left.equalTo(mScrollerView).with.offset(0);
        make.right.equalTo(mScrollerView).with.offset(0);
        make.bottom.equalTo(mScrollerView).with.offset(0);
        make.height.offset(h);
        make.width.offset(mScrollerView.mwidth);
    }];
    
    [mScrollerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mHeader.bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(mBottom.top).with.offset(0);
        make.width.offset(DEVICE_Width);
        
    }];


    
}
#pragma maek----服务时间段按钮的状态
- (void)btnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    
    if ( sender.selected ) {
        [timeData addObject:sender.titleLabel.text];
    }
    else{
        [timeData removeObject:sender.titleLabel.text];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma maek----确定按钮
- (void)okAction:(UIButton *)sender{
    if (mType == 0) {
        if ((imgArr.count == 0 && _mallTimeinfo.mWeekInfo.count == 0) || timeData.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请至少选择一个服务重复时间"];
            return;
        }
    }else{
        if (imgArr.count == 0  || timeData.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请至少选择一个服务重复时间"];
            return;
        }
    }

    
    NSMutableArray * tt = NSMutableArray.new;
    for ( NSString* one in timeData ) {
        //00:00~00:30
        [tt addObject: [one substringToIndex:5]];
    }
    MLLog(@"确定----->最终选择的内容是：%@",tt);

    [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
    [[SUser currentUser] addTimeSet:_mallTimeinfo.mId weeks:ttArr hours:tt block:^(SResBase *resb, STimeSet *retobj) {
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self popViewController];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
    
}
#pragma maek----重复按钮
- (void)repeatAction:(UIButton *)sender{
    MLLog(@"重复服务");
    [self showPopView];
}

- (void)showPopView{
    [imgArr removeAllObjects];

    popview = [UIView new];
    popview.frame = CGRectMake(0, 0, DEVICE_Width, DEVICE_Height);
    popview.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.35];
    [self.view addSubview:popview];
    
    UIScrollView *bgkView = [UIScrollView new];
    bgkView.frame = CGRectMake(0, 120, popview.mwidth, DEVICE_Height-120);
    bgkView.backgroundColor = [UIColor whiteColor];
    [popview addSubview:bgkView];

    
    UILabel *lll = [UILabel new];
    lll.frame = CGRectMake(0, 20, bgkView.mwidth, 20);
    lll.textColor = [UIColor colorWithRed:0.525 green:0.502 blue:0.518 alpha:1];
    lll.font = [UIFont systemFontOfSize:15];
    lll.text = @"重复时间";
    lll.textAlignment = NSTextAlignmentCenter;
    [bgkView addSubview:lll];

    UIView *line = [UIView new];
    line.frame = CGRectMake(0, lll.mbottom+20, bgkView.mwidth, 0.5);
    line.backgroundColor = [UIColor colorWithRed:0.635 green:0.635 blue:0.635 alpha:1];

    [bgkView addSubview:line];
    
    
    weekArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    int x= line.mbottom+0.5;
    
    for (int i =0; i<weekArr.count; i++) {
        mPopView = [timeSetHeader shareContent];
        mPopView.frame = CGRectMake(0, x,bgkView.mwidth, 40);
        [mPopView.mBtn setTitleColor:[UIColor colorWithRed:0.286 green:0.286 blue:0.290 alpha:1] forState:0];
        [mPopView.mBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [mPopView.mBtn setTitle:weekArr[i] forState:0];
        mPopView.mBtn.tag = i;
        [bgkView addSubview:mPopView];
        [mPopView.mBtn addTarget:self action:@selector(mBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        x+=40;
        
        NSArray *mWeekArr = [_mallTimeinfo.mWeek componentsSeparatedByString:@" "];

        
        for ( int j = 0;j<mWeekArr.count;j++) {
            NSString *tt = weekArr[i];
            if ([tt isEqualToString:mWeekArr[j]]) {
                
                mPopView.mBtn.enabled = 0;;
                [mPopView.mBtn setTitleColor:[UIColor lightGrayColor] forState:0];
                mPopView.mImg.image = [UIImage imageNamed:@"26-2"];
            }

        }
        
    }
    
    NSArray *mWeekArr = [_mallTimeinfo.mWeek componentsSeparatedByString:@" "];
    
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",mWeekArr];
    
    NSArray * filter = [weekArr filteredArrayUsingPredicate:filterPredicate];
    
    MLLog(@"%@",filter);
    
    NSArray *btnArr = @[@"取消",@"确定"];
    UIImage *img1 = [UIImage imageNamed:@"27"];
    UIImage *img2 = [UIImage imageNamed:@"27-1"];
    
    UIColor *color1 = [UIColor colorWithRed:0.286 green:0.286 blue:0.290 alpha:1];
    UIColor *color2 = [UIColor whiteColor];
    NSArray *cArr = @[color1,color2];
    NSArray *arr = @[img1,img2];
    for (int i = 0; i<btnArr.count; i++) {
        mBottomBtn = [UIButton new];
        mBottomBtn.frame = CGRectMake(i*bgkView.mwidth/2+10,mPopView.mbottom+20, bgkView.mwidth/2-20, 40);
        [mBottomBtn setTitle:btnArr[i] forState:0];
        mBottomBtn.tag = i+1;
        [mBottomBtn setTitleColor:cArr[i] forState:0];
        [mBottomBtn setBackgroundImage:arr[i] forState:0];
        [bgkView addSubview:mBottomBtn];
        [mBottomBtn addTarget:self action:@selector(mbottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    bgkView.contentSize = CGSizeMake(DEVICE_Width, mBottomBtn.mbottom+20);
}
- (void)hiddenPopView{

    [popview removeFromSuperview];
    
}
#pragma mark----弹出的按钮
- (void)mbottomBtnAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            MLLog(@"取消");
            [self hiddenPopView];
        }
            break;
        case 2:
        {
            if (imgArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"请至少选择一个服务重复时间"];
                return;
            }
            
            MLLog(@"确定");
            [self hiddenPopView];
            MLLog(@"%@",imgArr);
            if (imgArr.count == 1) {
                mHeader.mWeek.text = [NSString stringWithFormat:@"%@",[imgArr objectAtIndex:0]];

            }
            if (imgArr.count == 2) {
                mHeader.mWeek.text = [NSString stringWithFormat:@"%@,%@",[imgArr objectAtIndex:0],[imgArr objectAtIndex:1]];
                
            }
            if (imgArr.count == 3) {
                mHeader.mWeek.text = [NSString stringWithFormat:@"%@,%@,%@",[imgArr objectAtIndex:0],[imgArr objectAtIndex:1],[imgArr objectAtIndex:2]];
                
            }
            if (imgArr.count == 4) {
                mHeader.mWeek.text = [NSString stringWithFormat:@"%@,%@,%@,%@",[imgArr objectAtIndex:0],[imgArr objectAtIndex:1],[imgArr objectAtIndex:2],[imgArr objectAtIndex:3]];
                
            }
            if (imgArr.count == 5) {
                mHeader.mWeek.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",[imgArr objectAtIndex:0],[imgArr objectAtIndex:1],[imgArr objectAtIndex:2],[imgArr objectAtIndex:3],[imgArr objectAtIndex:4]];
                
            }
            if (imgArr.count == 6) {
                mHeader.mWeek.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[imgArr objectAtIndex:0],[imgArr objectAtIndex:1],[imgArr objectAtIndex:2],[imgArr objectAtIndex:3],[imgArr objectAtIndex:4],[imgArr objectAtIndex:5]];
                
            }
            if (imgArr.count == 7) {
                mHeader.mWeek.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[imgArr objectAtIndex:0],[imgArr objectAtIndex:1],[imgArr objectAtIndex:2],[imgArr objectAtIndex:3],[imgArr objectAtIndex:4],[imgArr objectAtIndex:5],[imgArr objectAtIndex:6]];
                
            }

        }
            break;
        default:
            break;
    }
}
#pragma markj----选择星期
- (void)mBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    for (UIImageView *view in sender.superview.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
            if ( sender.selected ) {
                view.image = [UIImage imageNamed:@"26"];
            }else{
                view.image = [UIImage imageNamed:@"26-1"];

            }
        }
    }
    
    
    if ( sender.selected ) {
        [imgArr addObject:sender.titleLabel.text];
        [ttArr addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
    else{
        [imgArr removeObject:sender.titleLabel.text];
        [ttArr addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];

    }

}
@end
