//
//  DMHomeViewController.m
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMHomeViewController.h"

@interface DMHomeViewController ()<UINavigationControllerDelegate>

@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *subs = self.childViewControllers;
    for (UIViewController *sub in subs) {
        if([NSStringFromClass([sub class]) isEqualToString:@"DMCopyViewController"])
        {
            sub.tabBarItem.image = [mImageByName(@"home_copy") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            sub.tabBarItem.selectedImage = [mImageByName(@"home_copy_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            sub.title = @"临摹";

        }
        else if([NSStringFromClass([sub class]) isEqualToString:@"DMLearnViewController"])
        {
            sub.tabBarItem.image = [mImageByName(@"home_learn") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

            sub.tabBarItem.selectedImage = [mImageByName(@"home_learn_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

            sub.title = @"教程";
        }
        else
        {
            sub.tabBarItem.image = [mImageByName(@"home_mine") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

            sub.tabBarItem.selectedImage = [mImageByName(@"home_mine_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            sub.title = @"我的";
        }
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
