//
//  DMBrushModel.m
//  DrawMaster
//
//  Created by git on 16/7/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBrushModel.h"

@implementation DMBrushModel
- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.brushLines = [NSMutableArray array];
    return self;
}
@end
