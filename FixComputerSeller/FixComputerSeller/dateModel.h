//
//  dateModel.h
//  YiZanService
//
//  Created by zzl on 15/3/19.
//  Copyright (c) 2015年 zywl. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SPromotion;
@class SAddress;
@class SCar;
@interface dateModel : NSObject

@end

@interface SAutoEx : NSObject

-(id)initWithObj:(NSDictionary*)obj;

-(void)fetchIt:(NSDictionary*)obj;

@end

//返回通用数据,,,
@interface SResBase : NSObject

@property (nonatomic,assign) BOOL       msuccess;//是否成功了
@property (nonatomic,assign) int        mcode;  //错误码
@property (nonatomic,strong) NSString*  mmsg;   //客户端需要显示的提示信息,正确,失败,根据msuccess判断显示错误还是提示,
@property (nonatomic,strong) NSString*  mdebug;
@property (nonatomic,strong) id         mdata;

-(id)initWithObj:(NSDictionary*)obj;

-(void)fetchIt:(NSDictionary*)obj;

+(SResBase*)infoWithError:(NSString*)error;

@end

@interface SUserState : NSObject

@property (nonatomic,assign)    BOOL    mbHaveNewMsg;

@end

@class SMobile;
@class STimeSet;
@class SRate;
@interface SUser : NSObject

@property (nonatomic,assign) int         mUserId;
@property (nonatomic,assign) int         mAge;
@property (nonatomic,strong) NSString*   mSex;
@property (nonatomic,strong) NSString*   mPhone;
@property (nonatomic,strong) NSString*   mUserName;
@property (nonatomic,strong) NSString*   mHeadImgURL;
@property (nonatomic,strong) NSString*   mToken;
@property (nonatomic,assign) int         mStaffId;
@property (nonatomic,strong) NSString*   mBrief;
@property (nonatomic,assign) float       mTotalMoney; //总余额
@property (nonatomic,assign) float       mWithdrawMoney; //可提现金额
@property (nonatomic,assign) float       mFrozenMoney; //冻结金额

///1为自营门店 2为服务机构
@property (nonatomic,assign) int         mType;

//返回当前用户
+(SUser*)currentUser;

//判断是否需要登录
+(BOOL)isNeedLogin;

//退出登陆
+(void)logout;

//发送短信
+(void)sendSM:(NSString*)phone block:(void(^)(SResBase* resb))block;

//登录,密码或者验证码登录
+(void)loginWithPhone:(NSString*)phone psw:(NSString*)psw vcode:(NSString*)vcode block:(void(^)(SResBase* resb, SUser*user))block;

//密码登录,
+(void)loginWithPhone:(NSString*)phone psw:(NSString*)psw block:(void(^)(SResBase* resb, SUser*user))block;

//注册
+(void)regWithPhone:(NSString*)phone psw:(NSString*)psw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block;

//重置密码
+(void)reSetPswWithPhone:(NSString*)phone newpsw:(NSString*)newpsw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block;

//修改用户信息,修改成功会更新对应属性 HeadImg 360x360
-(void)updateUserInfo:(NSString*)name HeadImg:(UIImage*)Head Brief:(NSString *)brief block:(void(^)(SResBase* resb))block;

//获取消息列表 all => SMessageInfo
-(void)getMyMsg:(int)page block:(void(^)( SResBase* resb , NSArray* all ))block;

//是否有新消息
-(void)getMsgStatus:(void(^)( SResBase* resb ,BOOL bhavenew ))block;

//staff.detail
-(void)getDetail:(int)staffId block:(void(^)( SResBase* resb , SRate *rate))block;

//获取评价列表 all => SRate
-(void)getMyRate:(int)page type:(int)type block:(void(^)( SResBase* resb , NSArray* all ))block;

//获取余额
-(void)getBalance:(void(^)( SResBase* resb , NSDictionary *dic))block;

//获取我的订单,,
// statu "订单状态0：待处理1：已完成订单" all ==> SOderInfo
-(void)getMyOrders:(int)status page:(int)page block:(void(^)(SResBase* resb,NSArray* all))block;

/**
 *  修改用户信息,修改成功会更新对应属性
 *
 *  @param pwdStr 修改的密码
 *  @param mImage 修改的头像
 *  @param block  返回的数据
 */
