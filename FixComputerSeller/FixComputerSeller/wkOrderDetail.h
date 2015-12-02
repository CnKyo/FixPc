//
//  wkOrderDetail.h
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/7.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wkOrderDetail : UIView
/**
 *  跑腿-1
 */
+ (wkOrderDetail *)sharePaotuiView;
/**
*  顶部view
*/
@property (weak, nonatomic) IBOutlet UIView *wkView1;
/**
 *  中部view
 */
@property (weak, nonatomic) IBOutlet UIView *wkView2;
/**
 *  服务数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceNum;
/**
 *  服务时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceTime;
/**
 *  联系人
 */
@property (weak, nonatomic) IBOutlet UILabel *mConnectName;

/**
 *  联系电话
 */
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
/**
 *  服务地址
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceAdd;
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceCode;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceNote;
/**
 *  订单金额
 */
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
/**
 *  已支付
 */
@property (weak, nonatomic) IBOutlet UILabel *mYizhifu;

/**
 *  支付状态
 */
@property (weak, nonatomic) IBOutlet UILabel *mPayStatus;
/**
 *  开始服务按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mStartServiceBtn;

/**
 *  拨打
 */
@property (weak, nonatomic) IBOutlet UIButton *mConnection;
/**
 *  导航
 */
@property (weak, nonatomic) IBOutlet UIButton *mNav;
/**
 *  支付方式
 */
@property (weak, nonatomic) IBOutlet UILabel *mPayType;


#pragma mark----header
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *mHeader;
/**
 *  服务名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
/**
 *  服务单价
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceDanjia;
/**
 *  服务时长
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceShichang;

@property (weak, nonatomic) IBOutlet UIView *line;

+ (wkOrderDetail *)shareHeaderView;

/**
 *  通用view
 *
 *  @return view
 */
+ (wkOrderDetail *)shareOrderDetail;

/**
 *  取消原因
 */
@property (weak, nonatomic) IBOutlet UILabel *mCancelreason;

/**
 *  取消原因
 *
 *  @return view
 */
+ (wkOrderDetail *)shareCancelreason;
@end
