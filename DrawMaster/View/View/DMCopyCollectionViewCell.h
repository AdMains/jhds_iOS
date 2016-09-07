//
//  DMCopyCollectionViewCell.h
//  DrawMaster
//
//  Created by git on 16/6/24.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCopyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *tipLable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingAI;

@end
