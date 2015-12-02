//
//  AppDelegate.m
//  O2O_XiCheSeller
//
//  Created by 密码为空！ on 15/6/18.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import <QMapKit/QMapKit.h>

#import "MyViewController.h"
#import "APService.h"

#import "WebVC.h"
#import "wkOrderDetailViewController.h"
#import "myMessageViewController.h"
@interface AppDelegate ()<UIAlertViewDelegate>

@end
@interface myalert : UIAlertView

@property (nonatomic,strong) id obj;

@end

@implementation myalert


@end
@implementation AppDelegate

-(void)initExtComp
{
    [MobClick startWithAppkey:@"55e500cd67e58e1ea300526f" reportPolicy:BATCH   channelId:@"App Store"];
    [MobClick setCrashReportEnabled:YES];
    
    [QMapServices sharedServices].apiKey = QQMAPKEY;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    
    [self initExtComp];
    
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    
    [APService setupWithOption:launchOptions];
    
    [SUser relTokenWithPush];
    
    [GInfo getGInfo:^(SResBase *resb, GInfo *gInfo) {
        
        if (resb.msuccess) {
            
        }
        else{
        
        }
        
    }];
    
    [SOrderGoodsList getGoodsItems:nil typeid:25 block:^(SResBase *resb, NSArray *all) {
        
      
        
    }];

 
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"back"object:self];
    
    [application setApplicationIconBadgeNumber:0];

    [APService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)gotoLogin
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    id viewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    
    [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:viewController animated:YES];
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"reg push err:%@",error);
}
#pragma mark*-*----加载推送通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive) {
        
        [self dealPush:userInfo bopenwith:NO];
    }
    else
    {
        [self dealPush:userInfo bopenwith:YES];
    }
}
-(void)dealPush:(NSDictionary*)userinof bopenwith:(BOOL)bopenwith
{
    SMessageInfo* pushobj = [[SMessageInfo alloc]initWithAPN:userinof];
    
    if( !bopenwith )
    {//当前用户正在APP内部,,
        myalert *alertVC = [[myalert alloc]initWithTitle:@"提示" message:@"有新的消息是否查看?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        alertVC.obj = pushobj;
        [alertVC show];
    }
    else
    {
        
        if( pushobj.mType == 1 )
        {
            myMessageViewController* vc = [[myMessageViewController alloc]init];
            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
        }
        else if( pushobj.mType == 2 )
        {
            WebVC* vc = [[WebVC alloc]init];
            vc.mName = @"详情";
            vc.mUrl = pushobj.mArgs;
        }
        else if( pushobj.mType == 3 )
        {
            wkOrderDetailViewController* vc = [[wkOrderDetailViewController alloc]init];
            vc.wkorder = SOrder.new;
            vc.wkorder.mId = [pushobj.mArgs intValue];
            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
        }
    }
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    NSLog(@"tag:%@ alias%@ irescod:%d",tags,alias,iResCode);
    if( iResCode == 6002 )
    {
        [SUser  relTokenWithPush];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        SMessageInfo* pushobj = ((myalert *)alertView).obj;
        
        if( pushobj.mType == 1 )
        {
            myMessageViewController* vc = [[myMessageViewController alloc]init];
            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
        }
        else if( pushobj.mType == 2 )
        {
            WebVC* vc = [[WebVC alloc]init];
            vc.mName = @"详情";
            vc.mUrl = pushobj.mArgs;
        }
        else if( pushobj.mType == 3 )
        {
            wkOrderDetailViewController* vc = [[wkOrderDetailViewController alloc]init];
            vc.wkorder = SOrder.new;
            vc.wkArgs = [pushobj.mArgs intValue];
            [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
        }
        
    }
}

@end
