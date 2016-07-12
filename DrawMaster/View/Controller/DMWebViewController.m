//
//  DMWebViewController.m
//  DrawMaster
//
//  Created by git on 16/7/5.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMWebViewController.h"
#import "CommonShareView.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface DMWebViewController ()<UIWebViewDelegate,CommonShareViewDelegate>
@property (nonatomic,readwrite,strong) UIWebView * webView;
@property (nonatomic,assign) CGFloat progress; // 进度
@property (nonatomic,strong) UIView * progressView;
@property (nonatomic,assign) NSUInteger loadingCount; // 当前正在加载的URL数
@property (nonatomic,assign) NSUInteger maxLoadingCount;// 当前所有要加载的URL数
@property (nonatomic,strong) NSURL * currentURL;
@end

@implementation DMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"详情";
    self.webView = [[UIWebView alloc] init];
    {
        [self.view addSubview:self.webView];
        self.webView.delegate = self;
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(65);
        }];
       
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailUrl]]];
    }
    if(self.canShare)
    {
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
            
        }
    }
    
    
    self.progressView=[[UIView alloc] initWithFrame:CGRectMake(0, 66, 0, 2)];
    self.progressView.backgroundColor=mRGBToColor(0x67C600);
    [self.view addSubview:self.progressView];
    [self.view bringSubviewToFront:self.progressView];
    
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

-(void)resetProgress{
    _maxLoadingCount=_loadingCount=0;
    self.progress=0.0;
}

-(void)setProgress:(CGFloat)progress{
    
    if(progress>_progress||progress==0){
        _progress=progress;
        CGFloat maxWidth=mScreenWidth;
        CGFloat curWidth = _progress*maxWidth;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.progressView.alpha=1;
            self.progressView.frame=CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, curWidth, self.progressView.frame.size.height) ;
        }completion:^(BOOL finished) {
        }];
        if(_progress>=1){
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha=0;
            } completion:^(BOOL finished){
                self.progressView.frame=CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, 0, self.progressView.frame.size.height) ;
            }];
        }
    }
}

-(void)completeProgress{
    UALog(@"completeProgress");
    self.progress=1.0;
}
-(void)incrementProgress{
    
    CGFloat progress=self.progress;
    CGFloat maxProgress = 0.9;
    CGFloat remainPrecent = (float)_loadingCount/(float)_maxLoadingCount;
    CGFloat increment = (maxProgress-progress)*remainPrecent;
    
    progress+=increment;
    progress=fmin(progress, maxProgress);
    
    self.progress=progress;
}

#pragma mark UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (!isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        [self resetProgress];
        _currentURL=request.URL;
    }
    
    return YES;
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    _loadingCount++;
    _maxLoadingCount=fmax(_loadingCount, _maxLoadingCount);
    self.progress=0.1;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _loadingCount--;
    
    [self incrementProgress];
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"]||[readyState isEqualToString:@"interactive"];
    
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _loadingCount--;
    
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"]||[readyState isEqualToString:@"interactive"];
    if ((complete && isNotRedirect)|| error) {
        [self completeProgress];
    }
}

#pragma mark 分享

- (void)shareWithIndex:(NSInteger)index
{
    
    
    if(index == 0)
    {
        WBMessageObject *message = [WBMessageObject message];
        message.text = [NSString stringWithFormat:@"%@ %@ #简画大师#",self.detailTitle,self.detailUrl] ;
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
        message.title = self.detailTitle;
        message.description = self.detailTitle;
        
        
        [message setThumbImage:mImageByName(@"icon")];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = self.detailUrl;
        
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
        message.title = self.detailTitle;
        message.description = self.detailTitle;
        
        
        [message setThumbImage:mImageByName(@"icon")];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = self.detailUrl;
        
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
    QQApiTextObject *message = [[QQApiTextObject alloc] init];
    message.text = [NSString stringWithFormat:@"%@ %@ #简画大师#",self.detailTitle,self.detailUrl] ;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:message];
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
