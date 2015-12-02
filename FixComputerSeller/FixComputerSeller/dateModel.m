//
//  dateModel.m
//  YiZanService
//
//  Created by zzl on 15/3/19.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "CustomDefine.h"
#import "SVProgressHUD.h"
#import "dateModel.h"
#import "NSObject+myobj.h"
#import "APIClient.h"
#import "Util.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "OSSBucket.h"
#import <CoreLocation/CoreLocation.h>

#import "AFURLSessionManager.h"
#import "APService.h"

#import <QMapKit/QMapKit.h>
#import <objc/message.h>

@class SStaff;
@class SCar;

@implementation dateModel

@end

@implementation SAutoEx

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj )
    {
        [self fetchIt:obj];
    }
    return self;
}

-(void)fetchIt:(NSDictionary*)obj
{
    if( obj == nil ) return;
    NSMutableDictionary* nameMapProp = NSMutableDictionary.new;
    id leaderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(leaderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        [nameMapProp setObject:[NSString stringWithFormat:@"%s",property_getAttributes(property)] forKey:propName];
    }
    if( properties )
    {
        free( properties );
    }
    
    if( nameMapProp.count == 0 ) return;
    
    NSArray* allnames = [nameMapProp allKeys];
    for ( NSString* oneName in allnames ) {
        if( ![oneName hasPrefix:@"m"] ) continue;
        //mId....like this
        NSString* jsonkey = [oneName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:[[oneName substringWithRange:NSMakeRange(1, 1)] lowercaseString] ];
        //mId ==> mid;
        jsonkey = [jsonkey substringFromIndex:1];
        //mid ==> id;
        
        
        id itobj = [obj objectForKeyMy:jsonkey];

        if( itobj == nil ) continue;
        [self setValue:itobj forKey:oneName];
    }
}
@end
@interface SResBase()

@property (nonatomic,strong)    id mcoredat;

@end

@implementation SResBase


-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
        self.mcoredat = obj;
    }
    return self;
}

-(void)fetchIt:(NSDictionary *)obj
{
    _mcode = [[obj objectForKeyMy:@"code"] intValue];
    _msuccess = _mcode == 0;
    self.mmsg = [obj objectForKeyMy:@"msg"];
    self.mdebug = [obj objectForKeyMy:@"debug"];
    self.mdata = [obj objectForKeyMy:@"data"];
}

+(SResBase*)infoWithError:(NSString*)error
{
    SResBase* retobj = SResBase.new;
    retobj.mcode = 1;
    retobj.msuccess = NO;
    retobj.mmsg = error;
    return retobj;
}
@end

@implementation SUserState

-(id)initWithObj:(NSDictionary*)dic
{
    self = [super init];
    if( self )
    {
        self.mbHaveNewMsg = [[dic objectForKeyMy:@"hasNewMessage"] boolValue];
    }
    return self;
}

@end

@interface SUser()

@property (nonatomic,strong)    id  mcoredat;

@end

@implementation SUser

static SUser* g_user = nil;
//返回当前用户
bool g_bined = NO;
+(SUser*)currentUser
{
    if( g_user ) return g_user;
    if( g_bined )
    {
        NSLog(@"fuck err rrrr");
        return nil;//递归问题,
    }
    g_bined = YES;
    @synchronized(self) {
        
        if ( !g_user )
        {
            g_user = [SUser loadUserInfo];
        }
    }
    g_bined = NO;
    return g_user;
}

+(void)saveUserInfo:(NSDictionary *)dccat
{
    dccat = [Util delNUll:dccat];
    NSMutableDictionary *dcc = [[NSMutableDictionary alloc] initWithDictionary:dccat];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dat = [[NSMutableDictionary alloc] initWithDictionary:[def objectForKey:@"userInfo"]];
    if ([dccat objectForKeyMy:@"user"]) {
        
        [def setObject:dcc forKey:@"userInfo"];
    }else{
        
        NSMutableDictionary *d1 = [[NSMutableDictionary alloc] initWithDictionary:[dat objectForKeyMy:@"staff"]];
        [d1 setValue:[dccat objectForKeyMy:@"name"] forKey:@"name"];
        
        if ([dccat objectForKeyMy:@"avatar"]) {
    
            [d1 setValue:[dccat objectForKeyMy:@"avatar"] forKey:@"avatar"];
            [dat setObject:d1 forKey:@"staff"];
        }
        [d1 setValue:[dccat objectForKeyMy:@"brief"] forKey:@"brief"];
        [dat setObject:d1 forKey:@"staff"];
        [def setObject:dat forKey:@"userInfo"];
    }
    
    
    
    [def synchronize];
}

+(SUser*)loadUserInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"userInfo"];
    if( dat )
    {
        SUser* tu = [[SUser alloc]initWithObj:dat];
        return tu;
    }
    return nil;
}
+(NSDictionary*)loadUserJson
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"userInfo"];
}

+(void)cleanUserInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:@"userInfo"];
    [def synchronize];
}

//判断是否需要登录
+(BOOL)isNeedLogin
{
    return [SUser currentUser] == nil;
}

//退出登陆
+(void)logout
{
    [SUser clearTokenWithPush];
    [SUser cleanUserInfo];
    g_user = nil;
    
    [[APIClient sharedClient] postUrl:@"user.logout" parameters:nil call:^(SResBase *info) {
        
    }];
    
}
//发送短信
+(void)sendSM:(NSString*)phone block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    
    [[APIClient sharedClient] postUrl:@"user.mobileverify" parameters:param call:^(SResBase *info) {
        block( info );
    }];
}

+(void)dealUserSession:(SResBase*)info block:(void(^)(SResBase* resb, SUser*user))block
{
    if( info.msuccess && info.mdata)
    {
        NSDictionary* tmpdic = info.mdata;
        
        NSMutableDictionary* tdic = [[NSMutableDictionary alloc]initWithDictionary:info.mdata];
        NSString* fucktoken = [info.mcoredat objectForKeyMy:@"token"];
        if( fucktoken.length )
            [tdic setObject:fucktoken forKey:@"token"];
        else
        {//如果没有token,那弄原来的
            [tdic setObject:[SUser currentUser].mToken forKey:@"token"];
        }
        SUser* tu = [[SUser alloc]initWithObj:tdic];
        tmpdic = tdic;
        
        if( tu )
        {
            [SUser saveUserInfo: tmpdic];
            g_user = nil;
            [SUser relTokenWithPush];
        }
    }
    block( info , [SUser currentUser] );
}

//登录,
+(void)loginWithPhone:(NSString*)phone psw:(NSString*)psw vcode:(NSString*)vcode block:(void(^)(SResBase* resb, SUser*user))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    if( psw )
        [param setObject:psw forKey:@"pwd"];
    if( vcode )
        [param setObject:vcode forKey:@"verifyCode"];
    [[APIClient sharedClient] postUrl:@"user.login" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
}
///密码登录,
+(void)loginWithPhone:(NSString*)phone psw:(NSString*)psw block:(void(^)(SResBase* resb, SUser*user))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    [param setObject:psw forKey:@"pwd"];
    
    [[APIClient sharedClient] postUrl:@"user.login" parameters:param call:^(SResBase *info) {
        [SUser dealUserSession:info block:block];
    }];
}

//注册
+(void)regWithPhone:(NSString*)phone psw:(NSString*)psw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    [param setObject:psw forKey:@"pwd"];
    [param setObject:smcode forKey:@"verifyCode"];
    
    [[APIClient sharedClient] postUrl:@"user.repwd" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
}

//重置密码
+(void)reSetPswWithPhone:(NSString*)phone newpsw:(NSString*)newpsw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    [param setObject:newpsw forKey:@"pwd"];
    [param setObject:smcode forKey:@"verifyCode"];
    
    [[APIClient sharedClient] postUrl:@"user.reg" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
}


-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
}


