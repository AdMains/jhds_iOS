//
//  DMLearnViewModel.m
//  DrawMaster
//
//  Created by git on 16/6/24.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMLearnViewModel.h"
#import "DMAPIManager.h"
#import "DMLearnModel.h"
@interface DMLearnViewModel()

@property (nonatomic, strong) NSMutableArray *learnsAry;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign) NSInteger mCurPage ;
@end
@implementation DMLearnViewModel

- (instancetype)initWithType:(NSString *)type
{
    self = [super init];
    self.type = type;
    if (self) {
        self.learnsAry = [NSMutableArray array];
        self.mCurPage= 1;
    }
    
    return self;
}

- (RACSignal*)fetchDataWithMore:(BOOL)more
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[[DMAPIManager sharedManager] fetchLearnNumWithType:self.type] subscribeNext:^(NSString* value){
            NSInteger num = value.integerValue;
            self.mCurPage = more ?  ++self.mCurPage:1  ;
            [[[DMAPIManager sharedManager] fetchLearnListWithType:self.type PageIndex:@(num-self.mCurPage).stringValue] subscribeNext:^(NSArray* value) {
                
                if(!more)
                {
                    [self.learnsAry removeAllObjects];
                }
                [self.learnsAry addObjectsFromArray:value];
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


- (NSInteger)learnNum
{
    return self.learnsAry.count;
}

- (NSString *)urlLearnWithIndex:(NSInteger)index
{
    DMLearnModel * m =self.learnsAry[index];
    NSString* url = [NSString stringWithFormat:@"%@/images/jhds/learn/%@.jpg",kAPIBaseURI,m.url];
    return  url;
}

- (NSArray *)detailLearnWithIndex:(NSInteger)index
{
    DMLearnModel * m =self.learnsAry[index];
    return m.detail;
}

- (NSString *)typeLearnWithIndex:(NSInteger)index
{
    DMLearnModel * m =self.learnsAry[index];
    return m.type;
    
}

- (NSString *)infoLearnWithIndex:(NSInteger)index
{
    DMLearnModel * m =self.learnsAry[index];
    return m.info;
    
}

- (NSString *)sizeOfLearnWithIndex:(NSInteger)index
{
    
    DMLearnModel * m =self.learnsAry[index];
    return m.size;
}

@end
