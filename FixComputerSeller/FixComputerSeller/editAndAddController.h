//
//  editAndAddController.h
//  ShuFuJiaSeller
//
//  Created by 密码为空！ on 15/9/2.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"

@interface editAndAddController : BaseVC
/**
 *  判断是设置还是编辑  0是编辑 1是添加
 */
@property (assign,nonatomic) int    mType;

@property (nonatomic,strong)    STimeSet*   mallTimeinfo;//STimeSet

@property (nonatomic,strong)    NSArray*    mUnSelectWeek;

@end
