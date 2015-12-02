//
//  wkOrderTableViewCell.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/10.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "wkOrderTableViewCell.h"
#import <MapKit/MapKit.h>

@implementation wkOrderTableViewCell
{
    
    
    
}
@synthesize wkAddress,wkName,wkNavBtn,wkPhone,wkStatus,sLine1View,sLine2View,sHeaderView,wkConnectBtn,wkCreateTime,wkPrice,sJiantou,wkOrder,wkOrderNum;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        
    }
    return self;
}
- (void)initView{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    sHeaderView = [UIView new];
    sHeaderView.layer.masksToBounds = YES;
    sHeaderView.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    sHeaderView.layer.borderColor = [UIColor colorWithRed:0.847 green:0.843 blue:0.835 alpha:1].CGColor;
    sHeaderView.layer.borderWidth = 0.5;
    [self.contentView addSubview:sHeaderView];
    
    wkCreateTime = [UILabel new];
    wkCreateTime.textColor = [UIColor colorWithRed:0.235 green:0.243 blue:0.239 alpha:1];
    wkCreateTime.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:wkCreateTime];
    
    wkStatus = [UILabel new];
    wkStatus.textAlignment = NSTextAlignmentRight;
    wkStatus.font = [UIFont systemFontOfSize:15];
    wkStatus.minimumScaleFactor = 13;
    wkStatus.textColor = [UIColor colorWithRed:0.494 green:0.773 blue:0.973 alpha:1];
    [self.contentView addSubview:wkStatus];
    
    sLine1View = [UIView new];
    sLine1View.backgroundColor = [UIColor colorWithRed:0.851 green:0.843 blue:0.847 alpha:1];
    [self.contentView addSubview:sLine1View];
    
    wkName = [UILabel new];
    wkName.textAlignment = NSTextAlignmentLeft;
    wkName.font = [UIFont systemFontOfSize:15];
    wkName.textColor = [UIColor colorWithRed:0.235 green:0.243 blue:0.239 alpha:1];
    [self.contentView addSubview:wkName];
    
    wkPhone = [UILabel new];
    wkPhone.font = [UIFont systemFontOfSize:15];
    wkPhone.textColor = [UIColor colorWithRed:0.235 green:0.243 blue:0.239 alpha:1];
    [self.contentView addSubview:wkPhone];
    
    wkOrderNum = [UILabel new];
    wkOrderNum.font = [UIFont systemFontOfSize:15];
    wkOrderNum.textColor = [UIColor colorWithRed:0.235 green:0.243 blue:0.239 alpha:1];
    [self.contentView addSubview:wkOrderNum];
    
    sJiantou = [UIImageView new];
    sJiantou.image = [UIImage imageNamed:@"jiantou1"];
    [self.contentView addSubview:sJiantou];
    
    UILabel *addressL = [UILabel new];
    
    [addressL sizeToFit];
    addressL.font = [UIFont systemFontOfSize:15];
    addressL.textColor = [UIColor colorWithRed:0.235 green:0.243 blue:0.239 alpha:1];
    [self.contentView addSubview:addressL];
    
    wkAddress = [UILabel new];
    [wkAddress sizeToFit];
    wkAddress.numberOfLines = 0;
    wkAddress.font = [UIFont systemFontOfSize:15];
    wkAddress.textColor = [UIColor colorWithRed:0.235 green:0.243 blue:0.239 alpha:1];
    [self.contentView addSubview:wkAddress];
    
    wkPrice = [UILabel new];
    wkPrice.font = [UIFont systemFontOfSize:15];
    wkPrice.textColor = [UIColor colorWithRed:0.235 green:0.243 blue:0.239 alpha:1];
    [self.contentView addSubview:wkPrice];
    
    sLine2View = [UIView new];
    sLine2View.backgroundColor = [UIColor colorWithRed:0.851 green:0.843 blue:0.847 alpha:1];
    
    [self.contentView addSubview:sLine2View];
    
    wkNavBtn = [UIButton new];
    [wkNavBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
    wkNavBtn.layer.masksToBounds = YES;
    wkNavBtn.layer.borderColor = [UIColor colorWithRed:0.565 green:0.549 blue:0.561 alpha:1].CGColor;
    wkNavBtn.layer.borderWidth = 0.75;
    wkNavBtn.layer.cornerRadius = 4;
    [wkNavBtn setTitle:@"路径导航" forState:0];
    [wkNavBtn setTitleColor:[UIColor colorWithRed:0.565 green:0.549 blue:0.561 alpha:1] forState:0];
    [self.contentView addSubview:wkNavBtn];
    
    wkConnectBtn = [UIButton new];
    [wkConnectBtn addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    wkConnectBtn.layer.masksToBounds = YES;
    wkConnectBtn.layer.borderColor = M_CO.CGColor;
    wkConnectBtn.layer.borderWidth = 0.75;
    wkConnectBtn.layer.cornerRadius = 4;
    [wkConnectBtn setTitle:@"联系顾客" forState:0];
    [wkConnectBtn setTitleColor:M_CO forState:0];
    [self.contentView addSubview:wkConnectBtn];
    
    
    [sHeaderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.top.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(wkCreateTime.top).with.offset(-18);
        make.height.offset(15);
        
    }];
    
    [wkCreateTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(wkStatus.left).with.offset(-10);
        make.top.equalTo(sHeaderView.bottom).with.offset(15);
        make.height.offset(20);
    }];
    
    [wkStatus makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wkCreateTime.right).with.offset(10);
        make.right.equalTo(self.contentView.right).with.offset(-2);
        make.top.equalTo(sHeaderView.bottom).with.offset(15);
        make.bottom.equalTo(sLine1View.top).with.offset(-15);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    [sLine1View makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(2);
        make.right.equalTo(self.contentView.right).with.offset(0);
        make.top.equalTo(wkStatus.bottom).with.offset(0);
        make.bottom.equalTo(wkName.top).with.offset(-15);
        make.height.offset(0.5);
    }];
    
    
    [wkName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView.right).with.offset(-15);
        make.top.equalTo(sLine1View.bottom).with.offset(20);
        make.bottom.equalTo(wkPhone.top).with.offset(-15);
        make.height.offset(25);
    }];
    
    
    [wkPhone makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView.right).with.offset(-15);
        make.top.equalTo(wkName.bottom).with.offset(18);
        make.bottom.equalTo(wkOrderNum.top).with.offset(-15);
        make.height.offset(20);
    }];
    
    
    [wkOrderNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(sJiantou.left).with.offset(-10);
        make.top.equalTo(wkPhone.bottom).with.offset(18);
        make.bottom.equalTo(wkAddress.top).with.offset(-15);
        make.height.offset(20);
    }];
    
    
    [addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(wkAddress.left).with.offset(-2);
        make.top.equalTo(wkOrderNum.bottom).with.offset(15);
        //        make.bottom.equalTo(wkPrice.top).with.offset(-15);
        make.width.offset(80);
        make.height.offset(20);
    }];
    
    [wkAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressL.right).with.offset(2);
        make.right.equalTo(self.contentView.right).with.offset(-15);
        make.top.equalTo(addressL);
        make.bottom.equalTo(wkPrice.top).with.offset(-15);
    }];
    
    [wkPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(wkAddress.bottom).with.offset(15);
        make.bottom.equalTo(sLine2View.top).with.offset(-15);
        make.height.offset(20);
        
    }];
    
    [sLine2View makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView.right).with.offset(0);
        make.top.equalTo(wkPrice.bottom).with.offset(17);
        make.height.offset(0.5);
    }];
    
    [sJiantou makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sLine1View.bottom).with.offset(85);
        make.left.equalTo(wkOrderNum.right).with.offset(25);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.height.offset(13);
        make.width.offset(7);
    }];
    
    [wkConnectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).with.offset(-10);
        make.top.equalTo(sLine2View.bottom).with.offset(15);
        make.width.offset(95);
        make.height.offset(40);
    }];
    
    [wkNavBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wkConnectBtn.left).with.offset(-10);
        make.top.equalTo(sLine2View.bottom).with.offset(15);
        make.width.offset(95);
        make.height.offset(40);
    }];
    
    [addressL hyb_setAttributedText:[NSString stringWithFormat:@"<style color=#878787>服务地址：</style>"]];
    
    [self hdf_setCellLastView:wkConnectBtn bottomOffset:10];
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [wkStatus setText:wkOrder.mOrderStateStr];
    
    [wkCreateTime hyb_setAttributedText:[NSString stringWithFormat:@"<style color=#878787>订单编号：</style><style color=#878787>%@</style>",wkOrder.mSn]];
    
    [wkName hyb_setAttributedText:[NSString stringWithFormat:@"<style color=#878787>服务时间：</style><style color=#262626>%@</style>",wkOrder.mApptime]];
    
    
    [wkPhone hyb_setAttributedText:[NSString stringWithFormat:@"<style color=#878787>顾客名称：</style><style color=#262626>%@</style>",wkOrder.mUserName]];
    
    [wkOrderNum hyb_setAttributedText:[NSString stringWithFormat:@"<style color=#878787>联系电话：</style><style color=#262626>%@</style>",wkOrder.mPhoneNum]];
    
    
    [wkAddress hyb_setAttributedText:[NSString stringWithFormat:@"<style color=#262626>%@</style>",wkOrder.mAddress]];
    
    [wkPrice hyb_setAttributedText:[NSString stringWithFormat:@"<style color=#878787>订单金额：</style><style color=#FA3B42>¥%.2f元</style>",wkOrder.mPayMoney]];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark----打电话
- (void)connectAction:(UIButton *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",wkOrder.mPhoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
#pragma mark----导航按钮
- (void)navAction:(UIButton *)sender{
    //跳转到高德地图
    NSString* ampurl = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=testapp&backScheme=zyseller&lat=%.7f&lon=%.7f&dev=0&style=0",wkOrder.mLat,wkOrder.mLongit];
    
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ampurl]] )
    {//
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ampurl]];
    }
    else
    {//ioS map
        
        CLLocationCoordinate2D to;
        to.latitude =  wkOrder.mLat;
        to.longitude =  wkOrder.mLongit;
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
        toLocation.name = wkOrder.mAddress;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
    
}

@end
