//
//  DMBigImgBoxView.m
//  DrawMaster
//
//  Created by git on 16/7/4.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMBigImgBoxView.h"
#import "DMCopyDetailCollectionViewCell.h"

@interface DMBigImgBoxView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation DMBigImgBoxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImgUrls:(NSArray *)imgUrls
{
    _imgUrls = imgUrls;
    [self.collecttionView reloadData];
    CGFloat w = mScreenWidth -220;
    
    if(imgUrls.count>1)
    {
        self.pageControl = [[KYAnimatedPageControl alloc]initWithFrame:CGRectMake(mScreenWidth/2-w/2, 35, w, 20)];
        {
            self.pageControl.pageCount = imgUrls.count;
            self.pageControl.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
            self.pageControl.selectedColor = mRGBToColor(0x119B39);
            self.pageControl.bindScrollView = self.collecttionView;
            self.pageControl.shouldShowProgressLine = YES;
            
            self.pageControl.indicatorStyle = IndicatorStyleGooeyCircle;
            self.pageControl.indicatorSize = 20;
            
            [self addSubview:self.pageControl];
            
            
            
        }
    }
    
   

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self buildUI];
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{

    self.fullScreen = @(YES);
    
    UICollectionViewFlowLayout *copyLayout=[[UICollectionViewFlowLayout alloc] init];
    {
        copyLayout.minimumLineSpacing = 0;
        [copyLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        self.collecttionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:copyLayout];
        {
            [self addSubview:self.collecttionView];
            self.collecttionView.delegate = self;
            self.collecttionView.dataSource = self;
            self.collecttionView.pagingEnabled = YES;
            self.collecttionView.backgroundColor = mRGBToColor(0xffffff);
            [self.collecttionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(0);
            }];
            
            [self.collecttionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMCopyDetailCollectionViewCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([DMCopyDetailCollectionViewCell class])];
            
            
        }
        
    }
    
    self.tryBtn = [[UIButton alloc] init];
    {
        self.tryBtn.layer.borderWidth = 1.0;
        self.tryBtn.layer.cornerRadius = 3.0;
        self.tryBtn.layer.borderColor =mRGBToColor(0x333333).CGColor;
        [self.tryBtn setTitle:@"试一试" forState:UIControlStateNormal];
        [self.tryBtn setTitleColor:mRGBToColor(0x333333) forState:UIControlStateNormal];
        self.tryBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.tryBtn];
        [self.tryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-20);
        }];
    }
    
    
    [RACObserve(self, fullScreen) subscribeNext:^(NSNumber* x) {
        [self.collecttionView reloadData];
   
        self.pageControl.hidden = ![x boolValue];
        self.tryBtn.hidden = ![x boolValue];
    }];

}

#pragma mark --UICollectionView回调
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.imgUrls count];
    //return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCopyDetailCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMCopyDetailCollectionViewCell class]) forIndexPath:indexPath];
    cell.contentImgWidth.constant = cv.frame.size.width/(mIsPad?([self.fullScreen boolValue]?1.5:1.0):1);
    cell.contentImgHeight.constant = cv.frame.size.height/(mIsPad?([self.fullScreen boolValue]?1.5:1.0):1);
    cell.contentImg.contentMode =UIViewContentModeScaleAspectFit;
  
    cell.loadingBoxView.hidden = NO;
    [cell.loadAI startAnimating];
    cell.loadingTip.text = @"卖力加载中...";
    
    [cell.contentImg setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.imgUrls objectAtIndex:indexPath.row]]] placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xffffff) size:CGSizeMake(cv.frame.size.width, cv.frame.size.height)] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.contentImg.image = image;
        cell.loadingBoxView.hidden = YES;
        [cell.loadAI startAnimating];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        cell.loadingBoxView.hidden = NO;
        cell.loadingTip.text = @"图片加载失败，点击屏幕重试";
        
    }];
    
    
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
    [self.delegate clickImg:[self.fullScreen boolValue] row:indexPath.row];
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

- (void)gotoIndexWithRow:(NSInteger)row
{
    [self.collecttionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
@end
