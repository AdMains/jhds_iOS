//
//  DMBrushModel.m
//  DrawMaster
//
//  Created by git on 16/7/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBrushModel.h"

@implementation DMBrushModel


- (instancetype)initWithBrushWidth:(CGFloat)bw BrushColor:(UIColor *)bc
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.brushLines = [NSMutableArray array];
    self.brushWidth = bw;
    self.brushColor = bc;
    self.brushPath =  [UIBezierPath bezierPath];
    
    self.shape = [CAShapeLayer layer];
    self.shape.lineCap = kCALineCapRound;
    self.shape.fillColor=[UIColor clearColor].CGColor;
    self.shape.strokeColor=bc.CGColor;
    self.shape.lineWidth=bw;
    
    
    return self;
}
@end
