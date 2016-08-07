//
//  DMMineSaveDetailViewController.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMMineSaveDetailViewController.h"
#import "DMCopyCollectionViewCell.h"
#import "CommonShareView.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface DMMineSaveDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CommonShareViewDelegate>
@property (nonatomic,readwrite,strong) UICollectionView *collecttionView;
@property (nonatomic,readwrite,strong) UILabel * numLabel;
@end

@implementation DMMineSaveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
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
- (void)buildUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *copyLayout=[[UICollectionViewFlowLayout alloc] init];
    {
        copyLayout.minimumLineSpacing = 10;
        [copyLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        self.collecttionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:copyLayout];
        {
            [self.view addSubview:self.collecttionView];
            self.collecttionView.delegate = self;
            self.collecttionView.dataSource = self;
            self.collecttionView.pagingEnabled = YES;
            [self.collecttionView setPullType:SVPullTypeVisibleLogo];
            self.collecttionView.backgroundColor = mRGBToColor(0xffffff);
            [self.collecttionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(0);
            }];
            
            [self.collecttionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMCopyCollectionViewCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([DMCopyCollectionViewCell class])];
        }
    }
    
    self.numLabel = [[UILabel alloc] init];
    {
        self.numLabel.layer.backgroundColor = mRGBAToColor(0xeeeeee, 0.7).CGColor;
        self.numLabel.textColor = mRGBToColor(0x444444);
        self.numLabel.font = [UIFont systemFontOfSize:14];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(30);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
    }
    @weakify(self)
    [RACObserve(self.collecttionView, contentOffset) subscribeNext:^(NSValue* x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        if(((int)point.x)%((int)mScreenWidth) == 0)
        {
            self.view.tag=(int)point.x/(int)mScreenWidth;
            self.numLabel.text = [NSString stringWithFormat:@"%@/%@",@(((int)point.x/mScreenWidth)+1).stringValue,@(self.imgData.count).stringValue] ;
        }
    }];
    
    UIButton * backBtn = [[UIButton alloc] init];
    {
        @weakify(self);
        [self.view addSubview:backBtn];
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
    
    UIButton * shareBtn = [[UIButton alloc] init];
    {
        @weakify(self);
        [self.view addSubview:shareBtn];
        [shareBtn setImage:[UIImage imageNamed:@"new_share"] forState:UIControlStateNormal];
        shareBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           @strongify(self);
            if([WeiboSDK isWeiboAppInstalled] || [WXApi isWXAppInstalled] || [QQApi isQQInstalled])
            {
                [[CommonShareView sharedView] show];
                [CommonShareView sharedView].delegate = self;
            }
            else
            {
                [self showLoadAlertView:@"不能分享,微博.微信.QQ都没有" imageName:nil autoHide:YES];
            }
            return [RACSignal empty];
        }];
        
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(30);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];
        
        shareBtn.hidden = !self.canShare;
        
    }

    self.collecttionView.alpha = 0;
    [self.collecttionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.collecttionView.alpha = 1;
        }];
        [self.collecttionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.curIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --UICollectionView回调
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.imgData count];
    //return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCopyCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMCopyCollectionViewCell class]) forIndexPath:indexPath];
    cell.contentImg.contentMode =UIViewContentModeScaleAspectFit;
    if([[self.imgData objectAtIndex:0] isMemberOfClass:[ALAsset class]])
    {
        ALAsset * al = [self.imgData objectAtIndex:indexPath.row];
        UIImage *img = [UIImage imageWithCGImage:[[al defaultRepresentation] fullScreenImage]];
        cell.contentImg.image = img;
    }
    else
    {
        [cell.contentImg sd_setImageWithURL:[NSURL URLWithString:[self.imgData objectAtIndex:indexPath.row]] placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xcccccc) size:CGSizeMake(2, 3)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    
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

- (void)shareWithIndex:(NSInteger)index
{
    ALAsset * al = [self.imgData objectAtIndex:self.view.tag];
    UIImage *theimg = [UIImage imageWithCGImage:[[al defaultRepresentation] fullScreenImage]];
    if(index == 0)
    {
        WBMessageObject *message = [WBMessageObject message];
        message.text = [[CommonShareView sharedView] shareMessageWithType:0];
        WBImageObject *image = [WBImageObject object];
        
        image.imageData = UIImagePNGRepresentation(theimg);
        message.imageObject = image;
      
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        request.userInfo = @{@"ShareMessageFrom": @"分享Ask",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        if ([WeiboSDK sendRequest:request])
        {
            UALog(@"呵呵，分享给新浪微博，产品");
        }

    }
    else if(index == 1)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"简画大师";
        message.description = [[CommonShareView sharedView] shareMessageWithType:0];
        
        
        [message setThumbImage:[UIImage scaleImage:theimg toSize:CGSizeMake(mScreenWidth/3, mScreenHeight/3)] ];
        
        WXImageObject *ext = [WXImageObject object];
        
        ext.imageData = UIImagePNGRepresentation(theimg);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        //req.text = @"我发现一个有意思东东，一起来看看吧";
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        
        [WXApi sendReq:req];
    }
    else if(index == 2)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"简画大师";
        message.description = [[CommonShareView sharedView] shareMessageWithType:0];
        
        
        [message setThumbImage:[UIImage scaleImage:theimg toSize:CGSizeMake(mScreenWidth/3, mScreenHeight/3)] ];
        
        WXImageObject *ext = [WXImageObject object];
     
        ext.imageData = UIImagePNGRepresentation(theimg);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        //req.text = @"我发现一个有意思东东，一起来看看吧";
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        
        [WXApi sendReq:req];
    }
    else
    {
        [self shareButtonQQ];
    }

}

#pragma mark -QQ分享
- (void)shareButtonQQ
{
    ALAsset * al = [self.imgData objectAtIndex:self.view.tag];
    UIImage *theimg = [UIImage imageWithCGImage:[[al defaultRepresentation] fullScreenImage]];
    UIImage *preView  = [UIImage scaleImage:theimg toSize:CGSizeMake(mScreenWidth/3, mScreenHeight/3)];
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(theimg)
                                               previewImageData:UIImagePNGRepresentation(preView)
                                                          title:@"简画大师"
                                                    description:[[CommonShareView sharedView] shareMessageWithType:0]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //            [msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //            [msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //            [msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
