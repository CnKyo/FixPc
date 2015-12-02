//
//  DatingCell.m
//  com.yizan.vso2o.business
//
//  Created by zzl on 15/4/16.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "DatingCell.h"
#import "feedbackViewController.h"
@implementation DatingCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews{
    [super layoutSubviews];

    _mNoteBtn1.layer.masksToBounds = YES;
    _mNoteBtn1.layer.cornerRadius = 4;
    _mNoteBtn1.layer.borderColor = M_CO.CGColor;
    _mNoteBtn1.layer.borderWidth = 0.75;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
