//
//  DMWithCanvasBtnViewController.m
//  DrawMaster
//
//  Created by git on 16/6/28.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMWithCanvasBtnViewController.h"

@interface DMWithCanvasBtnViewController ()

@end

@implementation DMWithCanvasBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * gotoCanvas = [[UIButton alloc] init];
    {
        [self.view addSubview:gotoCanvas];
        gotoCanvas.clipsToBounds = YES;
        gotoCanvas.layer.backgroundColor = mRGBToColor(0x119B39).CGColor;
        gotoCanvas.alpha = 0.8;
        gotoCanvas.layer.cornerRadius = 35;
        [gotoCanvas setTitle:@"涂鸦版" forState:UIControlStateNormal];
        [gotoCanvas setTitleColor:mRGBToColor(0xeeeeee) forState:UIControlStateNormal];
        gotoCanvas.titleLabel.font = [UIFont systemFontOfSize:14];
        [gotoCanvas mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
            make.right.mas_equalTo(-8);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    [gotoCanvas addTarget:self action:@selector(gotoDraw) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gotoDraw
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"DMDrawViewController"];
    [self.navigationController pushViewController:modal animated:NO];
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

@end
