//
//  DMShareCollectionViewCell.m
//  DrawMaster
//
//  Created by git on 16/8/1.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareCollectionViewCell.h"

@implementation DMShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (IBAction)gotoImgDetail:(UIButton *)sender {
    [self.delegate gotoImgDetail:sender.tag indexRow:self.tag];
}
@end