-(void)fetchIt:(NSDictionary *)obj
{
    
    
    self.mToken = [obj objectForKeyMy:@"token"];
    
    self.mStaffId = [[[obj objectForKeyMy:@"staff"] objectForKeyMy:@"id"] intValue];
    self.mUserName = [[obj objectForKeyMy:@"staff"] objectForKeyMy:@"name"];
    self.mHeadImgURL = [[obj objectForKeyMy:@"staff"] objectForKeyMy:@"avatar"];
    self.mPhone = [[obj objectForKeyMy:@"staff"] objectForKeyMy:@"mobile"];
    self.mAge = [[[obj objectForKeyMy:@"staff"] objectForKeyMy:@"age"] intValue];
    self.mSex = [[obj objectForKeyMy:@"staff"] objectForKeyMy:@"sexStr"];
    self.mUserId = [[[obj objectForKeyMy:@"user"] objectForKeyMy:@"id"] intValue];
    self.mBrief = [[obj objectForKeyMy:@"staff"] objectForKeyMy:@"brief"];
    
    
    self.mTotalMoney = [[[obj objectForKeyMy:@"totalMoney"] objectForKey:@"totalMoney"] floatValue];
    self.mWithdrawMoney = [[[obj objectForKeyMy:@"withdrawMoney"] objectForKey:@"withdrawMoney"] floatValue];
    self.mFrozenMoney = [[[obj objectForKeyMy:@"frozenMoney"] objectForKey:@"frozenMoney"] floatValue];
    
    self.mType = [[[[obj objectForKeyMy:@"staff"] objectForKeyMy:@"seller"] objectForKey:@"type"] intValue];
    
}

-(void)getDetail:(int)staffId block:(void(^)( SResBase* resb , SRate *rate ))block{

    [[APIClient sharedClient]postUrl:@"staff.detail" parameters:@{@"staffId":@(staffId)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            
            block(info,[[SRate alloc] initWithObj:info.mdata]);
        }
        else
            block( info ,nil);
    }];
    
}

//获取评价列表
-(void)getMyRate:(int)page type:(int)type block:(void(^)( SResBase* resb , NSArray* all ))block{

    [[APIClient sharedClient]postUrl:@"rate.staff.lists" parameters:@{@"page":@(type),@"type":@(page)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [t addObject: [[SRate alloc] initWithObj:one]];
            }
            block(info,t);
        }
        else
            block( info ,nil);
    }];

}

//获取余额
-(void)getBalance:(void(^)( SResBase* resb , NSDictionary *dic))block{

    [[APIClient sharedClient]postUrl:@"staff.get" parameters:@{@"id":@(_mStaffId)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            
            block(info,info.mdata);
        }
        else
            block( info ,nil);
    }];
    
}


//获取消息列表 all => SMessageInfo
-(void)getMyMsg:(int)page block:(void(^)( SResBase* resb , NSArray* all ))block
{
    [[APIClient sharedClient]postUrl:@"msg.list" parameters:@{@"page":@(page)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [t addObject: [[SMessageInfo alloc]initWithObj:one]];
            }
            block(info,t);
        }
        else
            block( info ,nil);
    }];
}

//是否有新消息
-(void)getMsgStatus:(void(^)( SResBase* resb ,BOOL bhavenew ))block
{
    [[APIClient sharedClient]postUrl:@"msg.status" parameters:nil call:^(SResBase *info) {
       
        block( info, [[info.mdata objectForKeyMy:@"hasNewMessage"] boolValue]);
        
    }];
    
}




#define APPKEY      [GInfo shareClient].mOssid
#define APPSEC      [GInfo shareClient].mOssKey
#define BUCKET      [GInfo shareClient].mOssBucket
#define OSSHOST     [GInfo shareClient].mOssHost


//修改用户信息,修改成功会更新对应属性
-(void)updateUserInfo:(NSString*)name HeadImg:(UIImage*)Head Brief:(NSString *)brief block:(void(^)(SResBase* resb ))block
{
    NSString* filepath = nil;
    if( Head )
    {//上传头像
        
        [SVProgressHUD showWithStatus:@"正在保存头像..."];
        OSSClient* _ossclient = [OSSClient sharedInstanceManage];
        _ossclient.globalDefaultBucketHostId = OSSHOST;
        
        NSString *accessKey = APPKEY;
        NSString *secretKey = APPSEC;
        [_ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
            NSString *signature = nil;
            NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
            signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
            signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
            //NSLog(@"here signature:%@", signature);
            return signature;
        }];
        
        OSSBucket* _ossbucket = [[OSSBucket alloc] initWithBucket:BUCKET];
        NSData *dataObj = UIImageJPEGRepresentation(Head, 1.0);
        filepath = [SUser makeFileName:@"jpg"];
        OSSData *testData = [[OSSData alloc] initWithBucket:_ossbucket withKey:filepath];
        [testData setData:dataObj withType:@"jpg"];
        [testData uploadWithUploadCallback:^(BOOL bok, NSError *err) {
            if( !bok )
            {
                SResBase* resb = [SResBase infoWithError:err.description];
                block( resb  );
            }
            else
            {   [SVProgressHUD dismiss];
                [self realUpdate:name file:filepath Brief:brief block:block];
            }
            
        } withProgressCallback:^(float process) {
            
            NSLog(@"process:%f",process);
          //  block(nil,NO,process);
            
        }];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self realUpdate:name file:nil Brief:brief block:block];
    }
}
-(void)realUpdate:(NSString*)name file:(NSString*)file Brief:(NSString *)brief block:(void(^)(SResBase* resb ))block
{
    NSMutableDictionary *param = NSMutableDictionary.new;
    if( name.length )
        [param setObject:name forKey:@"name"];
    if( file.length )
        [param setObject:file forKey:@"avatar"];
    if (brief.length) {
        [param setObject:brief forKey:@"brief"];
    }
    [SVProgressHUD showWithStatus:@"正在修改" maskType:SVProgressHUDMaskTypeClear];
    [[APIClient sharedClient] postUrl:@"staff.update" parameters:param call:^(SResBase *info) {
        
        [SUser dealUserSession:info block:^(SResBase *resb, SUser *user) {
            block( info );
        }];
        
    }];
}


//获取我的订单,,
-(void)getMyOrders:(int)status page:(int)page block:(void(^)(SResBase* resb,NSArray* all))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(status) forKey:@"status"];
    [param setObject:NumberWithInt(page) forKey:@"page"];
    [[APIClient sharedClient] postUrl:@"order.lists" parameters:param call:^(SResBase *info) {
         
        NSArray* t = nil;
        if( info.msuccess )
        {
            NSMutableArray* tar = NSMutableArray.new;
            for (NSDictionary* one in info.mdata ) {
                SOrder *sss= [[SOrder alloc] initWithObj:one];
                [tar addObject: sss];
            }
            t = tar;
        }
        block(info,t);
    }];
}

static int g_index = 0;
+(NSString*)makeFileName:(NSString*)extName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* t = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"HH-mm-ss"];
    NSString* s = [dateFormatter stringFromDate:[NSDate date]];
    g_index++;
    
    return [NSString stringWithFormat:@"temp/%@/%d_%u_%@.%@",t,[SUser currentUser].mUserId,g_index,s,extName];
}



+(void)clearTokenWithPush
{
    [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];
}
+(void)relTokenWithPush
{
    NSString* t = [NSString stringWithFormat:@"%d", [SUser currentUser].mStaffId];
    
    t = [@"staff_" stringByAppendingString:t];
    
    //别名
    //1."seller_1"
    //2."buyer_1"
    

    //标签
    //1."seller"/"buyer"
    //2."重庆"/...
    
    
    NSSet* labelset = [[NSSet alloc]initWithObjects:@"staff", @"ios",nil];
    
    [APService setTags:labelset alias:t callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];
    
}

