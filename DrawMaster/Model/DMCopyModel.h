//
//  DMCopyModel.h
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBaseModel.h"

@interface DMCopyModel : DMBaseModel
@property (nonatomic,readwrite,copy) NSString * url;
@property (nonatomic,readwrite,copy) NSString * detail;
@property (nonatomic,readwrite,copy) NSString * type;
@end
