//
//  DMShareViewController.m
//  DrawMaster
//
//  Created by git on 16/8/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareViewController.h"
#import "DMShareViewModel.h"
#import "DMShareCollectionViewCell.h"

@interface DMShareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,readwrite,strong) UICollectionView * collecttionView;
@property (nonatomic,readwrite,strong) DMShareViewModel * viewModel;
@property (nonatomic,readwrite,strong) UILabel * titleLabel;
@property (nonatomic,readwrite,strong) UIView *topBar;
@end

@implementation DMShareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];//
    self.viewModel = [[DMShareViewModel alloc] init];
    @weakify(self)
    
    self.topBar = [[UIView alloc] init];
    {
        [self.view addSubview:self.topBar];
        [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(65);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        {
            self.titleLabel.text = @"未登录";
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

    
    UICollectionViewFlowLayout *copyLayout=[[UICollectionViewFlowLayout alloc] init];
    {
        copyLayout.minimumLineSpacing = 10;
        [copyLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collecttionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:copyLayout];
        {
            [self.view addSubview:self.collecttionView];
            self.collecttionView.delegate = self;
            self.collecttionView.dataSource = self;
            self.collecttionView.backgroundColor = mRGBToColor(0xdddddd);
            [self.collecttionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.top.mas_equalTo(66);
            }];
            
            [self.collecttionView addPullToRefreshWithActionHandler:^{
                @strongify(self)
                [[self.viewModel fetchDataWithMore:NO] subscribeNext:^(id x) {
                    [self.collecttionView  reloadData];
                    [self.collecttionView.pullToRefreshView stopAnimating];
                } error:^(NSError *error) {
                    [self.collecttionView.pullToRefreshView stopAnimating];
                    [self.collecttionView showNoNataViewWithMessage:@"无法获取数据" imageName:@"home_copy"];
                    
                }];
            }];
            
            [self.collecttionView addInfiniteScrollingWithActionHandler:^{
                @strongify(self)
                [[self.viewModel fetchDataWithMore:YES] subscribeNext:^(id x) {
                    [self.collecttionView  reloadData];
                    [self.collecttionView.infiniteScrollingView stopAnimating];
                } error:^(NSError *error) {
                    [self.collecttionView.infiniteScrollingView stopAnimating];
                    [self.collecttionView showNoNataViewWithMessage:@"无法获取数据" imageName:@"home_copy"];
                    
                }];
                
            }];
            
            [self.collecttionView.pullToRefreshView setTitle:@"下拉更新" forState:SVPullToRefreshStateStopped];
            [self.collecttionView.pullToRefreshView setTitle:@"释放更新" forState:SVPullToRefreshStateTriggered];
            [self.collecttionView.pullToRefreshView setTitle:@"卖力加载中" forState:SVPullToRefreshStateLoading];
            [self.collecttionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMShareCollectionViewCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([DMShareCollectionViewCell class])];
            
            
        }
        
    }
    [self.collecttionView triggerPullToRefresh];
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


#pragma mark --UICollectionView回调
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.viewModel shareNum];
    //return 20;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMShareCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMShareCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor =mRGBToColor(0xdddddd);
    cell.nickName.text = [self.viewModel nickNameWithRow:indexPath.row];
    cell.createAtTime.text = [self.viewModel createTimeWithRow:indexPath.row];
    //cell.shareText.backgroundColor = mRGBToColor(0xff0000);
    cell.shareText.attributedText = [self.viewModel contentWithRow:indexPath.row];
    NSArray *smallpics = [self.viewModel  smallPicsWithRow:indexPath.row];
    cell.imgTopBox.hidden = !(smallpics.count>0) ;
    cell.imgCenterBox.hidden = !(smallpics.count>3) ;
    cell.imgBottomBox.hidden = !(smallpics.count>6) ;
    NSArray *subviews = @[cell.shareImgBtn0,cell.shareImgBtn1,cell.shareImgBtn2,cell.shareImgBtn3,cell.shareImgBtn4,cell.shareImgBtn5,cell.shareImgBtn6,cell.shareImgBtn7,cell.shareImgBtn8];
    for (UIButton*btn in subviews) {
        btn.hidden = YES;
        btn.contentMode = UIViewContentModeScaleAspectFit;
    }
    for (int i = 0; i<smallpics.count; ++i) {
        ((UIButton *)subviews[i]).hidden = NO;
        [(UIButton *)subviews[i] sd_setImageWithURL:[NSURL URLWithString:smallpics[i]] forState:UIControlStateNormal placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xeeeeee) size:CGSizeMake(2, 3)]];
    }
    [cell.userIconBtn sd_setImageWithURL:[NSURL URLWithString:[self.viewModel userIconWithRow:indexPath.row]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_share"]];
    cell.shareTextHeight.constant = [self.viewModel contentHeightWithRow:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = mIsPad?(mScreenWidth-32-15)/2:(mScreenWidth-16-10);
    CGFloat h = 48 + [self.viewModel contentHeightWithRow:indexPath.row];
    NSArray *smallpics = [self.viewModel  smallPicsWithRow:indexPath.row];
    if((smallpics.count>6))
        h =h+ ((w-16)*(15.0f/32.0f))*3;
    else if((smallpics.count>3))
        h =h+ ((w-16)*(15.0f/32.0f))*2;
    else if((smallpics.count>0))
        h =h+ ((w-16)*(15.0f/32.0f))*1;
    
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5 , 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
   
    
}
@end