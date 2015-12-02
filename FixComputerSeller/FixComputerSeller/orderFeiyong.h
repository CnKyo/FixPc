//
//  orderFeiyong.h
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/11.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderFeiyong : UIView
/**
 *  购物车
 */
@property (weak, nonatomic) IBOutlet UIButton *mShopingCar;
/**
 *  购物车数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mNum;

/**
 *  总价
 */
@property (weak, nonatomic) IBOutlet UILabel *mTotlePrice;

/**
 *  总数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mTotleNum;

/**
 *  下单
 */
@property (weak, nonatomic) IBOutlet UIButton *mDoneBtn;

/**
 *  搜索北京
 */
@property (weak, nonatomic) IBOutlet UIView *mSearchView;
/**
 *  搜索输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *mSearchTx;
/**
 *  搜索按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mSearchBtn;

+ (orderFeiyong *)shareBottom;
+ (orderFeiyong *)shareSearch;
+ (orderFeiyong *)shareJiesuan;
@end
