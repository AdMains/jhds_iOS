//
//  DMProtectBabyViewModel.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMProtectBabyViewModel.h"
#import "DMAPIManager.h"
#import "DMNewsModel.h"
@interface DMProtectBabyViewModel()
@property (nonatomic, strong) NSArray *newsAry;
@end


@implementation DMProtectBabyViewModel
- (RACSignal*)fetchData
{
    return [[[DMAPIManager sharedManager] fetchProtectBabyList]map:^id(NSArray *value) {
        
        self.newsAry = value;
        return value;
    } ];
}


- (NSInteger)newsNum
{
    return self.newsAry.count;
}
- (NSString*)newsTitleWithRow:(NSInteger)row
{
    DMNewsModel * model = [self.newsAry objectAtIndex:row];
    return model.title;
    
}
- (NSString*)newsDetailWithRow:(NSInteger)row
{
    DMNewsModel * model = [self.newsAry objectAtIndex:row];
    return model.detail;
}

@end
