//
//  leavVC.h
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/23.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQTextView.h"
@interface leavVC : UIView
/**
 *  背景
 */
@property (strong, nonatomic) IBOutlet UIView *mBgkView;
/**
 *  确定按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *mOkBtn;
/**
 *  输入框
 */
@property (strong, nonatomic) IBOutlet IQTextView *mTxView;
/**
 *  开始时间安妞
 */
@property (strong, nonatomic) IBOutlet UIButton *mStartBtn;
/**
 *  结束时间按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *mEndBtn;
/**
 *  背景1
 */
@property (strong, nonatomic) IBOutlet UIView *bgkView1;
/**
 *  背景2
 */
@property (strong, nonatomic) IBOutlet UIView *bgkView2;

+ (leavVC *)shareView;

@end
