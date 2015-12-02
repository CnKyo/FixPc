//
//  mMyDeatailView.h
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/7/13.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQTextView.h"

@interface mMyDeatailView : UIView
///背景view
@property (weak, nonatomic) IBOutlet UIView *mBgkView;
///头像
@property (weak, nonatomic) IBOutlet UIImageView *mHeaderImg;
///姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *mPwdTx;
@property (weak, nonatomic) IBOutlet UILabel *mAgeLB;
@property (weak, nonatomic) IBOutlet UIImageView *mSexImg;
@property (weak, nonatomic) IBOutlet UILabel *mSexLB;
@property (weak, nonatomic) IBOutlet IQTextView *mRemarkTextV;

///编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *mEditBtn;
///保存按钮
@property (weak, nonatomic) IBOutlet UIButton *mSaveBtn;


+ (mMyDeatailView *)shareView;
@end
