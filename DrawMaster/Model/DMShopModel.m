//
//  DMShopModel.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShopModel.h"

@implementation DMShopModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content":@"content",
             @"imgUrl":@"imgUrl",
             @"clickUrl":@"clickUrl",
             @"orther":@"orther"
             };
}
@end
