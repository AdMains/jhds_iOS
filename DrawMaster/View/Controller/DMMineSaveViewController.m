//
//  DMMineSaveViewController.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMMineSaveViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DMCopyCollectionViewCell.h"
#import "DMMineSaveDetailViewController.h"
#import "DMAPIManager.h"
@interface DMMineSaveViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,readwrite,strong) NSMutableArray *imgData;
@property (nonatomic,readwrite,strong) UICollectionView * collecttionView;
@property (nonatomic,readwrite,strong) UIView *loadingView;

@end

@implementation DMMineSaveViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"已保存";
    self.imgData = [NSMutableArray array];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ALAssetsLibrary *al = [DMAPIManager defaultAssetsLibrary];
        [al enumerateGroupsWithTypes:ALAssetsGroupAll
         
                          usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             if (!group || *stop)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.loadingView.hidden = YES;
                     if(self.imgData.count == 0)
                         [self.collecttionView showNoNataViewWithMessage:@"您还没有保存任何作品，赶快去试一下吧" imageName:@"icon_my_last"];
                     else
                         [self.collecttionView  reloadData];
                 });
             }
             
             NSString *name =[group valueForProperty:ALAssetsGroupPropertyName];
             if ([name isEqualToString:app_Name])
             {
                 
                 [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
                  {
                      if (asset)
                      {
                          if ([[asset valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto])
                          {
                              //UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                              //UIImage *img = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                              [self.imgData insertObject:asset atIndex:0];
                          }
                          
                          
                      }
                  }
                  ];
                 
             }
             
             
         }
         
                        failureBlock:^(NSError *error)
         {
             // User did not allow access to library
             
         }
         ];
    });
   
    
   
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
            
           [self.collecttionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMCopyCollectionViewCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([DMCopyCollectionViewCell class])];
            
            
        }
        
        
        
    }

    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.imgData.count == 0)
            [self.collecttionView showNoNataViewWithMessage:@"您还没有保存任何作品，赶快去试一下吧" imageName:@"icon_my_last"];
        else
            [self.collecttionView  reloadData];
    });
    */
    self.loadingView = [[UIView alloc] init];
    {
        [self.view addSubview:self.loadingView];
        [self.loadingView setBackgroundColor:mRGBToColor(0xffffff)];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.equalTo(self.topBar.mas_bottom);
        }];
        UIActivityIndicatorView *at = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        {
            [at startAnimating];
            [self.loadingView addSubview:at];
            [at mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
                
            }];
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
    
    return [self.imgData count];
    //return 20;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCopyCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMCopyCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor =mRGBToColor(0xffffff);
    cell.contentImg.contentMode =UIViewContentModeScaleAspectFit;
    ALAsset * al = [self.imgData objectAtIndex:indexPath.row];
    UIImage *img = [UIImage imageWithCGImage:[al aspectRatioThumbnail] ];
    //UIImage *img = [self.imgData objectAtIndex:indexPath.row];
    cell.contentImg.image = img;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat w = mIsPad?(mScreenWidth-40)/3:(mScreenWidth-20)/2;
    CGFloat h = w*1.5;
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5 , 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    DMMineSaveDetailViewController *modal =  [[DMMineSaveDetailViewController alloc] init];
    modal.imgData = self.imgData;
    modal.curIndex = indexPath.row;
    [self.navigationController pushViewController:modal animated:YES];
    
}

@end
