//
//  DMCopyViewController.m
//  DrawMaster
//
//  Created by git on 16/6/22.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMCopyViewController.h"
#import "DMCopyViewModel.h"
#import "DMCopySubViewController.h"
@interface DMCopyViewController ()
@property (weak, nonatomic) IBOutlet QGCollectionMenu *sub;
@property (nonatomic,readwrite,strong) NSMutableArray* viewModels;
@property (nonatomic,readwrite,strong) NSArray* titles;
@property (nonatomic,readwrite,strong) NSArray* subClassStrs;
@end

@implementation DMCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModels  = [NSMutableArray array];
    self.titles = [[NSArray alloc] initWithObjects:@"动物", @"植物",@"人物",@"其他",nil];
    self.subClassStrs = [[NSArray alloc] initWithObjects:@"DMCopySubViewController", @"DMCopySubViewController",@"DMCopySubViewController",@"DMCopySubViewController",nil];
    for (int i=0;i<self.titles.count;++i) {
        DMCopyViewModel *vm = [[DMCopyViewModel alloc] initWithType:@(i).stringValue];
        [self.viewModels addObject:vm];
    }
    
    
    {
        
        self.sub.delegate =self;
        self.sub.dataSource = self;
        [self.sub reload];
        
    }
    self.title = @"临摹";
    
    
    
    
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

//
- (NSArray*)menumTitles
{
    return self.titles;
}
//
- (NSArray*)subVCClassStrsForStoryBoard
{
    return nil;
}
//
- (NSArray*)subVCClassStrsForCode
{
    return self.subClassStrs;
}

- (void)updateSubVCWithIndex:(NSInteger)index
{
    NSArray *sub =  self.childViewControllers;
    for (DMCopySubViewController * subView in sub) {
        subView.view.backgroundColor = mRGBToColor(0xdddddd);
        subView.viewModel = self.viewModels[index];
        
        [subView.collecttionView reloadData];
        if([subView.viewModel copyNum] == 0)
        {
            [subView.collecttionView triggerPullToRefresh];
        }
    }
}

@end
