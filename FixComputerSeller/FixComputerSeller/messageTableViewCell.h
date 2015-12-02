//
//  messageTableViewCell.h
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/23.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageTableViewCell : UITableViewCell
///消息类型
@property (weak, nonatomic) IBOutlet UIImageView *mMsgType;

///消息标题
@property (weak, nonatomic) IBOutlet UILabel *msgTitleLb;
///消息内容
@property (weak, nonatomic) IBOutlet UILabel *msgContentLb;
///时间
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

///是否选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
///已读消息的点
@property (weak, nonatomic) IBOutlet UIImageView *mPoint;

@end
