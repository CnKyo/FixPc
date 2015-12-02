//
//  mHaveBack.m
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/9.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "mHaveBack.h"

@implementation mHaveBack

+ (mHaveBack *)shareHaveBack{
    mHaveBack *view = [[[NSBundle mainBundle]loadNibNamed:@"mHaveBackView" owner:self options:nil]objectAtIndex:0];
    
    view.mBackBtn.layer.masksToBounds = YES;
    view.mBackBtn.layer.cornerRadius = 4;
    view.mBackBtn.layer.borderColor = M_CO.CGColor;
    view.mBackBtn.layer.borderWidth = 0.75;
    
    return view;
}

+ (mHaveBack *)shareNoteView{
    
    mHaveBack *view = [[[NSBundle mainBundle]loadNibNamed:@"mNoteView" owner:self options:nil]objectAtIndex:0];
    
    view.mBgkLine.layer.masksToBounds = YES;
    view.mBgkLine.layer.borderColor = [UIColor colorWithRed:0.871 green:0.855 blue:0.851 alpha:1].CGColor;
    view.mBgkLine.layer.borderWidth = 0.75f;
    
    
    view.mAddNoteBtn.layer.masksToBounds = YES;
    view.mAddNoteBtn.layer.cornerRadius = 4;
    view.mAddNoteBtn.layer.borderColor = M_CO.CGColor;
    view.mAddNoteBtn.layer.borderWidth = 0.75;
    
    return view;
}

+ (mHaveBack *)shareAddNoteView{
    mHaveBack *view = [[[NSBundle mainBundle]loadNibNamed:@"mHaveNoteView" owner:self options:nil]objectAtIndex:0];
    
    
    return view;
}

+ (mHaveBack *)shareBottomView{
    mHaveBack *view = [[[NSBundle mainBundle]loadNibNamed:@"mBottomView" owner:self options:nil]objectAtIndex:0];
    
    
    return view;
}
@end
