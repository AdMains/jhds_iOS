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
@property (readwrite,nonatomic, strong) NSMutableDictionary* dataDic;
@property (nonatomic, assign) NSInteger mCurPage ;
@end
@implementation DMShareViewModel
- (instancetype)init
{
    self = [super init];

    if (self) {
        self.sharesAry = [NSMutableArray array];
        self.dataDic = [NSMutableDictionary dictionary];
        self.mCurPage= 1;
    }
    
    return self;
}

- (RACSignal*)fetchDataWithMore:(BOOL)more
{
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        @weakify(self)
        [[[DMAPIManager sharedManager] fetchShareNum] subscribeNext:^(NSString* value){
            @strongify(self)
            NSInteger num = value.integerValue;
            self.mCurPage = more ?  ++self.mCurPage:1  ;
            @weakify(self)
            [[[DMAPIManager sharedManager] fetchShareListWithPageIndex:@(num-self.mCurPage).stringValue] subscribeNext:^(NSArray* value) {
                @strongify(self)
                if(!more)
                {
                    [self.sharesAry removeAllObjects];
                    [self.dataDic removeAllObjects];
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"top_idstr"])
                    {
                        DMShareModel * share = [[DMShareModel alloc] init];
                        share.idstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"top_idstr"];
                        share.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"top_text"];
                        share.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"top_nickName"];
                        share.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"top_userId"];
                        share.userIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"top_userIcon"];
                        share.original_pic = [[NSUserDefaults standardUserDefaults] objectForKey:@"top_original_pic"];
                        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"top_pic_urls"] isEqualToString: @""])
                        {
                            share.smallPics = [[[NSUserDefaults standardUserDefaults] objectForKey:@"top_pic_urls"] componentsSeparatedByString:@","];
                            share.bigPics =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"top_pic_urls"] componentsSeparatedByString:@","];
                        }
                        else
                        {
                            share.smallPics = [NSArray array];
                        }
                        [share updateTextIcon];
                        [self.sharesAry addObject:share];
                        
                    }
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

- (NSString*)idstr
{
    NSString *str = @"";
    int i = 0;
    for (DMShareModel * share in self.sharesAry) {
        if (i == 0)
        {
            str = share.idstr;
        }
        else
        {
            str = [NSString stringWithFormat:@"%@,%@",str,share.idstr];
        }
        i++;
    }
    return str;
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

-(void)fetchWeiboNum:(NSString*)weiboID success:(void (^)( NSNumber *repostNum,NSNumber *commentNum,NSNumber *attributeNum))success
{
    if(weiboID ==nil)
    {
        success(@(0),@(0),@(0));
        return;
    }
    else if ([self.dataDic objectForKey:weiboID])
    {
        NSArray * d = [self.dataDic objectForKey:weiboID];
        success(d[0],d[1],d[2]);
        return;
    }
    
    @weakify(self)
    NSLog(@"++++++++请求了微博的%@数目",weiboID);
    [[[DMAPIManager sharedManager] fetchWeiboNumWithIdstr:[self idstr]] subscribeNext:^(id x) {
        @strongify(self)
        for (NSDictionary *dic in x) {
            [self.dataDic setObject:@[dic[@"reposts"],dic[@"comments"],dic[@"attitudes"]] forKey:[dic[@"id"] stringValue]];
            if([[dic[@"id"] stringValue] isEqualToString:weiboID])
            {
                NSArray * d = [self.dataDic objectForKey:weiboID];
                success(d[0],d[1],d[2]);
            }
        }

    } error:^(NSError *error) {
        success(@(0),@(0),@(0));
    }];
    
}

@end
