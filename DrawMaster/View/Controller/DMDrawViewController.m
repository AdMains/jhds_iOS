//
//  DMDrawViewController.m
//  DrawMaster
//
//  Created by git on 16/6/28.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMDrawViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DMDrawView.h"
@interface DMDrawViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet DMDrawView *drawView;

@end

@implementation DMDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backBtn.layer.backgroundColor= mRGBToColor(0xeeeeee).CGColor;
    self.backBtn.layer.cornerRadius = 22.5;
    self.backBtn.alpha = 0.8;
    @weakify(self)
    self.backBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal empty];
    }];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
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



#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        [self shakeshake];
        [self.drawView shakeToClear];
    }
    return;
}

//  摇动结束后执行震动
- (void)shakeshake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
