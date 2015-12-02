//
//  leaveCell.h
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/24.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leaveCell : UITableViewCell
/**
 *  请假时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mLeaveTime;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mContent;
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIButton *mSelectBtn;

/**
 *  回复时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mTime;

@end
