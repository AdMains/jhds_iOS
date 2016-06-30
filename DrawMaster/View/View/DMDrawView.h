//
//  DMDrawView.h
//  DrawMaster
//
//  Created by git on 16/6/28.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDrawView : UIView

- (void)shakeToClear;
- (void)updateBrushWidth:(CGFloat)bw BrushColor:(UIColor *)bc;
@end
