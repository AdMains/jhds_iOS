//
//  DMShareInputCommentViewController.m
//  DrawMaster
//
//  Created by git on 16/10/16.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareInputCommentViewController.h"
#import "DMAPIManager.h"

@interface DMShareInputCommentViewController ()
@property (nonatomic,readwrite,strong) UILabel * titleLabel;
@property (nonatomic,readwrite,strong) UIView *topBar;
@property (nonatomic,readwrite,strong) UITextView *commentTextView;
@property (nonatomic,readwrite,strong) UIButton * sendBtn;
@property (nonatomic,readwrite,strong) UILabel *numLabel;
@end

@implementation DMShareInputCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.commentTextView = [[UITextView alloc] init];
    {
        self.commentTextView.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:self.commentTextView];
        [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(50);
            make.bottom.mas_equalTo(0);
        }];
        
        [self.commentTextView becomeFirstResponder];
    }
    
    self.numLabel = [[UILabel alloc] init];
    {
        [self.view addSubview:self.numLabel];
        self.numLabel.textColor = [UIColor redColor];
        self.numLabel.font = [UIFont systemFontOfSize:12];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.right.mas_equalTo(-2);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    }
    self.topBar = [[UIView alloc] init];
    {
        
        
        [self.view addSubview:self.topBar];
        [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(65);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        {
            self.titleLabel.text = @"发评论";
            self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            self.titleLabel.textColor = mRGBToColor(0x333333);
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.topBar addSubview:self.titleLabel];
            
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
            
        }
        
        UILabel *name  = [[UILabel alloc] init];
        {
            name.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"DMWeiboNickName"];
            name.font = [UIFont boldSystemFontOfSize:14];
            name.textColor = mRGBToColor(0xdddddd);
            name.textAlignment = NSTextAlignmentCenter;
            [self.topBar addSubview:name];
            
            [name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(40);
                make.height.mas_equalTo(15);
            }];
            
        }
        
        UIButton * backBtn = [[UIButton alloc] init];
        {
            @weakify(self);
            [self.topBar addSubview:backBtn];
            backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [backBtn setTitle:@"取消" forState:UIControlStateNormal];
            [backBtn setTitleColor:mRGBToColor(0x555555) forState:UIControlStateNormal];
            backBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
                return [RACSignal empty];
            }];
            
            [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(30);
                make.width.mas_equalTo(50);
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
        
        self.sendBtn = [[UIButton alloc] init];
        {
            @weakify(self);
            [self.topBar addSubview:self.sendBtn];
            self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
            [self.sendBtn setTitleColor:mRGBToColor(0xdddddd) forState:UIControlStateDisabled];
            [self.sendBtn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateNormal];
            
            self.sendBtn.layer.borderWidth = 1.0;
            
            
            
            self.sendBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                
                if(self.commentTextView.text.length>140)
                {
                    [self showLoadAlertView:@"最多输入140个字" imageName:nil autoHide:YES];
                }
                else
                {
                    [self comment];
                }
                
                NSLog(@"输入的评论字数为%@",@(self.commentTextView.text.length));
                return [RACSignal empty];
            }];
            
            [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-8);
                make.top.mas_equalTo(30);
                make.width.mas_equalTo(45);
                make.height.mas_equalTo(25);
            }];
            
        }
        
        [self.commentTextView.rac_textSignal subscribeNext:^(NSString* text) {
            @strongify(self)
            self.numLabel.text = [@"-" stringByAppendingString:@(text.length - 140).stringValue] ;
            self.numLabel.hidden = (text.length<=140);
            if(text.length == 0)
            {
                self.sendBtn.enabled = NO;
                self.sendBtn.layer.cornerRadius = 3.0f;
                self.sendBtn.layer.borderColor = mRGBToColor(0xdddddd).CGColor;
                self.sendBtn.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                self.sendBtn.enabled = YES;
                self.sendBtn.layer.cornerRadius = 3.0f;
                self.sendBtn.layer.borderColor = [UIColor orangeColor].CGColor;
                self.sendBtn.backgroundColor = [UIColor orangeColor];
                
               
                
                
            }
        }];
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

- (void)comment
{
    [self showLoadAlertView:@"正在评论" imageName:nil autoHide:NO];
    @weakify(self)
    
    [[self.viewModel commentWithBody:self.commentTextView.text] subscribeNext:^(id x) {
        @strongify(self)
        if(x != nil)
        {
            [self hideLoadAlertView];
            [self showLoadAlertView:@"评论成功" imageName:nil autoHide:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self hideLoadAlertView];
            [self showLoadAlertView:@"评论失败，请稍后再试" imageName:nil autoHide:YES];
        }
    } error:^(NSError *error) {
        @strongify(self)
        [self hideLoadAlertView];
        [self showLoadAlertView:@"评论失败，请稍后再试" imageName:nil autoHide:YES];
    }];
}

@end
