//
//  DMShareNumView.m
//  DrawMaster
//
//  Created by git on 16/8/16.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareNumView.h"
@interface DMShareNumView ()
@property (readwrite, nonatomic, strong) AFHTTPRequestOperation *weiboNumRequestOperation;
@property (readwrite,nonatomic, strong) NSMutableDictionary* dataDic;
@end


@implementation DMShareNumView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.dataDic = [NSMutableDictionary dictionary];
   
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataDic = [NSMutableDictionary dictionary];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (NSOperationQueue *)DM_sharedWeiboNumRequestOperationQueue {
    static NSOperationQueue *_DM_sharedWeiboNumRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DM_sharedWeiboNumRequestOperationQueue = [[NSOperationQueue alloc] init];
        _DM_sharedWeiboNumRequestOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
       
    });
    
    return _DM_sharedWeiboNumRequestOperationQueue;
}

-(void)fetchWeiboNum:(NSString*)weiboID  idStr:(NSString*)str success:(void (^)( NSNumber *repostNum,NSNumber *commentNum,NSNumber *attributeNum))success
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
    [self cancelImageRequestOperation];
    //[[NSUserDefaults standardUserDefaults] setObject:self.wbtoken forKey:@"DMWeiboAccessToken"];
    NSLog(@"++++++++请求了微博的%@数目",weiboID);
    NSString * urlStr = @"https://api.weibo.com/2/statuses/count.json";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *urlRequest = [manager.requestSerializer requestWithMethod:@"get"
                                                                         URLString:urlStr
                                                                        parameters:@{@"ids":str,
                                                                                     @"access_token": [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"]}  error:nil];
    urlRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    __weak __typeof(self)weakSelf = self;
    self.weiboNumRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    self.weiboNumRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.weiboNumRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[urlRequest URL] isEqual:[strongSelf.weiboNumRequestOperation.request URL]]) {
            NSArray* d = (NSArray*)responseObject;
            
            for (NSDictionary *dic in d) {
                [strongSelf.dataDic setObject:@[dic[@"reposts"],dic[@"comments"],dic[@"attitudes"]] forKey:[dic[@"id"] stringValue]];
                if([[dic[@"id"] stringValue] isEqualToString:weiboID])
                {
                    NSArray * d = [strongSelf.dataDic objectForKey:weiboID];
                    success(d[0],d[1],d[2]);
                }
            }
            
            if (operation == strongSelf.weiboNumRequestOperation){
                strongSelf.weiboNumRequestOperation = nil;
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[urlRequest URL] isEqual:[strongSelf.weiboNumRequestOperation.request URL]]) {
            
            if (operation == strongSelf.weiboNumRequestOperation){
                strongSelf.weiboNumRequestOperation = nil;
            }
        }
    }];
    
    [[[self class] DM_sharedWeiboNumRequestOperationQueue] addOperation:self.weiboNumRequestOperation];

    
    
}

- (void)cancelImageRequestOperation {
    [self.weiboNumRequestOperation cancel];
    self.weiboNumRequestOperation = nil;
}
@end
