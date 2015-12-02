//
//  mServiceContent.h
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/11.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mServiceContent : UIView

+ (mServiceContent *)shareTitle;

+ (mServiceContent *)shareName;

/**
 *  服务名称
 */
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
/**
 *  服务价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mPrice;

@end
