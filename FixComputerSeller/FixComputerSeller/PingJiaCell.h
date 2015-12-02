//
//  PingJiaCell.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/7/17.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PingJiaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mGrade;
@property (weak, nonatomic) IBOutlet UILabel *mContent;
@property (weak, nonatomic) IBOutlet UILabel *mType;

@property (weak, nonatomic) IBOutlet UILabel *mTime;


@property (weak, nonatomic) IBOutlet UILabel *mReply;
@property (weak, nonatomic) IBOutlet UILabel *mReplyTime;
@property (weak, nonatomic) IBOutlet UIButton *mReplyBT;


@end
