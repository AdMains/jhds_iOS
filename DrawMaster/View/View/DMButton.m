//
//  DMButton.m
//  DrawMaster
//
//  Created by git on 16/10/26.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMButton.h"

@implementation DMButton
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.customArgs = [NSMutableArray array];
        
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.customArgs = [NSMutableArray array];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.customArgs = [NSMutableArray array];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
