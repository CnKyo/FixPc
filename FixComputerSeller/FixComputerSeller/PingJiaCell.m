//
//  PingJiaCell.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/7/17.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "PingJiaCell.h"

@implementation PingJiaCell

- (void)awakeFromNib {
    // Initialization code
    _mReplyBT.layer.masksToBounds = YES;
    _mReplyBT.layer.cornerRadius = 3;
    _mReplyBT.layer.borderColor = COLOR(123, 176, 70).CGColor;
    _mReplyBT.layer.borderWidth = 0.7;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
