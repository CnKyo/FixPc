//
//  tongjiCell.h
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/24.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tongjiCell : UITableViewCell
/*
统计cell
*/
///头像
@property (weak, nonatomic) IBOutlet UIImageView *mHeaderImg;
///服务名称
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
///时间
@property (weak, nonatomic) IBOutlet UILabel *mTime;
///价格
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
/*
月份cell
 */
///月份
@property (weak, nonatomic) IBOutlet UILabel *mMonth;
///年份
@property (weak, nonatomic) IBOutlet UILabel *mYear;
///成交数
@property (weak, nonatomic) IBOutlet UILabel *mDealNum;
///累计总收入
@property (weak, nonatomic) IBOutlet UILabel *mTotlePrice;

@end
