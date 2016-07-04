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
    NSMutableArray *lines = ((DMBrushModel*)[self.allBrushs lastObject]).brushLines;
    if(fabs(p.x -self.lastPoint.x)<5.0f &&fabs(p.y-self.lastPoint.y)<5.0f && lines.count<3)
    {
        
        
        //画点需要添加新的类型
        
        DMBrushModel * bm = [[DMBrushModel alloc] init];
        bm.brushPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(p.x-((DMBrushModel*)[self.allBrushs lastObject]).brushWidth, p.y-((DMBrushModel*)[self.allBrushs lastObject]).brushWidth, ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth*2, ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth*2) cornerRadius:((DMBrushModel*)[self.allBrushs lastObject]).brushWidth];
        bm.brushWidth = ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth;
        bm.brushColor = ((DMBrushModel*)[self.allBrushs lastObject]).brushColor;
        bm.brushType = 0;
        [bm.brushLines addObject:[NSMutableArray array]];
        NSMutableArray *lastPoints = bm.brushLines.lastObject;
        [lastPoints addObject:[NSString stringWithFormat:@"%@,%@",@(p.x-bm.brushWidth).stringValue,@(p.y-bm.brushWidth).stringValue]];
        //因为这里要添加一个新的，所以之前的要删除
        if(lines.count == 0 || lines.count == 1)
            [self.allBrushs removeObjectAtIndex:self.allBrushs.count -1];
        //
        [self.allBrushs addObject:bm];
        
        

      
        //画点画完后需要切换回来
        
        DMBrushModel * bmline = [[DMBrushModel alloc] init];
        bmline.brushPath = [UIBezierPath bezierPath];
        bmline.brushWidth = ((DMBrushModel*)[self.allBrushs lastObject]).brushWidth;
        bmline.brushColor = ((DMBrushModel*)[self.allBrushs lastObject]).brushColor;
        bmline.brushType = 0;
        [self.allBrushs addObject:bmline];
        
       
        
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self save];
    });
    
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
        jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"brushColor\":\"%@\",\"brushWidth\":\"%@\",\"brushType\":\"%@\",\"brushLines\":\"%@\"",colorStr,@(brush.brushWidth).stringValue,@(brush.brushType).stringValue,brushLinesStr]];
        jsonString = [jsonString stringByAppendingString:@"},"];
    }
    jsonString = [jsonString substringToIndex:jsonString.length-1];
    jsonString = [jsonString stringByAppendingString:@"]"];
    NSLog(@"json数据为:%@",jsonString);
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
    NSLog(@"%@",jsonObject);
    if (error==nil) {
       
        for (NSDictionary * model in jsonObject) {
            if([[model objectForKey:@"brushLines"] isEqualToString:@""])
                continue;
            DMBrushModel * bm = [[DMBrushModel alloc] init];
            bm.brushWidth = [[model objectForKey:@"brushWidth"] floatValue];
            NSArray* color = [[model objectForKey:@"brushColor"] componentsSeparatedByString:@","];
            bm.brushColor = [UIColor colorWithRed:[[color objectAtIndex:0] floatValue] green:[[color objectAtIndex:1] floatValue] blue:[[color objectAtIndex:2] floatValue] alpha:1.0];
            bm.brushType = [[model objectForKey:@"brushType"] integerValue];
            NSArray * lines = [[model objectForKey:@"brushLines"] componentsSeparatedByString:@"="];
            
            if(bm.brushType ==1 )
            {
                bm.brushPath = [UIBezierPath bezierPath];
                
                for (NSString * line in lines) {
                    NSArray *points = [line componentsSeparatedByString:@";"] ;
                    int i = 0;
                    for (NSString *point in points) {
                        NSArray *pointXY = [point componentsSeparatedByString:@","];
                        if(i == 0)
                        {
                            [bm.brushPath moveToPoint:CGPointMake([[pointXY objectAtIndex:0] floatValue], [[pointXY objectAtIndex:1] floatValue])];
                            
                        }
                        else
                        {
                            [bm.brushPath addLineToPoint:CGPointMake([[pointXY objectAtIndex:0] floatValue], [[pointXY objectAtIndex:1] floatValue])];
                        }
                        ++i;
                    }
                }
            }
            else if(bm.brushType ==0)
            {
                NSArray *points = [[lines objectAtIndex:0] componentsSeparatedByString:@";"] ;
                NSArray *point = [[points objectAtIndex:0] componentsSeparatedByString:@","];
                bm.brushPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake([point[0] floatValue],[point[1] floatValue], bm.brushWidth*2, bm.brushWidth*2) cornerRadius:bm.brushWidth];
            }
            [self.allBrushs addObject:bm];
            if([model isEqual: jsonObject.lastObject])
            {
                [self.delegate updateBrushWidth:bm.brushWidth BrushColor:bm.brushColor];
            }
        }
        [self setNeedsDisplay];
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

