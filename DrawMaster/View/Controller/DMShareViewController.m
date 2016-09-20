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
#import "DMMineSaveDetailViewController.h"
#import "WeiboSDK.h"
#import "WeiboSDK+Statistics.h"
#import "WeiboUser.h"
@interface DMShareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DMShareCollectionViewCellDelegate>
@property (nonatomic,readwrite,strong) UICollectionView * collecttionView;
@property (nonatomic,readwrite,strong) DMShareViewModel * viewModel;
@property (nonatomic,readwrite,strong) UILabel * titleLabel;
@property (nonatomic,readwrite,strong) UIView *topBar;
@property (nonatomic,readwrite,strong) NSCache * cellHeightCache;
@end

@implementation DMShareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];//
    self.viewModel = [[DMShareViewModel alloc] init];
    Boolean shareNumHidden = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"])
    {
        if([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"]] == NSOrderedAscending)
            shareNumHidden = FALSE;
    }
    
    
    @weakify(self)
    self.cellHeightCache = [[NSCache alloc] init];
    self.topBar = [[UIView alloc] init];
    {
        [self.view addSubview:self.topBar];
        [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(65);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        {
            if(shareNumHidden)
                self.titleLabel.text = @"未登录";
            else
                self.titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"];
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
        
        UIButton *btn = [[UIButton alloc] init];
        {
            [self.topBar addSubview:btn];
            [btn setTitle:@"微博登录" forState:UIControlStateNormal];
            [btn setTitleColor:mRGBToColor(0x333333) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(30);
                make.right.mas_equalTo(-10);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(80);
            }];
            [btn addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
                make.top.mas_equalTo(65);
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSinaLogin:) name:kSinaLoginNotification object:nil];
}

- (void)didSinaLogin:(NSNotification*)sender
{
    [self.collecttionView reloadData];
    
    [WBHttpRequest requestForUserProfile:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboCurrentUserID"]  withAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"]  andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
        if(result )
        {
            WeiboUser *u = (WeiboUser *)result;
            self.titleLabel.text = u.screenName;
            
        }
        
    }];
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


- (void)gotoImgDetail:(NSInteger)tag indexRow:(NSInteger)row
{
    [self gotoPicDetail:tag Pics:[self.viewModel bigPicsWithRow:row]];
}

- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"DMShareViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}


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
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.backgroundColor =mRGBToColor(0xdddddd);
    cell.nickName.text = [self.viewModel nickNameWithRow:indexPath.row];
    cell.createAtTime.text = [self.viewModel createTimeWithRow:indexPath.row];
    
    
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
        [(UIButton *)subviews[i] sd_setImageWithURL:[NSURL URLWithString:smallpics[i]] forState:UIControlStateNormal placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xeeeeee) size:CGSizeMake(300, 300)]];
    }
    [cell.userIconBtn sd_setImageWithURL:[NSURL URLWithString:[self.viewModel userIconWithRow:indexPath.row]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_share"]];
    cell.shareTextHeight.constant = [self.viewModel contentHeightWithRow:indexPath.row];
    if([self.cellHeightCache objectForKey:indexPath])
        cell.shareNumBoxViewTop.constant = [[self.cellHeightCache objectForKey:indexPath] floatValue] - 40;
    Boolean shareNumHidden = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"])
    {
        if([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"]] == NSOrderedAscending)
            shareNumHidden = FALSE;
    }
    cell.shareNumBoxView.hidden = shareNumHidden;
    [cell.repostNumBtn setTitleColor:mRGBToColor(0xaaaaaa) forState:UIControlStateNormal];
    [cell.commentNumBtn setTitleColor:mRGBToColor(0xaaaaaa) forState:UIControlStateNormal];
    [cell.atrributeNumBtn setTitleColor:mRGBToColor(0xaaaaaa) forState:UIControlStateNormal];
    if(!shareNumHidden)
        [cell.shareNumBoxView fetchWeiboNum:[self.viewModel idstrWithRow:indexPath.row] success:^(NSNumber *repostNum, NSNumber *commentNum, NSNumber *attributeNum) {
            NSLog(@"%@========%@",repostNum,commentNum);
            [cell.repostNumBtn setTitle:[repostNum integerValue]==0?@"转发":[repostNum stringValue] forState:UIControlStateNormal];
            [cell.commentNumBtn setTitle:[commentNum integerValue]==0?@"评论":[commentNum stringValue] forState:UIControlStateNormal];
            [cell.atrributeNumBtn setTitle:[attributeNum integerValue]==0?@"赞":[attributeNum stringValue] forState:UIControlStateNormal];
        }];
    return cell;
}

- (void)gotoPicDetail:(NSInteger)index Pics:(NSArray*)pics
{
    DMMineSaveDetailViewController *modal =  [[DMMineSaveDetailViewController alloc] init];
    modal.imgData = pics;
    modal.curIndex = index;
    modal.canShare = NO;
    [self.navigationController pushViewController:modal animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    CGFloat w = mIsPad?(mScreenWidth-32-15)/2:(mScreenWidth-16-10);
    
    //return CGSizeMake(w, 400);
    CGFloat h = 0;
    if([self.cellHeightCache objectForKey:indexPath])
    {
        h = [[self.cellHeightCache objectForKey:indexPath] floatValue];
    }
    else
    {
        h = 48 + [self.viewModel contentHeightWithRow:indexPath.row];
        NSArray *smallpics = [self.viewModel  smallPicsWithRow:indexPath.row];
        if((smallpics.count>6))
            h =h+ ((w-16)*(15.0f/32.0f))*3;
        else if((smallpics.count>3))
            h =h+ ((w-16)*(15.0f/32.0f))*2;
        else if((smallpics.count>0))
            h =h+ ((w-16)*(15.0f/32.0f))*1;
        
        Boolean shareNumHidden = YES;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"])
        {
            if([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"]] == NSOrderedAscending)
                shareNumHidden = FALSE;
        }
        if(!shareNumHidden)
            h = h +30;
        [self.cellHeightCache setObject:@(h) forKey:indexPath];
    }
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