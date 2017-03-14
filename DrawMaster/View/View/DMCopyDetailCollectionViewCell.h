//
//  DMCopyDetailCollectionViewCell.h
//  DrawMaster
//
//  Created by git on 16/7/4.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCopyDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UIView *loadingBoxView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadAI;
@property (weak, nonatomic) IBOutlet UILabel *loadingTip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgHeight;

@end