-(void)editUserInfo:(NSString*)name pwd:(NSString *)pwdStr mHeaderImg:(UIImage*)mImage block:(void(^)(SResBase* resb,BOOL bok ,float process))block;

+(void)relTokenWithPush;

+(void)clearTokenWithPush;

+(NSArray*)loadHistoryWaiter;

+(NSArray*)loadHistory;

+(void)clearHistoryWaiter;

+(void)clearHistory;

//获取服务时间设置,
-(void)getTimeSet:(void(^)( SResBase* resb , NSArray* all ))block;

//设置时间,
-(void)addTimeSet:(int)maybeid weeks:(NSArray*)weeks hours:(NSArray*)hours block:(void(^)(SResBase* resb ,STimeSet* retobj))block;


//请假
-(void)leaveReq:(int)starttime endtime:(int)endtime text:(NSString*)text block:(void(^)(SResBase* resb))block;

//获取请假列表
-(void)leaveList:(int)page block:(void(^)(NSArray* arr, SResBase*  resb))block;

@end

@class SPayment;
@interface GInfo : NSObject

@property (nonatomic,strong)    NSString*   mGToken;    //全局token
@property (nonatomic,assign)    int         mivint;      //962694
@property (nonatomic,strong)    NSArray*    mSupCitys;  //开通城市 ==> SCity
@property (nonatomic,strong)    NSArray*    mPayments;  //支付信息 ==> SPayment;


@property (nonatomic,strong)    NSString*   mAppVersion;
@property (nonatomic,assign)    BOOL        mForceUpgrade;
@property (nonatomic,strong)    NSString*   mAppDownUrl;
@property (nonatomic,strong)    NSString*   mUpgradeInfo;
@property (nonatomic,strong)    NSString*   mServiceTel;

@property (nonatomic,strong)    NSString*   mOssid;
@property (nonatomic,strong)    NSString*   mOssKey;
@property (nonatomic,strong)    NSString*   mOssBucket;
@property (nonatomic,strong)    NSString*   mOssHost;

@property (nonatomic,strong)    NSString*   mAboutUrl;          //关于我们Url
@property (nonatomic,strong)    NSString*   mProtocolUrl;       //用户协议Url
@property (nonatomic,strong)    NSString*   mRestaurantTips;    //餐厅订餐说明
@property (nonatomic,strong)    NSString*   mShareQrCodeImage;  //分享二维码图片地址



+(GInfo*)shareClient;

+(void)getGInfoForce:(void(^)(SResBase* resb, GInfo* gInfo))block;

+(void)getGInfo:(void(^)(SResBase* resb, GInfo* gInfo))block;

-(SPayment*)geAiPayInfo;

-(SPayment*)geWxPayInfo;


@end


@interface SCity : NSObject

-(id)initWithObj:(NSDictionary*)obj;

@property (nonatomic,assign)    int         mId;
@property (nonatomic,strong)    NSString*   mName;      //名字
@property (nonatomic,strong)    NSString*   mFirstChar;//拼音首指母
@property (nonatomic,assign)    BOOL        mIsDefault;//是否是默认

@property (nonatomic,strong)    NSArray*    mSubs;// ==> SCity

@end


@interface SWxPayInfo : NSObject

@property (nonatomic,strong) NSString*  mpartnerId;//	string	是			商户号
@property (nonatomic,strong) NSString*  mprepayId;//	string	是			预支付交易会话标识
@property (nonatomic,strong) NSString*  mpackage;//	string	是			扩展字段
@property (nonatomic,strong) NSString*  mnonceStr;//	string	是			随机字符串
@property (nonatomic,assign) int        mtimeStamp;//	int	是			时间戳
@property (nonatomic,strong) NSString*  msign;//	string	是			签名
-(id)initWithObj:(NSDictionary*)obj;

@end


@interface SPayment : NSObject

-(id)initWithObj:(NSDictionary*)obj;


@property (nonatomic,strong)    NSString*   mCode;
@property (nonatomic,strong)    NSString*   mName;
@property (nonatomic,strong)    NSString*   mIconName;;

