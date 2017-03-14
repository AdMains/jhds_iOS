//
//  DMShareViewModel.h
//  DrawMaster
//
//  Created by git on 16/8/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface DMShareViewModel : RVMViewModel
- (instancetype)init;
- (RACSignal*)fetchDataWithMore:(BOOL)more;
- (NSInteger)shareNum;
- (NSAttributedString*)contentWithRow:(NSInteger)row;
- (CGFloat)contentHeightWithRow:(NSInteger)row;
- (NSString*)nickNameWithRow:(NSInteger)row;
- (NSString*)idstrWithRow:(NSInteger)row;
- (NSString*)idstr;
- (NSString*)userIconWithRow:(NSInteger)row;
- (NSArray*)picIDsWithRow:(NSInteger)row;
- (NSArray*)smallPicsWithRow:(NSInteger)row;
- (NSArray*)bigPicsWithRow:(NSInteger)row;
- (NSString*)createTimeWithRow:(NSInteger)row;
-(void)fetchWeiboNum:(NSString*)weiboID success:(void (^)( NSNumber *repostNum,NSNumber *commentNum,NSNumber *attributeNum))success;

@end
