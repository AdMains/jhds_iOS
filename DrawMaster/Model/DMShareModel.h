//
//  DMShareModel.h
//  DrawMaster
//
//  Created by git on 16/8/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBaseModel.h"

@interface DMShareModel : DMBaseModel
@property (nonatomic,readwrite,copy) NSString * idstr;
@property (nonatomic,readwrite,copy) NSString * text;
@property (nonatomic,readwrite,copy) NSString * original_pic;
@property (nonatomic,readwrite,copy) NSString * nickName;
@property (nonatomic,readwrite,copy) NSString * userId;
@property (nonatomic,readwrite,copy) NSString * userIcon;
@property (nonatomic,readwrite,copy) NSString * created_timestamp;
@property (nonatomic,readwrite,strong) NSArray * pic_ids;
@property (nonatomic,readwrite,strong) NSAttributedString * attributedText;
@property (nonatomic,readwrite,strong) NSArray * smallPics;
@property (nonatomic,readwrite,strong) NSArray * bigPics;
@property (nonatomic,readwrite,assign) CGFloat textHeight;
@end
