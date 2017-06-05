//
//  UserBankListView.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserBankListView.h"
#import "ServiceFactory.h"
#import "MicroDistributeService.h"
#import "AlertBox.h"
#import "UserBankCell.h"
#import "AcountAddView.h"
#import "XHAnimalUtil.h"

@interface UserBankListView () <INavigateEvent>

@property (nonatomic, strong) MicroDistributeService *microDistributeService;

@property (nonatomic, strong) NSMutableArray *userBankList;

@end

@implementation UserBankListView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.microDistributeService = [ServiceFactory shareInstance].microDistributeService;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"账号" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserBankCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    
    [_microDistributeService selectUserBankList:[[Platform Instance] getkey:USER_ID] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        
        weakSelf.userBankList = [UserBankVo converToArr:json[@"userBankList"]];
        
        [weakSelf.tableView reloadData];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onNavigateEvent:(Direct_Flag)event {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - table部分
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userBankList.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UserBankCell *cell = (UserBankCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UserBankVo *userBankVo = [self.userBankList objectAtIndex:indexPath.row];
    
    cell.lblBankName.text = userBankVo.accountName;
    cell.lblAccountNo.text = [NSString stringWithFormat:@"%@    尾号%@",userBankVo.bankName,userBankVo.lastFourNum];
    if ([self.selectId isEqualToString:userBankVo.accountNumber]) {
        cell.imgCheck.image = [UIImage imageNamed:@"ico_check.png"];
    } else {
        cell.imgCheck.image = [UIImage imageNamed:@"ico_uncheck"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserBankCell *cell = (UserBankCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgCheck.image = [UIImage imageNamed:@"ico_check.png"];

    UserBankVo *userBankVo = [self.userBankList objectAtIndex:indexPath.row];

    if (self.selectUserBankHander) {
        self.selectUserBankHander(userBankVo);
    }
}

//添加
- (IBAction)addUserBankClick:(id)sender {
    AcountAddView *vc = [[AcountAddView alloc] initWithNibName:[SystemUtil getXibName:@"AcountAddView"] bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

@end
