//
//  noterCell.h
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noterCell : UITableViewCell

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mContent;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mTime;

@end