+(NSString*)uploadImagSyn:(UIImage*)tagimg error:(NSError**)error
{
    OSSClient* _ossclient = [OSSClient sharedInstanceManage];
    _ossclient.globalDefaultBucketHostId = OSSHOST;
    //_ossclient.globalDefaultBucketHostId = @"osscn-hangzhou.aliyuncs.com";
    
    NSString *accessKey = APPKEY;
    NSString *secretKey = APPSEC;
    [_ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
        signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
        //NSLog(@"here signature:%@", signature);
        return signature;
    }];
    
    OSSBucket* _ossbucket = [[OSSBucket alloc] initWithBucket:BUCKET];
    NSData *dataObj = UIImageJPEGRepresentation(tagimg, 1.0);
    NSString* filepath = [SUser makeFileName:@"jpg"];
    OSSData *testData = [[OSSData alloc] initWithBucket:_ossbucket withKey:filepath];
    [testData setData:dataObj withType:@"jpg"];
    [testData upload:error];
    if( *error ) return nil;
    return filepath;
}

+(void)uploadImg:(UIImage*)tagimg block:(void(^)(NSString* err,NSString* filepath))block
{
    
    OSSClient* _ossclient = [OSSClient sharedInstanceManage];
    _ossclient.globalDefaultBucketHostId = OSSHOST;

    //_ossclient.globalDefaultBucketHostId = @"osscn-hangzhou.aliyuncs.com";
    
    NSString *accessKey = APPKEY;
    NSString *secretKey = APPSEC;
    [_ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
        signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
        //NSLog(@"here signature:%@", signature);
        return signature;
    }];
    
    OSSBucket* _ossbucket = [[OSSBucket alloc] initWithBucket:BUCKET];
    NSData *dataObj = UIImageJPEGRepresentation(tagimg, 1.0);
    NSString* filepath = [SUser makeFileName:@"jpg"];
    OSSData *testData = [[OSSData alloc] initWithBucket:_ossbucket withKey:filepath];
    [testData setData:dataObj withType:@"jpg"];
    [testData uploadWithUploadCallback:^(BOOL bok, NSError *err) {
        if( !bok )
        {
            block(err.description,nil);
        }
        else
        {
            block(nil,filepath);
        }
    } withProgressCallback:^(float process) {
        
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传图片:%.1f%%",process*100.0f] maskType:SVProgressHUDMaskTypeClear];
    }];
}



//++++++++++++++++++++++++++++++++++
NSMutableArray* g_allWaiterKey = nil;

+(void)addSearchWaiterKey:(NSString*)key
{
    if( g_allWaiterKey == nil )
        g_allWaiterKey = NSMutableArray.new;
    
    if( key.length )
    {
        if( ![g_allWaiterKey containsObject:key] )
        {
            [g_allWaiterKey addObject:key];
            [SUser saveHistoryWaiter:g_allWaiterKey];
        }
    }
}
+(NSArray*)loadHistoryWaiter
{
    if( g_allWaiterKey ) return g_allWaiterKey;
    
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_wat_his",userid];
    g_allWaiterKey =  [st objectForKey:key];
    return g_allWaiterKey;
}
+(void)clearHistoryWaiter
{
    [SUser saveHistoryWaiter:@[]];
    g_allWaiterKey = NSMutableArray.new;
}
+(void)saveHistoryWaiter:(NSArray*)dat
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_wat_his",userid];
    [st setObject:dat forKey:key];
    [st synchronize];
}
//++++++++++++++++++++++++++++++++++



//++++++++++++++++++++++++++++++++++
NSMutableArray* g_allGoodsKey = nil;

+(void)addSearchKey:(NSString*)key
{
    if( g_allGoodsKey == nil )
        g_allGoodsKey = NSMutableArray.new;
    
    if( key.length )
    {
        if( ![g_allGoodsKey containsObject:key] )
        {
            [g_allGoodsKey addObject:key];
            [SUser saveHistory:g_allGoodsKey];
        }
    }
}

+(NSArray*)loadHistory
{
    if( g_allGoodsKey ) return g_allGoodsKey;
    g_allGoodsKey = NSMutableArray.new;
    
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_srv_his",userid];
    NSArray* tt = [st objectForKey:key];
    if( tt )
        [g_allGoodsKey addObjectsFromArray:tt];
    return g_allGoodsKey;
}
+(void)clearHistory
{
    [SUser saveHistory:@[]];
    g_allGoodsKey = NSMutableArray.new;
}
+(void)saveHistory:(NSArray*)dat
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_srv_his",userid];
    [st objectForKey:key];
    [st setObject:dat forKey:key];
    [st synchronize];
}
//++++++++++++++++++++++++++++++++++
//获取服务时间设置,
-(void)getTimeSet:(void(^)( SResBase* resb , NSArray* all ))block
{
    
    [[APIClient sharedClient]postUrl:@"staffstime.lists" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* ttt = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata)  {
                [ttt addObject: [[STimeSet alloc]initWithObj: one]];
            }
            block( info , ttt );
            
        }else
            block( info , nil );
    }];
    
}

//
-(void)addTimeSet:(int)maybeid weeks:(NSArray*)weeks hours:(NSArray*)hours block:(void(^)(SResBase* resb ,STimeSet* retobj))block
{
    
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:weeks forKey:@"weeks"];
    [param setObject:hours forKey:@"hours"];
    if( maybeid )
    {
        [param setObject:NumberWithInt(maybeid) forKey:@"id"];
        
        [[APIClient sharedClient]postUrl:@"staffstime.update" parameters:param call:^(SResBase *info) {
            
            if( info.msuccess )
            {
                block( info, nil );
            }
            else
                block( info , nil );
        }];
    }
    else
    {
        [[APIClient sharedClient]postUrl:@"staffstime.add" parameters:param call:^(SResBase *info) {
            
            if( info.msuccess )
            {
                block( info, nil );
            }
            else
                block( info , nil );
        }];
    }
}

-(void)leaveReq:(int)starttime endtime:(int)endtime text:(NSString *)text block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:text  forKey:@"remark"];
    [param setObject:NumberWithInt(starttime) forKey:@"beginTime"];
    [param setObject:NumberWithInt(endtime) forKey:@"endTime"];
    
    [[APIClient sharedClient]postUrl:@"staffleave.create" parameters:param call:block];
}

-(void)leaveList:(int)page block:(void(^)(NSArray* arr, SResBase*  resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt( page ) forKey:@"page"];
    [[APIClient sharedClient] postUrl:@"staffleave.lists" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* tarr = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata  )
            {
                [tarr addObject:[[SLeave alloc]initWithObj:one] ];
            }
            block( tarr ,info);
        }
        else
        {
            block( nil ,info);
        }
        
    }];
}

@end


static GInfo* g_info = nil;
@implementation GInfo
{
}

