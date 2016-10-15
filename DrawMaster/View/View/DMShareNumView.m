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

@end


@implementation DMShareNumView

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

-(void)fetchWeiboNum:(NSString*)weiboID success:(void (^)( NSNumber *repostNum,NSNumber *commentNum,NSNumber *attributeNum))success
{
    if(weiboID ==nil)
    {
        success(@(0),@(0),@(0));
        return;
    }
    [self cancelImageRequestOperation];
    //[[NSUserDefaults standardUserDefaults] setObject:self.wbtoken forKey:@"DMWeiboAccessToken"];
    NSString * urlStr = @"https://api.weibo.com/2/statuses/count.json";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *urlRequest = [manager.requestSerializer requestWithMethod:@"get"
                                                                         URLString:urlStr
                                                                        parameters:@{@"ids":weiboID,
                                                                                     @"access_token": [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"]}  error:nil];
    urlRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    __weak __typeof(self)weakSelf = self;
    self.weiboNumRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    self.weiboNumRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.weiboNumRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[urlRequest URL] isEqual:[strongSelf.weiboNumRequestOperation.request URL]]) {
            NSArray* d = (NSArray*)responseObject;
            
            NSDictionary *item = d[0]?d[0]:@{};
            if (success && item.count>0) {
                success(item[@"reposts"],item[@"comments"],item[@"attitudes"]);
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
