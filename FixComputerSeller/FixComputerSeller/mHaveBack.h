//
//  mHaveBack.h
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/9.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mHaveBack : UIView
/**
 *  没有回复内容
 *
 *  @return view
 */
+ (mHaveBack *)shareHaveBack;

/**
 *  评价等级
 */
@property (weak, nonatomic) IBOutlet UIView *mPjL;

/**
 *  回复按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mBackBtn;
/**
 *  回复内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mBackContent;

@property (weak, nonatomic) IBOutlet UILabel *mMyhuifu;

@property (weak, nonatomic) IBOutlet UILabel *mHoutaihuifu;


/**
 *  工作日志
 */

+ (mHaveBack *)shareNoteView;
/**
 *  添加日志按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mAddNoteBtn;

@property (weak, nonatomic) IBOutlet UIView *mBgkLine;

@property (weak, nonatomic) IBOutlet UIView *mAddView;

/**
 *  填写工作日志
 */
+ (mHaveBack *)shareAddNoteView;
/**
 *  日志内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mNoteContent;
/**
 *  日志时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mNoteTime;



/**
 *  地步按钮
 */
+ (mHaveBack *)shareBottomView;
/**
 *  地步view
 */
@property (weak, nonatomic) IBOutlet UIView *mBottomView;

/**
 *  地部按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mBtn;



@end