+(GInfo*)shareClient
{
    if( g_info ) return g_info;
    @synchronized(self) {
        
        if ( !g_info )
        {
            GInfo* t = [GInfo loadGInfo];
            if( [t isGInfoVaild] )
                g_info = t;
        }
        return g_info;
    }
}
-(BOOL)isGInfoVaild
{//这个全局数据是否有效,,目前只判断了,token,应该判断所有的字段,:todo
    return self.mGToken.length > 0;
}
-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
}
-(void)fetchIt:(NSDictionary *)obj
{
    self.mGToken = [obj objectForKeyMy:@"token"];
    NSString* sssssss = [obj objectForKeyMy:@"key"];
    if( sssssss.length )
    {
        char keyPtr[10]={0};
        [sssssss getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        self.mivint  = (int)strtoul(keyPtr,NULL,24);
    }
    
    NSDictionary* data = [obj objectForKeyMy:@"data"];
    NSArray* tt = [data objectForKeyMy:@"citys"];
    NSMutableArray* t = NSMutableArray.new;
    for ( NSDictionary* one in tt ) {
        [t addObject: [[SCity alloc]initWithObj:one] ];
    }
    self.mSupCitys = t;
    
    tt = [data objectForKeyMy:@"payments"];
    t = NSMutableArray.new;
    for (NSDictionary* one in tt ) {
        [t addObject: [[SPayment alloc]initWithObj: one]];
    }
    
    self.mPayments = t;
    
    self.mAppVersion    = [data objectForKeyMy:@"appVersion"];
    self.mForceUpgrade  = [[data objectForKeyMy:@"forceUpgrade"] boolValue];
    self.mAppDownUrl    = [data objectForKeyMy:@"appDownUrl"];
    self.mUpgradeInfo   = [data objectForKeyMy:@"upgradeInfo"];
    self.mServiceTel    = [data objectForKeyMy:@"serviceTel"];
    
    
    NSDictionary* tttt = [data objectForKeyMy:@"oss"];
    
    self.mOssBucket = [tttt objectForKey:@"bucket"];
    self.mOssHost = [tttt objectForKey:@"host"];
    self.mOssid = [tttt objectForKey:@"access_id"];
    self.mOssKey = [tttt objectForKey:@"access_key"];
    
    if(  [self.mAppVersion isEqualToString:[Util getAppVersion]] )
    {
        self.mAppDownUrl = nil;
    }
    
    
    self.mAboutUrl = [data objectForKeyMy:@"aboutUrl"];          //关于我们Url
    self.mProtocolUrl = [data objectForKeyMy:@"protocolUrl"];       //用户协议Url
    self.mRestaurantTips = [data objectForKeyMy:@"restaurantTips"];    //餐厅订餐说明
    self.mShareQrCodeImage = [data objectForKeyMy:@"shareQrCodeImage"];  //分享二维码图片地址
    
    tt = [data objectForKeyMy:@"serviceRange"];
    NSMutableArray* allcitys = NSMutableArray.new;
    for ( NSDictionary* one in tt ) {
        SCity* rootprov =   SCity.new;
        rootprov.mId = [[one objectForKeyMy:@"id"] intValue];
        rootprov.mName = [one objectForKeyMy:@"name"];
        NSArray* subcitys = [one objectForKeyMy:@"city"];
        if( subcitys.count )
        {
            NSMutableArray* _subcitys = NSMutableArray.new;
            for ( NSDictionary* onecity in subcitys ) {
                SCity* onesubcity = SCity.new;
                onesubcity.mId = [[onecity objectForKeyMy:@"id"] intValue];
                onesubcity.mName = [onecity objectForKeyMy:@"name"];
                
                NSArray* subarea = [onecity objectForKeyMy:@"area"];
                if( subarea.count )
                {
                    NSMutableArray* _subareas = NSMutableArray.new;
                    for ( NSDictionary* onearea in subarea ) {
                        SCity* onesubarea = SCity.new;
                        onesubarea.mId = [[onearea objectForKeyMy:@"id"] intValue];
                        onesubarea.mName = [onearea objectForKeyMy:@"name"];
                        [_subareas addObject:onesubarea];
                    }
                    onesubcity.mSubs = _subareas;
                }
                [_subcitys addObject: onesubcity];
            }
            rootprov.mSubs = _subcitys;
        }
        [allcitys  addObject: rootprov];
    }
    self.mSupCitys = allcitys;
    
}
static bool g_blocked = NO;
static bool g_startlooop = NO;
+(void)getGInfoForce:(void(^)(SResBase* resb, GInfo* gInfo))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:DeviceType()   forKey:@"systemInfo"];
    [param setObject:@"ios"  forKey:@"deviceType"];
    [param setObject:DeviceSys()    forKey:@"systemVersion"];
    NSString *version =  [Util getAppVersion];
    [param setObject:version  forKey:@"appVersion"];
    [[APIClient sharedClient] postUrl:@"app.init" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {//如果网络获取成功,并且数据有效,就覆盖本地的,
            GInfo* obj = [[GInfo alloc] initWithObj: info.mcoredat];
            if( [obj isGInfoVaild] )
            {//有效
                [GInfo saveGInfo:info.mcoredat];
                obj = [GInfo shareClient] ;
                if( [obj isGInfoVaild] )
                {
                    block( info, obj);
                    return ;
                }
            }
        }
        
        block(info,nil);
    }];
}

+(void)getGInfo:(void(^)(SResBase* resb, GInfo* gInfo))block
{
    if( !g_startlooop )
    {
        GInfo* s = [GInfo shareClient];
        if( s )
        {
            SResBase* objret = [[SResBase alloc]init];
            objret.msuccess = YES;
            
            block( objret , s );
            g_blocked = YES;
        }
    }
    
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:DeviceType()   forKey:@"systemInfo"];
    [param setObject:@"ios"  forKey:@"deviceType"];
    [param setObject:DeviceSys()    forKey:@"systemVersion"];
    NSString *version =  [Util getAppVersion];
    [param setObject:version  forKey:@"appVersion"];
    [[APIClient sharedClient] postUrl:@"app.init" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {//如果网络获取成功,并且数据有效,就覆盖本地的,
            GInfo* obj = [[GInfo alloc] initWithObj: info.mcoredat];
            if( [obj isGInfoVaild] )
            {//有效
                [GInfo saveGInfo:info.mcoredat];
                obj = [GInfo shareClient] ;
                if( [obj isGInfoVaild] )
                {
                    if( !g_blocked )
                    {
                        g_blocked = YES;
                        block( info, obj);
                    }
                    
                    if( g_startlooop )
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserGinfoSuccess" object:nil];
                    return ;//这里就不用再下去了,,
                }
            }
        }
        else
        {
            //这里就是,没有网络或者数据无效了,就本地看看
            GInfo* tmp = [GInfo shareClient];
            if( tmp )
            {//如果本地有也可以
                if( !g_blocked )
                {
                    g_blocked = YES;
                    block(info,tmp);
                }
            }
            else
            {
                //连本地都没得,,,那么要一直循环获取了,,直到成功为止
                if( !g_blocked )
                {
                    g_blocked = YES;
                    
                    block([SResBase infoWithError:@"获取配置信息失败"] ,nil);
                }
                [GInfo loopGInfo];
            }
        }
    }];
}
+(void)loopGInfo
{
    g_startlooop = YES;
    MLLog(@"loopGInfo...");
    int64_t delayInSeconds = 1.0*20;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [GInfo getGInfo:^(SResBase *resb, GInfo *gInfo) {
            
            
        }];
        
    });
}
+(void)saveGInfo:(id)dat
{
    dat = [Util delNUll:dat];
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:dat  forKey:@"GInfo"];
    [def synchronize];
}
+(GInfo*)loadGInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"GInfo"];
    if( dat)
    {
        return [[GInfo alloc]initWithObj:dat];
    }
    return nil;
}

-(SPayment*)geAiPayInfo
{
    
    for ( SPayment* one in _mPayments ) {
        
        if( one.mPartnerId != nil )
            return one;
    }
    return nil;
}

-(SPayment*)geWxPayInfo
{
    for ( SPayment* one in _mPayments ) {
        
        if( one.mAppId != nil )
            return one;
    }
    return nil;
}



@end

@implementation SCity
-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mName = [obj objectForKeyMy:@"name"];
        self.mFirstChar = [obj objectForKeyMy:@"firstChar"];
        self.mIsDefault = [[obj objectForKeyMy:@"isDefault"] boolValue];
    }
    return self;
}

@end

@implementation SWxPayInfo
-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj )
    {
        self.mpartnerId = [obj objectForKeyMy:@"partnerid"];//	string	是			商户号
        self.mprepayId = [obj objectForKeyMy:@"prepayid"];//	string	是			预支付交易会话标识
        self.mpackage = [obj objectForKeyMy:@"packages"];//	string	是			扩展字段
        self.mnonceStr = [obj objectForKeyMy:@"noncestr"];//	string	是			随机字符串
        self.mtimeStamp = [[obj objectForKeyMy:@"timestamp"] intValue];//	int	是			时间戳
        self.msign = [obj objectForKeyMy:@"sign"];//	string	是			签名
        
    }
    return self;
}


@end
@implementation SPayment

-(id)initWithObjWX:(NSDictionary *)obj
{
    self = [super init];
    if( self )
    {
        self.mCode = [obj objectForKeyMy:@"code"];
        self.mName = [obj objectForKeyMy:@"name"];
        NSDictionary* cfg = [obj objectForKeyMy:@"config"];
        self.mAppId = [cfg objectForKeyMy:@"appId"];
        self.mAppSecret = [cfg objectForKeyMy:@"appSecret"];
        self.mWxPartnerId = [cfg objectForKeyMy:@"partnerId"];
        self.mWxPartnerkey = [cfg objectForKeyMy:@"partnerKey"];
    }
    return self;
}

