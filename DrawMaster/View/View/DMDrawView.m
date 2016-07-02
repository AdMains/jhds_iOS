//
//  DMDrawView.m
//  DrawMaster
//
//  Created by git on 16/6/28.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMDrawView.h"
#import "DMBrushModel.h"
@interface DMDrawView ()
@property (nonatomic,readwrite,strong) NSMutableArray * allBrushs;
@property (nonatomic,readwrite,assign) CGPoint lastPoint;
@end

@implementation DMDrawView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.allBrushs = [NSMutableArray array];
        
       
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.allBrushs = [NSMutableArray array];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //[incrementalImage drawInRect:rect];
    //[path stroke];
    
    for (int i =0; i<self.allBrushs.count;++i) {
        if([(DMBrushModel*)[self.allBrushs objectAtIndex:i] brushType] ==1)
        {
            [((DMBrushModel*)[self.allBrushs objectAtIndex:i]).brushColor setStroke];
            [((DMBrushModel*)[self.allBrushs objectAtIndex:i]).brushPath setLineWidth:((DMBrushModel*)[self.allBrushs objectAtIndex:i]).brushWidth];
            [((DMBrushModel*)[self.allBrushs objectAtIndex:i]).brushPath stroke];
        }
        else
        {
            [((DMBrushModel*)[self.allBrushs objectAtIndex:i]).brushColor setFill];
            [((DMBrushModel*)[self.allBrushs objectAtIndex:i]).brushPath fill];
        }
        
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];
    [((DMBrushModel*)[self.allBrushs lastObject]).brushPath moveToPoint:self.lastPoint];
    [((DMBrushModel*)[self.allBrushs lastObject]).brushLines addObject:[NSMutableArray array]];
   
    NSMutableArray *lastPoints = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines.lastObject;
    [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(self.lastPoint.x).stringValue,@(self.lastPoint.y).stringValue]];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [((DMBrushModel*)[self.allBrushs lastObject]).brushPath addLineToPoint:p];
    NSMutableArray *lastPoints = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines.lastObject;
    [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(p.x).stringValue,@(p.y).stringValue]];
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    NSLog(@"差距为x:%f     y:%f",(p.x -self.lastPoint.x),(p.y-self.lastPoint.y));
    
    if(fabs(p.x -self.lastPoint.x)<3.0f &&fabs(p.y-self.lastPoint.y)<3.0f)
    {
        
        NSMutableArray *lines = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines;
        if(lines.count == 0)
            [self.allBrushs removeObjectAtIndex:self.allBrushs.count -1];
        //画点需要添加新的类型
        
        DMBrushModel * bm = [[DMBrushModel alloc] init];
        bm.brushPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(p.x-((DMBrushModel*)[self.allBrushs lastObject]).brushWidth, p.y-((DMBrushModel*)[self.allBrushs lastObject]).brushWidth, ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth*2, ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth*2) cornerRadius:((DMBrushModel*)[self.allBrushs lastObject]).brushWidth];
        bm.brushWidth = ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth;
        bm.brushColor = ((DMBrushModel*)[self.allBrushs lastObject]).brushColor;
        bm.brushType = 0;
        [self.allBrushs addObject:bm];
      
        //画点画完后需要切换回来
        
        DMBrushModel * bmline = [[DMBrushModel alloc] init];
        bmline.brushPath = [UIBezierPath bezierPath];
        bmline.brushWidth = ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth;
        bmline.brushColor = ((DMBrushModel*)[self.allBrushs lastObject]).brushColor;
        bmline.brushType = 0;
        [self.allBrushs addObject:bmline];
        
       
        
    }
    
   
    [self setNeedsDisplay];
  
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}



- (void)shakeToClear
{
   
    [self.allBrushs removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)updateBrushWidth:(CGFloat)bw BrushColor:(UIColor *)bc
{
    CGColorRef colorRef = bc.CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    NSLog(@"新的画笔颜色为%@",colorString);
  
    DMBrushModel * bm = [[DMBrushModel alloc] init];
    bm.brushPath = [UIBezierPath bezierPath];
    bm.brushWidth = bw;
    bm.brushColor = bc;
    bm.brushType = 1;
    [self.allBrushs addObject:bm];
    
}

- (void)backToFront
{
    if(((DMBrushModel*)[self.allBrushs lastObject]).brushType == 1)
    {
        NSMutableArray *lines = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines;
        
        if(lines.count>0)
            [lines removeObjectAtIndex:lines.count-1];
        if(lines.count == 0)
            [self.allBrushs removeObjectAtIndex:self.allBrushs.count -1];
        else
        {
            [((DMBrushModel*)[self.allBrushs lastObject]).brushPath removeAllPoints];
            for (NSMutableArray *points in lines) {
                int i = 0;
                for (NSString * point in points) {
                    NSArray *pointxy = [point componentsSeparatedByString:@","];
                    if(i == 0)
                    {
                        [((DMBrushModel*)[self.allBrushs lastObject]).brushPath moveToPoint:CGPointMake([pointxy[0] floatValue], [pointxy[1] floatValue])];
                    }
                    else
                    {
                        [((DMBrushModel*)[self.allBrushs lastObject]).brushPath addLineToPoint:CGPointMake([pointxy[0] floatValue], [pointxy[1] floatValue])];
                    }
                    ++i;
                }
            }
        }
    
    }
    else
    {
        [self.allBrushs removeObjectAtIndex:self.allBrushs.count -1];
    }
    
    
    [self.delegate updateBrushWidth:((DMBrushModel*)[self.allBrushs lastObject]).brushWidth BrushColor:((DMBrushModel*)[self.allBrushs lastObject]).brushColor];
    [self setNeedsDisplay];
    
    NSLog(@"撤销");
}


@end

