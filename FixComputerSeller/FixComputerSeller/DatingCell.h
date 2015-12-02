//
//  DatingCell.h
//  com.yizan.vso2o.business
//
//  Created by zzl on 15/4/16.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cusTomeBtn.h"
@interface DatingCell : UITableViewCell
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mtime;
@property (weak, nonatomic) IBOutlet UILabel *msrvname;
@property (weak, nonatomic) IBOutlet UILabel *muserphone;
@property (weak, nonatomic) IBOutlet UILabel *madress;
@property (weak, nonatomic) IBOutlet UILabel *mtextS;

@property (weak, nonatomic) IBOutlet UIImageView *mcheckimg;


/**
 *  姓名1
 */
@property (weak, nonatomic) IBOutlet UILabel *mName1;

/**
 *  写日志1
 */
@property (weak, nonatomic) IBOutlet cusTomeBtn *mNoteBtn1;

/**
 *  地址1
 */
@property (weak, nonatomic) IBOutlet UILabel *mAddress1;

/**
 *  备注1
 */
@property (weak, nonatomic) IBOutlet UILabel *mNote1;

@property (strong,nonatomic) SScheduleItem  *model;

@end
