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

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    self.url =  [NSString stringWithFormat:@"%@/images/jhds/learn/%@.jpg",kAPIBaseURI,self.url];
    NSMutableArray * tmp = [NSMutableArray array];
    for (NSString *url in self.detail) {
        [tmp  addObject:[NSString stringWithFormat:@"%@/images/jhds/learn/%@.jpg",kAPIBaseURI,url]];
    }
    self.detail = tmp;
    return self;
}
@end
