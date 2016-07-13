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

{
    CGPoint pts[5];
    uint ctr;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.allBrushs = [NSMutableArray array];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self loadFromSave];
//        });
       
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
        [self loadFromSave];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];
    //[((DMBrushModel*)[self.allBrushs lastObject]).brushPath moveToPoint:self.lastPoint];
    [((DMBrushModel*)[self.allBrushs lastObject]).brushLines addObject:[NSMutableArray array]];
   
    NSMutableArray *lastPoints = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines.lastObject;
    [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(self.lastPoint.x).stringValue,@(self.lastPoint.y).stringValue]];
    
    ctr = 0;
    pts[0] = self.lastPoint;
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
       
        [((DMBrushModel*)[self.allBrushs lastObject]).brushPath moveToPoint:pts[0]];
        [((DMBrushModel*)[self.allBrushs lastObject]).brushPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        
        ((DMBrushModel*)[self.allBrushs lastObject]).shape.path = ((DMBrushModel*)[self.allBrushs lastObject]).brushPath.CGPath;
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
    
    //[((DMBrushModel*)[self.allBrushs lastObject]).brushPath addLineToPoint:p];
    //((DMBrushModel*)[self.allBrushs lastObject]).shape.path = ((DMBrushModel*)[self.allBrushs lastObject]).brushPath.CGPath;
    NSMutableArray *lastPoints = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines.lastObject;
    [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(p.x).stringValue,@(p.y).stringValue]];
    [MobClick event:@"canvas_draw"];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    //NSLog(@"差距为x:%f     y:%f",(p.x -self.lastPoint.x),(p.y-self.lastPoint.y));
    NSMutableArray *lastPoints = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines.lastObject;
    if(fabs(p.x -self.lastPoint.x)<8.0f &&fabs(p.y-self.lastPoint.y)<8.0f && lastPoints.count<3)
    {
        [((DMBrushModel*)[self.allBrushs lastObject]).brushPath moveToPoint:self.lastPoint];
        [((DMBrushModel*)[self.allBrushs lastObject]).brushPath addLineToPoint:self.lastPoint];
        NSMutableArray *lastPoints = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines.lastObject;
        [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(self.lastPoint.x).stringValue,@(self.lastPoint.y).stringValue]];
        ((DMBrushModel*)[self.allBrushs lastObject]).shape.path = ((DMBrushModel*)[self.allBrushs lastObject]).brushPath.CGPath;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self save];
    });
    
    ctr = 0;
  
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}



- (void)shakeToClear
{
   
    for (DMBrushModel * bm in self.allBrushs) {
        [bm.shape removeFromSuperlayer];
    }
    [self.allBrushs removeAllObjects];
    
    
}

- (void)updateBrushWidth:(CGFloat)bw BrushColor:(UIColor *)bc
{
    NSMutableArray *lines = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines;
    if(lines.count == 0  && lines != nil)
        [self.allBrushs removeObjectAtIndex:self.allBrushs.count -1];

    CGColorRef colorRef = bc.CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    //NSLog(@"新的画笔颜色为%@",colorString);
  
    DMBrushModel * bm = [[DMBrushModel alloc] initWithBrushWidth:bw BrushColor:bc];
    [self.layer addSublayer:bm.shape];
    [self.allBrushs addObject:bm];
    
}

