//
//  DMShareDetailViewModel.h
//  DrawMaster
//
//  Created by git on 16/10/13.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface DMShareDetailViewModel : RVMViewModel
@property (nonatomic,readwrite,assign) NSInteger selectIndex;
@property (nonatomic,readwrite,assign) NSInteger repostNum;
@property (nonatomic,readwrite,assign) NSInteger commentNum;
@property (nonatomic,readwrite,assign) NSInteger goodNum;
@property (nonatomic,readwrite,assign) BOOL weiboNumFetched;;

- (instancetype)initWithWeiboIdstr:(NSString *)idStr;

- (RACSignal*)fetchDataWithMore:(BOOL)more;
- (RACSignal*)commentWithBody:(NSString*)body;
- (RACSignal*)repostWithBody:(NSString*)body;
- (RACSignal*)fetchWeiboNum;


- (NSInteger)commentNum;
- (NSAttributedString *)commentTextWithIndex:(NSInteger)index;
- (NSString *)commentNickNameWithIndex:(NSInteger)index;
- (NSString *)commentUserIconWithIndex:(NSInteger)index;
- (NSString *)commentTimeWithIndex:(NSInteger)index;
- (CGFloat)commentTextHeightWithIndex:(NSInteger)index;

@end
