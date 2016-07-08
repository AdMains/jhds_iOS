//
//  DMNavigationController.m
//  DrawMaster
//
//  Created by git on 16/7/8.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMNavigationController.h"

@interface DMNavigationController ()<UINavigationControllerDelegate>

@end

@implementation DMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)resetDelegate
{
    self.delegate = self;
}
@end
