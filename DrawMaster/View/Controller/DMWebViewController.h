//
//  DMWebViewController.h
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMMineBaseViewController.h"

@interface DMWebViewController : DMMineBaseViewController
@property (nonatomic,readwrite,strong) NSString*detailUrl;
@property (nonatomic,readwrite,strong) NSString*detailTitle;
@property (nonatomic,readwrite,assign) BOOL canShare;
@end
