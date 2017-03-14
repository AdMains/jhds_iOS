//
//  DMShareDetailViewController.h
//  DrawMaster
//
//  Created by git on 16/9/20.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMShareDetailViewModel.h"
@interface DMShareDetailViewController : UIViewController
@property (nonatomic,readwrite,assign) CGFloat headHeight;
@property (nonatomic,readwrite,strong) NSString* headNickName;
@property (nonatomic,readwrite,strong) NSString* headUserIcon;
@property (nonatomic,readwrite,strong) NSString* headCreateAtTime;
@property (nonatomic,readwrite,strong) NSAttributedString* headShareText;
@property (nonatomic,readwrite,strong) NSArray* headSmallPic;
@property (nonatomic,readwrite,strong) NSArray* headBigPic;
@property (nonatomic,readwrite,strong) NSString* weiboIdstr;
@property (nonatomic,readwrite,assign) BOOL logined;
@property (nonatomic,readwrite,assign) NSUInteger selectMenumIndex;
@property (nonatomic,readwrite,strong) DMShareDetailViewModel* viewModel;
@end
