//
//  DMShareCollectionViewCell.h
//  DrawMaster
//
//  Created by git on 16/8/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMShareNumView.h"
@protocol DMShareCollectionViewCellDelegate <NSObject>

- (void)gotoImgDetail:(NSInteger)tag indexRow:(NSInteger)row;

@end

@interface DMShareCollectionViewCell : UICollectionViewCell
@property (weak,nonatomic) id <DMShareCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *createAtTime;
@property (weak, nonatomic) IBOutlet UITextView *shareText;
@property (weak, nonatomic) IBOutlet UIView *imgTopBox;
@property (weak, nonatomic) IBOutlet UIView *imgCenterBox;
@property (weak, nonatomic) IBOutlet UIView *imgBottomBox;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn0;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn2;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn3;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn4;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn5;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn6;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn7;
@property (weak, nonatomic) IBOutlet UIButton *shareImgBtn8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareTextHeight;

@property (weak, nonatomic) IBOutlet DMShareNumView *shareNumBoxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareNumBoxViewTop;
@property (weak, nonatomic) IBOutlet UIButton *repostNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *atrributeNumBtn;
- (IBAction)gotoImgDetail:(UIButton *)sender;


@end
