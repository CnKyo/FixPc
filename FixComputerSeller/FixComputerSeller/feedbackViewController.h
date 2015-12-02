//
//  feedbackViewController.h
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/22.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"
#import "IQTextView.h"
@interface feedbackViewController : BaseVC

@property (assign,nonatomic)    SOrder *mOrder;

/**
 *  显示类型 0 为反馈 1为日志 其他为回复
 */
@property (assign,nonatomic)    int mType;

///背景view
@property (weak, nonatomic) IBOutlet UIView *bgkView;
///输入框
@property (weak, nonatomic) IBOutlet IQTextView *txView;
///提交按钮
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic,strong) SRate *mRate;

@end
