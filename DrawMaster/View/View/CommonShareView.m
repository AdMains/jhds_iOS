//
//  CommonShareView.m
//  DrawMaster
//
//  Created by git on 16/7/6.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "CommonShareView.h"

@interface CommonShareView ()
@property(nonatomic,readwrite,strong) MASConstraint *bootomViewBottom;
@property(nonatomic,readwrite,strong) NSArray *shareMessages;
@end

@implementation CommonShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)sharedView
{
    static CommonShareView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
      
        self.hidden = YES;
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:self];
        self.backgroundColor = [UIColor colorWithWhite:0.098 alpha:0.190];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        self.shareMessages = @[@"叮咚，新鲜的简画出炉了，看我画的还凑合吧？#简画大师#",
                               @"快来瞧，看来看，我刚创作了一番，看看我的水平是啥等级的#简画大师#",
                               @"哎呀，妈呀，累死我了，终于画完了#简画大师#",
                               @"小手一抖，简画在手#简画大师#",
                               @"啥？我画的不好看？你来试试#简画大师#",
                               @"you can you up，no can no BB？#简画大师#",
                               @"快得了吧，这是我画的最好的了，😄？#简画大师#",
                               @"简画，就是简单，想画就画，我骄傲😄？#简画大师#",
                               @"一句话：不服来画给我看。#简画大师#"];
        [self buildView];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)buildView {
    UIView * bottom = [[UIView alloc] init];
    {
        [self addSubview:bottom];
        bottom.backgroundColor = mRGBToColor(0xeeeeee);
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(160);
            self.bootomViewBottom = make.bottom.mas_equalTo(160);
        }];
    }
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    {
        [bottom addSubview:cancelBtn];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.layer.backgroundColor = mRGBToColor(0x444444).CGColor;
        cancelBtn.layer.cornerRadius = 5;
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    NSArray * icons = @[@"more_weibo",@"more_weixin",@"more_circlefriends",@"qq"];
     NSArray * name = @[@"微博",@"微信",@"朋友圈",@"QQ"];
    for (int i = 0; i<icons.count; ++i) {
        UIButton *btn = [[UIButton alloc] init];
        {
            btn.tag = i;
            [bottom addSubview:btn];
            CGFloat btnWidth = 60;
            CGFloat mm = (mScreenWidth-btnWidth*icons.count)/(icons.count+1);
            [btn setTitle:name[i] forState:UIControlStateNormal];
            [btn setTitleColor:mRGBToColor(0x333333) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.titleEdgeInsets = UIEdgeInsetsMake(btnWidth, -btnWidth+5, 0, 0);
            [btn setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(btnWidth);
                make.top.mas_equalTo(20);
                make.left.mas_equalTo(mm*(i+1)+i*btnWidth);
            }];
            [btn addTarget:self action:@selector(clickFroBtn:) forControlEvents:UIControlEventTouchUpInside];
            
        }

        
    }
}

- (void)clickFroBtn:(UIButton*)btn
{
    [self.delegate shareWithIndex:btn.tag];
    [self hide];
}

- (void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bootomViewBottom.mas_equalTo(160);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];

}

- (void)show
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.bootomViewBottom.mas_equalTo(0);
            [self layoutIfNeeded];
        }];
    });
    
    
}

- (NSString*)shareMessageWithType:(NSInteger)type
{
    int value = arc4random()% (self.shareMessages.count-1);
    return self.shareMessages[value];
}
@end