-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        self.mCode = [obj objectForKeyMy:@"code"];
        self.mName = [obj objectForKeyMy:@"name"];
        NSDictionary*   objali = [obj objectForKeyMy:@"alipayConfig"];
        NSDictionary*   objwex = [obj objectForKeyMy:@"weixinConfig"];
        if( objali )
        {
            self.mPartnerId = [objali objectForKeyMy:@"partnerId"];
            self.mSellerId  = [objali objectForKeyMy:@"sellerId"];
            self.mPartnerPrivKey = [objali objectForKeyMy:@"partnerPrivKey"];
            self.mAlipayPubKey = [objali objectForKeyMy:@"alipayPubKey"];
            self.mIconName = @"22-1.png";

        }
        else if( objwex )
        {
            self.mAppId = [objwex objectForKeyMy:@"appId"];
            self.mAppSecret = [objwex objectForKeyMy:@"appSecret"];
            self.mIconName = @"22.png";

            self.mWxPartnerId = [objwex objectForKeyMy:@"partnerId"];
            self.mWxPartnerkey = [objwex objectForKeyMy:@"partnerKey"];
        }
        else
            MLLog(@"what pay?");
    }
    return self;
}

@end

@interface SAppInfo()<CLLocationManagerDelegate>

@property (atomic,strong) NSMutableArray*   allblocks;

@end
SAppInfo* g_appinfo = nil;
@implementation SAppInfo
{
    CLLocationManager* _llmgr;
    BOOL            _blocing;
    NSDate*          _lastget;
}

+(void)feedback:(NSString*)content block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:content forKey:@"content"];
    [param setObject:@"ios" forKey:@"deviceType"];
    [[APIClient sharedClient]postUrl:@"feedback.create" parameters:param call:block];
}

+(SAppInfo*)shareClient
{
    if( g_appinfo ) return g_appinfo;
    @synchronized(self) {
        
        if ( !g_appinfo )
        {
            SAppInfo* t = [SAppInfo loadAppInfo];
            g_appinfo = t;
        }
        return g_appinfo;
    }
}

+(SAppInfo*)loadAppInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"gappinfo"];
    SAppInfo* tt = SAppInfo.new;
    if( dat )
    {
        tt.mCityId = [[dat objectForKey:@"cityid"] intValue];
        tt.mSelCity = [dat objectForKey:@"selcity"];
    }
    return tt;
}
-(id)init
{
    self = [super init];
    self.allblocks = NSMutableArray.new;
    return self;
}
-(void)updateAppInfo
{
    NSMutableDictionary* dic = NSMutableDictionary.new;
    [dic setObject:self.mSelCity forKey:@"selcity"];
    [dic setObject:NumberWithInt(self.mCityId) forKey:@"cityid"];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:dic forKey:@"gappinfo"];
    [def synchronize];
}

//定位,
-(void)getUserLocation:(BOOL)bforce block:(void(^)(NSString*err))block
{
    NSDate *nowt = [NSDate date];
    long diff = [nowt timeIntervalSince1970] - [_lastget timeIntervalSince1970];
    if( diff > 60*5 && !bforce && _mlat != 0.0f && _mlng != 0.0f )
    {
        block(nil);
        return;
    }
    
    [_allblocks addObject:block];
    if( _blocing )
    {
        return;
    }
    _blocing = YES;
    _llmgr = [[CLLocationManager alloc] init];
    _llmgr.delegate = self;
    _llmgr.desiredAccuracy = kCLLocationAccuracyBest;
    _llmgr.distanceFilter = kCLDistanceFilterNone;
    if([_llmgr respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [_llmgr  requestWhenInUseAuthorization];
    
    
    [_llmgr startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [manager stopUpdatingLocation];
    
    CLLocation* location = [locations lastObject];
    
    _mlat = location.coordinate.latitude;
    _mlng = location.coordinate.longitude;
    
    
    [SAppInfo getPointAddress:_mlng lat:_mlat block:^(NSString *address, NSString *err) {
        if( !err )
        {
            self.mAddr = address;
            _lastget = [NSDate date];
        }
        
        for(int j = 0; j < _allblocks.count;j++ )
        {
            void(^block)(NSString*err) = _allblocks[j];
            block(err);
        }
        [_allblocks removeAllObjects];
        _blocing = NO;
        
    }];
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString* str = nil;
    if( error.code ==1 )
    {
        str = @"定位权限失败";
    }
    else
    {
        str = @"定位失败";
    }
    for(int j = 0; j < _allblocks.count;j++ )
    {
        void(^block)(NSString*err) = _allblocks[j];
        block(str);
    }
    [_allblocks removeAllObjects];
    _blocing = NO;
}
    

+(void)getPointAddress:(float)lng lat:(float)lat block:(void(^)(NSString* address,NSString*err))block
{
    NSString* requrl =
    [NSString stringWithFormat:@"http://apis.map.qq.com/ws/geocoder/v1/?location=%.6f,%.6f&key=%@&get_poi=1",lat,lng, QQMAPKEY];
    
    [[APIClient sharedClient] GET:requrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* addr = [[responseObject objectForKey:@"result"] objectForKey:@"address"];
        if( addr == nil )
            block(nil,@"获取位置信息失败");
        else
        {
            block(addr,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,@"获取位置信息失败");
        
    }];
}





@end



@implementation SGoods
-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    
    if( self && obj != nil )
    {
        [self fetch:obj];
    }
    
    return self;
}
-(void)fetch:(NSDictionary*)obj
{
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mSellerId = [[obj objectForKeyMy:@"sellerId"] intValue];
    self.mName = [obj objectForKeyMy:@"name"];
    self.mImgURL =[obj objectForKeyMy:@"image"];
    self.mImgURL = [self.mImgURL stringByAppendingString:@"@292w_292h_1e_1c_1o.jpg"];
    ///
    self.mPriceType = [[obj objectForKeyMy:@"priceType"] intValue];
    ///
    NSMutableArray* ta = NSMutableArray.new;
    NSMutableArray* tabig = NSMutableArray.new;
    self.mImgs = [obj objectForKeyMy:@"images"];
    for (NSString* one in self.mImgs ) {
        [ta addObject:[one stringByAppendingString:@"@640w_640h_1e_1c_1o.jpg"]];
        [tabig addObject:one];
        
    }
    self.mImgs = ta;
    self.mImgsBig = tabig;
    
    self.mPrice = [[obj objectForKeyMy:@"price"] floatValue];
    self.mMrketPrice = [[obj objectForKeyMy:@"marketPrice"] floatValue];
    self.mDesc = [obj objectForKeyMy:@"brief"];
    self.mDuration = [[obj objectForKeyMy:@"duration"] intValue];
    
    
    self.mGoodDesURL = [obj objectForKeyMy:@"url"];
    
}


@end

@implementation SOrder
-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        [self fetchIt:obj];
    }
    return self;
}
-(void)fetchIt:(NSDictionary *)obj
{
    self.mSn= [obj objectForKeyMy:@"sn"]                ;//订单号
    self.mId= [[obj objectForKeyMy:@"id"] intValue]                 ;//编号
    int second = [[obj objectForKeyMy:@"appointTime"] intValue];
    self.mApptime= [Util getTimeStringHourSecond:second];//当初预约的时间
    self.mPromStr= [[obj objectForKeyMy:@"promotion"] objectForKeyMy:@"promotionName"]                  ;//优惠描述
    self.mPromMoney= [[obj objectForKeyMy:@"discountFee"] floatValue]                ;//优惠了多少钱
    self.mUserName=  [obj objectForKeyMy:@"userName"]                ;//下单的人
    self.mPhoneNum= [obj objectForKeyMy:@"mobile"]                 ;//下单的电话
    self.mAddress= [obj objectForKeyMy:@"address"]                 ;//地址
    self.mTotalMoney= [[obj objectForKeyMy:@"totalFee"] floatValue]                 ;//总价
    self.mPayMoney= [[obj objectForKeyMy:@"payFee"] floatValue]                 ;//支付金额
    self.mReMark= [obj objectForKeyMy:@"buyRemark"]                 ;//备注
    self.mOrderStateStr = [obj objectForKeyMy:@"orderStatusStr"];
    self.mServiceScope = [obj objectForKeyMy:@"serviceScope"];
    self.mServiceBrief = [[obj objectForKeyMy:@"goods"]objectForKeyMy:@"brief"];///服务内容
    
    NSString *payment = [obj objectForKeyMy:@"payment"];
    if (payment == nil || [payment isEqualToString:@""]) {
        self.mPayment = @"未支付";

    }else{
        self.mPayment = [obj objectForKeyMy:@"payment"];

    }
    
    payment = [obj objectForKeyMy:@""];
    if (payment == nil || [payment isEqualToString:@""]) {
        self.mPromotionName = @"";

    }else{
        self.mPromotionName = [obj objectForKeyMy:@"promotionName"];

    }
    
    int end = [[obj objectForKeyMy:@"serviceEndTime"] intValue];
    self.mServiceEndTime = [Util getTimeStringHourSecond:end];//服务结束的时间

    self.mOrderStatus = [[obj objectForKeyMy:@"orderStatus"] intValue];
    self.mOrderStatusNew = [[obj objectForKeyMy:@"status"]intValue];
    self.mCancelReason = [obj objectForKeyMy:@"buyerCancelContent"];
    
    /*99：显示接受拒绝按钮
     102\103\104： 显示开始服务按钮
     105：显示订单挂起，选择收费项目按钮
     305：显示继续服务按钮
     107、306:显示保修开始服务
     108：显示订单挂起按钮
     */
    
    self.misCanStartService = ( _mOrderStatusNew == 102 || _mOrderStatusNew == 103 || _mOrderStatusNew == 104 );
    self.misCanRefushAndAccept = _mOrderStatusNew == 99;//是否可以显示拒绝
    self.misCanPendingAndShowItem = _mOrderStatusNew == 105;//是否可以显示挂起并且选择收费项目按钮
    self.misCanContinue = _mOrderStatusNew == 305;//是否显示继续服务按钮
    self.misCanProtFixStart = (_mOrderStatusNew == 107 || _mOrderStatusNew == 306);//是否显示保修开始服务
    self.misCanPending = _mOrderStatusNew == 108;
    
    
    
    self.mPayState = [[obj objectForKeyMy:@"payStatus"] intValue];
    self.mBComment= [[obj objectForKeyMy:@"isRate"] boolValue]                 ;//是否已经评价过了
    self.mGooods = [[SGoods alloc] initWithObj: [obj objectForKeyMy:@"goods"]];
    self.mUser = [[SUser alloc]initWithObj: [obj objectForKeyMy:@"user"]];
    
    _mLongit =[[[obj objectForKeyMy:@"mapPoint"] objectForKeyMy:@"y"] floatValue];
    _mLat =[[[obj objectForKeyMy:@"mapPoint"] objectForKeyMy:@"x"] floatValue];
    
    _mServiceStartTime = [[obj objectForKeyMy:@"serviceStartTime"] intValue];
    _mServiceFinishTime = [[obj objectForKeyMy:@"serviceFinishTime"]intValue];
    
    second = [[obj objectForKeyMy:@"createTime"] intValue];
    self.mCreateOrderTime =[Util getTimeStringHourSecond:second];
    
    self.mCreateOrderTimeWithWeek = self.mCreateOrderTime;
    
    self.mNum = self.mTotalMoney/self.mGooods.mPrice;
    
    self.mCreateOrderTimeWithWeek = [self.mCreateOrderTimeWithWeek stringByReplacingOccurrencesOfString:@" " withString:[NSString stringWithFormat:@"(周%@)",[Util DateTimeInt:second]]];
    
    NSMutableArray *stafflog = [NSMutableArray new];
    for (NSDictionary *dic in [obj objectForKeyMy:@"staffLog"]) {

        StaffLog *mSatff = [[StaffLog alloc]initWithObj:dic];
        [stafflog addObject:mSatff];
  
    }
    self.mStaffLogArr = stafflog;
    
    self.mOrderRate = [obj objectForKeyMy:@"orderRate"];
    
    self.mOrderDetailRate = [[OrderDetailRate alloc]initWithObj:[obj objectForKeyMy:@"orderRate"]];
    
    
    NSMutableArray *goodsArr = [NSMutableArray new];
    for (NSDictionary *tempdic in [obj objectForKeyMy:@"goods"]) {
        OrderServiceContent *mOrderContent = [[OrderServiceContent alloc]initWithObj:tempdic];
        [goodsArr addObject:mOrderContent];
    }
    self.mServiceContent = goodsArr;
    
}


 
//订单详情
-(void)getDetail:(void(^)(SResBase* resb))block
{
    NSMutableDictionary * param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [[APIClient sharedClient]postUrl:@"order.details" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt: info.mdata];
        }
        block( info );
    }];
    
}

