//
//  DMLearnModel.m
//  DrawMaster
//
//  Created by git on 16/6/24.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMLearnModel.h"

@implementation DMLearnModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"url":@"url",
             @"detail":@"detail",
             @"info":@"info",
             @"size":@"size",
             @"stdNum":@"stdNum",
             @"type":@"type"
             };
}
@end
