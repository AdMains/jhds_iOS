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
#import "DMShareDetailViewController.h"
#import "WeiboSDK.h"
#import "WeiboSDK+Statistics.h"
#import "WeiboUser.h"
#import "DMButton.h"
@interface DMShareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DMShareCollectionViewCellDelegate>
@property (nonatomic,readwrite,strong) UICollectionView * collecttionView;
@property (nonatomic,readwrite,strong) DMShareViewModel * viewModel;
@property (nonatomic,readwrite,strong) UILabel * titleLabel;
@property (nonatomic,readwrite,strong) UIView *topBar;
@property (nonatomic,readwrite,strong) NSCache * cellHeightCache;
@end

@implementation DMShareViewController


- (void)viewDidLoad {
    
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
                self.titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboNickName"];
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
                    [self.cellHeightCache removeAllObjects];
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
            [self.collecttionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
            
            
        }
        
    }
    [self.collecttionView triggerPullToRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSinaLogin:) name:kSinaLoginNotification object:nil];
    [super viewDidLoad];
}

- (void)didSinaLogin:(NSNotification*)sender
{
    [self.cellHeightCache removeAllObjects];
    [self.collecttionView reloadData];
    self.titleLabel.text = @"获取昵称中....";
    [WBHttpRequest requestForUserProfile:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboCurrentUserID"]  withAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"]  andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
        if(result )
        {
            WeiboUser *u = (WeiboUser *)result;
            self.titleLabel.text = u.screenName;
            [[NSUserDefaults standardUserDefaults] setObject:self.titleLabel.text forKey:@"DMWeiboNickName"];
            
        }
        else
        {
            self.titleLabel.text = @"获取昵称失败";
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
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor =mRGBToColor(0xffffff);
    Boolean shareNumHidden = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"])
    {
        if([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"]] == NSOrderedAscending)
            shareNumHidden = FALSE;
    }
    if(cell.contentView.subviews.count == 0)
    {
        UIButton * userIcon = [[UIButton alloc] init];
        {
            userIcon.layer.cornerRadius = 20;
            userIcon.clipsToBounds = YES;
            [cell.contentView addSubview:userIcon];
            userIcon.tag = 1024;
            [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(8);
                make.top.mas_equalTo(4);
                make.height.width.mas_equalTo(40);
            }];
            
            
        }
        
        UILabel *userName = [[UILabel alloc] init];
        {
            [cell.contentView addSubview:userName];
            userName.tag = 1025;
            [userName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(userIcon.mas_right).offset(8);
                make.top.mas_equalTo(4);
                make.height.mas_equalTo(20);
                make.right.mas_equalTo(-8);
            }];
            
            userName.font = [UIFont systemFontOfSize:14];
            userName.textColor = [UIColor orangeColor];
            
        }
        
        UILabel *creatTime = [[UILabel alloc] init];
        {
            [cell.contentView addSubview:creatTime];
            creatTime.tag = 1026;
            [creatTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(userIcon.mas_right).offset(8);
                make.top.equalTo(userName.mas_bottom);
                make.height.mas_equalTo(20);
                make.right.mas_equalTo(-8);
            }];
            
            creatTime.font = [UIFont systemFontOfSize:12];
            creatTime.textColor = [UIColor lightGrayColor];
            
        }
        
        UITextView *content = [[UITextView alloc] init];
        {
            content.scrollEnabled = NO;
            content.editable = NO;
            content.userInteractionEnabled = NO;
            [cell.contentView addSubview:content];
            content.tag = 1027;
            
        }
        
        CGFloat w = mIsPad?(mScreenWidth-32-5)/2:(mScreenWidth-16);
        for (NSUInteger i = 0; i<9; i++) {
            DMButton * img = [[DMButton alloc] init];
            {
                img.tag = 1028+i;
                [cell.contentView addSubview:img];
                CGFloat imgw = (w-4*8)/3;
                CGFloat imgh = imgw*1.5;
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(content.mas_bottom).offset((i/3)* (imgh+8)-10);
                    NSUInteger index = i%3;
                    make.left.mas_equalTo(index*imgw+(index+1)*8);
                    make.width.mas_equalTo(imgw);
                    make.height.mas_equalTo(imgh);
                }];
                [img addTarget:self action:@selector(onPicClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
        }
        
        for (NSUInteger i = 0; i<3; i++) {
            DMButton * btn = [[DMButton alloc] init];
            {
                btn.tag = 2048+i;
                [cell.contentView addSubview:btn];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.left.mas_equalTo(i*(w/3));
                    make.width.mas_equalTo(w/3);
                    make.height.mas_equalTo(40);
                }];
                [btn addTarget:self action:@selector(onclickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [btn setTitleColor:mRGBToColor(0xaaaaaa) forState:UIControlStateNormal];
                if(i==0)
                    [btn setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
                else if(i == 1)
                    [btn setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:UIControlStateNormal];
                else if(i == 2)
                    [btn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];

            }
        }
        
        UIView * line = [[UIView alloc] init];
        {
            [cell.contentView addSubview:line];
            line.tag = 1001;
            line.backgroundColor = mRGBToColor(0xdddddd);
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-40);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(0.5);
            }];
        }
        
    }
    [cell.contentView viewWithTag:1001].hidden = shareNumHidden;
    [(UIButton*)[cell.contentView viewWithTag:1024] sd_setImageWithURL:[NSURL URLWithString:[self.viewModel userIconWithRow:indexPath.row]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_share"]];
    ((UILabel*)[cell.contentView viewWithTag:1025]).text = [self.viewModel nickNameWithRow:indexPath.row];
    if(indexPath.row == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:@"top_idstr"] != nil)
    {
        ((UILabel*)[cell.contentView viewWithTag:1026]).text = @"刚刚";
    }
    else
    {
        ((UILabel*)[cell.contentView viewWithTag:1026]).text = [self.viewModel createTimeWithRow:indexPath.row];
    }
    
    [[cell.contentView viewWithTag:1027] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.equalTo([cell.contentView viewWithTag:1026].mas_bottom);
        make.height.mas_equalTo([self.viewModel contentHeightWithRow:indexPath.row]);
    }];
    [(UITextView*)[cell.contentView viewWithTag:1027] setAttributedText:[self.viewModel contentWithRow:indexPath.row]];
    NSArray *smallpics = [self.viewModel  smallPicsWithRow:indexPath.row];
    for (int i = 0; i<9; ++i) {
        [((DMButton*)[cell.contentView viewWithTag:1028+i]).customArgs removeAllObjects];
        [((DMButton*)[cell.contentView viewWithTag:1028+i]).customArgs addObject:indexPath];
        [cell.contentView viewWithTag:1028+i].hidden = !(i<smallpics.count);
        if(i<smallpics.count)
            [(UIButton *)[cell.contentView viewWithTag:1028+i] sd_setImageWithURL:[NSURL URLWithString:smallpics[i]] forState:UIControlStateNormal placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xeeeeee) size:CGSizeMake(300, 300)]];
    }
   
    if(!shareNumHidden)
        [self.viewModel fetchWeiboNum:[self.viewModel idstrWithRow:indexPath.row] success:^(NSNumber *repostNum, NSNumber *commentNum, NSNumber *attributeNum) {
           
            [((UIButton*)[cell.contentView viewWithTag:2048]) setTitle:[repostNum integerValue]==0?@"转发":[repostNum stringValue] forState:UIControlStateNormal];
            [((UIButton*)[cell.contentView viewWithTag:2049]) setTitle:[commentNum integerValue]==0?@"评论":[commentNum stringValue] forState:UIControlStateNormal];
            [((UIButton*)[cell.contentView viewWithTag:2050]) setTitle:[attributeNum integerValue]==0?@"赞":[attributeNum stringValue] forState:UIControlStateNormal];
        }];
    
    [((DMButton*)[cell.contentView viewWithTag:2048]).customArgs removeAllObjects];
    [((DMButton*)[cell.contentView viewWithTag:2048]).customArgs addObject:indexPath];
    [((DMButton*)[cell.contentView viewWithTag:2049]).customArgs removeAllObjects];
    [((DMButton*)[cell.contentView viewWithTag:2049]).customArgs addObject:indexPath];
    [((DMButton*)[cell.contentView viewWithTag:2050]).customArgs removeAllObjects];
    [((DMButton*)[cell.contentView viewWithTag:2050]).customArgs addObject:indexPath];
    
    ((UIButton*)[cell.contentView viewWithTag:2048]).hidden=shareNumHidden;
    ((UIButton*)[cell.contentView viewWithTag:2049]).hidden=shareNumHidden;
    ((UIButton*)[cell.contentView viewWithTag:2050]).hidden=shareNumHidden;
    
