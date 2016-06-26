//
//  DMLearnSubViewController.h
//  DrawMaster
//
//  Created by git on 16/6/24.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMLearnViewModel.h"
@interface DMLearnSubViewController : UIViewController
@property (nonatomic,readwrite,strong) UICollectionView * collecttionView;
@property (nonatomic,readwrite,strong) DMLearnViewModel * viewModel;
@end
