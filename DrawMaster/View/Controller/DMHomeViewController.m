//
//  DMHomeViewController.m
//  DrawMaster
//
//  Created by git on 16/6/23.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMHomeViewController.h"
#import "DMAPIManager.h"
#import "DMNavigationController.h"
#import "DMSplashViewController.h"
#import "DMWebViewController.h"
#import "UITabBar+RedDot.h"
@interface DMHomeViewController ()<UINavigationControllerDelegate>

@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    
    [[[DMAPIManager sharedManager] fetchSplashData] subscribeNext:^(id x) {
        //NSLog(@"闪屏页数据偷偷加载完成");
    }];
    [[[DMAPIManager sharedManager] fetchMessageTag] subscribeNext:^(id x) {
        //NSLog(@"闪屏页数据偷偷加载完成");
    }];
    
    
    NSString* firstInstall = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMFirstInstall"];
    if(firstInstall==nil)
    {
        [[NSUserDefaults standardUserDefaults]  setObject:@"YES" forKey:@"DMFirstInstall"];
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:1 atIndex:2];
    }
    else
    {
        NSString * oldMessageTag =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMOldMessageTag"];
        if(oldMessageTag == nil)
        {
            [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:1 atIndex:2];
        }
        else
        {
            [self updateTip];
        }
    }
    
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTip) name:@"updateRedTip" object:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [(DMNavigationController*)self.navigationController resetDelegate];
    DMSplashViewController* first = self.navigationController.childViewControllers[0];
    if(first.view.tag==11)
    {
        NSString * clickurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMSplashClickUrl"];
        DMWebViewController *modal =  [[DMWebViewController alloc] init];
        modal.detailUrl = clickurl;
        modal.detailTitle = @"守护宝贝,爱心接力 ";
        modal.canShare = YES;
        [self.navigationController pushViewController:modal animated:NO];
    }
    
}

- (void)updateTip
{
    NSString * oldMessageTag =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMOldMessageTag"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString * oldShopTag =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMOldShopTag"];
    NSString * oldProtectBabyTag =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMOldProtectBabyTag"];
    
    NSString * newShopTag =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMShopTag"];
    NSString * newProtectBabyTag =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMProtectBabyTag"];
    NSString * newAppVersion =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMAppVersion"];
    NSString * newMessageTag =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"DMMessageTag"];
    
    if([app_Version floatValue]<[newAppVersion floatValue] ||
       ![oldMessageTag isEqualToString:newMessageTag] ||
       ![oldShopTag isEqualToString:newShopTag] ||
       ![oldProtectBabyTag isEqualToString:newProtectBabyTag]
       
       )
    {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:1 atIndex:2];
    }
    else
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:1 atIndex:2];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
