//
//  feedbackViewController.m
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/22.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()

@end

@implementation feedbackViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self.isStoryBoard = YES;
    return [super initWithCoder:aDecoder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
//    self.hiddenTabBar = YES;

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    if (_mType == 2) {
        self.Title = self.mPageName = @"评价回复";

    }
    else if (_mType == 1) {
        self.Title = self.mPageName = @"填写日志";

    }
    else{
        self.Title = self.mPageName = @"投诉与建议";

    }
    self.hiddenlll = YES;
    self.bgkView.layer.masksToBounds = YES;
    self.bgkView.layer.borderColor = [UIColor colorWithRed:0.855 green:0.851 blue:0.843 alpha:1].CGColor;
    self.bgkView.layer.borderWidth = 0.75f;
    self.txView.placeholder = @"请输入您的内容";
    self.okBtn.layer.masksToBounds = YES;
    self.okBtn.layer.cornerRadius = 4;
    [self.txView setHolderToTop];
    [self.okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)okAction:(UIButton *)sender{
    ///提交按钮
    if (self.txView.text == nil || [self.txView.text isEqualToString:@""]) {
        [self showAlertVC:@"提示" alertMsg:@"您未输入任何信息!"];
        return;
    }
    if (self.txView.text.length >= 2000) {
        [self showAlertVC:@"提示" alertMsg:@"内容长度不能超过2000个字符"];
        return;
    }
    
    [self showWithStatus:@"正在提交..."];

    if (_mType == 2) {
        [_mOrder rateAndreply:self.txView.text block:^(SResBase *resb) {
            if (resb.msuccess) {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                [self dismiss];
                [self popViewController];
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }
        }];
      
    }
    else if (_mType == 1) {
        [_mOrder postNote:self.txView.text block:^(SResBase *resb) {
            
            if (resb.msuccess) {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                [self dismiss];
                [self popViewController];
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }
            
        }];
        
    }
    else{
        
        [SAppInfo feedback:self.txView.text block:^(SResBase *resb) {

            if (resb.msuccess) {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                [self dismiss];
                [self popViewController];
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }
            
        }];
        
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)leftBtnTouched:(id)sender{
    [self popViewController];
}
- (void)showAlertVC:(NSString *)title alertMsg:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}


@end