//ali
@property (nonatomic,strong)    NSString*   mPartnerId;
@property (nonatomic,strong)    NSString*   mSellerId;
@property (nonatomic,strong)    NSString*   mPartnerPrivKey;
@property (nonatomic,strong)    NSString*   mAlipayPubKey;

//weixn
@property (nonatomic,strong)    NSString*   mAppId;
@property (nonatomic,strong)    NSString*   mAppSecret;
@property (nonatomic,strong)    NSString*   mWxPartnerId;
@property (nonatomic,strong)    NSString*   mWxPartnerkey;


@end

//存储一些APP的全局数据
@interface SAppInfo : NSObject

@property (nonatomic,strong)    NSString*   mSelCity;//用户选择的城市
@property (nonatomic,assign)    int         mCityId;//用户选择的城市id
@property (nonatomic,strong)    NSString*   mAddr;//当前APP的地址
@property (nonatomic,assign)    float       mlng;//当前APP的坐标
@property (nonatomic,assign)    float       mlat;

//支付需要跳出到APP,这里记录回调
@property (nonatomic,strong)    void(^mPayBlock)(SResBase* resb);


//修改了属性就调用下这个,
-(void)updateAppInfo;

//定位,,会修改 mAddr mlat mlng
//bforce 是否强制定位,否则是缓存了的
-(void)getUserLocation:(BOOL)bforce block:(void(^)(NSString*err))block;


+(void)getPointAddress:(float)lng lat:(float)lat block:(void(^)(NSString* address,NSString*err))block;

+(SAppInfo*)shareClient;
///
+(void)feedback:(NSString*)content block:(void(^)(SResBase* resb))block;

@end



@interface SGoods : NSObject

-(id)initWithObj:(NSDictionary*)obj;

@property (nonatomic,assign) int        mId;
@property (nonatomic,assign) int        mSellerId;
@property (nonatomic,strong) NSString*  mName;
@property (nonatomic,strong) NSString*  mImgURL;
@property (nonatomic,strong) NSArray*   mImgs;//所有图标,==>NSString
@property (nonatomic,strong) NSArray*   mImgsBig;//所有图标,==>NSString
@property (nonatomic,assign) float      mPrice;//价格
@property (nonatomic,assign) float      mMrketPrice;//市场价
@property (nonatomic,strong) NSString*  mDesc;
@property (nonatomic,assign) int        mDuration;//服务需要的时间,秒
@property (nonatomic,strong) NSString*  mGoodDesURL;//商品详情URL


@property (nonatomic,assign) int        mPriceType;//服务类型,1:按次收费,2:按小时收费

@end



typedef enum _orderStateNew
{
    ///无
    E_OS_Non                = 000,
    ///等待付款
    E_OS_WaitPayIt          = 100,
    ///付款成功
    E_OS_PaySucsess         = 101,
    ///服务机构确认
    E_OS_JigouComfirm       = 102,
    ///服务人员确认
    E_OS_RenyuanComfirm     = 103,
    ///服务人员出发
    E_OS_Renyuango          = 104,
    ///服务人员上门取件(洗衣类型)
    E_OS_Pickup             = 105,
    ///开始服务
    E_OS_StartService       = 106,
    ///平台清洗
    E_OS_CleanFinish        = 107,
    ///上门返件
    E_OS_ReturnFinish       = 108,
    ///服务完成
    E_OS_ServiceFinish      = 109,
    ///会员确认完成
    E_OS_VipComfirmFinish   = 200,
    ///系统自动确认完成
    E_OS_SystemComfirmfinish= 201,
    ///会员取消订单
    E_OS_VipCancelOrder     = 300,
    ///支付超时取消订单
    E_OS_PayTimeOut         = 301,
    ///服务机构拒绝
    E_OS_JigouRefuse        = 302,
    ///服务人员拒绝
    E_OS_RenyuanRefuse      = 303,
    ///退款审核中
    E_OS_AuditRefund        = 400,
    ///退款未通过
    E_OS_RefundNotThrought  = 401,
    ///退款处理中
    E_OS_Refunding          = 402,
    ///退款失败
    E_OS_Refundfailure      = 403,
    ///退款成功
    E_OS_RefundSecsess      = 404,
    ///会员删除订单
    E_OS_VipDelOrder        = 500,
    ///服务机构删除订单
    E_OS_JigouDelOrder      = 501,
    
}OrderStateNew;

