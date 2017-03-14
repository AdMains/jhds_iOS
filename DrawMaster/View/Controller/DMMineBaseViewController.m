//
//  DMMineBaseViewController.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMMineBaseViewController.h"

@interface DMMineBaseViewController ()

@end

@implementation DMMineBaseViewController


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];//
    self.topBar = [[UIView alloc] init];
    {
        [self.view addSubview:self.topBar];
        [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(65);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        {
            self.titleLabel.text = @"添加版块";
            self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            self.titleLabel.textColor = mRGBToColor(0x333333);
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.topBar addSubview:self.titleLabel];
            
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(30);
                make.height.mas_equalTo(30);
            }];
            
        }
        
        UIButton * backBtn = [[UIButton alloc] init];
        {
            @weakify(self);
            [self.topBar addSubview:backBtn];
            [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            backBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
                return [RACSignal empty];
            }];
            
            [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(-10);
                make.top.mas_equalTo(30);
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(30);
            }];
            
        }
        UIView * line = [[UIView alloc] init];
        {
            [self.topBar addSubview:line];
            line.backgroundColor = mRGBToColor(0xcccccc);
           
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(64.5);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(0.5);
            }];
        }
        
    }

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
