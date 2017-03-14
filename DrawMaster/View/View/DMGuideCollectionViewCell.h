//
//  DMGuideCollectionViewCell.h
//  DrawMaster
//
//  Created by git on 16/7/6.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMGuideCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *guideTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryBtn;
@property (weak, nonatomic) IBOutlet UILabel *shakeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