- (void)acceptOrder:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [param setObject:NumberWithInt(103) forKey:@"status"];
    [[APIClient sharedClient] postUrl:@"order.updatestatus" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block(info);
    }];
}

-(void)startSrv:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [param setObject:NumberWithInt(105) forKey:@"status"];
    [[APIClient sharedClient] postUrl:@"order.updatestatus" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block(info);
    }];
}


//拒绝接单
-(void)refushOrder:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [param setObject:NumberWithInt(304) forKey:@"status"];
    [[APIClient sharedClient] postUrl:@"order.updatestatus" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block(info);
    }];
}


//挂起订单
-(void)pendingOrder:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [param setObject:NumberWithInt(305) forKey:@"status"];
    [[APIClient sharedClient] postUrl:@"order.updatestatus" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block(info);
    }];
}


//继续服务
-(void)continueOrder:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [param setObject:NumberWithInt(105) forKey:@"status"];
    [[APIClient sharedClient] postUrl:@"order.updatestatus" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block(info);
    }];
}


//保修开始
-(void)protFixStart:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [param setObject:NumberWithInt(108) forKey:@"status"];
    [[APIClient sharedClient] postUrl:@"order.updatestatus" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block(info);
    }];
}

//收费服务下单
-(void)dealItem:(NSArray*)items andOrderId:(int)mOrderId andTotlePrice:(int)mPrice block:(void(^)(SResBase* resb))block
{
    NSMutableArray* t = NSMutableArray.new;
    for ( SOrderGood * one in items ) {
        /*
        id 	int	是			类型编号
        price	double	是			现价
        name	string	是			名称
        orderId	int	是			订单编号
        typeId	int	是			商品分类编号
        num	int	是			商品数量
        */
        NSMutableDictionary* dic = NSMutableDictionary.new;
        [dic setObject:@(one.mId) forKey:@"id"];
        [dic setObject:@(one.mPrice) forKey:@"price"];
        [dic setObject:one.mName forKey:@"name"];
        [dic setObject:@(_mId) forKey:@"orderId"];
        [dic setObject:@(one.mTypeid) forKey:@"typeId"];
        [dic setObject:@(one.mNum) forKey:@"num"];
        [t addObject:dic];
    }
    
    NSMutableDictionary *tempdic = NSMutableDictionary.new;
    [tempdic setObject:NumberWithInt(mOrderId) forKey:@"orderId"];
    [tempdic setObject:NumberWithInt(mPrice) forKey:@"totalPrice"];
    [tempdic setObject:t forKey:@"goods"];
    
    [[APIClient sharedClient]postUrl:@"order.create" parameters:tempdic call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block(info);
    }];
    
}


-(void)postNote:(NSString*)content block:(void(^)(SResBase* resb))block{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:content forKey:@"content"];
    [param setObject:@(_mId) forKey:@"orderId"];
    [[APIClient sharedClient]postUrl:@"order.stafflog" parameters:param call:block];
}

- (void)rateAndreply:(NSString *)content block:(void(^)(SResBase* resb))block{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:content forKey:@"content"];
    [param setObject:@(_mId) forKey:@"id"];
    [[APIClient sharedClient]postUrl:@"rate.staff.reply" parameters:param call:block];
}


