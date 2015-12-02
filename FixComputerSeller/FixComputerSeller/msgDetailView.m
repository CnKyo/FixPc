//
//  msgDetailView.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/7/1.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "msgDetailView.h"
@interface msgDetailView ()

@end

@implementation msgDetailView{

}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;

    [super viewDidLoad];
    self.hiddenlll = YES;
    self.Title = self.mPageName = @"消息详情";
    [self initView];

    // Do any additional setup after loading the view from its nib.
}
- (void)initView{

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *sss = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navBar.mbottom, DEVICE_Width, DEVICE_Height)];
    sss.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sss];
    
    UILabel *mTitiel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, DEVICE_Width/2, 20)];
    mTitiel.textColor = [UIColor colorWithRed:0.235 green:0.200 blue:0.224 alpha:1];
    mTitiel.textAlignment = NSTextAlignmentLeft;
    mTitiel.font = [UIFont systemFontOfSize:14];
    mTitiel.text = self.Smsg.mTitle;
    [sss addSubview:mTitiel];
    
    UILabel *mTime = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_Width-141, mTitiel.origin.y, 125, 20)];
    mTitiel.textColor = [UIColor colorWithRed:0.235 green:0.200 blue:0.224 alpha:1];
    mTime.textAlignment = NSTextAlignmentRight;
    mTime.font = [UIFont systemFontOfSize:13];
    mTime.text = self.Smsg.mCreateTime;
    [sss addSubview:mTime];
    
    UIView *l1 = [[UIView alloc]initWithFrame:CGRectMake(15, mTime.mbottom+15, DEVICE_Width-15, 1)];
    l1.backgroundColor = [UIColor colorWithRed:0.882 green:0.878 blue:0.867 alpha:1];
    [sss addSubview:l1];
    
    UILabel *mcontent = [[UILabel alloc]initWithFrame:CGRectMake(15, l1.mbottom+15, DEVICE_Width-30, 20)];
    mcontent.numberOfLines = 0;
    mcontent.textColor = [UIColor colorWithRed:0.235 green:0.200 blue:0.224 alpha:1];
    mcontent.font = [UIFont systemFontOfSize:13];
    mcontent.text = self.Smsg.mContent;
   CGFloat CH = [self.Smsg.mContent sizeWithFont:mcontent.font constrainedToSize:CGSizeMake(mcontent.mwidth, CGFLOAT_MAX)].height;
    CGRect rrrr = mcontent.frame;
    rrrr.size.height = CH;
    mcontent.frame = rrrr;
    [sss addSubview:mcontent];
    
    UIView *l2 = [[UIView alloc]initWithFrame:CGRectMake(15, mcontent.mbottom+15, DEVICE_Width-15, 1)];
    l2.backgroundColor = [UIColor colorWithRed:0.882 green:0.878 blue:0.867 alpha:1];
    [sss addSubview:l2];
    
    sss.contentSize = CGSizeMake(DEVICE_Width, l2.mbottom+69);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
