//
//  DMSplashViewController.m
//  DrawMaster
//
//  Created by git on 16/6/22.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMSplashViewController.h"
#define degressToRadius(ang) (M_PI*(ang)/180.0f)
#define kskipBtnRadius 18
@interface DMSplashViewController ()
@property (nonatomic,readwrite,strong) UIButton * skipBtn;
@end

@implementation DMSplashViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];//
    
    UIImageView * image = [[UIImageView alloc] init];
    {
        image.image =  [UIImage imageNamed:@"eduHome2"];
        [self.view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-100);
        }];
    }
    
    self.skipBtn = [[UIButton alloc] init];
    {
        self.skipBtn.alpha = 0.7;
        self.skipBtn.layer.backgroundColor = mRGBToColor(0x333333).CGColor;
        [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        self.skipBtn.layer.cornerRadius = kskipBtnRadius;
        [self.skipBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.view addSubview:self.skipBtn];
        [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kskipBtnRadius*2);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(kskipBtnRadius*2);
        }];
        self.skipBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.skipBtn.tag = 1;
            [self goToHome];
            return [RACSignal empty];
        }];
        [self skipButtonBorderAnimation:self.skipBtn withDurationTime:2500];

    }
    
    UIView *bottomBox = [[UIView alloc] init];
    {
        [self.view addSubview:bottomBox];
        bottomBox.backgroundColor = mRGBToColor(0xf0f0f0);
        [bottomBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(100);
            make.bottom.mas_equalTo(0);
        }];
        
        UIImageView * image = [[UIImageView alloc] init];
        {
            image.image =  [UIImage imageNamed:@"icon"];
            [bottomBox addSubview:image];
            image.layer.cornerRadius = 25;
            image.clipsToBounds = YES;
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
                make.top.mas_equalTo(15);
                make.left.mas_equalTo((mScreenWidth-100-50-80)/2);
            }];
        }
        
        UILabel * appName = [[UILabel alloc] init];
        {
            appName.text = @"简画大师 |";
            appName.textColor = mRGBToColor(0x222222);
            appName.font = [UIFont systemFontOfSize:18];
            [bottomBox addSubview:appName];
            [appName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(50);
                make.top.mas_equalTo(15);
                make.left.equalTo(image.mas_right).offset(10);
            }];
        }
        
        UILabel * shortName = [[UILabel alloc] init];
        {
            shortName.text = @"有笔格";
            shortName.textColor = mRGBToColor(0xdf0526);
            shortName.font = [UIFont systemFontOfSize:14];
            [bottomBox addSubview:shortName];
            [shortName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(70);
                make.height.mas_equalTo(50);
                make.top.mas_equalTo(15);
                make.left.equalTo(appName.mas_right);
            }];
        }

        UILabel * workerName = [[UILabel alloc] init];
        {
            workerName.text = @"泉哥工作室出品";
            workerName.textColor = mRGBToColor(0xbbbbbb);
            workerName.font = [UIFont systemFontOfSize:12];
            workerName.textAlignment = NSTextAlignmentCenter;
            [bottomBox addSubview:workerName];
            [workerName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(30);
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

- (void)goToHome
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"appHome"];
    [self.navigationController pushViewController:modal animated:NO];
}


- (void)skipButtonBorderAnimation:(UIButton *)skipButton withDurationTime:(CGFloat)duration
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:skipButton.center radius:kskipBtnRadius startAngle:degressToRadius(-90) endAngle:degressToRadius(270) clockwise:YES];
    
    CAShapeLayer * progressLayer;
    progressLayer = [CAShapeLayer layer];
    progressLayer.frame =CGRectMake(kskipBtnRadius, kskipBtnRadius, kskipBtnRadius, kskipBtnRadius);
    progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    progressLayer.strokeColor=[UIColor redColor].CGColor;
    progressLayer.lineCap = kCALineCapButt;
    progressLayer.lineWidth = 2;
    [skipButton.layer addSublayer:progressLayer];
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeStart"];
    pathAnimation.duration = duration/1000.0;
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses=NO;
    pathAnimation.repeatCount = 1;
    progressLayer.path=path.CGPath;
    [progressLayer addAnimation:pathAnimation forKey:@"strokeStartAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((pathAnimation.duration - 0.3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [progressLayer removeFromSuperlayer];
        if(self.skipBtn.tag != 1)
        {
            [self goToHome];
        }
    });
    
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