@end


@implementation StaffLog

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        self.mContent = [obj objectForKeyMy:@"content"];
        
        int second = [[obj objectForKeyMy:@"createTime"] intValue];
        self.mCreateTime = [Util getTimeStringHourSecond:second];
        
        self.mId = [[obj objectForKeyMy:@"id"]intValue];
        self.mOrderId = [[obj objectForKeyMy:@"orderId"]intValue];
        self.mStaffId = [[obj objectForKeyMy:@"staffId"]intValue];

    }
    return self;
}

@end

@implementation OrderDetailRate



-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        self.mCommunicateScore = [[obj objectForKeyMy:@"communicateScore"] intValue];
        self.mContent = [obj objectForKeyMy:@"content"];
        int second = [[obj objectForKeyMy:@"createTime"] intValue];
        self.mCreateTime = [Util getTimeStringHourSecond:second];
        self.mResult = [obj objectForKeyMy:@"result"];
        self.mScore = [[obj objectForKeyMy:@"score"] intValue];
        self.mSellerReply = [obj objectForKeyMy:@"sellerReply"];
        self.mSellerReplyTime = [obj objectForKeyMy:@"sellerReplyTime"];
        
        self.mReply = [obj objectForKeyMy:@"reply"];
        
    }
    return self;
}


@end

@implementation OrderServiceContent

- (id)initWithObj:(NSDictionary *)obj{
    
    self = [super init];
    
    if (self&&obj) {
        
        self.mGoddsId = [[obj objectForKeyMy:@"goodsId"] intValue];
        self.mNum = [[obj objectForKeyMy:@"num"] intValue];
        self.mOrderID = [[obj objectForKeyMy:@"orderId"]intValue];
        
        self.mGooods = [[SGoods alloc]initWithObj:[obj objectForKeyMy:@"ordergoods"]];
    }
    
    return  self;
}


@end


@implementation SRate

- (id)initWithObj:(NSDictionary *)obj{

    self = [super init];
    
    if (self&&obj) {
        
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mUserName = [[obj objectForKeyMy:@"user"] objectForKeyMy:@"name"];
        self.mContent = [obj objectForKeyMy:@"content"];
        self.mImages = [obj objectForKeyMy:@"images"];
        self.mReply = [obj objectForKeyMy:@"reply"];
        self.mResult = [obj objectForKeyMy:@"result"];
        self.mCreateTime = [Util dateForint:[[obj objectForKeyMy:@"createTime"] floatValue] bfull:NO];
        self.mReplyTime = [Util dateForint:[[obj objectForKeyMy:@"replyTime"] floatValue] bfull:NO];
        self.mOrder = [[SOrder alloc] initWithObj:[obj objectForKeyMy:@"order"]];
        self.mGoodsName = [[obj objectForKeyMy:@"goods"] objectForKeyMy:@"name"];
        
        self.mCommentTotalCount = [[[obj objectForKeyMy:@"extend"] objectForKeyMy:@"commentTotalCount"] intValue];
        self.mCommentGoodCount = [[[obj objectForKeyMy:@"extend"] objectForKeyMy:@"commentGoodCount"] intValue];
        self.mCommentNeutralCount = [[[obj objectForKeyMy:@"extend"] objectForKeyMy:@"commentNeutralCount"] intValue];
        self.mCommentBadCount = [[[obj objectForKeyMy:@"extend"] objectForKeyMy:@"commentBadCount"] intValue];
    }
    
    return  self;
}

-(void)RateReply:(NSString*)content block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:content forKey:@"replyContent"];
    [param setObject:@(_mId) forKey:@"id"];
    [[APIClient sharedClient]postUrl:@"rate.staff.reply" parameters:param call:block];
}


@end


@implementation SStatisic

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        NSString* tt = [obj objectForKeyMy:@"month"];
        if( tt.length == 6 )
        {
            self.mMonth = [[tt substringFromIndex:4] intValue];
            self.mYear = [[tt substringToIndex:4] intValue];
        }
        self.mNum = [[obj objectForKeyMy:@"num"] intValue];
        self.mTotal = [[obj objectForKeyMy:@"total"] floatValue];
    }
    return self;
}
-(id)initWtihOrderDic:(NSDictionary*)order
{
    self = [super init];
    if( self )
    {
        SOrder* or = [[SOrder alloc]initWithObj: order];
        self.mImgURL = [or.mGooods.mImgURL copy];
        self.mSrvName = [or.mGooods.mName copy];
        self.mTimeStr = [Util dateForint:[[order objectForKeyMy:@"payEndTime"] floatValue] bfull:NO];

        self.mTotal = [[order objectForKeyMy:@"payFee"] floatValue];;
        self.mOrderId = or.mId;
        
        self.mGooods = [order objectForKeyMy:@"goods"];
        
    }
    return self;
}

+(void)getStatisic:(int)yeaer month:(int)month page:(int)page block:(void(^)(SResBase* resb,NSArray* all))block
{
    if( month == -1 )
    {//按照月份统计
        NSMutableDictionary* param =    NSMutableDictionary.new;
        [param setObject:NumberWithInt(page) forKey:@"page"];
        [[APIClient sharedClient]postUrl:@"statistics.month" parameters:param call:^(SResBase *info) {
            //这个返回的是订单,,,
            NSArray* t  = nil;
            if( info.msuccess )
            {
                NSMutableArray* ta = NSMutableArray.new;
                for ( NSDictionary* one in info.mdata ) {
                    [ta addObject: [[SStatisic alloc]initWithObj:one]];
                }
                t = ta;
            }
            block(info,t);
        }];
        
    }
    else
    {
        NSMutableDictionary* param =    NSMutableDictionary.new;
        [param setObject:NumberWithInt(month) forKey:@"month"];
        [param setObject:NumberWithInt(page) forKey:@"page"];
        if( month > 0 )
        {
            if( month < 10 )
                [param setObject:[NSString stringWithFormat:@"%d0%d",yeaer,month] forKey:@"month"
                 ];
            else
                [param setObject:[NSString stringWithFormat:@"%d%d",yeaer,month] forKey:@"month"
                 ];
        }
        
        [[APIClient sharedClient] postUrl:@"statistics.detail" parameters:param call:^(SResBase *info) {
            NSArray* t  = nil;
            if( info.msuccess )
            {
                NSMutableArray* ta = NSMutableArray.new;
                for ( NSDictionary* one in info.mdata ) {
                    [ta addObject: [[SStatisic alloc]initWtihOrderDic:one]];
                }
                t = ta;
            }
            block(info,t);
        }];
    }
    
}





@end


@implementation SMessageInfo

-(id)initWithAPN:(NSDictionary*)objapn
{
    self = [super init];
    if( self )
    {
        self.mId = [[objapn objectForKeyMy:@"id"] intValue];
        self.mTitle = [objapn objectForKeyMy:@"title"];
        self.mContent = [objapn objectForKeyMy:@"content"];
        self.mCreateTime = [Util dateForint:[[objapn objectForKeyMy:@"sendTime"] floatValue] bfull:NO];
        self.mArgs = [objapn objectForKeyMy:@"args"];
        self.mType = [[objapn objectForKeyMy:@"type"] intValue];
        self.mStatus = [[objapn objectForKeyMy:@"status"] intValue];
    }
    
    return self;
}

//阅读消息
-(void)readThis:(void(^)(SResBase* resb))block
{
    [SMessageInfo realAll:@[@(_mId)] block:block];
}
+(void)realAll:(NSArray*)all block:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"msg.read" parameters:@{@"id":all} call:block];
}

//删除消息
-(void)delThis:(void(^)(SResBase* resb))block
{
    [SMessageInfo delAll:@[@(_mId)] block:block];
}
+(void)delAll:(NSArray*)all block:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"msg.delete" parameters:@{@"id":all} call:block];
}

