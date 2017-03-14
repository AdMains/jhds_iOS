//
//  DMBigImgBoxView.h
//  DrawMaster
//
//  Created by git on 16/7/4.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYAnimatedPageControl.h"

@protocol DMBigImgBoxViewDelegate <NSObject>

- (void)clickImg:(BOOL)fullScree row:(NSInteger )r;

@end

@interface DMBigImgBoxView : UIView
@property (nonatomic, weak) id <DMBigImgBoxViewDelegate> delegate;
@property (nonatomic,readwrite,strong) NSArray * imgUrls;
@property (nonatomic,readwrite,strong) UIButton * tryBtn;
@property (nonatomic,readwrite,strong) KYAnimatedPageControl *pageControl;
@property (nonatomic,readwrite,strong) UICollectionView *collecttionView;
@property (nonatomic,readwrite,strong) NSNumber * fullScreen;

- (void)gotoIndexWithRow:(NSInteger)row;
@end
