//
//  CommonShareView.h
//  DrawMaster
//
//  Created by git on 16/7/6.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonShareViewDelegate <NSObject>

- (void)shareWithIndex:(NSInteger)index;

@end


@interface CommonShareView : UIView
@property (nonatomic, weak) id <CommonShareViewDelegate> delegate;
+ (instancetype)sharedView;
- (void)hide;
- (void)show;
- (NSString*)shareMessageWithType:(NSInteger)type;
@end
