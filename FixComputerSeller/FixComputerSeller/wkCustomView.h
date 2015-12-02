//
//  wkCustomView.h
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/7.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wkCustomView : UIView

/**
 *  自定义增长的view
 */
+ (wkCustomView *)shareAddView;
/**
*  名称
*/
@property (weak, nonatomic) IBOutlet UILabel *wkOrderName;
/**
 *  数量
 */
@property (weak, nonatomic) IBOutlet UILabel *wkOrderNum;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *wkOrderPrice;




/**
 *  自定义增长view下面衔接的view
 */
+ (wkCustomView *)shareCustomBottomView;
/**
 *  配送费
 */
@property (weak, nonatomic) IBOutlet UILabel *wkOrderPeisong;
/**
 *  总数量
 */
@property (weak, nonatomic) IBOutlet UILabel *wkTotleNum;
/**
 *  总价
 */
@property (weak, nonatomic) IBOutlet UILabel *wkTotlePrice;

@end
