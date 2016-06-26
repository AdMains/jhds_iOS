//
//  DMMineViewController.m
//  DrawMaster
//
//  Created by git on 16/6/22.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMMineViewController.h"
#import "DMMineTableViewCell.h"
@interface DMMineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation DMMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        DMMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DMMineTableViewCell class])];
    
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];
    
        return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 5, mScreenWidth - 30, 25);
    [headerView addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = mRGBColor(120, 120, 120);
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
}

@end
