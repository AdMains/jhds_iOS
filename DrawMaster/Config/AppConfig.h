

/*－－－－－－－－－－－－－－－－－－－－app的相关配置－－－－－－－－－－－－－－－－－－*/
/*---------------------------------相关值根据需要自行更改------------------------*/

#define kAPIBaseURI @"http://quangelab.com"
#define kBaiduAPIKey @"02296dd93f1940a39913d9a406332486"
#define kBaiduSecretKey @"c790af68cc294b82b52fc87cc1b79264"
#define kUMengKey       @"5784568e67e58ee8f800110c"
#define kShareSDKKey    @""
#define kQZoneId        @""
#define kQZoneKey       @""


/*---------------------------------用户相关信息-------------------------------------*/

#define kUsername           @"usernameNew"
#define kUserNickname       @"userNicknameNew"
#define kUserPassword       @"userPassword"
#define kUserID             @"userID"
#define kUserToken          @"userToken"
#define kUserPortraitUrl    @"userPortraitUrl"
#define kUserEmail          @"userEmail"
#define kUserGender         @"userGender"
#define kUserSign           @"userSign"
#define kUserTelephone      @"userTelephone"
#define kUserStatus         @"userStatus"
#define kUserType           @"userType"
#define kUserOSPlatform     @"userOSPlatform"




/*---------------------------------程序相关常数-------------------------------------*/
//App Id、下载地址、评价地址
#define kAppId      @"593499239"
#define kAppUrl     [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ling-hao-xian/id%@?ls=1&mt=8",kAppId]
#define kRateUrl    [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppId]

#define kPlaceholderImage       [UIImage imageNamed:@"lessonDefult"]
#define kUserPlaceHoldImage [UIImage imageNamed:@"userImageDefault.png"]


/*---------------------------------程序全局通知-------------------------------------*/
//新浪登录通知
#define kSinaLoginNotification    @"SinaLoginNotification"
#define kVideoDownloadUpdateNotification @"VideoDownloadUpdateNotification"
#define kLessonDetailInputCommentNotification @"LessonDetailInputCommentNotification"
#define kCointProductPayedNotification @"kCointProductPayedNotification"
/*---------------------------------程序界面配置信息-------------------------------------*/

//设置app界面字体及颜色

#define kTitleFontLarge              [UIFont boldSystemFontOfSize:25]//一级标题字号
#define kTitleFontMiddle             [UIFont boldSystemFontOfSize:19]//二级标题字号
#define kTitleFontSmall              [UIFont boldSystemFontOfSize:16]//三级标题字号

#define kContentFontXLarge           [UIFont systemFontOfSize:25]  //内容部分特大字号
#define kContentFontLarge            [UIFont systemFontOfSize:19]  //内容部分大字号
#define kContentFontMiddle           [UIFont systemFontOfSize:16]  //内容部分中字号
#define kContentFontSmall            [UIFont systemFontOfSize:13]  //内容部分小字号
#define kContentFontLeast            [UIFont systemFontOfSize:10]  //内容部分特小字号
#define kLessonTitleFont             [UIFont systemFontOfSize:14] //课程标题文字
#define kLessonOrtherInfoFont        [UIFont systemFontOfSize:10] //课程课时及c币等的字体
#define kNavTitleFont                [UIFont boldSystemFontOfSize:18]//导航条字体
#define kContentFontNormal           [UIFont systemFontOfSize:14]  //描述内容字体
#define kMoneyFontLarge              [UIFont systemFontOfSize:24]  //价格较大字体
#define kMoneyFontVeryLarge          [UIFont systemFontOfSize:36]  //价格非常大字体
#define kBuyBtnFont                  [UIFont systemFontOfSize:20]  //购买按钮的字体
#define kTipNumFont                  [UIFont systemFontOfSize:8]  //小数字字体
#define kLessonRightContentFont      [UIFont systemFontOfSize:18]  //小数字字体
//内容部分正常显示颜色和突出显示颜色
#define kContentColorNormal      [UIColor colorWithRed:57/255.0 green:32/255.0 blue:0/255.0 alpha:1]
#define kContentColorHighlight   [UIColor colorWithRed:0/255.0 green:191/255.0 blue:225/255.0 alpha:1]

//几个常用色彩

#define kTabSelectColor         mRGBToColor(0x11bb11)
#define kTabColor         mRGBToColor(0x666666)

#define kNavTitleColor          mRGBToColor(0x262626)
#define kWhiteColor             [UIColor whiteColor]
#define kBlackColor             [UIColor blackColor]
#define kClearColor             [UIColor clearColor]

#define kSmallTextGrayColor     mRGBToColor(0x9b9b9b)
#define kContentColor           mRGBToColor(0x4a4a4a)
#define kLessonTitleColor           mRGBToColor(0x4a4a4a)
#define kLessonOrtherInforNomalColor           mRGBToColor(0x9B9B9B)
#define kLessonOrtherInforHighlight           mRGBToColor(0x00A5C6)
#define kSegmentNormalColor     mRGBToColor(0x9B9B9B)
#define kSegmentHighlightColor       mRGBToColor(0xE44624)
#define kLineColor              mRGBToColor(0xc9c9c9)
#define kMoneyColor             mRGBToColor(0xff7300)
#define kWillBuyBtnColor        mRGBToColor(0x4dccc3)
#define kNowBuyBtnColor         mRGBToColor(0xfe6b6b)
#define kImageViewBorderColor mRGBToColor(0xA9A9A9)

#define kPackageTextBackgroundColor mRGBToColor(0xB9E78B)
#define kVIPTextBackgroundPakeColor mRGBToColor(0xF14C58)

#define kShadowColor mRGBToColor(0x8D8D8D)


#define kBottomBarHeight 70
#define kBottomBarBackgroundColor mRGBAToColor(0x54626F, 0.88)

//界面布局
#define kLeftOrRightEdgeInset           50 //所有界面左右边距
#define kNavIconWith                    24 //导航条上的图标的大小
#define kNavIconSpace                   24 //导航条上的图标之间的间距
#define kNavLeftOrRightEdgeInset        24 //导航条左右控件的默认边距
#define kNavHeight                      65
#define kCellUserBarHeight              48
#define kCellNum 12




/*---------------------------------第三方登录-------------------------------------*/

#define kSinaKey @"3129504298"

#define kWeixin_Parther @"1261353101"
#define kWeixinAppKey @"wxd9d724f78ea966a8"
#define kWeixinAppSecret @"f7d57a7ef45aa1a6399f64c8dfce34b6"
#define kWeixinCode @"weixinCode"
#define kWeixinTypeLogin @"CSDNInteractionWeixinLoginType"

#define kTencentAppId @"1105413313"
//#define kTencentAppId @"100270989"
#define kTencentKey @"NkkJ9gXOebppQEgd"
#define kQQTypeLogin @"CSDNInteractionQQLoginType"

#define kCSDNLogin @"csdnlogin"
#define kSinatLogin @"sinat"
#define kWeixin     @"weixin"
#define kQQLogin     @"qq"

#define kAliPay_Parther @"2088911953581392"
#define kAliPay_Seller @"xueyuan@csdn.net"
#define kAliPay_Notify_URl @"http://pay.csdn.net/returns/edu_mobile_notify_url"
#define kAliPay_Return_URL @"http://pay.csdn.net/returns/edu_return_url"
#define kAliPay_AppScheme @"edualipay"