@class OrderDetailRate;
@interface SOrder : NSObject

-(id)initWithObj:(NSDictionary*)obj;

@property (nonatomic,strong)    NSString*       mSn;//订单号
@property (nonatomic,assign)    int             mId;//编号

@property (nonatomic,strong)    NSString*       mApptime;//当初预约的时间
@property (nonatomic,strong)    NSString*       mPromStr;//优惠描述
@property (nonatomic,assign)    float           mPromMoney;//优惠了多少钱
@property (nonatomic,strong)    NSString*       mUserName;//下单的人
@property (nonatomic,strong)    NSString*       mPhoneNum;//下单的电话
@property (nonatomic,strong)    NSString*       mAddress;//地址
@property (nonatomic,assign)    float           mTotalMoney;//总价
@property (nonatomic,assign)    float           mPayMoney;//支付金额
@property (nonatomic,strong)    NSString*       mReMark;//备注
@property (nonatomic,strong)    NSString*       mOrderStateStr;//订单状态字符串格式
@property (nonatomic,strong)    NSString*       mCreateOrderTime;//下单时间
@property (nonatomic,strong)    NSString*       mCreateOrderTimeWithWeek;//下单时间
@property (nonatomic,strong)    NSString*       mServiceScope;//
@property (nonatomic,strong)    NSString*       mServiceBrief;//服务简介/内容
@property (nonatomic,strong)    NSString*       mServiceEndTime;//服务结束时间

@property (nonatomic,strong)    OrderDetailRate*          mOrderDetailRate;
/**
 *  支付方式
 */
@property (nonatomic,strong)    NSString*       mPayment;
@property (nonatomic,assign)    OrderStateNew   mOrderStatusNew;
/**
 *  是否有评价
 */
@property (nonatomic,strong)    NSString*       mOrderRate;
/**
 *  订单状态
 */
@property (nonatomic,assign)    int             mOrderStatus;
/**
 *  取消原因
 */
@property (nonatomic,strong)    NSString*       mCancelReason;
/**
 *  优惠信息
 */
@property (nonatomic,strong)    NSString*       mPromotionName;

@property (nonatomic,assign)    BOOL            misCanStartService;
@property (nonatomic,assign)    BOOL            misCanRefushAndAccept;//是否可以显示拒绝接受和接受
@property (nonatomic,assign)    BOOL            misCanPendingAndShowItem;//是否可以显示挂起并且选择收费项目按钮
@property (nonatomic,assign)    BOOL            misCanContinue;//是否显示继续服务按钮
@property (nonatomic,assign)    BOOL            misCanProtFixStart;//是否显示保修开始服务
@property (nonatomic,assign)    BOOL            misCanPending;//


@property (nonatomic,assign)    int             mPayState;//0 没有支付,1已经支付
@property (nonatomic,assign)    BOOL            mBComment;//是否已经评价过了
@property (nonatomic,strong)    SGoods*         mGooods;
@property (nonatomic,strong)    SUser*          mUser;

@property (nonatomic,assign)    float           mLongit;
@property (nonatomic,assign)    float           mLat;

@property (nonatomic,assign)    int           mNum;
/**
 *  工作日志
 */
@property (nonatomic,strong)    NSArray*       mStaffLogArr;
/**
 *  服务内容
 */
@property (nonatomic,strong)    NSArray*       mServiceContent;


///服务开始时间
@property (nonatomic,assign)    int             mServiceStartTime;
///服务完成时间
@property (nonatomic,assign)    int             mServiceFinishTime;


//订单详情
-(void)getDetail:(void(^)(SResBase* resb))block;


//开始服务
-(void)startSrv:(void(^)(SResBase* resb))block;

/**
 *  接受订单
 *
 *  @param block 返回值
 */
- (void)acceptOrder:(void(^)(SResBase* resb))block;


//拒绝接单
-(void)refushOrder:(void(^)(SResBase* resb))block;


//挂起订单
-(void)pendingOrder:(void(^)(SResBase* resb))block;


//继续服务
-(void)continueOrder:(void(^)(SResBase* resb))block;


