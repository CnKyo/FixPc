//
//  leaveDetailViewController.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/24.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "leaveDetailViewController.h"

@interface leaveDetailViewController ()

@end

@implementation leaveDetailViewController

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"请假审核";
    self.hiddenA = YES;
    self.hiddenB = YES;
    self.hiddenlll = YES;
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initView{

    self.view.backgroundColor = [UIColor colorWithRed:0.933 green:0.918 blue:0.914 alpha:1];

    UIView *FFF = [[UIView alloc]initWithFrame:CGRectMake(0, self.navBar.mbottom+20, DEVICE_Width, 95)];
    FFF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:FFF];
    
    
    UILabel *sll = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 75, 15)];
    sll.textColor = [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1];
    sll.font = [UIFont systemFontOfSize:15];
    sll.text = @"请假时间：";
    [FFF addSubview:sll];
    
    UILabel *ttt = [[UILabel alloc]initWithFrame:CGRectMake(sll.mright+5, sll.origin.y, 233, 18)];
    ttt.textColor = [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1];
    ttt.font = [UIFont systemFontOfSize:15];
    ttt.text = [Util startTimeStr:self.ssl.mStartTimeStr andEndTime:self.ssl.mEndTimeStr];

    [FFF addSubview:ttt];

    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, ttt.mbottom+18, DEVICE_Width-10, 1)];
    lineV.backgroundColor = [UIColor colorWithRed:0.871 green:0.863 blue:0.867 alpha:1];
    [FFF addSubview:lineV];
    
    UILabel *RRR = [[UILabel alloc]initWithFrame:CGRectMake(10, sll.mbottom+40, 75, 15)];
    RRR.textColor = [UIColor colorWithRed:0.596 green:0.584 blue:0.604 alpha:1];
    RRR.font = [UIFont systemFontOfSize:15];
    RRR.text = @"请假理由：";
    [FFF addSubview:RRR];
    
    UILabel *rrr = [[UILabel alloc]initWithFrame:CGRectMake(RRR.mright+5, RRR.origin.y-2, DEVICE_Width-(RRR.mright+30), 15)];
    rrr.numberOfLines = 0;
    rrr.textColor = [UIColor colorWithRed:0.596 green:0.584 blue:0.604 alpha:1];
    rrr.font = [UIFont systemFontOfSize:15];
    rrr.text = self.ssl.mText;

    [FFF addSubview:rrr];
    
    CGFloat CG  =[rrr.text sizeWithFont:rrr.font constrainedToSize:CGSizeMake(rrr.mwidth, CGFLOAT_MAX)].height;
    CGRect rect = rrr.frame;
    rect.size.height = CG;
    rrr.frame = rect;
    
    rect = FFF.frame;
    rect.size.height = rrr.origin.y+CG+20;
    FFF.frame = rect;
    
    UIView *bbb = [[UIView alloc]initWithFrame:CGRectMake(0, FFF.mbottom+15, DEVICE_Width, 65)];
    bbb.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bbb];
    
    UILabel *ggg = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, bbb.mwidth-20, bbb.mheight-20)];
    ggg.textColor = M_CO;
    ggg.numberOfLines = 0;
    ggg.font = [UIFont systemFontOfSize:15];
    ggg.text = @"您请假申请已提交到后台，审核预计需要1个工作日，请耐心等待或咨询后台";
    [bbb addSubview:ggg];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(15, bbb.mbottom+20, DEVICE_Width-30, 45)];
    [bt setBackgroundImage:[UIImage imageNamed:@"33-33"] forState:UIControlStateNormal];
    [bt setTitle:@"电话咨询" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(Caction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)Caction:(UIButton *)sender{
    MLLog(@"%@",[GInfo shareClient].mServiceTel);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[GInfo shareClient].mServiceTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