//    @weakify(self)
//    ((UIButton*)[cell.contentView viewWithTag:2048]).rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        [self selectOneShare:indexPath onBtnIndex:11];
//        return [RACSignal empty];
//    }];
//    ((UIButton*)[cell.contentView viewWithTag:2049]).rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        [self selectOneShare:indexPath onBtnIndex:12];
//        return [RACSignal empty];
//    }];
//    ((UIButton*)[cell.contentView viewWithTag:2050]).rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        [self selectOneShare:indexPath onBtnIndex:12];
//        return [RACSignal empty];
//    }];
    
    
    
    
    /*DMShareCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMShareCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.backgroundColor =mRGBToColor(0xdddddd);
    if(indexPath.row == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:@"top_idstr"] != nil)
    {
        cell.createAtTime.text = @"刚刚";
    }
    else
    {
        cell.createAtTime.text = [self.viewModel createTimeWithRow:indexPath.row];
    }
    cell.nickName.text = [self.viewModel nickNameWithRow:indexPath.row];
    
    cell.nickName.textColor = [UIColor orangeColor];
    cell.createAtTime.textColor = [UIColor lightGrayColor];
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
    else
    {
        CGFloat w = mIsPad?(mScreenWidth-32-5)/2:(mScreenWidth-16);
        CGFloat h = 0;
        h = kCellUserBarHeight + [self.viewModel contentHeightWithRow:indexPath.row];
        NSArray *smallpics = [self.viewModel  smallPicsWithRow:indexPath.row];
        if((smallpics.count>6))
            h =h+ ((w-16)*(15.0f/32.0f))*3;
        else if((smallpics.count>3))
            h =h+ ((w-16)*(15.0f/32.0f))*2;
        else if((smallpics.count>0))
            h =h+ ((w-16)*(15.0f/32.0f))*1;
        cell.shareNumBoxViewTop.constant = h;
        
    }
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
        [cell.shareNumBoxView fetchWeiboNum:[self.viewModel idstrWithRow:indexPath.row] idStr:[self.viewModel idstr] success:^(NSNumber *repostNum, NSNumber *commentNum, NSNumber *attributeNum) {
            NSLog(@"%@========%@",repostNum,commentNum);
            [cell.repostNumBtn setTitle:[repostNum integerValue]==0?@"转发":[repostNum stringValue] forState:UIControlStateNormal];
            [cell.commentNumBtn setTitle:[commentNum integerValue]==0?@"评论":[commentNum stringValue] forState:UIControlStateNormal];
            [cell.atrributeNumBtn setTitle:[attributeNum integerValue]==0?@"赞":[attributeNum stringValue] forState:UIControlStateNormal];
        }];
    @weakify(self)
    cell.repostNumBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self selectOneShare:indexPath onBtnIndex:11];
        return [RACSignal empty];
    }];
    cell.commentNumBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self selectOneShare:indexPath onBtnIndex:12];
        return [RACSignal empty];
    }];
    cell.atrributeNumBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self selectOneShare:indexPath onBtnIndex:12];
        return [RACSignal empty];
    }];
    */
    return cell;
}

