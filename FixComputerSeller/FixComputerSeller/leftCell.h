//
//  leftCell.h
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/11.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "CellButton.h"
@interface leftCell : UITableViewCell

/**
 *  左边的cell
 */

/**
 *  左边cell的商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mLeftName;
/**
 *  左边cell的商品数量
 */
@property (weak, nonatomic) IBOutlet UIButton *mLeftNum;


/**
 *  右边的cell
 */
/**
 *  右边cell的商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mRightName;
/**
 *  进价
 */
//@property (weak, nonatomic) IBOutlet StrikeThroughLabel *mOldPrice;
/**
 *  现在的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mNowPrice;
/**
 *  减按钮
 */
@property (weak, nonatomic) IBOutlet CellButton *mDelBtn;
/**
 *  左边cell的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mRightNum;
/**
 *  加按钮
 */
@property (weak, nonatomic) IBOutlet CellButton *mAddBtn;

@end
