//
//  timeSetHeader.h
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeSetHeader : UIView
/**
 *  周期
 */
@property (weak, nonatomic) IBOutlet UILabel *mWeek;
/**
 *  选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIView *bgkView;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (weak, nonatomic) IBOutlet UIView *line;

/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mImg;
/**
 *  日期按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mBtn;

+ (timeSetHeader *)shareView;
+ (timeSetHeader *)shareBottom;
+ (timeSetHeader *)shareContent;
@end
