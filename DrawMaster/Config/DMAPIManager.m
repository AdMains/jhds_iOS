//
//  DMAPIManager.m
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMAPIManager.h"

@implementation DMAPIManager

+ (instancetype)sharedManager
{
    static DMAPIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return instance;
}

-(instancetype)init{
    
    self=[super init];
    if(self){
    }
    return  self;
}

- (RACSignal *)fetchDataWithURLString:(NSString *)urlString params:(NSDictionary *)parameters headers:(NSDictionary*)headers returnType:(DMAPIReturnType)type httpMethod:(NSString *)method{
    
    BOOL errorReturnCache = [parameters objectForKey:@"errorReturnCache"]?[[parameters objectForKey:@"errorReturnCache"] boolValue] :NO;
    
    NSString * savePath = [kDocuments stringByAppendingPathComponent:[urlString componentsSeparatedByString:@"/"].lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:savePath])
    {
        errorReturnCache = NO;
    }
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:urlString
                                                                  parameters:parameters error:nil];
    if(type == DMAPIManagerReturnTypeData)
        request.timeoutInterval = 120;
    if(headers)
    {
        for (NSString * key in headers) {
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"application/vnd.apple.mpegurl",@"application/octet-stream",@"image/jpeg",@"text/vnd.trolltech.linguist",@"audio/x-mpegurl",nil];
        AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (type == DMAPIManagerReturnTypePlain||type == DMAPIManagerReturnTypeM3u8) {
                
                NSDictionary *result = @{@"data":operation.responseString};
                
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:result];
                [data writeToFile:savePath atomically:YES];
                
                [subscriber sendNext:operation.responseString];
                [subscriber sendCompleted];
            }
            else if (type == DMAPIManagerReturnTypeData) {
                [subscriber sendNext:operation.responseData];
                [subscriber sendCompleted];
            }
            else
            {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                id dict= nil;//[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                
                if (data) {
                    if ([data length] > 0) {
                        dict = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                    } else if(!errorReturnCache){
                        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                    }
                    else
                    {
                        [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                        [subscriber sendCompleted];
                        
                    }
                }
                
                if(![dict isKindOfClass:[NSDictionary class]] &&type == DMAPIManagerReturnTypeDic)
                {
                    if(!errorReturnCache){
                        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                    }
                    else
                    {
                        [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                        [subscriber sendCompleted];
                        
                    }
                    
                }
                else if(![dict isKindOfClass:[NSArray class]] &&type == DMAPIManagerReturnTypeArray)
                {
                    if(!errorReturnCache){
                        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                    }
                    else
                    {
                        [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                        [subscriber sendCompleted];
                        
                    }
                    
                }
                else if(![dict isKindOfClass:[NSString class]] &&type == DMAPIManagerReturnTypeStr)
                {
                    if(!errorReturnCache){
                        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                    }
                    else
                    {
                        [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                        [subscriber sendCompleted];
                        
                    }
                    
                }
                else if(![dict isKindOfClass:[NSValue class]] &&type == DMAPIManagerReturnTypeValue)
                {
                    if(!errorReturnCache){
                        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                    }
                    else
                    {
                        
                        [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                        [subscriber sendCompleted];
                        
                    }
                    
                }
                else
                {
                    NSDictionary *result = @{@"data":dict};
                    
                    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:result];
                    [data writeToFile:savePath atomically:YES];
                    
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                }
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if(!errorReturnCache){
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                [subscriber sendCompleted];
                
            }
            
            
            
        }];
        
        
        [self.operationQueue addOperation:operation];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]  doError:^(NSError *error) {
        
    }];
    
    
    
}


- (RACSignal *)fetchCopyNumWithType:(NSString*)type
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/copy_%@.txt",type];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypePlain httpMethod:@"get"] map:^id(id value) {
        
        return value;
    }];

    
}

- (RACSignal *)fetchCopyListWithType:(NSString*)type PageIndex:(NSString*)page
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/copy_%@_%@.txt",type,page];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMCopyModel") fromJSONArray:value error:nil];
    }];

    
}

- (RACSignal *)fetchLearnNumWithType:(NSString*)type
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/learn_%@.txt",type];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypePlain httpMethod:@"get"] map:^id(id value) {
        
        return value;
    }];
    
    
}

- (RACSignal *)fetchLearnListWithType:(NSString*)type PageIndex:(NSString*)page
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/learn_%@_%@.txt",type,page];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMLearnModel") fromJSONArray:value error:nil];
    }];
}

- (RACSignal *)fetchShopNumWithType:(NSString*)type
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/shop_%@.txt",type];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypePlain httpMethod:@"get"] map:^id(id value) {
        
        return value;
    }];
    
    
}

- (RACSignal *)fetchShopListWithType:(NSString*)type PageIndex:(NSString*)page
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/shop_%@_%@.txt",type,page];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMShopModel") fromJSONArray:value error:nil];
    }];
}


