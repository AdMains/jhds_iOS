//
//  DMLearnModel.h
//  DrawMaster
//
//  Created by git on 16/6/24.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBaseModel.h"

@interface DMLearnModel : DMBaseModel
@property (nonatomic,readwrite,copy) NSString *url;
@property (nonatomic,readwrite,copy) NSArray* detail;
@property (nonatomic,readwrite,copy) NSString *type;
@property (nonatomic,readwrite,copy) NSString *size;
@property (nonatomic,readwrite,copy) NSString *info;
@property (nonatomic,readwrite,copy) NSString *stdNum;
@end
