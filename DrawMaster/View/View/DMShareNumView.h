//
//  DMShareNumView.h
//  DrawMaster
//
//  Created by git on 16/8/16.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMShareNumView : UIView
-(void)fetchWeiboNum:(NSString*)weiboID success:(void (^)( NSNumber *repostNum,NSNumber *commentNum,NSNumber *attributeNum))success;
@end
