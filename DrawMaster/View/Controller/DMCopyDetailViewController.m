//
//  DMCopyDetailViewController.m
//  DrawMaster
//
//  Created by git on 16/7/4.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMCopyDetailViewController.h"
#import "DMCopyDetailCollectionViewCell.h"
#import "DMBigImgBoxView.h"
@interface DMCopyDetailViewController ()<DMBigImgBoxViewDelegate>
@property (weak, nonatomic) IBOutlet DMBigImgBoxView *imgInfoBoxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgInfoBoxWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgInfoBoxHeight;


@end

@implementation DMCopyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imgInfoBoxView.imgUrls = self.imgUrls;
    self.brushView.hidden = YES;
    self.imgInfoBoxView.delegate = self;
    self.imgInfoBoxView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imgInfoBoxView.layer.borderWidth = 1.0;
    @weakify(self)
    self.imgInfoBoxView.tryBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self scaleImgInfoBoxView:self.imgInfoBoxView.tag == 1];
        self.imgInfoBoxView.tag = self.imgInfoBoxView.tag == 0?1:0;
        return [RACSignal empty];
    }];
    
    
    self.imgInfoBoxWidth.constant = mScreenWidth;
    self.imgInfoBoxHeight.constant = mScreenHeight;
}

- (void)scaleImgInfoBoxView:(BOOL)scale
{
    [UIView animateWithDuration:0.1 animations:^{
        self.imgInfoBoxWidth.constant = scale?mScreenWidth:(mScreenWidth/(mIsPad?5:4));
        self.imgInfoBoxHeight.constant = scale?mScreenHeight:(mScreenHeight/(mIsPad?5:4));
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.imgInfoBoxView.fullScreen = @(scale);
        self.brushView.hidden = scale;
        
    }];
}

- (void)clickImg:(BOOL)fullScree
{
    if(fullScree)
        return;
    self.imgInfoBoxView.tag =0;
    [self scaleImgInfoBoxView:YES];
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




@end