- (void)backToFront
{
    [MobClick event:@"canvas_last"];
    NSMutableArray *lines = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines;
    
    if(lines.count>0)
        [lines removeObjectAtIndex:lines.count-1];
    if(lines.count == 0)
    {
        [((DMBrushModel *)self.allBrushs.lastObject).shape removeFromSuperlayer];
        [self.allBrushs removeObject:self.allBrushs.lastObject];
        
        if(self.allBrushs.count>0)
            [self.delegate updateBrushWidth:((DMBrushModel*)[self.allBrushs lastObject]).brushWidth BrushColor:((DMBrushModel*)[self.allBrushs lastObject]).brushColor];
        else
        {
            [self updateBrushWidth:3.0 BrushColor:mRGBToColor(0xDF0526)];
            [self.delegate updateBrushWidth:((DMBrushModel*)[self.allBrushs lastObject]).brushWidth BrushColor:((DMBrushModel*)[self.allBrushs lastObject]).brushColor];
            
        }
    }
    else
    {
        [((DMBrushModel*)[self.allBrushs lastObject]).brushPath removeAllPoints];
        for (NSMutableArray *points in lines) {
            int i = 0;
            if(points.count == 2)
            {
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
            else
            {
                ctr=0;
                for (NSString * point in points) {
                    NSArray *pointxy = [point componentsSeparatedByString:@","];
                    CGPoint p = CGPointMake([pointxy[0] floatValue], [pointxy[1] floatValue]);
                    if(i == 0)
                    {
                        pts[0] = p;
                    }
                    else
                    {

                        ctr++;
                       
                        pts[ctr] = p;
                        if (ctr == 4)
                        {
                            pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0);
                            [((DMBrushModel*)[self.allBrushs lastObject]).brushPath moveToPoint:pts[0]];
                            [((DMBrushModel*)[self.allBrushs lastObject]).brushPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
                            
                            ((DMBrushModel*)[self.allBrushs lastObject]).shape.path = ((DMBrushModel*)[self.allBrushs lastObject]).brushPath.CGPath;
                            // replace points and get ready to handle the next segment
                            pts[0] = pts[3];
                            pts[1] = pts[4];
                            ctr = 1;
                        }
                    }

                    ++i;
                }
            }
        }
        
        ((DMBrushModel*)[self.allBrushs lastObject]).shape.path = ((DMBrushModel*)[self.allBrushs lastObject]).brushPath.CGPath;
        
        
    }
    
    ctr=0;
    //NSLog(@"撤销");
}


- (void)save
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * FolderName = [NSString stringWithFormat:@"%@/jhdsLineData",kDocuments];
    NSError *error;
    if (![fileManager fileExistsAtPath:FolderName]) {
        
        [fileManager createDirectoryAtPath:FolderName withIntermediateDirectories:NO attributes:nil error:&error];
    }
    NSString * jsonString = @"[";
    for (DMBrushModel* brush in self.allBrushs) {
        NSString *brushLinesStr = @"";
        NSMutableArray * tempLines = [NSMutableArray array];
        for (NSArray * points in brush.brushLines) {
            NSString* pointsStr = [points componentsJoinedByString:@";"];
            [tempLines addObject:pointsStr];
        }
        brushLinesStr = [tempLines componentsJoinedByString:@"="];

        const CGFloat* colors = CGColorGetComponents( brush.brushColor.CGColor );
        jsonString = [jsonString stringByAppendingString:@"{"];
        NSString *colorStr = [NSString stringWithFormat:@"%@,%@,%@",@(colors[0]).stringValue,@(colors[1]).stringValue,@(colors[2]).stringValue];
        jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"brushColor\":\"%@\",\"brushWidth\":\"%@\",\"brushLines\":\"%@\"",colorStr,@(brush.brushWidth).stringValue,brushLinesStr]];
        jsonString = [jsonString stringByAppendingString:@"},"];
    }
    jsonString = [jsonString substringToIndex:jsonString.length-1];
    jsonString = [jsonString stringByAppendingString:@"]"];
    //NSLog(@"json数据为:%@",jsonString);
    NSString * jsonSavePath = [NSString stringWithFormat:@"%@/jhdsLineData/%@",kDocuments,@"lineData.json"];
    
    
    [jsonString writeToFile:jsonSavePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error)
    {
        //[(UIViewController*)self.delegate showLoadAlertView:@"保存失败" imageName:nil autoHide:YES];
        UALog(@"%@",NSLocalizedString([error userInfo][NSUnderlyingErrorKey], nil));
    }
    else
    {
        //[(UIViewController*)self.delegate showLoadAlertView:@"保存成功" imageName:nil autoHide:YES];
    }

}



