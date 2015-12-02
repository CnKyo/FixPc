//
//  wkOrderTableViewCell.h
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/10.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"

@interface wkOrderTableViewCell : UITableViewCell

@property (strong,nonatomic) SOrder *wkOrder;

/**
 *  顶部view
 */
@property (strong,nonatomic)UIView  *sHeaderView;
/**
 *  线1
 */
@property (strong,nonatomic)UIView *sLine1View;
/**
 *  下单时间
 */
@property (strong,nonatomic)UILabel *wkCreateTime;

/**
 *  服务状态
 */
@property (strong,nonatomic)UILabel *wkStatus;
/**
 *  服务名
 */
@property (strong,nonatomic)UILabel *wkName;

/**
 *  线2
 */
@property (strong,nonatomic)UIView *sLine2View;

/**
 *  客户人与客户电话
 */
@property (strong,nonatomic)UILabel  *wkPhone;
/**
 *  订单编号
 */
@property (strong,nonatomic)UILabel  *wkOrderNum;
/**
 *  服务地址
 */
@property (strong,nonatomic)UILabel *wkAddress;
/**
 *  金额
 */
@property (strong,nonatomic)UILabel  *wkPrice;

/**
 *  箭头
 */
@property (strong,nonatomic)UIImageView *sJiantou;
/**
 *  导航按钮
 */
@property (strong,nonatomic)UIButton    *wkNavBtn;
/**
 *  联系顾客按钮
 */
@property (strong,nonatomic)UIButton    *wkConnectBtn;
@end
