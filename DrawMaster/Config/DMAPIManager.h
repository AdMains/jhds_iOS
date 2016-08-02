//
//  DMAPIManager.h
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef NS_ENUM(NSInteger, DMAPIReturnType)
{
    DMAPIManagerReturnTypeDic,
    DMAPIManagerReturnTypeArray,
    DMAPIManagerReturnTypeStr,
    DMAPIManagerReturnTypeValue,
    DMAPIManagerReturnTypePlain,
    DMAPIManagerReturnTypeM3u8,
    DMAPIManagerReturnTypeData
    
};

@interface DMAPIManager : AFHTTPRequestOperationManager
+ (instancetype)sharedManager;

- (RACSignal *)fetchCopyNumWithType:(NSString*)type;
- (RACSignal *)fetchCopyListWithType:(NSString*)type PageIndex:(NSString*)page;

- (RACSignal *)fetchLearnNumWithType:(NSString*)type;
- (RACSignal *)fetchLearnListWithType:(NSString*)type PageIndex:(NSString*)page;

- (RACSignal *)fetchProtectBabyList;
- (RACSignal *)fetchNewsList;

- (RACSignal *)fetchShopNumWithType:(NSString*)type;
- (RACSignal *)fetchShopListWithType:(NSString*)type PageIndex:(NSString*)page;

- (RACSignal *)fetchSplashData;
- (RACSignal *)fetchMessageTag;

- (RACSignal *)fetchShareNum;
- (RACSignal *)fetchShareListWithPageIndex:(NSString*)page;
+ (ALAssetsLibrary *)defaultAssetsLibrary;
@end
