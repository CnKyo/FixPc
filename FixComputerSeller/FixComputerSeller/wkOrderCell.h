//
//  wkOrderCell.h
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wkOrderCell : UITableViewCell
/**
 *  顶部view
 */
@property (weak, nonatomic) IBOutlet UIView *wkTopView;
/**
 *  订单名称
 */
@property (weak, nonatomic) IBOutlet UILabel *wkOrderName;
/**
 *  订单状态
 */
@property (weak, nonatomic) IBOutlet UILabel *wkOrderStatus;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UIButton *wkPhone;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *wkAddress;


@property (strong,nonatomic) SOrder *model;

@property (assign,nonatomic) CGFloat    cellHeight;
@end
