//
//  DMShareDetailViewModel.m
//  DrawMaster
//
//  Created by git on 16/10/13.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareDetailViewModel.h"
#import "DMAPIManager.h"
#import "DMShareCommentModel.h"
@interface DMShareDetailViewModel()

@property (nonatomic, readwrite,strong) NSMutableArray *commentsAry;
@property (nonatomic, readwrite,assign) NSInteger mCurPageOfComments ;
@property (nonatomic, readwrite,strong) NSMutableArray *repostsAry;
@property (nonatomic, readwrite,assign) NSInteger mCurPageOfReposts ;
@property (nonatomic, readwrite,copy) NSString * weiboIdstr;

@end
@implementation DMShareDetailViewModel

- (instancetype)initWithWeiboIdstr:(NSString *)idStr
{
    self = [super init];
    self.weiboIdstr = idStr;
    if (self) {
        self.commentsAry = [NSMutableArray array];
        self.mCurPageOfComments= 1;
        self.repostsAry = [NSMutableArray array];
        self.mCurPageOfReposts= 1;
        self.selectIndex = 12;
        self.weiboNumFetched = NO;
    }
    
    return self;
}

- (RACSignal*)fetchDataWithMore:(BOOL)more
{
    if (self.selectIndex == 12)
    {
        self.mCurPageOfComments = more ?  ++self.mCurPageOfComments:1  ;
        return [[[DMAPIManager sharedManager] fetchWeiboCommentsWithIdstr:self.weiboIdstr PageIndex:@(self.mCurPageOfComments).stringValue] map:^id(NSArray *value) {
            if(!more)
            {
                [self.commentsAry removeAllObjects];
            }
            [self.commentsAry addObjectsFromArray:value];

            return value;
        } ];
        
    }
    else
    {
        self.mCurPageOfReposts = more ?  ++self.mCurPageOfReposts:1  ;
        return [[[DMAPIManager sharedManager] fetchWeiboRepostWithIdstr:self.weiboIdstr PageIndex:@(self.mCurPageOfReposts).stringValue] map:^id(NSArray *value) {
            if(!more)
            {
                [self.repostsAry removeAllObjects];
            }
            [self.repostsAry addObjectsFromArray:value];
            
            return value;
        } ];
    }
 
}


- (NSInteger)commentNum
{
    return self.selectIndex == 12 ? self.commentsAry.count:self.repostsAry.count;
}
- (NSAttributedString *)commentTextWithIndex:(NSInteger)index
{
    DMShareCommentModel * c = [(self.selectIndex == 12 ? self.commentsAry :self.repostsAry) objectAtIndex:index];
    return c.attributedText;
}
- (NSString *)commentNickNameWithIndex:(NSInteger)index
{
    DMShareCommentModel * c = [(self.selectIndex == 12 ? self.commentsAry :self.repostsAry) objectAtIndex:index];
    return c.nickName;
}
- (NSString *)commentUserIconWithIndex:(NSInteger)index
{
    DMShareCommentModel * c = [(self.selectIndex == 12 ? self.commentsAry :self.repostsAry) objectAtIndex:index];
    return c.userIcon;
}

- (NSString *)commentTimeWithIndex:(NSInteger)index
{
    DMShareCommentModel * c = [(self.selectIndex == 12 ? self.commentsAry :self.repostsAry) objectAtIndex:index];
    return c.created_at;
}

- (CGFloat)commentTextHeightWithIndex:(NSInteger)index
{
    DMShareCommentModel * c = [(self.selectIndex == 12 ? self.commentsAry :self.repostsAry) objectAtIndex:index];
    return c.textHeight;
}

- (RACSignal*)commentWithBody:(NSString*)body
{
    return  [[[DMAPIManager sharedManager]  commentWeiboWithIdstr:self.weiboIdstr Content:body] map:^id(id value) {
        
        if(value != nil)
        {
            [self.commentsAry addObject:value];
            self.commentNum ++;
        }
        return value;
    }];
}

- (RACSignal*)repostWithBody:(NSString*)body
{
    return [[[DMAPIManager sharedManager] repostWeiboWithIdstr:self.weiboIdstr Content:body] map:^id(id value) {
        if(value != nil)
        {
            [self.repostsAry addObject:value];
            self.repostNum ++;
            
        }
        return value;

    }];
}

- (RACSignal*)fetchWeiboNum
{
    return [[[DMAPIManager sharedManager] fetchWeiboNumWithIdstr:self.weiboIdstr] map:^id(NSArray * value) {
    
        NSDictionary *item = [value objectAtIndex:0]?[value objectAtIndex:0]:@{};
        if(item.count>0)
        {
            self.repostNum = [item[@"reposts"] integerValue];
            self.commentNum = [item[@"comments"] integerValue];
            self.goodNum = [item[@"attitudes"] integerValue];
            
            self.weiboNumFetched = YES;
            return @[item[@"reposts"],item[@"comments"],item[@"attitudes"]];
        }
        else
            return @[@(0),@(0),@(0)];
        
        return value;
    }];
}

@end
