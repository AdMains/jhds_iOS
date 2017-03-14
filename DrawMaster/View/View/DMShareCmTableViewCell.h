//
//  DMShareCmTableViewCell.h
//  DrawMaster
//
//  Created by git on 16/10/13.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMShareCmTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UILabel *createAt;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextHeight;

@end
