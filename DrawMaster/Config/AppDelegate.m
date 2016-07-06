//
//  AppDelegate.m
//  DrawMaster
//
//  Created by git on 16/6/21.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "AppDelegate.h"
#import "DMSplashViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,TencentSessionDelegate>

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

@end
