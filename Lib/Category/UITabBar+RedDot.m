//
//  UITabBar+RedDot.m
//  DrawMaster
//
//  Created by git on 16/7/8.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "UITabBar+RedDot.h"
#define kBadgeViewInitedKey @"kBadgeViewInitedKey"
#define kBadgeDotViewsKey @"kBadgeDotViewsKey"
#define kBadgeNumberViewsKey @"kBadgeNumberViewsKey"
#define kTabIconWidth @"kTabIconWidth"
#define kBadgeTop @"kBadgeTop"

@implementation UITabBar (RedDot)
-(void)setBadgeStyle:(CustomBadgeType)type value:(NSInteger)badgeValue atIndex:(NSInteger)index{
    //判断是否已经初始化过badge，没有的话则计算并添加badge
    if( ![[self valueForKey:kBadgeViewInitedKey] boolValue] ){
        [self setValue:@(YES) forKey:kBadgeViewInitedKey];
        [self addBadgeViews];
    }
    
    //获取badge dotViews数组  和 numberViews数组， 分别代表红点badge和数字badge
    NSMutableArray *badgeDotViews = [self valueForKey:kBadgeDotViewsKey];
    NSMutableArray *badgeNumberViews = [self valueForKey:kBadgeNumberViewsKey];
    
    //设置隐藏badge
    [badgeDotViews[index] setHidden:YES];
    [badgeNumberViews[index] setHidden:YES];
    
    //根据类型决定显示哪一种badge
    if(type == kCustomBadgeStyleRedDot){
        [badgeDotViews[index] setHidden:NO];
        
    }else if(type == kCustomBadgeStyleNumber){
        [badgeNumberViews[index] setHidden:NO];
        UILabel *label = badgeNumberViews[index];
        //根据数字来动态更新badge
        [self adjustBadgeNumberViewWithLabel:label number:badgeValue];
        
    }else if(type == kCustomBadgeStyleNone){
        //empty
    }
}

-(void)addBadgeViews{
    //获取badgeview的横向偏移量和top值
    id idIconWith = [self valueForKey:kTabIconWidth];
    CGFloat tabIconWidth = idIconWith ? [idIconWith floatValue] : 32;
    id idBadgeTop = [self valueForKey:kBadgeTop];
    CGFloat badgeTop = idBadgeTop ? [idBadgeTop floatValue] : 11;
    
    NSInteger itemsCount = self.items.count;
    CGFloat itemWidth = self.bounds.size.width / itemsCount;
    
    //dotBadge views
    NSMutableArray *badgeDotViews = [NSMutableArray new];
    for(int i = 0;i < itemsCount;i ++){
        UIView *redDot = [UIView new];
        redDot.bounds = CGRectMake(0, 0, 10, 10);
        redDot.center = CGPointMake(itemWidth*(i+0.5)+tabIconWidth/2, badgeTop);
        redDot.layer.cornerRadius = redDot.bounds.size.width/2;
        redDot.clipsToBounds = YES;
        redDot.backgroundColor = [UIColor redColor];
        redDot.hidden = YES;
        [self addSubview:redDot];
        [badgeDotViews addObject:redDot];
    }
    //设置属性来记录有哪些dotViews，方便更新dotViews的属性时使用
    [self setValue:badgeDotViews forKey:kBadgeDotViewsKey];
    
    //numberBadge views
    NSMutableArray *badgeNumberViews = [NSMutableArray new];
    for(int i = 0;i < itemsCount;i ++){
        UILabel *redNum = [UILabel new];
        redNum.layer.anchorPoint = CGPointMake(0, 0.5);
        redNum.bounds = CGRectMake(0, 0, 20, 14);
        redNum.center = CGPointMake(itemWidth*(i+0.5)+tabIconWidth/2-10, badgeTop);
        redNum.layer.cornerRadius = redNum.bounds.size.height/2;
        redNum.clipsToBounds = YES;
        redNum.backgroundColor = [UIColor redColor];
        redNum.hidden = YES;
        
        redNum.textAlignment = NSTextAlignmentCenter;
        redNum.font = [UIFont systemFontOfSize:12];
        redNum.textColor = [UIColor whiteColor];
        
        [self addSubview:redNum];
        [badgeNumberViews addObject:redNum];
    }
    //设置属性来记录有哪些numberViews，方便更新numberViews的属性时使用
    [self setValue:badgeNumberViews forKey:kBadgeNumberViewsKey];
}

-(void)adjustBadgeNumberViewWithLabel:(UILabel *)label number:(NSInteger)number{
    [label setText:(number > 99 ? @"..." : @(number).stringValue)];
    if(number < 10){
        label.bounds = CGRectMake(0, 0, 14, 14);
    }else if(number < 99){
        label.bounds = CGRectMake(0, 0, 20, 14);
    }else{
        label.bounds = CGRectMake(0, 0, 20, 14);
    }
}


-(id)valueForUndefinedKey:(NSString *)key{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_COPY);
}
@end