- (void)onclickBtn:(DMButton*)btn
{
    [self selectOneShare:btn.customArgs[0] onBtnIndex:(btn.tag-(2048 -11))==13?12:(btn.tag-(2048 -11))];
}

- (void)onPicClickBtn:(DMButton*)btn
{
    [self gotoPicDetail:btn.tag - 1028 Pics:[self.viewModel  bigPicsWithRow:((NSIndexPath*)btn.customArgs[0]).row]];
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
    
    
    
    CGFloat w = mIsPad?(mScreenWidth-32-5)/2:(mScreenWidth-16);
    
    //return CGSizeMake(w, 400);
    CGFloat h = 0;
    if([self.cellHeightCache objectForKey:indexPath])
    {
        h = [[self.cellHeightCache objectForKey:indexPath] floatValue];
    }
    else
    {
        h = kCellUserBarHeight + [self.viewModel contentHeightWithRow:indexPath.row];
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
    [self selectOneShare:indexPath onBtnIndex:12];
    
}

- (void)selectOneShare:(NSIndexPath *)indexPath onBtnIndex:(NSUInteger)btnIndex
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMShareDetailViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"DMShareDetailViewController"];
    modal.headNickName = [self.viewModel nickNameWithRow:indexPath.row];
    modal.headUserIcon = [self.viewModel userIconWithRow:indexPath.row];
    if(indexPath.row == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:@"top_idstr"] != nil)
    {
        modal.headCreateAtTime = @"刚刚";
    }
    else
    {
        modal.headCreateAtTime = [self.viewModel createTimeWithRow:indexPath.row];
    }
    modal.headShareText = [self.viewModel contentWithRow:indexPath.row];
    modal.headSmallPic = [self.viewModel smallPicsWithRow:indexPath.row];
    modal.headBigPic = [self.viewModel bigPicsWithRow:indexPath.row];
    modal.weiboIdstr = [self.viewModel idstrWithRow:indexPath.row];
    modal.selectMenumIndex = btnIndex;
    Boolean shareNumHidden = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboAccessToken"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"])
    {
        if([[NSDate date] compare:[[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboExpirationDate"]] == NSOrderedAscending)
            shareNumHidden = FALSE;
    }
    
    modal.logined = !shareNumHidden;
    CGFloat w = mScreenWidth-16;
    
    CGFloat h = kCellUserBarHeight + [modal.headShareText boundingRectWithSize:CGSizeMake(w-16-10, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size.height;
    NSArray *smallpics = [self.viewModel  smallPicsWithRow:indexPath.row];
    CGFloat imgw = (mScreenWidth-4*8)/3;
    CGFloat imgh = imgw*1.5;
    
    if((smallpics.count>6))
        h =h+ (imgh +8)*3;
    else if((smallpics.count>3))
        h =h+ (imgh +8)*2;
    else if((smallpics.count>0))
        h =h+ (imgh +8)*1;
    
    modal.headHeight = h;
    
    [self.navigationController pushViewController:modal animated:YES];
}
@end
