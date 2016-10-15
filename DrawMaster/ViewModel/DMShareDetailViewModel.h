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
- (instancetype)initWithWeiboIdstr:(NSString *)idStr;

- (RACSignal*)fetchDataWithMore:(BOOL)more;

- (NSInteger)commentNum;
- (NSAttributedString *)commentTextWithIndex:(NSInteger)index;
- (NSString *)commentNickNameWithIndex:(NSInteger)index;
- (NSString *)commentUserIconWithIndex:(NSInteger)index;
- (NSString *)commentTimeWithIndex:(NSInteger)index;
- (CGFloat)commentTextHeightWithIndex:(NSInteger)index;

@end
