//
//  DMMineShopViewController.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMMineShopViewController.h"
#import "DMShopCollectionViewCell.h"
#import "DMShopViewModel.h"
@interface DMMineShopViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,readwrite,strong) UICollectionView * collecttionView;
@property (nonatomic,readwrite,strong) DMShopViewModel *viewModel;
@end

@implementation DMMineShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"简便宜";
    self.viewModel = [[DMShopViewModel alloc] initWithType:@"0"];
    @weakify(self)
    UICollectionViewFlowLayout *copyLayout=[[UICollectionViewFlowLayout alloc] init];
    {
        copyLayout.minimumLineSpacing = 10;
        [copyLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collecttionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:copyLayout];
        {
            [self.view addSubview:self.collecttionView];
            self.collecttionView.delegate = self;
            self.collecttionView.dataSource = self;
            [self.collecttionView setPullType:SVPullTypeVisibleLogo];
            self.collecttionView.backgroundColor = mRGBToColor(0xeeeeee);
            [self.collecttionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(65);
            }];
            
            [self.collecttionView addPullToRefreshWithActionHandler:^{
                @strongify(self)
                [[self.viewModel fetchDataWithMore:NO] subscribeNext:^(id x) {
                    [self.collecttionView  reloadData];
                    [self.collecttionView.pullToRefreshView stopAnimating];
                } error:^(NSError *error) {
                    [self.collecttionView.pullToRefreshView stopAnimating];
                    [self.collecttionView showNoNataViewWithMessage:@"无法获取数据" imageName:@"icon_my_buy"];
                    
                }];
            }];
            
            [self.collecttionView addInfiniteScrollingWithActionHandler:^{
                @strongify(self)
                [[self.viewModel fetchDataWithMore:YES] subscribeNext:^(id x) {
                    [self.collecttionView  reloadData];
                    [self.collecttionView.infiniteScrollingView stopAnimating];
                } error:^(NSError *error) {
                    [self.collecttionView.infiniteScrollingView stopAnimating];
                    [self.collecttionView showNoNataViewWithMessage:@"无法获取数据" imageName:@"icon_my_buy"];
                    
                }];
                
            }];
            
            [self.collecttionView.pullToRefreshView setTitle:@"下拉更新" forState:SVPullToRefreshStateStopped];
            [self.collecttionView.pullToRefreshView setTitle:@"释放更新" forState:SVPullToRefreshStateTriggered];
            [self.collecttionView.pullToRefreshView setTitle:@"卖力加载中" forState:SVPullToRefreshStateLoading];
           
            [self.collecttionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMShopCollectionViewCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([DMShopCollectionViewCell class])];
            [self.collecttionView triggerPullToRefresh];
            
        }
        
    }

    
    



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
    
    return [self.viewModel shopNum];
    //return 20;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMShopCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMShopCollectionViewCell class]) forIndexPath:indexPath];
    //cell.backView.backgroundColor =mRGBToColor(0xffffff);
    cell.backView.hidden = NO;
    cell.img.contentMode =UIViewContentModeScaleAspectFill;
    cell.img.clipsToBounds = YES;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = -5;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0], NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName,mRGBToColor(0x444444),NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[self.viewModel contentWithRow:indexPath.row] attributes:attrs];
    
    [cell.contentLabel setAttributedText:attributedText];
    [cell.contentLabel sizeToFit];
    //cell.contentLabel.text = [self.viewModel contentWithRow:indexPath.row];
    cell.ortherLabel.text = [self.viewModel ortherWithRow:indexPath.row];
    CGFloat w = mIsPad?(mScreenWidth-40)/2:(mScreenWidth-20)/1;
    CGFloat h = w/3;
    cell.imgWidth.constant = h*1.5;
    [cell.img  setImageWithURL:[NSURL URLWithString:[self.viewModel imgUrlWithRow:indexPath.row]] placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xbbbbbb) size:CGSizeMake(2*1.5, 2)]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat w = mIsPad?(mScreenWidth-40)/2:(mScreenWidth-20)/1;
    CGFloat h = w/3;
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5 , 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [UIAlertView qgocc_showWithTitle:@"温馨提示"
                             message:@"将要打开淘宝APP，请与店主报告暗号：简画大师"
                   cancelButtonTitle:@"取消"
                   otherButtonTitles:@[@"简便宜"]
                            tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                if (buttonIndex == [alertView cancelButtonIndex]) {
                                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                                } else if (buttonIndex == 1) {
                                    
                                    NSString *url = [@"taobao://" stringByAppendingString:[[self.viewModel clickUrlWithRow:indexPath.row] substringFromIndex:8]];
                                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                                        // 如果已经安装淘宝客户端，就使用客户端打开链接
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                    } else {
                                        // 否则使用 Mobile Safari 或者内嵌 WebView 来显示
                                        
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.viewModel clickUrlWithRow:indexPath.row]]];
                                    }
                                    
                                }
                            }];

    
}

@end
