//
//  DMLearnViewModel.h
//  DrawMaster
//
//  Created by git on 16/6/24.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface DMLearnViewModel : RVMViewModel
- (instancetype)initWithType:(NSString *)type;
- (RACSignal*)fetchDataWithMore:(BOOL)more;

- (NSInteger)learnNum;
- (NSString *)urlLearnWithIndex:(NSInteger)index;
- (NSArray *)detailLearnWithIndex:(NSInteger)index;
- (NSString *)typeLearnWithIndex:(NSInteger)index;
- (NSString *)infoLearnWithIndex:(NSInteger)index;
- (NSString *)sizeOfLearnWithIndex:(NSInteger)index;
@end
