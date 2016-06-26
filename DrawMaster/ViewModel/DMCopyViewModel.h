//
//  DMCopyViewModel.h
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface DMCopyViewModel : RVMViewModel
- (instancetype)initWithType:(NSString *)type;
- (RACSignal*)fetchDataWithMore:(BOOL)more;

- (NSInteger)copyNum;
- (NSString *)urlCopyWithIndex:(NSInteger)index;
- (NSString *)detailCopyWithIndex:(NSInteger)index;
- (NSString *)typeCopyWithIndex:(NSInteger)index;
@end
