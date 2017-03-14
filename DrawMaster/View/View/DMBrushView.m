//
//  DMBrushView.m
//  DrawMaster
//
//  Created by git on 16/6/30.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBrushView.h"

@interface DMBrushView ()
@property (nonatomic,readwrite,strong) UIBezierPath *path;
@property (nonatomic,readwrite,strong) UIBezierPath *backGroundPath;
@property (nonatomic,readwrite,strong) UIColor *brushColor;
@end

@implementation DMBrushView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [mRGBToColor(0xeeeeee) setFill];
    [self.backGroundPath fill];
    [self.path fill];
    
    [self.brushColor setFill];
    [self.path fill];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        
        
        self.path = [UIBezierPath bezierPath];
        [self.path setLineWidth:2.0];
        
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMultipleTouchEnabled:NO];
        self.path = [UIBezierPath bezierPath];
        [self.path setLineWidth:2.0];
        
    }
    return self;
}

- (void)updateRadius:(CGFloat)radius BrushWidth:(CGFloat)bw BrushColor:(UIColor*)bc
{
  
    self.backGroundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, radius*2, radius*2) cornerRadius:radius];
    [self.backGroundPath setLineWidth:0.0];
    //[mRGBToColor(0xcccccc) setFill];
    
    
    self.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(radius-bw, radius-bw, bw*2, bw*2) cornerRadius:bw];
    [self.path setLineWidth:0.0];
    self.brushColor = bc;
    
   
    
    [self setNeedsDisplay];
    
    
}

@end
