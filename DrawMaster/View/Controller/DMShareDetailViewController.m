//
//  DMShareDetailViewController.m
//  DrawMaster
//
//  Created by git on 16/9/20.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareDetailViewController.h"

@interface DMShareDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,readwrite,strong) UILabel * titleLabel;
@property (nonatomic,readwrite,strong) UIView *topBar;

@property (nonatomic,readwrite,strong) UIView *menuBar;
@property (nonatomic,readwrite,strong) MASConstraint *menuBarTop;
@property (nonatomic,readwrite,strong) UITableView *tableView;
@property (nonatomic,readwrite,strong) NSMutableArray *repostsArray;
@property (nonatomic,readwrite,strong) NSMutableArray *commentsArray;
@property (nonatomic,readwrite,strong) NSMutableArray *goodsArray;
@property (nonatomic,readwrite,assign) CGFloat repostOffsety;
@property (nonatomic,readwrite,assign) CGFloat commentOffsety;
@property (nonatomic,readwrite,assign) CGFloat goodOffsety;
@property (nonatomic,readwrite,assign) BOOL menuBarLock;
@property (nonatomic,readwrite,assign) CGFloat headHeight;
@end

@implementation DMShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuBarLock = NO;
    self.headHeight = 400;
    self.topBar = [[UIView alloc] init];
    {
        self.repostsArray = [NSMutableArray array];
        self.commentsArray = [NSMutableArray array];
        self.goodsArray = [NSMutableArray array];
        for (int i = 0; i<300; ++i) {
            [self.repostsArray addObject:@"AAAAAAAA"];
            [self.commentsArray addObject:@"BBBBBBB"];
            [self.goodsArray addObject:@"CCCCCCCC"];
        }
        
        self.view.tag = 11;
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
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 465)];
        headView.backgroundColor = [UIColor orangeColor];
        self.tableView.tableHeaderView = headView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        
        self.menuBar = [[UIView alloc] init];
        {
            self.menuBar.backgroundColor = [UIColor blueColor];
            [self.tableView addSubview:self.menuBar];
            [self.menuBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                self.menuBarTop = make.top.mas_equalTo(self.headHeight);
                make.height.mas_equalTo(65);
                make.width.mas_equalTo(mScreenWidth);
            }];
            
            UIButton * repostBtn = [[UIButton alloc] init];
            {
                [self.menuBar addSubview:repostBtn];
                repostBtn.tag = 11;
                [repostBtn setTitle:@"转发" forState:UIControlStateNormal];
                [repostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(20);
                    make.width.mas_equalTo(70);
                    make.height.mas_equalTo(40);
                    make.centerY.mas_equalTo(0);
                    
                }];
                [repostBtn addTarget:self action:@selector(selectMenum:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            UIButton * commentsBtn = [[UIButton alloc] init];
            {
                [self.menuBar addSubview:commentsBtn];
                commentsBtn.tag = 12;
                [commentsBtn setTitle:@"评论" forState:UIControlStateNormal];
                [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.width.mas_equalTo(70);
                    make.height.mas_equalTo(40);
                    make.centerY.mas_equalTo(0);
                    
                }];
                [commentsBtn addTarget:self action:@selector(selectMenum:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            UIButton * goodBtn = [[UIButton alloc] init];
            {
                [self.menuBar addSubview:goodBtn];
                goodBtn.tag = 13;
                [goodBtn setTitle:@"赞" forState:UIControlStateNormal];
                [goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.width.mas_equalTo(70);
                    make.height.mas_equalTo(40);
                    make.centerY.mas_equalTo(0);
                    
                }];
                
                [goodBtn addTarget:self action:@selector(selectMenum:) forControlEvents:UIControlEventTouchUpInside];
            }

        }
        
        
    }
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    

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
    
    self.view.tag = sender.tag;
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
    NSMutableArray * array = nil;
    switch (self.view.tag) {
        case 11:
            array =  self.repostsArray;
            break;
        case 12:
            array =  self.commentsArray;
            break;
        case 13:
            array =  self.goodsArray;
            break;
        default:
            break;
    }
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    NSMutableArray * array = nil;
    switch (self.view.tag) {
        case 11:
            array =  self.repostsArray;
            break;
        case 12:
            array =  self.commentsArray;
            break;
        case 13:
            array =  self.goodsArray;
            break;
        default:
            break;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[array objectAtIndex:indexPath.row],@(indexPath.row)];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = mRGBToColor(0x666666);
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 55;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