- (BOOL)loadFromSave
{
    NSMutableArray *lines = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines;
    if(lines.count == 0)
        [self.allBrushs removeObjectAtIndex:self.allBrushs.count -1];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * FolderName = [NSString stringWithFormat:@"%@/jhdsLineData",kDocuments];
    NSError *error;
    if (![fileManager fileExistsAtPath:FolderName]) {
        
        return NO;
    }
    
    NSString * jsonSavePath = [NSString stringWithFormat:@"%@/jhdsLineData/%@",kDocuments,@"lineData.json"];
    if (![fileManager fileExistsAtPath:jsonSavePath]) {
        
        return NO;
    }
//    NSString * lineStr = [NSString stringWithContentsOfFile:jsonSavePath encoding:NSUTF8StringEncoding error:nil];
    
    NSData * lineData = [NSData dataWithContentsOfFile:jsonSavePath];
  
    NSArray* jsonObject = [NSJSONSerialization JSONObjectWithData:lineData options:NSJSONReadingAllowFragments error:&error];
    //NSLog(@"%@",jsonObject);
    if (error==nil) {
       
        for (NSDictionary * model in jsonObject) {
            if([[model objectForKey:@"brushLines"] isEqualToString:@""])
                continue;
            
            CGFloat bw = [[model objectForKey:@"brushWidth"] floatValue];
            NSArray* color = [[model objectForKey:@"brushColor"] componentsSeparatedByString:@","];
            UIColor *bc = [UIColor colorWithRed:[[color objectAtIndex:0] floatValue] green:[[color objectAtIndex:1] floatValue] blue:[[color objectAtIndex:2] floatValue] alpha:1.0];
            NSArray * lines = [[model objectForKey:@"brushLines"] componentsSeparatedByString:@"="];
           
            DMBrushModel * bm = [[DMBrushModel alloc] initWithBrushWidth:bw BrushColor:bc];
            for (NSString * line in lines) {
                NSArray *points = [line componentsSeparatedByString:@";"] ;
                int i = 0;
                if(points.count == 2)
                {
                    for (NSString *point in points) {
                        NSArray *pointXY = [point componentsSeparatedByString:@","];
                        CGPoint p = CGPointMake([[pointXY objectAtIndex:0] floatValue], [[pointXY objectAtIndex:1] floatValue]);
                        
                        if(i == 0)
                        {
                            
                            [bm.brushPath moveToPoint:p];
                            [bm.brushLines addObject:[NSMutableArray array]];
                            NSMutableArray *lastPoints = bm.brushLines.lastObject;
                            [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(p.x).stringValue,@(p.y).stringValue]];
                            
                        }
                        else
                        {
                            [bm.brushPath addLineToPoint:p];
                            NSMutableArray *lastPoints = bm.brushLines.lastObject;
                            [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(p.x).stringValue,@(p.y).stringValue]];
                        }
                        ++i;
                    }
                }
                else
                {
                    ctr=0;
                    for (NSString*point in points) {
                        NSArray *pointXY = [point componentsSeparatedByString:@","];
                        CGPoint p = CGPointMake([[pointXY objectAtIndex:0] floatValue], [[pointXY objectAtIndex:1] floatValue]);
                        if(i == 0)
                        {
                            
                            //[bm.brushPath moveToPoint:p];
                            pts[0] = p;
                            [bm.brushLines addObject:[NSMutableArray array]];
                            NSMutableArray *lastPoints = bm.brushLines.lastObject;
                            [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(p.x).stringValue,@(p.y).stringValue]];
                            
                        }
                        else
                        {
                            //[bm.brushPath addLineToPoint:p];
                            ctr++;
                            pts[ctr] = p;
                            if (ctr == 4)
                            {
                                pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
                                
                                [bm.brushPath moveToPoint:pts[0]];
                                [bm.brushPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
                                
                                bm.shape.path = bm.brushPath.CGPath;
                                // replace points and get ready to handle the next segment
                                pts[0] = pts[3];
                                pts[1] = pts[4];
                                ctr = 1;
                            }
                            
                            NSMutableArray *lastPoints = bm.brushLines.lastObject;
                            [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(p.x).stringValue,@(p.y).stringValue]];
                        }
                        ++i;

                    }
                }
            }
            bm.shape.path = bm.brushPath.CGPath;
            [self.layer addSublayer:bm.shape];
            
            [self.allBrushs addObject:bm];
            if([model isEqual: jsonObject.lastObject])
            {
                [self.delegate updateBrushWidth:bm.brushWidth BrushColor:bm.brushColor];
            }
        }
        ctr=0;
       
        return YES;
    }
    else
        return NO;
    
    

    return YES;

    
    
}

- (BOOL)shouldDirectBack
{
    if(self.allBrushs.count ==0)
        return YES;
    if(self.allBrushs.count == 1 && ((DMBrushModel*)self.allBrushs[0]).brushLines.count == 0)
        return YES;
    return NO;
}


@end

