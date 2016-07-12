//
//  DMSplashViewController.m
//  DrawMaster
//
//  Created by git on 16/6/22.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMSplashViewController.h"
#import "DMGuideCollectionViewCell.h"
#import "KYAnimatedPageControl.h"
#import "DMWebViewController.h"
#define degressToRadius(ang) (M_PI*(ang)/180.0f)
#define kskipBtnRadius 18
@interface DMSplashViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,readwrite,strong) UIButton * skipBtn;
@property (nonatomic,readwrite,strong) UIView *guideBoxView;
@property (nonatomic,readwrite,strong) UICollectionView *collecttionView;
@property (nonatomic,readwrite,strong) NSArray* guideData;
@property (nonatomic,readwrite,strong) KYAnimatedPageControl *pageControl;
@end

@implementation DMSplashViewController

- (void)loadView
{
    [super loadView];
    [MobClick event:@"splash"];
    self.view.backgroundColor = [UIColor whiteColor];//
    @weakify(self)
    NSString* firstInstall = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMFirstInstall"];
    if(firstInstall != nil)
    {
        UIImageView * image = [[UIImageView alloc] init];
        {
            image.contentMode =UIViewContentModeScaleAspectFill;
            NSString * localImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMSplashImgUrl"];
            NSString * imageSavePath = [NSString stringWithFormat:@"%@/jhdsSplashImg/%@",kDocuments,[localImg qgocc_stringFromMD5]];
            if(localImg != nil)
                image.image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:imageSavePath]];
            [self.view addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(-100);
            }];
            
            NSNumber * splashType = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMSplashType"];
            if(splashType != nil)
            {
                image.userInteractionEnabled = YES;
                NSString * clickurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMSplashClickUrl"];
                
                switch ([splashType integerValue]) {
                    case -1:
                        
                        break;
                    case 0:
                    {
                        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
                        [image addGestureRecognizer:tap];
                        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer *x) {
                            @strongify(self)
                            if(x.state == UIGestureRecognizerStateEnded)
                            {
                                self.view.tag =11;
                                self.skipBtn.tag = 1;
                                [self goToHome];
                                [MobClick event:@"splash_img_click"];
                            }
                        }];
                        
                        
                    }
                        break;
                    case 1:
                    {
                        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
                        [image addGestureRecognizer:tap];
                        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer *x) {
                           
                            if(x.state == UIGestureRecognizerStateEnded)
                            {
                                [UIAlertView qgocc_showWithTitle:@"温馨提示"
                                                         message:@"将要打开淘宝APP，请与店主报告暗号：简画大师"
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@[@"简便宜"]
                                                        tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                            if (buttonIndex == [alertView cancelButtonIndex]) {
                                                                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                                                            } else if (buttonIndex == 1) {
                                                                
                                                                NSString *url = [@"taobao://" stringByAppendingString:[clickurl substringFromIndex:8]];
                                                                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                                                                    // 如果已经安装淘宝客户端，就使用客户端打开链接
                                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                                                } else {
                                                                    // 否则使用 Mobile Safari 或者内嵌 WebView 来显示
                                                                    
                                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:clickurl]];
                                                                }
                                                                
                                                            }
                                                        }];

                            }
                        }];
                    }
                        break;
                    
                    default:
                        break;
                }
            }
            
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
    else
    {
        self.guideData = @[@"给你一块画板\n画出你的天空",@"海量简画教程\n持续不断更新",@"临摹优秀作品\n提升自己笔格",@"手机摇一摇\n重新来画",@"画笔"];
        self.guideBoxView = [[UIView alloc] init];
        {
            self.guideBoxView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.guideBoxView];
            [self.guideBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.mas_equalTo(0);
            }];
            
          
            UICollectionViewFlowLayout *copyLayout=[[UICollectionViewFlowLayout alloc] init];
            {
                copyLayout.minimumLineSpacing = 10;
                [copyLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
                
                self.collecttionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:copyLayout];
                {
                    [self.guideBoxView addSubview:self.collecttionView];
                    self.collecttionView.delegate = self;
                    self.collecttionView.dataSource = self;
                    self.collecttionView.pagingEnabled = YES;
                    
                    self.collecttionView.backgroundColor = mRGBToColor(0xeeeeee);
                    [self.collecttionView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.mas_equalTo(0);
                        make.bottom.mas_equalTo(0);
                    }];
                    [self.collecttionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMGuideCollectionViewCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([DMGuideCollectionViewCell class])];
                    
                   
                    
                }
                
            }

            
        }
        
        CGFloat left =30;
        self.pageControl = [[KYAnimatedPageControl alloc]initWithFrame:CGRectMake(left, 35, mScreenWidth-left*2, 20)];
        {
            self.pageControl.pageCount = self.guideData.count;
            self.pageControl.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
            self.pageControl.selectedColor = mRGBToColor(0x119B39);
            self.pageControl.bindScrollView = self.collecttionView;
            self.pageControl.shouldShowProgressLine = YES;
            
            self.pageControl.indicatorStyle = IndicatorStyleGooeyCircle;
            self.pageControl.indicatorSize = 20;
            
            [self.guideBoxView addSubview:self.pageControl];
            
            
            
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((pathAnimation.duration - 0.4) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [progressLayer removeFromSuperlayer];
        if(self.skipBtn.tag != 1)
        {
            [self goToHome];
        }
    });
    
}


#pragma mark --UICollectionView回调
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.guideData count];
    //return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMGuideCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMGuideCollectionViewCell class]) forIndexPath:indexPath];
    NSString *path = [[NSBundle mainBundle]pathForResource:[@"splash" stringByAppendingString:@(indexPath.row).stringValue]ofType:@"jpg"];
    cell.contentImg.image = [UIImage imageWithContentsOfFile:path];
    cell.contentImg.contentMode = UIViewContentModeScaleAspectFit;
    cell.contentImg.clipsToBounds = YES;
    cell.shakeLabel.text = @"音量键可以控制画笔粗细";
    [cell.tryBtn setTitle:@"试一试" forState:UIControlStateNormal];
    [cell.tryBtn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateNormal];
    cell.tryBtn.layer.backgroundColor = mRGBToColor(0xDF0526).CGColor;
    cell.tryBtn.layer.cornerRadius = 5;
    cell.tryBtn.clipsToBounds = YES;
    cell.bottomView.backgroundColor = mRGBToColor(0xeeeeee);
    cell.guideTipLabel.text = [self.guideData objectAtIndex:indexPath.row];
    cell.contentImg.hidden = (indexPath.row == ([self.guideData count] -1))?YES:NO;
    cell.shakeLabel.hidden = !cell.contentImg.hidden;
    cell.guideTipLabel.hidden = cell.contentImg.hidden;
    cell.tryBtn.hidden = cell.shakeLabel.hidden;
    [cell.tryBtn addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0 , 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝点击 该干点啥呢＝＝＝＝＝＝");
    
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //Indicator动画
    [self.pageControl.indicator animateIndicatorWithScrollView:scrollView andIndicator:self.pageControl];
    
    if (scrollView.dragging || scrollView.isDecelerating || scrollView.tracking) {
        //背景线条动画
        [self.pageControl.pageControlLine animateSelectedLineWithScrollView:scrollView];
    }
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x;
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    
    [self.pageControl.indicator restoreAnimation:@(1.0/self.pageControl.pageCount)];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x;
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
