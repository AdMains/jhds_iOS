//
//  DMCopySubViewController.h
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMCopyViewModel.h"
@interface DMCopySubViewController : UIViewController
@property (nonatomic,readwrite,strong) UICollectionView * collecttionView;
@property (nonatomic,readwrite,strong) DMCopyViewModel * viewModel;
@end
