//
//  mOrderRefund.h
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/9.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mOrderRefund : UIView
/**
 *  顶部view
 */
@property (weak, nonatomic) IBOutlet UIView *wkView1;
/**
 *  中部view
 */
@property (weak, nonatomic) IBOutlet UIView *wkView2;
/**
 *  服务时间
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mServiceTime;
/**
 *  联系人
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mConnectName;

/**
 *  联系电话
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mPhone;
/**
 *  服务地址
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mServiceAdd;
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mServiceCode;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mServiceNote;

/**
 *  支付状态
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mPayStatus;
/**
 *  取消元素
 */
@property (weak, nonatomic) IBOutlet DetailTextView *mReason;


/**
 *  拨打
 */
@property (weak, nonatomic) IBOutlet UIButton *mConnection;
/**
 *  导航
 */
@property (weak, nonatomic) IBOutlet UIButton *mNav;




@property (weak, nonatomic) IBOutlet UILabel *quxiao;

@property (weak, nonatomic) IBOutlet UIView *lastLine;



+ (mOrderRefund *)shareView;
@end
