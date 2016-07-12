//
//  AppDelegate.h
//  DrawMaster
//
//  Created by git on 16/6/21.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *userInfoOfNotifation;
-(void)performPushReadDetailController:(NSDictionary *)userInfo;
@end

