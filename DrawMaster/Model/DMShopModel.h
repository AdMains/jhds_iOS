//
//  DMShopModel.h
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBaseModel.h"

@interface DMShopModel : DMBaseModel
@property (nonatomic,readwrite,copy) NSString*content;
@property (nonatomic,readwrite,copy) NSString*imgUrl;
@property (nonatomic,readwrite,copy) NSString*clickUrl;
@property (nonatomic,readwrite,copy) NSString*orther;
@end

