//
//  DMLearnSubViewController.m
//  DrawMaster
//
//  Created by git on 16/6/24.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMLearnSubViewController.h"
#import "DMLearnCollectionViewCell.h"
#import "DMCopyDetailViewController.h"
@interface DMLearnSubViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation DMLearnSubViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor redColor];//
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
            self.collecttionView.backgroundColor = mRGBToColor(0xdddddd);
            [self.collecttionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(14);
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
            [self.collecttionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMLearnCollectionViewCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([DMLearnCollectionViewCell class])];
            
            
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


#pragma mark --UICollectionView回调
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.viewModel learnNum];
    //return 20;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMLearnCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMLearnCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor =mRGBToColor(0xffffff);
    cell.contentImg.contentMode =UIViewContentModeScaleAspectFit;
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.lineSpacing = 12;
    cell.infoLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[self.viewModel infoLearnWithIndex:indexPath.row] attributes:@{NSFontAttributeName: kLessonTitleFont,NSForegroundColorAttributeName:kContentColor,NSParagraphStyleAttributeName:style}];
    
     NSArray * size = [[self.viewModel sizeOfLearnWithIndex:indexPath.row] componentsSeparatedByString:@","];
    
    [cell.contentImg setImageWithURL:[NSURL URLWithString:[self.viewModel urlLearnWithIndex:indexPath.row]] placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xbbbbbb) size:CGSizeMake(2, 2*([size[1] floatValue]/[size[0] floatValue]))]];
    
    CGFloat w = mIsPad?(mScreenWidth-32-15)/2:(mScreenWidth-16-10);
   
    
    cell.contentImgHeight.constant = w*([size[1] floatValue]/[size[0] floatValue]);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat w = mIsPad?(mScreenWidth-32-15)/2:(mScreenWidth-16-10);
    NSArray * size = [[self.viewModel sizeOfLearnWithIndex:indexPath.row] componentsSeparatedByString:@","];
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.lineSpacing = 12;
    
    CGFloat h = w*([size[1] floatValue]/[size[0] floatValue])+ [[self.viewModel infoLearnWithIndex:indexPath.row] boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                                                            attributes:@{NSFontAttributeName: kLessonTitleFont,NSForegroundColorAttributeName:kContentColor,NSParagraphStyleAttributeName:style}
                                                                                                                               context:nil].size.height+20;
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5 , 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMCopyDetailViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"DMCopyDetailViewController"];
    modal.imgUrls = [self.viewModel detailLearnWithIndex:indexPath.row];
    [self.navigationController pushViewController:modal animated:NO];
    
}
@end
