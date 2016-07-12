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
#import "UMessage.h"
#import "DMWebViewController.h"
#import "DMCopyDetailViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,TencentSessionDelegate>
@property (strong, nonatomic) TencentOAuth *tencentOAuth;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[[Crashlytics class]]];

    
    UMConfigInstance.appKey = kUMengKey;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = BATCH;
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:kUMengKey launchOptions:launchOptions];
    
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];

    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaKey];
    [WXApi registerApp:kWeixinAppKey withDescription:@"简画大师"];
    //底部选项卡设置
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTabColor,NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTabSelectColor,NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    [[UITabBar appearance] setItemWidth:200];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAppId andDelegate:self];
    NSDictionary * userInfo=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo!=nil) {
        
        self.userInfoOfNotifation=userInfo;
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge = 0;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }

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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[UMessage didReceiveRemoteNotification:userInfo];
    self.userInfoOfNotifation=userInfo;
    //在此处理接收到的消息。
    NSLog(@"Receive remote notification : %@",userInfo);
    if(application.applicationState==UIApplicationStateActive){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"简画大师推送"
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"忽略"
                                              otherButtonTitles:@"查看", nil];
        @weakify(self);
        [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber* x) {
            @strongify(self);
            if (x.integerValue == 0) {
                
            } else if (x.integerValue == 1) {
                [self performPushReadDetailController:userInfo];
            }
        }];
        [alert show];
        
    }
    else{
        [self performPushReadDetailController:userInfo];
    }

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is:%@", token);
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

-(void)performPushReadDetailController:(NSDictionary *)userInfo{
    UINavigationController * navigationControll =(UINavigationController *)self.window.rootViewController;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(userInfo[@"pushType"])
    {
        if([userInfo[@"pushType"] isEqualToString:@"1"])
        {
            DMWebViewController *modal =  [[DMWebViewController alloc] init];
            modal.detailUrl = userInfo[@"pushDetail"];
            modal.detailTitle = @"守护宝贝,爱心接力 ";
            modal.canShare = YES;
            [navigationControll pushViewController:modal animated:NO];
        }
        else if([userInfo[@"pushType"] isEqualToString:@"2"])
        {
            DMCopyDetailViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"DMCopyDetailViewController"];
            NSArray * tempArray  = [userInfo[@"pushDetail"] componentsSeparatedByString:@","];
            NSMutableArray * tmp = [NSMutableArray array];
            for (NSString *url in tempArray) {
                [tmp  addObject:[NSString stringWithFormat:@"%@/images/jhds/learn/%@.jpg",kAPIBaseURI,url]];
            }
            modal.imgUrls = tmp;
            [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:@"DMLastDrawInfo"];
            [navigationControll pushViewController:modal animated:NO];
        }
    }
    self.userInfoOfNotifation=nil;
}


@end
