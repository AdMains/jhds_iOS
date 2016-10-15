//
//  DMShareDetailViewController.m
//  DrawMaster
//
//  Created by git on 16/9/20.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareDetailViewController.h"
#import "DMAPIManager.h"
#import "DMShareDetailViewModel.h"
#import "DMShareCmTableViewCell.h"
#define MenumBarHeight 50


@interface DMShareDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,readwrite,strong) UILabel * titleLabel;
@property (nonatomic,readwrite,strong) UIView *topBar;

@property (nonatomic,readwrite,strong) UIView *menuBar;
@property (nonatomic,readwrite,strong) MASConstraint *menuBarTop;
@property (nonatomic,readwrite,strong) UITableView *tableView;

@property (nonatomic,readwrite,assign) CGFloat repostOffsety;
@property (nonatomic,readwrite,assign) CGFloat commentOffsety;
@property (nonatomic,readwrite,assign) CGFloat goodOffsety;

@property (nonatomic,readwrite,strong) UIView *btnBox;
@property (nonatomic,readwrite,strong) UIView *lineBox;
@property (nonatomic,readwrite,strong) MASConstraint *bottomLineLeft;
@property (nonatomic,readwrite,strong) DMShareDetailViewModel* viewModel;

@end

@implementation DMShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    @weakify(self)
    
    if(self.selectMenumIndex == 0)
        self.selectMenumIndex = 12;
    
    self.viewModel = [[DMShareDetailViewModel alloc] initWithWeiboIdstr:self.weiboIdstr];
    self.topBar = [[UIView alloc] init];
    {
     
        
        [self.view addSubview:self.topBar];
        [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(65);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        {
            self.titleLabel.text = @"哇晒正文";
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
        
        UIButton * backBtn = [[UIButton alloc] init];
        {
            @weakify(self);
            [self.topBar addSubview:backBtn];
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
        
    }
    
    self.tableView = [[UITableView alloc] init];
    {
       
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(65);
        }];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, self.headHeight+MenumBarHeight)];
        {
            UIButton * userIcon = [[UIButton alloc] init];
            {
                [headView addSubview:userIcon];
                [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(8);
                    make.top.mas_equalTo(4);
                    make.height.width.mas_equalTo(40);
                }];
                [userIcon sd_setImageWithURL:[NSURL URLWithString:self.headUserIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_share"]];
                
            }
            
            UILabel *userName = [[UILabel alloc] init];
            {
                [headView addSubview:userName];
                [userName mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(userIcon.mas_right).offset(8);
                    make.top.mas_equalTo(4);
                    make.height.mas_equalTo(20);
                    make.right.mas_equalTo(-8);
                }];
                userName.text = self.headNickName;
                userName.font = [UIFont systemFontOfSize:14];
                userName.textColor = [UIColor orangeColor];
                
            }
            
            UILabel *creatTime = [[UILabel alloc] init];
            {
                [headView addSubview:creatTime];
                [creatTime mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(userIcon.mas_right).offset(8);
                    make.top.equalTo(userName.mas_bottom);
                    make.height.mas_equalTo(20);
                    make.right.mas_equalTo(-8);
                }];
                creatTime.text = self.headCreateAtTime;
                creatTime.font = [UIFont systemFontOfSize:12];
                creatTime.textColor = [UIColor lightGrayColor];
                
            }
            
            UITextView *content = [[UITextView alloc] init];
            {
                [headView addSubview:content];
                [content mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(8);
                    make.right.mas_equalTo(-8);
                    make.top.equalTo(creatTime.mas_bottom);
                    make.height.mas_equalTo([self.headShareText boundingRectWithSize:CGSizeMake(mScreenWidth-16-10, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size.height);
                   
                }];
                content.attributedText = self.headShareText;

            }
            
            for (NSUInteger i = 0; i<self.headSmallPic.count; i++) {
                UIButton * img = [[UIButton alloc] init];
                {
                    [headView addSubview:img];
                    CGFloat imgw = (mScreenWidth-4*8)/3;
                    CGFloat imgh = imgw*1.5;
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(content.mas_bottom).offset((i/3)* (imgh+8)-10);
                        NSUInteger index = i%3;
                        make.left.mas_equalTo(index*imgw+(index+1)*8);
                        make.width.mas_equalTo(imgw);
                        make.height.mas_equalTo(imgh);
                    }];
                    
                    [img sd_setImageWithURL:[NSURL URLWithString:self.headSmallPic[i]] forState:UIControlStateNormal placeholderImage:[UIImage qgocc_imageWithColor:mRGBToColor(0xeeeeee) size:CGSizeMake(300, 300)]];
                }
                
            }
            
        }
        headView.backgroundColor = mRGBToColor(0xffffff);
        self.tableView.tableHeaderView = headView;
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DMShareCmTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([DMShareCmTableViewCell class])];
        
        
        self.menuBar = [[UIView alloc] init];
        {
            CGFloat grayh =10;
            self.menuBar.backgroundColor = mRGBToColor(0xeeeeee);
            [self.tableView addSubview:self.menuBar];
            [self.menuBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                self.menuBarTop = make.top.mas_equalTo(self.headHeight);
                make.height.mas_equalTo(MenumBarHeight);
                make.width.mas_equalTo(mScreenWidth);
            }];
            
            UIView *line = [[UIView alloc] init];
            {
                [self.menuBar addSubview:line];
                line.backgroundColor = mRGBToColor(0xaaaaaa);
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                }];
            }
            UIView *line2 = [[UIView alloc] init];
            {
                [self.menuBar addSubview:line2];
                line2.backgroundColor = mRGBToColor(0xaaaaaa);
                [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                    make.top.mas_equalTo(grayh);
                }];
            }
            self.btnBox = [[UIView alloc] init];
            {
                [self.menuBar addSubview:self.btnBox];
                self.btnBox.backgroundColor = mRGBToColor(0xffffff);
                [self.btnBox mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(MenumBarHeight-grayh-1);
                    make.top.mas_equalTo(grayh+0.5);
                }];
                
                UIButton * repostBtn = [[UIButton alloc] init];
                {
                    [self.btnBox addSubview:repostBtn];
                    repostBtn.tag = 11;
                    [repostBtn setTitle:@"转发0" forState:UIControlStateNormal];
                    [repostBtn setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
                    repostBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    //[repostBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                    [repostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(8);
                        make.width.mas_equalTo(60);
                        make.height.mas_equalTo(30);
                        make.centerY.mas_equalTo(0);
                        
                    }];
                    
                    [repostBtn addTarget:self action:@selector(selectMenum:) forControlEvents:UIControlEventTouchUpInside];
                    if(self.selectMenumIndex == repostBtn.tag)
                    {
                        [self selectMenum:repostBtn];
                    }
                }
                
                UIButton * commentsBtn = [[UIButton alloc] init];
                {
                    [self.btnBox addSubview:commentsBtn];
                    commentsBtn.tag = 12;
                    [commentsBtn setTitle:@"评论0" forState:UIControlStateNormal];
                    [commentsBtn setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
                    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    //[commentsBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                    [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(68);
                        make.width.mas_equalTo(60);
                        make.height.mas_equalTo(30);
                        make.centerY.mas_equalTo(0);
                        
                    }];
                    [commentsBtn addTarget:self action:@selector(selectMenum:) forControlEvents:UIControlEventTouchUpInside];
                    if(self.selectMenumIndex == commentsBtn.tag)
                    {
                        [self selectMenum:commentsBtn];
                    }
                }
                
                UIButton * goodBtn = [[UIButton alloc] init];
                {
                    [self.btnBox addSubview:goodBtn];
                    goodBtn.tag = 13;
                    [goodBtn setTitle:@"赞0" forState:UIControlStateNormal];
                    [goodBtn setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
                    goodBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    //[goodBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                    [goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-8);
                        make.width.mas_equalTo(60);
                        make.height.mas_equalTo(30);
                        make.centerY.mas_equalTo(0);
                        
                    }];
                    
                    //[goodBtn addTarget:self action:@selector(selectMenum:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if(self.selectMenumIndex == goodBtn.tag)
                    {
                        [self selectMenum:goodBtn];
                    }
                }
                
                if (self.logined)
                {
                    [[[DMAPIManager sharedManager] fetchWeiboNumWithIdstr:self.weiboIdstr] subscribeNext:^(NSArray* x) {
                        
                        [repostBtn setTitle:[NSString stringWithFormat:@"%@%@",@"转发",[[x objectAtIndex:0] stringValue]] forState:UIControlStateNormal];
                        [commentsBtn setTitle:[NSString stringWithFormat:@"%@%@",@"评论",[[x objectAtIndex:1] stringValue]] forState:UIControlStateNormal];
                        [goodBtn setTitle:[NSString stringWithFormat:@"%@%@",@"赞",[[x objectAtIndex:2] stringValue]] forState:UIControlStateNormal];
                    }];
                }
                

            }
            
            UIView *line3 = [[UIView alloc] init];
            {
                [self.menuBar addSubview:line3];
                line3.backgroundColor = mRGBToColor(0xaaaaaa);
                [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                    make.bottom.mas_equalTo(0);
                }];
            }
            
            self.lineBox = [[UIView alloc] init];
            {
                [self.menuBar addSubview:self.lineBox];
                [self.lineBox mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(-0.5);
                    make.height.mas_equalTo(1.5);
                }];
            }
            UIView *line4 = [[UIView alloc] init];
            {
                [self.lineBox addSubview:line4];
                line4.backgroundColor = [UIColor orangeColor];
                [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
                    self.bottomLineLeft = make.left.mas_equalTo(8);
                    make.height.mas_equalTo(1.5);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(60);
                }];
            }
            
            [RACObserve(self.view, tag) subscribeNext:^(id x) {
                @strongify(self)
                switch ([x intValue]) {
                    case 11:
                        {
                            [UIView animateWithDuration:0.2 animations:^{
                                self.bottomLineLeft.mas_equalTo(8);
                                [self.lineBox layoutIfNeeded];
                            }];
                        }
                        break;
                    case 12:
                        {
                            [UIView animateWithDuration:0.2 animations:^{
                                self.bottomLineLeft.mas_equalTo(68);
                                [self.lineBox layoutIfNeeded];
                            }];
                        }
                        
                        break;
                    case 13:
                        {
                            [UIView animateWithDuration:0.2 animations:^{
                                self.bottomLineLeft.mas_equalTo(mScreenWidth - 68);
                                [self.lineBox layoutIfNeeded];
                            }];
                        }
                        
                        break;
                    default:
                        break;
                }
            }];

        }
        
        
    }
    
    [[self.viewModel fetchDataWithMore:NO] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
    

}

