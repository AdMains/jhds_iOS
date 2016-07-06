//
//  DMShopViewModel.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShopViewModel.h"
#import "DMAPIManager.h"
#import "DMShopModel.h"
@interface DMShopViewModel()
@property (nonatomic, strong) NSMutableArray *shopsAry;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign) NSInteger mCurPage ;
@end
@implementation DMShopViewModel
- (instancetype)initWithType:(NSString *)type
{
    self = [super init];
    self.type = type;
    if (self) {
        self.shopsAry = [NSMutableArray array];
        self.mCurPage= 1;
    }
    
    return self;
}

- (RACSignal*)fetchDataWithMore:(BOOL)more
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[[DMAPIManager sharedManager] fetchShopNumWithType:self.type] subscribeNext:^(NSString* value){
            NSInteger num = value.integerValue;
            self.mCurPage = more ?  ++self.mCurPage:1  ;
            [[[DMAPIManager sharedManager] fetchShopListWithType:self.type PageIndex:@(num-self.mCurPage).stringValue] subscribeNext:^(NSArray* value) {
                
                if(!more)
                {
                    [self.shopsAry removeAllObjects];
                }
                [self.shopsAry addObjectsFromArray:value];
                [subscriber sendNext:value];
                
            } error:^(NSError *error) {
                [subscriber sendError:error];
            }];
            
            
        }  error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }]  doError:^(NSError *error) {
        
    }];
    
    
}


- (NSInteger)shopNum
{
    return self.shopsAry.count;
}


- (NSString*)contentWithRow:(NSInteger)row
{
    DMShopModel * shop = [self.shopsAry objectAtIndex:row];
    return shop.content;
}

- (NSString*)imgUrlWithRow:(NSInteger)row
{
    DMShopModel * shop = [self.shopsAry objectAtIndex:row];
    return shop.imgUrl;
}

- (NSString*)clickUrlWithRow:(NSInteger)row
{
    DMShopModel * shop = [self.shopsAry objectAtIndex:row];
    return shop.clickUrl;
}

- (NSString*)ortherWithRow:(NSInteger)row
{
    DMShopModel * shop = [self.shopsAry objectAtIndex:row];
    return shop.orther;
}
@end
