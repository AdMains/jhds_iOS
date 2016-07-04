//
//  DMDrawViewController.h
//  DrawMaster
//
//  Created by git on 16/6/28.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBrushView.h"
@interface DMDrawViewController : UIViewController
@property (nonatomic,readwrite,strong) IBOutlet UIView * captureBoxView;
@property (weak, nonatomic) IBOutlet DMBrushView *brushView;
@end
