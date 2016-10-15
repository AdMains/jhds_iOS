//
//  DMShareCommentModel.h
//  DrawMaster
//
//  Created by git on 16/10/13.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBaseModel.h"

@interface DMShareCommentModel : DMBaseModel
@property (nonatomic,readwrite,copy) NSString * text;
@property (nonatomic,readwrite,copy) NSString * created_at;
@property (nonatomic,readwrite,copy) NSString * nickName;
@property (nonatomic,readwrite,copy) NSString * userIcon;
@property (nonatomic,readwrite,strong) NSDictionary * user;
@property (nonatomic,readwrite,strong) NSAttributedString * attributedText;
@property (nonatomic,readwrite,assign) CGFloat textHeight;
@end
