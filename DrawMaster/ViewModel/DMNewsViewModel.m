//
//  DMNewsViewModel.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMNewsViewModel.h"
#import "DMAPIManager.h"
#import "DMNewsModel.h"
@interface DMNewsViewModel()
@property (nonatomic, strong) NSArray *newsAry;
@end


@implementation DMNewsViewModel
- (RACSignal*)fetchData
{
    return [[[DMAPIManager sharedManager] fetchNewsList]map:^id(NSArray *value) {
        
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