+(void)getMsgList:(int)page block:(void(^)( SResBase* resb , NSArray* all ))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(page) forKey:@"page"];
    
    [[APIClient sharedClient]postUrl:@"msg.lists" parameters:param call:^(SResBase *info) {
        
        NSArray* t = nil;
        if( info.msuccess )
        {
            NSMutableArray* ta = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [ta addObject: [[SMessageInfo alloc] initWithAPN:one]];
            }
            t = ta;
        }
        block(info,t);
        
    }];
}

+(void)readAllMessage:(void(^)(SResBase* retobj))block{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(0) forKey:@"id"];
    [[APIClient sharedClient] postUrl:@"msg.read" parameters:param call:block];
}

+(void)readSomeMsg:(NSArray*)msgid block:(void(^)(SResBase* retobj))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:msgid forKey:@"id"];
    [[APIClient sharedClient]postUrl:@"msg.read" parameters:param call:block];
}

+(void)delMessages:(NSArray*)msgids block:(void(^)(SResBase* retobj))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:msgids forKey:@"id"];
    [[APIClient sharedClient]postUrl:@"msg.delete" parameters:param call:block];
    
}

@end
@implementation SScheduleItem

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        self.mAddress = [obj objectForKeyMy:@"address"];

        int time = [[obj objectForKeyMy:@"appointTime"] intValue];
        self.mTimeStr =[Util getTimeStringHourSecond:time];
        
        self.mStatus    = [[obj objectForKeyMy:@"status"] intValue];
        
        self.mbStringInfo = NO;
        
        self.mPhone = [obj objectForKeyMy:@"mobile"];
        self.mSrvName = [obj objectForKeyMy:@"goodsName"];
        self.mUserName = [obj objectForKeyMy:@"userName"];
        self.mOrderId = [[obj objectForKeyMy:@"id"] intValue];       
        
        self.mBuyRemark = [obj objectForKeyMy:@"buyRemark"];
        self.mDiscountFee = [[obj objectForKeyMy:@"discountFee"] intValue];
        self.mIsRate = [obj objectForKeyMy:@"isRate"];
        
        NSDictionary *dic = [obj objectForKeyMy:@"mapPoint"];
        self.mLat = [dic objectForKey:@"x"];
        self.mLong = [dic objectForKey:@"y"];
        
        self.mOrderStatusStr = [obj objectForKeyMy:@"orderStatusStr"];
        self.mPayFee = [[obj objectForKeyMy:@"payFee"] floatValue];
        self.mPayStatu = [[obj objectForKeyMy:@"payStatus"] intValue];
        self.mSn = [[obj objectForKeyMy:@"sn"] intValue];
        self.mTotalFee = [[obj objectForKeyMy:@"totalFee"] floatValue];
        
        
    }
    return self;
}
@end


@implementation SchedulDate

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    
    if( self )
    {
        
        self.mDateStr = [obj objectForKeyMy:@"time"];
        NSMutableArray *maa = [NSMutableArray new];
        maa = [obj objectForKeyMy:@"data"];
        NSMutableArray *mtt = [NSMutableArray new];
        
        for (NSDictionary *dic in maa) {
            
           SScheduleItem *mSchedule = [[SScheduleItem alloc]initWithObj:dic];
            
            [mtt addObject:mSchedule];
        }
        self.mTimeArr = mtt;

    }
    
    return self;
}


+(void)getSchedulesWithDate:(int)mDate block:(void(^)(SResBase* resb ,NSArray* mDateList ))block
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:NumberWithInt(mDate) forKey:@"date"];
//    [dic setObject:NumberWithInt(1) forKey:@"page"];
    
    [[APIClient sharedClient] postUrl:@"order.wapsorderlists" parameters:dic call:^(SResBase *info) {
        

        NSArray *tt = nil;
        if( info.msuccess )
        {
            NSMutableArray *arr = [NSMutableArray new];
    
            for (NSDictionary *mdic in [info.mdata objectForKey:@"list"]) {
              SchedulDate  *mSche = [[SchedulDate alloc]initWithObj:mdic];
                [arr addObject:mSche];

            }
            tt = arr;
        }
        
        block( info, tt);
    }];
}
@end


@implementation STimeSet

-(void)delThis:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt( _mId) forKey:@"id"];
    [[APIClient sharedClient]postUrl:@"staffstime.delete" parameters:param call:block];
}

-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self )
    {
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mWeek = [obj objectForKeyMy:@"weeks"];
//        self.mTimesInfo = [obj objectForKeyMy:@"hours"];
        self.mWeekInfo = [obj objectForKeyMy:@"week"];
        
        NSString *str = @"";
        NSArray *ary = [obj objectForKeyMy:@"shifts"];
        NSArray *ary2 = [obj objectForKeyMy:@"hours"];
        for (int i = 0; i< ary.count; i++) {
            
            str = [[str stringByAppendingString:[ary objectAtIndex:i]] stringByAppendingString:[NSString stringWithFormat:@"(%@)、",[ary2 objectAtIndex:i]]];
        }
        self.mShifts = str;

        
    }
    return self;
}


@end

@implementation SLeave

///删除一组请假记录
+(void)delAll:(NSArray*)allids block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary * param = NSMutableDictionary.new;
    [param setObject:allids forKey:@"ids"];
    [[APIClient sharedClient] postUrl:@"staffleave.delete" parameters:param call:block];
}


-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        
        /*
         
         id	int	是			请假记录编号
         beginTime	date	是			请假开始时间
         endTime	date	是			请假结束时间
         remark	string	否			请假理由
         createTime
         */
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mText = [obj objectForKey:@"remark"];
        
        self.mStartTimeStr = [obj objectForKeyMy:@"beginTime"];
        
        self.mEndTimeStr = [obj objectForKeyMy:@"endTime"];
        
        self.mTimeStr = [obj objectForKeyMy:@"createTime"];
        
        
    }
    return self;
}


@end
@implementation SNote

+(void)getNotes:(int)staffId andPage:(int)page block:(void(^)(SResBase* resb ,NSArray* all))block{
    NSMutableDictionary * param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(staffId) forKey:@"staffId"];
    [param setObject:NumberWithInt(page) forKey:@"page"];
    [[APIClient sharedClient] postUrl:@"announce.lists" parameters:param call:^(SResBase *info) {
        
        NSArray* t = nil;
        if( info.msuccess )
        {
            NSMutableArray* ta = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                
                [ta addObject:[[SNote alloc]initWithObj:one]];
                
            }
            t = ta;
        }
        
        block( info, t);
    }];

}


-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        
        self.mTime = [[obj objectForKeyMy:@"time"] intValue];
        self.mTitle = [obj objectForKeyMy:@"title"];
        self.mContent = [obj objectForKeyMy:@"content"];
        
    }
    return self;
}


@end


@implementation SOrderGoodsList

- (int)getNum{
    
    int num = 0;
    
    for (SOrderGood *goods in self.mSubGoods) {
        
        num +=goods.mNum;
    }
    
    return num;
}

+(void)getGoodsItems:(NSString*)keywords typeid:(int)typid block:(void(^)(SResBase* resb ,NSArray* all))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(typid) forKey:@"typeId"];
    if( keywords )
        [param setObject:keywords forKey:@"keyword"];
    
    [[APIClient sharedClient]postUrl:@"order.goodslists" parameters:param call:^(SResBase *info) {
        
        if ( info.msuccess ) {
            
            NSMutableArray* retall = NSMutableArray.new;
            for( NSDictionary* one in info.mdata  )
            {
                SOrderGoodsList* oneobj = SOrderGoodsList.new;
                oneobj.mTypeId = [[one objectForKeyMy:@"id"] intValue];
                oneobj.mName = [one objectForKeyMy:@"name"];
                NSMutableArray* subgoods = NSMutableArray.new;
                for ( NSDictionary* onesub in [one objectForKeyMy:@"goods"] ) {
                    SOrderGood*tobj = [[SOrderGood alloc]initWithObj:onesub];
                    tobj.mTypeid = oneobj.mTypeId;
                    [subgoods addObject:tobj ];
                }
                oneobj.mSubGoods = subgoods;
                
                [retall addObject: oneobj];
            }
            block( info,retall );
        }
        else
        {
            block( info,nil);
        }
    }];
}

@end

@implementation SOrderGood

@end







