//
//  DMCopyViewModel.m
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMCopyViewModel.h"
#import "DMAPIManager.h"
#import "DMCopyModel.h"
@interface DMCopyViewModel()

@property (nonatomic, strong) NSMutableArray *copysAry;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign) NSInteger mCurPage ;
@end
@implementation DMCopyViewModel

- (instancetype)initWithType:(NSString *)type
{
    self = [super init];
    self.type = type;
    if (self) {
        self.copysAry = [NSMutableArray array];
        self.mCurPage= 1;
    }
    
    return self;
}

- (RACSignal*)fetchDataWithMore:(BOOL)more
{
    NSString * event = @"";
    if(more)
        event = [NSString stringWithFormat:@"copy_%@_more",self.type];
    else
        event = [NSString stringWithFormat:@"copy_%@_refresh",self.type];
    [MobClick event:event];
      return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
          
          [[[DMAPIManager sharedManager] fetchCopyNumWithType:self.type] subscribeNext:^(NSString* value){
              NSInteger num = value.integerValue;
              self.mCurPage = more ?  ++self.mCurPage:1  ;
              [[[DMAPIManager sharedManager] fetchCopyListWithType:self.type PageIndex:@(num-self.mCurPage).stringValue] subscribeNext:^(NSArray* value) {
                  
                  if(!more)
                  {
                      [self.copysAry removeAllObjects];
                  }
                  [self.copysAry addObjectsFromArray:value];
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


- (NSInteger)copyNum
{
    return self.copysAry.count;
}

- (NSString *)urlCopyWithIndex:(NSInteger)index
{
    DMCopyModel * m =self.copysAry[index];
    return m.url;
}

- (NSString *)detailCopyWithIndex:(NSInteger)index
{
    DMCopyModel * m =self.copysAry[index];
    return m.detail;
}

- (NSString *)typeCopyWithIndex:(NSInteger)index
{
    DMCopyModel * m =self.copysAry[index];
    return m.type;
    
}


@end