//保修开始
-(void)protFixStart:(void(^)(SResBase* resb))block;

-(void)dealItem:(NSArray*)items andOrderId:(int)mOrderId andTotlePrice:(int)mPrice block:(void(^)(SResBase* resb))block;

/**
 *  写日志
 *
 *  @param mContent 日志内容
 *  @param block    返回值
 */
-(void)postNote:(NSString*)content block:(void(^)(SResBase* resb))block;


/**
 *  回复评价
 *
 *  @param content 评价内容
 *  @param block   返回值
 */
- (void)rateAndreply:(NSString *)content block:(void(^)(SResBase* resb))block;
@end
/**
 *  工作日志
 */
@interface StaffLog : NSObject
-(id)initWithObj:(NSDictionary*)obj;

/**
 *  日志内容
 */
@property (nonatomic,strong)    NSString*       mContent;
/**
 *  创建时间
 */
@property (nonatomic,assign)    NSString*       mCreateTime;
/**
 *  id
 */
@property (nonatomic,assign)    int             mId;
/**
 *  订单id
 */
@property (nonatomic,assign)    int             mOrderId;
/**
 *  工作人员id
 */
@property (nonatomic,assign)    int             mStaffId;

@end

/**
 *  评价
 */
@interface OrderDetailRate : NSObject
-(id)initWithObj:(NSDictionary*)obj;

/**
 *  回复内容
 */
@property (nonatomic,strong)    NSString*       mContent;
/**
 *  创建时间
 */
@property (nonatomic,assign)    NSString*       mCreateTime;
/**
 *  id
 */
@property (nonatomic,assign)    int             mId;
/**
 *  订单id
 */
@property (nonatomic,assign)    int             mOrderId;
/**
 *  工作人员id
 */
@property (nonatomic,assign)    int             mCommunicateScore;
/**
 *
 */
@property (nonatomic,strong)    NSArray *mImgArr;

/**
 *  回复？
 */
@property (nonatomic,assign)    NSString*       mReply;
/**
 *  结果
 */
@property (nonatomic,assign)    NSString*       mResult;
/**
 *  分？
 */
@property (nonatomic,assign)    int             mScore;
/**
 *  卖家回复
 */
@property (nonatomic,assign)    NSString*       mSellerReply;
/**
 *  卖家回复时间  
 */
@property (nonatomic,assign)    NSString*       mSellerReplyTime;

@end


/**
 服务内容
 */
@interface OrderServiceContent : NSObject
-(id)initWithObj:(NSDictionary*)obj;
/**
 *  商品编号？
 */
@property (nonatomic,assign)    int             mGoddsId;
/**
 *  数量？
 */
@property (nonatomic,assign)    int             mNum;
/**
 *  订单id
 */
@property (nonatomic,assign)    int             mOrderID;
/**
 *  goods对象
 */
@property (nonatomic,strong)    SGoods*         mGooods;




@end


@interface SOrderRateInfo : SAutoEx

@property (nonatomic,assign)  int       mId;//int 编号
@property (nonatomic,strong)  NSString* mUserName;//String;//评价用户昵称
@property (nonatomic,strong)  NSString* mContent;// string;//评价内容
@property (nonatomic,strong)  NSString* mReply;// string;//商家回复
@property (nonatomic,strong)  NSString* mReplyTime;// String;//"商家评价回复时间2015-07-29"
@property (nonatomic,assign)  int       mStar;//int 评价星级（1-5）
@property (nonatomic,strong)  NSString* mCreateTime;//String;//"创建时间2015-07-29"
@property (nonatomic,strong)  NSString* mGoodName;//String;//菜品名称（若是评价外卖菜品则有此字段）
@property (nonatomic,assign)  BOOL      mIsRate;//boolean 是否已评价（只在菜品评价中使用）



@end

@interface SStatisic : NSObject

@property (nonatomic,assign) int        mYear;//2015
@property (nonatomic,assign) int        mMonth;//1 2 3
@property (nonatomic,assign) int        mNum;
@property (nonatomic,assign) float      mTotal;
///订单id
@property (nonatomic,assign) int        mOrderId;

