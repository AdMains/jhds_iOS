//
//  DMMineViewController.m
//  DrawMaster
//
//  Created by git on 16/6/22.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMMineViewController.h"
#import "DMMineTableViewCell.h"
#import "DMDrawViewController.h"
#import "DMCopyDetailViewController.h"
@interface DMMineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,readwrite,strong) NSArray *data;

@end

@implementation DMMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    
    self.data = @[@[@{@"name":@"1",@"icon":@""},
  @{@"name":@"已保存",@"icon":@"icon_my_save"},
  @{@"name":@"上一次",@"icon":@"icon_my_last"}],
                  
  @[@{@"name":@"简便宜",@"icon":@"icon_my_buy"},
  @{@"name":@"官方公告",@"icon":@"icon_my_last"}],
                  
  @[@{@"name":@"守护宝贝",@"icon":@"icon_my_protect_baby"}],
                  
  @[@{@"name":@"给我好评",@"icon":@"icon_my_set"}]];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([DMMineTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([DMMineTableViewCell class])];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [[self.data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.backgroundColor = mRGBToColor(0xeeeeee);
        if(cell.contentView.subviews.count == 0)
        {
            UIImageView * icon = [[UIImageView alloc] init];
            {
                [cell addSubview:icon];
                icon.layer.cornerRadius = 35;
                icon.clipsToBounds = YES;
                icon.image = [UIImage imageNamed:@"icon"];
                [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(70);
                    make.height.mas_equalTo(70);
                    make.center.mas_equalTo(0);
                }];
            }
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app build版本
            // NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
            UILabel *tipLabel = [[UILabel alloc] init];
            {
                tipLabel.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:tipLabel];
                tipLabel.font = [UIFont systemFontOfSize:15];
                tipLabel.textColor = mRGBToColor(0x222222);
                tipLabel.text = [NSString stringWithFormat:@"当前版本为:%@",app_Version];
                [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(50);
                    make.top.equalTo(icon.mas_bottom);
                }];
            }
            
        }
        return cell;

        
    }
    DMMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DMMineTableViewCell class])];
    cell.titleLable.text = [[[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString * iconName = [[[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
    UIImage *icon = [UIImage imageNamed:iconName];
    cell.leftIconImg.image = icon;

    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];

    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
        return 200;
    else
        return 44;
        
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    UserInfoGroup *group = _groups[section];
//    return group.headerTitle;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(15, 5, mScreenWidth - 30, 25);
//    [headerView addSubview:label];
//    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = mRGBColor(120, 120, 120);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 3)
    {
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                         @"1126665175" ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if(indexPath.section == 0 &&indexPath.row == 2)
    {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DMDrawViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"DMDrawViewController"];
        modal.loadLastDraw = YES;
        [self.navigationController pushViewController:modal animated:NO];
    }
    
}

@end
