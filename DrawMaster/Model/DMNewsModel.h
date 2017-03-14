//
//  DMNewsModel.h
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBaseModel.h"

@interface DMNewsModel : DMBaseModel
@property (nonatomic,readwrite,copy) NSString*title;
@property (nonatomic,readwrite,copy) NSString*detail;
@end
