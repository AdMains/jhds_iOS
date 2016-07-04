//
//  DMDrawView.h
//  DrawMaster
//
//  Created by git on 16/6/28.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMDrawViewDelegate <NSObject>

/**
 *  由于撤销 而更改画笔的宽度 和颜色
 */
- (void)updateBrushWidth:(CGFloat)bw BrushColor:(UIColor *)bc;

@end



@interface DMDrawView : UIView
@property (nonatomic, weak) id <DMDrawViewDelegate> delegate;
- (void)shakeToClear;
- (void)updateBrushWidth:(CGFloat)bw BrushColor:(UIColor *)bc;
- (void)backToFront;

- (BOOL)shouldDirectBack;
- (BOOL)loadFromSave;
@end