//详情列表的时候,需要下面的
@property (nonatomic,strong) NSString*  mTimeStr;
@property (nonatomic,strong) NSString*  mSrvName;
@property (nonatomic,strong) NSString*  mImgURL;

@property (nonatomic,strong)    SGoods*         mGooods;


//获取统计数据,month = -1 表示 按照月份来统计,0 表示最近统计数据,
+(void)getStatisic:(int)yeaer month:(int)month page:(int)page block:(void(^)(SResBase* resb,NSArray* all))block;

@end

@interface SRate : SAutoEx

- (id)initWithObj:(NSDictionary *)obj;

@property (nonatomic,assign)    int mId;
@property (nonatomic,strong)    NSString *mUserName;
@property (nonatomic,strong)    NSString *mContent;
@property (nonatomic,strong)    NSArray *mImages;
@property (nonatomic,strong)    NSString *mReply;
@property (nonatomic,strong)    NSString *mResult;
@property (nonatomic,strong)    NSString *mCreateTime;
@property (nonatomic,strong)    NSString *mReplyTime;
@property (nonatomic,strong)    SOrder *mOrder;
@property (nonatomic,strong)    NSString *mGoodsName;

@property (nonatomic,assign)    int mCommentTotalCount; //评价总数
@property (nonatomic,assign)    int mCommentGoodCount; //好评数
@property (nonatomic,assign)    int mCommentNeutralCount; //中评数
@property (nonatomic,assign)    int mCommentBadCount; //差评数


-(void)RateReply:(NSString*)content block:(void(^)(SResBase* resb))block;


@end



@interface SMessageInfo : SAutoEx
-(id)initWithAPN:(NSDictionary*)objapn;

@property (nonatomic,assign)    int       mId;//int 编号
@property (nonatomic,strong)    NSString *mContent;// string  内容
@property (nonatomic,strong)    NSString *mTitle;// string  标题
@property (nonatomic,strong)    NSString *mCreateTime;//  string  "创建时间2015-08-09"
@property (nonatomic,assign)    int      mStatus;//  int "是否已读1：已读 0：未读"
@property (nonatomic,assign)    int      mType;//  int "消息类型1：普通消息2：html页面，args为url3：订单消息，args为订单id"
@property (nonatomic,strong)    NSString *mArgs;//    参数
@property (nonatomic,assign)    int      mCrateType;// int "消息来源类型0：平台1：商家"

@property (nonatomic,assign) BOOL       mChecked;
//阅读消息
-(void)readThis:(void(^)(SResBase* resb))block;

//删除消息
-(void)delThis:(void(^)(SResBase* resb))block;


//获取消息,
+(void)getMsgList:(int)page block:(void(^)( SResBase* resb , NSArray* all ))block;

//全部标记为已读
+(void)readAllMessage:(void(^)(SResBase* retobj))block;

//msgid 所有需要删除的消息ID
+(void)delMessages:(NSArray*)msgid block:(void(^)(SResBase* retobj))block;

//读一些..
+(void)readSomeMsg:(NSArray*)msgid block:(void(^)(SResBase* retobj))block;

@end



/**
 日程对象日程安排
 */

@interface SchedulDate : SAutoEx

@property (nonatomic,strong)    NSString*   mDateStr;//时间戳

@property (nonatomic,strong)    NSArray*    mTimeArr;

-(id)initWithObj:(NSDictionary*)obj;

+(void)getSchedulesWithDate:(int)mDate block:(void(^)(SResBase* resb ,NSArray* mDateList ))block;

@end


@interface SScheduleItem : NSObject
@property (nonatomic,strong)    NSString*   mTimeStr;//10:00 ...
@property (nonatomic,assign)    BOOL        mbStringInfo;//mStringInfo = NO表示是简要订单数据
@property (nonatomic,strong)    NSString*   mStr;//mStringInfo = YES 显示这个

//mbStringInfo = NO才有下面的
@property (nonatomic,strong)    NSString*   mSrvName;//服务名字
@property (nonatomic,strong)    NSString*   mUserName;//买家名称
@property (nonatomic,strong)    NSString*   mPhone;//买家手机号
@property (nonatomic,strong)    NSString*   mAddress;//buyer address;

@property (nonatomic,strong)    NSString*   mDateStr;
@property (nonatomic,assign)    int         mStatus;//"0：暂无安排 1：有单子 -1：停止接单"

