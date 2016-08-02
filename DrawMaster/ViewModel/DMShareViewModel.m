//
//  DMShareViewModel.m
//  DrawMaster
//
//  Created by git on 16/8/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareViewModel.h"
#import "DMAPIManager.h"
#import "DMShareModel.h"

@interface DMShareViewModel()
@property (nonatomic, strong) NSMutableArray *sharesAry;
@property (nonatomic, assign) NSInteger mCurPage ;
@end
@implementation DMShareViewModel
- (instancetype)init
{
    self = [super init];

    if (self) {
        self.sharesAry = [NSMutableArray array];
        self.mCurPage= 1;
    }
    
    return self;
}

- (RACSignal*)fetchDataWithMore:(BOOL)more
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[[DMAPIManager sharedManager] fetchShareNum] subscribeNext:^(NSString* value){
            NSInteger num = value.integerValue;
            self.mCurPage = more ?  ++self.mCurPage:1  ;
            [[[DMAPIManager sharedManager] fetchShareListWithPageIndex:@(num-self.mCurPage).stringValue] subscribeNext:^(NSArray* value) {
                
                if(!more)
                {
                    [self.sharesAry removeAllObjects];
                }
                [self.sharesAry addObjectsFromArray:value];
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


- (NSInteger)shareNum
{
    return self.sharesAry.count;
}


- (NSAttributedString*)contentWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    return shop.attributedText;
}

- (CGFloat)contentHeightWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    return shop.textHeight;
}

- (NSString*)nickNameWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    return shop.nickName;
}

- (NSString*)idstrWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    return shop.idstr;
}

- (NSString*)userIconWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    return shop.userIcon;
}

- (NSString*)createTimeWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:shop.created_timestamp.integerValue];
    return [date qgocc_timestampForDate];
}

- (NSArray*)picIDsWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];

    return shop.pic_ids;
}

- (NSArray*)smallPicsWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    return shop.smallPics;
}

- (NSArray*)bigPicsWithRow:(NSInteger)row
{
    DMShareModel * shop = [self.sharesAry objectAtIndex:row];
    return shop.bigPics;
}
@end
