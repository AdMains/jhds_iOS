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
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"application/vnd.apple.mpegurl",@"application/octet-stream",@"text/vnd.trolltech.linguist",@"audio/x-mpegurl",nil];
        AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (type == DMAPIManagerReturnTypePlain||type == DMAPIManagerReturnTypeM3u8) {
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
    NSString * str = [NSString stringWithFormat:@"images/jhds/copy/copy_%@.txt",type];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:nil
                                 headers:nil
                              returnType:DMAPIManagerReturnTypePlain httpMethod:@"get"] map:^id(id value) {
        
        return value;
    }];

    
}

- (RACSignal *)fetchCopyListWithType:(NSString*)type PageIndex:(NSString*)page
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/copy/copy_%@_%@.txt",type,page];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:nil
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMCopyModel") fromJSONArray:value error:nil];
    }];

    
}

- (RACSignal *)fetchLearnNumWithType:(NSString*)type
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/learn_%@.txt",type];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:nil
                                 headers:nil
                              returnType:DMAPIManagerReturnTypePlain httpMethod:@"get"] map:^id(id value) {
        
        return value;
    }];
    
    
}

- (RACSignal *)fetchLearnListWithType:(NSString*)type PageIndex:(NSString*)page
{
    NSString * str = [NSString stringWithFormat:@"images/jhds/learn_%@_%@.txt",type,page];
    return [[self fetchDataWithURLString:mUrlString(str)
                                  params:nil
                                 headers:nil
                              returnType:DMAPIManagerReturnTypeArray httpMethod:@"get"] map:^id(id value) {
        
        return [MTLJSONAdapter modelsOfClass:objc_getClass("DMLearnModel") fromJSONArray:value error:nil];
    }];
}



@end