@property (nonatomic,assign)    BOOL        mChecked;

@property (nonatomic,assign)    int         mOrderId;

/**
 *  备注
 */
@property (nonatomic,strong)    NSString*   mBuyRemark;
/**
 *  <#Description#>
 */
@property (nonatomic,assign)    int         mDiscountFee;
/**
 *  是否能评价
 */
@property (nonatomic,assign)    BOOL        mIsRate;
/**
 *  经度
 */
@property (nonatomic,strong)    NSString*   mLat;
/**
 *  纬度
 */
@property (nonatomic,strong)    NSString*   mLong;
/**
 *  订单状态
 */
@property (nonatomic,strong)    NSString*   mOrderStatusStr;
/**
 *  支付金额
 */
@property (nonatomic,assign)    float         mPayFee;
/**
 *  支付状态
 */
@property (nonatomic,assign)    int         mPayStatu;
/**
 *  msn
 */
@property (nonatomic,assign)    int         mSn;
/**
 *  总计
 */
@property (nonatomic,assign)    int         mTotalFee;

@end

@interface STimeSet : SAutoEx

-(id)initWithObj:(NSDictionary*)obj;

@property (nonatomic,assign) int        mId;

/*
 "0:星期日 1:星期一 2:星期二 3:星期三 4:星期四 5:星期五 6:星期六"
 */
@property (nonatomic,strong) NSString*  mWeek;
//@property (nonatomic,strong) NSString*  mTimes;// "00:00 ~ 10:00"
@property (nonatomic,strong) NSString *mShifts;

@property (nonatomic,strong) NSArray*   mWeekInfo;
@property (nonatomic,strong) NSArray*   mTimesInfo;// 选择的起始时间 "00:00"

-(void)delThis:(void(^)(SResBase* resb))block;

@end

@interface SLeave : SAutoEx

-(id)initWithObj:(NSDictionary*)obj;

@property (nonatomic,assign) CGFloat   mHHH;

@property (nonatomic,assign) BOOL       mSelected;

@property (nonatomic,assign) int        mId;
@property (nonatomic,strong) NSString*  mText;  //请假描述
@property (nonatomic,strong) NSString*  mTimeStr;//请假提交时间

@property (nonatomic,strong) NSString*  mStartTimeStr;
@property (nonatomic,strong) NSString*  mEndTimeStr;

///删除一组请假记录
+(void)delAll:(NSArray*)allids block:(void(^)(SResBase* resb))block;

@end
@interface SNote : SAutoEx

-(id)initWithObj:(NSDictionary*)obj;

/**
 *  公告标贴
 */
@property (nonatomic,strong) NSString*  mTitle;
/**
 *  公告内容
 */
@property (nonatomic,strong) NSString*  mContent;
/**
 *  公告发布时间
 */
@property (nonatomic,assign) int  mTime;


+(void)getNotes:(int)staffId andPage:(int)page block:(void(^)(SResBase* resb ,NSArray* all))block;

@end

@interface SOrderGoodsList: NSObject

@property (nonatomic,assign)    int         mTypeId;
@property (nonatomic,strong)    NSString*   mName;
@property (nonatomic,strong)    NSArray*    mSubGoods;// ==> SOrderGood

- (int)getNum;

//keywords搜索关键字,没有就传nil,typid 类型ID,没有指定类型就传0,,     all ==> SOrderGoodsList
+(void)getGoodsItems:(NSString*)keywords typeid:(int)typid block:(void(^)(SResBase* resb ,NSArray* all))block;

@end

@interface SOrderGood : SAutoEx

@property (nonatomic,assign) int        mId;//	int	是			编号
@property (nonatomic,assign) int        mSellerId;//	int	是			卖家编号
@property (nonatomic,strong) NSString*  mName;//	string	是			名称
@property (nonatomic,assign) float      mPrice;//	float	是			价格
@property (nonatomic,assign) float      mMarketPrice;//	float	否			店面价
@property (nonatomic,strong) NSString*  mBrief;//	string	否			简介
@property (nonatomic,assign) int        mTypeid;//类型ID
@property (nonatomic,assign) int        mNum;


@end




