//
//  DMShopViewModel.h
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface DMShopViewModel : RVMViewModel
- (instancetype)initWithType:(NSString *)type;
- (RACSignal*)fetchDataWithMore:(BOOL)more;
- (NSInteger)shopNum;
- (NSString*)contentWithRow:(NSInteger)row;
- (NSString*)imgUrlWithRow:(NSInteger)row;
- (NSString*)clickUrlWithRow:(NSInteger)row;
- (NSString*)ortherWithRow:(NSInteger)row;
@end
