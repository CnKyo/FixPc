//
//  mServiceContent.m
//  FixComputerSeller
//
//  Created by 密码为空！ on 15/9/11.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "mServiceContent.h"

@implementation mServiceContent

+ (mServiceContent *)shareTitle{
    mServiceContent *view = [[[NSBundle mainBundle]loadNibNamed:@"mServiceContent" owner:self options:nil]objectAtIndex:0];

    
    return view;
}
+ (mServiceContent *)shareName{
    mServiceContent *view = [[[NSBundle mainBundle]loadNibNamed:@"mServiceName" owner:self options:nil]objectAtIndex:0];
    
    
    return view;
}
@end
