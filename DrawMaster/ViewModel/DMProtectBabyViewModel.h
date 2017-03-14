//
//  DMProtectBabyViewModel.h
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface DMProtectBabyViewModel : RVMViewModel
- (RACSignal*)fetchData;

- (NSInteger)newsNum;
- (NSString*)newsTitleWithRow:(NSInteger)row;
- (NSString*)newsDetailWithRow:(NSInteger)row;
@end
