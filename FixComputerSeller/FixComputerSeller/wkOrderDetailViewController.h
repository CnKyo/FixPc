//
//  wkOrderDetailViewController.h
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/7.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"

@interface wkOrderDetailViewController : BaseVC
@property (strong,nonatomic)    SOrder *wkorder;

@property (assign,nonatomic)    int         wkArgs;
/**
 *  0为订单列表 1为日程列表
 */
@property (assign,nonatomic)    int         mType;

@property (strong,nonatomic)    SGoods *mGoods;

@end
