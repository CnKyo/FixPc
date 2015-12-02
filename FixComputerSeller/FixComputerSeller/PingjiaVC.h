//
//  PingjiaVC.h
//  ShuFuJiaSeller
//
//  Created by 周大钦 on 15/9/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface PingjiaVC : BaseVC
@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UIView *mBghao;
@property (weak, nonatomic) IBOutlet UIView *mBgzhong;
@property (weak, nonatomic) IBOutlet UIView *mBgCha;
@property (weak, nonatomic) IBOutlet UILabel *mHaolb;
@property (weak, nonatomic) IBOutlet UILabel *mZhonglb;
@property (weak, nonatomic) IBOutlet UILabel *mChalb;
@property (weak, nonatomic) IBOutlet UIButton *mAllBT;
@property (weak, nonatomic) IBOutlet UIButton *mHaoBT;
@property (weak, nonatomic) IBOutlet UIButton *mZhongBT;
@property (weak, nonatomic) IBOutlet UIButton *mChaBT;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mHeadView;

- (IBAction)ButtonClick:(id)sender;
@end