- (void)selectMenum:(UIButton*)sender
{
    switch (self.view.tag) {
        case 11:
            self.repostOffsety =self.tableView.contentOffset.y;
            
            break;
        case 12:
            self.commentOffsety =self.tableView.contentOffset.y;
            break;
        case 13:
            self.goodOffsety =self.tableView.contentOffset.y;
            break;
        default:
            break;
    }
    if(self.view.tag != 0)
    {
        [(UIButton*)[self.btnBox viewWithTag:self.view.tag] setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
        ((UIButton*)[self.btnBox viewWithTag:self.view.tag]).titleLabel.font = [UIFont systemFontOfSize:14];
    }
    self.view.tag = sender.tag;
    self.viewModel.selectIndex = sender.tag;
    if(self.view.tag != 0)
    {
        [(UIButton*)[self.btnBox viewWithTag:self.view.tag] setTitleColor:mRGBToColor(0x000000) forState:UIControlStateNormal];
        ((UIButton*)[self.btnBox viewWithTag:self.view.tag]).titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    switch (sender.tag) {
        case 11:
            if(self.repostOffsety<self.headHeight && self.tableView.contentOffset.y>self.headHeight)
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.headHeight);
            else
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.repostOffsety);
            break;
        case 12:
            if(self.commentOffsety<self.headHeight && self.tableView.contentOffset.y>self.headHeight)
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.headHeight);
            else
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.commentOffsety);
            break;
        case 13:
            if(self.goodOffsety<self.headHeight && self.tableView.contentOffset.y>self.headHeight)
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.headHeight);
            else
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.goodOffsety);
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        if([[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y >self.headHeight)
        {
            self.menuBarTop.mas_equalTo(self.headHeight + [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y-self.headHeight);
        }
        else
        {
            self.menuBarTop.mas_equalTo(self.headHeight);
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.viewModel commentNum];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMShareCmTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DMShareCmTableViewCell class])];
    
    cell.contentText.attributedText = [self.viewModel commentTextWithIndex:indexPath.row];
    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:[self.viewModel commentUserIconWithIndex:indexPath.row]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_share"]];
    cell.userNickName.textColor = [UIColor orangeColor];
    cell.userNickName.text = [self.viewModel commentNickNameWithIndex:indexPath.row];
    cell.createAt.text = [self.viewModel commentTimeWithIndex:indexPath.row];
    cell.contentTextHeight.constant = [self.viewModel commentTextHeightWithIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];

    
}


@end
