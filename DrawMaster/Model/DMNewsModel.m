//
//  DMNewsModel.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMNewsModel.h"

@implementation DMNewsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"detail":@"detail"
             };
}
@end
