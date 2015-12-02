//
//  tongjiViewController.h
//  O2O_PaoTuiSeller
//
//  Created by 密码为空！ on 15/9/1.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"

@interface tongjiViewController : BaseVC
//获取统计数据,month = -1 表示 按照月份来统计,0 表示最近统计数据,
@property (nonatomic,assign) int month;

@property (nonatomic,assign) int myeaer;

@property (nonatomic,assign) BOOL mbedit;

@property (nonatomic,assign) BOOL   mSref;
///订单id
@property (nonatomic,assign) int orderId;//0

@property (weak, nonatomic) IBOutlet UITableView *myTbale;
@end
