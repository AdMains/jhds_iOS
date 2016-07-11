//
//  AppDelegate.m
//  DrawMaster
//
//  Created by git on 16/6/21.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "AppDelegate.h"
#import "DMSplashViewController.h"
#import "DMDrawViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,TencentSessionDelegate>
@property (strong, nonatomic) TencentOAuth *tencentOAuth;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaKey];
    [WXApi registerApp:kWeixinAppKey withDescription:@"简画大师"];
    //底部选项卡设置
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTabColor,NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTabSelectColor,NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    [[UITabBar appearance] setItemWidth:200];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAppId andDelegate:self];

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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self]||
    [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UINavigationController * navigationControll =(UINavigationController *)self.window.rootViewController;
    UIViewController *vc = [navigationControll childViewControllers].lastObject;
    if([vc isKindOfClass:[DMDrawViewController class]])
    {
        [(DMDrawViewController*)vc BecomeActive];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if(response.statusCode == WeiboSDKResponseStatusCodeUserCancel)
    {
        UINavigationController * navigationControll =(UINavigationController *)self.window.rootViewController;
        UIViewController *vc = [navigationControll childViewControllers].lastObject;
        [vc showLoadAlertView:@"您已经取消分享" imageName:nil autoHide:YES];
    }
    else if(response.statusCode == WeiboSDKResponseStatusCodeSuccess)
    {
        UINavigationController * navigationControll =(UINavigationController *)self.window.rootViewController;
        UIViewController *vc = [navigationControll childViewControllers].lastObject;
        [vc showLoadAlertView:@"您已经成功分享" imageName:nil autoHide:YES];
    }
    
}

#pragma mark - 微信
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        return;
    }
}

@end
