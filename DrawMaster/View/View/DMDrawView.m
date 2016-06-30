//
//  DMDrawView.m
//  DrawMaster
//
//  Created by git on 16/6/28.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMDrawView.h"

@interface DMDrawView ()
@property (nonatomic,readwrite,strong) NSMutableArray * allBrushPath;
@property (nonatomic,readwrite,strong) NSMutableArray * allBrushWidth;
@property (nonatomic,readwrite,strong) NSMutableArray * allBrushColor;
@property (nonatomic,readwrite,strong) NSMutableArray * allBrushType;
@end

@implementation DMDrawView

{
    
    UIImage *incrementalImage;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.allBrushPath = [NSMutableArray array];
        self.allBrushWidth = [NSMutableArray array];
        self.allBrushColor = [NSMutableArray array];
        self.allBrushType = [NSMutableArray array];
        
       
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.allBrushPath = [NSMutableArray array];
        self.allBrushWidth = [NSMutableArray array];
        self.allBrushColor = [NSMutableArray array];
        self.allBrushType = [NSMutableArray array];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //[incrementalImage drawInRect:rect];
    //[path stroke];
    
    for (int i =0; i<self.allBrushPath.count;++i) {
        if([[self.allBrushType objectAtIndex:i] integerValue] ==1)
        {
            [(UIColor*)[self.allBrushColor objectAtIndex:i] setStroke];
            [(UIBezierPath*)[self.allBrushPath objectAtIndex:i] setLineWidth:[[self.allBrushWidth objectAtIndex:i] floatValue]];
            [[self.allBrushPath objectAtIndex:i] stroke];
        }
        else
        {
            [(UIColor*)[self.allBrushColor objectAtIndex:i] setFill];
            [[self.allBrushPath objectAtIndex:i] fill];
        }
        
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [(UIBezierPath*)[self.allBrushPath lastObject] moveToPoint:pts[0]];
        [(UIBezierPath*)[self.allBrushPath lastObject] addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        
        [self setNeedsDisplay];
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    NSLog(@"差距为x:%f     y:%f",(p.x -pts[0].x),(p.y-pts[0].y));
    if(fabs(p.x -pts[0].x)<3.0f &&fabs(p.y-pts[0].y)<3.0f)
    {
        //画点需要添加新的类型
        [self.allBrushPath addObject:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(p.x-[self.allBrushWidth.lastObject floatValue], p.y-[self.allBrushWidth.lastObject floatValue], [self.allBrushWidth.lastObject floatValue]*2, [self.allBrushWidth.lastObject floatValue]*2) cornerRadius:[self.allBrushWidth.lastObject floatValue]]];
        [self.allBrushWidth addObject:self.allBrushWidth.lastObject];
        [self.allBrushColor addObject:self.allBrushColor.lastObject];
        [self.allBrushType addObject:@(0)];
        
        //画点画完后需要切换回来
        [self.allBrushPath addObject:[UIBezierPath bezierPath]];
        [self.allBrushWidth addObject:self.allBrushWidth.lastObject];
        [self.allBrushColor addObject:self.allBrushColor.lastObject];
        [self.allBrushType addObject:@(1)];
        
    }
    
    //[self drawBitmap];
    [self setNeedsDisplay];
    //[path removeAllPoints];
    ctr = 0;
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!incrementalImage) // first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [[UIColor blackColor] setStroke];
    [(UIBezierPath*)[self.allBrushPath lastObject] stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (void)shakeToClear
{
    [self.allBrushPath removeAllObjects];
    [self.allBrushColor removeAllObjects];
    [self.allBrushWidth removeAllObjects];
    [self setNeedsDisplay];
}

- (void)updateBrushWidth:(CGFloat)bw BrushColor:(UIColor *)bc
{
    CGColorRef colorRef = bc.CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    NSLog(@"新的画笔颜色为%@",colorString);
    [self.allBrushPath addObject:[UIBezierPath bezierPath]];
    [self.allBrushWidth addObject:@(bw)];
    [self.allBrushColor addObject:bc];
    [self.allBrushType addObject:@(1)];
    
}


@end

