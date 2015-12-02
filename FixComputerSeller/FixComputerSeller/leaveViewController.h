//
//  leaveViewController.h
//  O2O_XiCheSeller
//
//  Created by 王钶 on 15/6/23.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "BaseVC.h"
#import "leavVC.h"
@interface leaveViewController : BaseVC
/**
 *  scrollerview
 */
@property (strong, nonatomic) IBOutlet UIScrollView *sss;
/**
 *  请假view
 */
@property (strong, nonatomic)  leavVC *lll;

@end
