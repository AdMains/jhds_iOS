//
//  UITabBar+RedDot.h
//  DrawMaster
//
//  Created by git on 16/7/8.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CustomBadgeType){
    kCustomBadgeStyleRedDot, //显示普通红点类型
    kCustomBadgeStyleNumber, //显示数字类型
    kCustomBadgeStyleNone //不显示
};
@interface UITabBar (RedDot)
- (void)setBadgeStyle:(CustomBadgeType)type value:(NSInteger)badgeValue atIndex:(NSInteger)index;
@end