- (RACSignal *)fetchNewsList
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/message.txt"];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMNewsModel") fromJSONArray:value error:nil];
    }];
}

- (RACSignal *)fetchProtectBabyList
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/protectBaby.txt"];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMNewsModel") fromJSONArray:value error:nil];
    }];
}

- (RACSignal *)fetchSplashData
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/splash.txt"];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeDic httpMethod:@"get"] map:^id(NSDictionary* value) {
        
        NSString *imgUrl = [value objectForKey:@"img"] ;
        NSString * localImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMSplashImgUrl"];
        if(localImg == nil)
        {
            [self saveSplashInfoAndImageWithDic:value];
        }
        else if(![imgUrl isEqualToString:localImg])
        {
            [self saveSplashInfoAndImageWithDic:value];
        }
        return value;
        
    }];
}

- (RACSignal *)fetchMessageTag
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/messageTag.txt"];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeDic httpMethod:@"get"] map:^id(NSDictionary* value) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[value objectForKey:@"appiOSVersion"] forKey:@"DMAppVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:[value objectForKey:@"shopTag"] forKey:@"DMShopTag"];
        [[NSUserDefaults standardUserDefaults] setObject:[value objectForKey:@"messageTag"] forKey:@"DMMessageTag"];
        [[NSUserDefaults standardUserDefaults] setObject:[value objectForKey:@"protectBabyTag"] forKey:@"DMProtectBabyTag"];
        
        return value;
        
    }];

    
}

- (void)saveSplashInfoAndImageWithDic:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"img"] forKey:@"DMSplashImgUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"detail"] forKey:@"DMSplashClickUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"type"] forKey:@"DMSplashType"];
    
    [[self fetchDataWithURLString:[dic objectForKey:@"img"] params:nil headers:nil returnType:DMAPIManagerReturnTypeData httpMethod:@"get"] subscribeNext:^(NSData *imgData) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString * FolderName = [NSString stringWithFormat:@"%@/jhdsSplashImg",kDocuments];
        NSError *error;
        if (![fileManager fileExistsAtPath:FolderName]) {
            
            [fileManager createDirectoryAtPath:FolderName withIntermediateDirectories:NO attributes:nil error:&error];
        }
        NSString * imageSavePath = [NSString stringWithFormat:@"%@/jhdsSplashImg/%@",kDocuments,[[dic objectForKey:@"img"] qgocc_stringFromMD5]];
        
        //UIImageWriteToSavedPhotosAlbum([ UIImage grabImageWithView:self.captureBoxView scale:2], self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        
        if([imgData writeToFile:imageSavePath atomically:YES])
        {
            //NSLog(@"闪屏页图片保存成功") ;
        }
        else
        {
            //NSLog(@"闪屏页图片保存失败") ;
        }
        
    } error:^(NSError *error) {
        NSLog(@"闪屏页图片获取失败") ;
    }];

}


+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}


- (RACSignal *)fetchShareNum
{
    
    NSString * str = [NSString stringWithFormat:@"images/jhds/weibo/weibo_num.txt"];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypePlain httpMethod:@"get"] map:^id(id value) {
        
        return value;
    }];
    
}

- (RACSignal *)fetchShareListWithPageIndex:(NSString*)page
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/weibo/weibo_%@.txt",page];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMShareModel") fromJSONArray:value error:nil];
    }];
}

- (RACSignal *)fetchWeiboNumWithIdstr:(NSString*)idstr
{
    
    
    return [[self fetchDataWithURLString:@"https://api.weibo.com/2/statuses/count.json"
                                  params:@{@"ids":idstr,
                                           @"access_token": [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"]}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        NSDictionary *item = [value objectAtIndex:0]?[value objectAtIndex:0]:@{};
        if(item.count>0)
        {
            return @[item[@"reposts"],item[@"comments"],item[@"attitudes"]];
        }
        else
            return @[@(0),@(0),@(0)];
        
    }];
    
}

- (RACSignal *)fetchWeiboCommentsWithIdstr:(NSString*)idstr PageIndex:(NSString*)page
{
    
    return [[self fetchDataWithURLString:@"https://api.weibo.com/2/comments/show.json"
                                  params:@{@"id":idstr,
                                           @"page":page,
                                           @"access_token": [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"]}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeDic httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMShareCommentModel") fromJSONArray:[value objectForKey:@"comments"]error:nil];

    }];

}

- (RACSignal *)fetchWeiboRepostWithIdstr:(NSString*)idstr PageIndex:(NSString*)page
{
    return [[self fetchDataWithURLString:@"https://api.weibo.com/2/statuses/repost_timeline.json"
                                  params:@{@"id":idstr,
                                           @"page":page,
                                           @"access_token": [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"]}
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeDic httpMethod:@"get"] map:^id(id value) {
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMShareCommentModel") fromJSONArray:[value objectForKey:@"reposts"]error:nil];

    }];

}
@end
