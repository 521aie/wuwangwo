//
//  LSMemberRechargeSetViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberRechargeRuleListViewController.h"
#import "LSMemberRechargeRuleEditViewController.h"
#import "NavigateTitle2.h"
#import "SMHeaderItem.h"
#import "MemberTypeCell.h"
#import "AttributeAddCell.h"
#import "LSAlertHelper.h"
#import "LSMemberRechargeSetVo.h"

static NSString *memberTypeCellId = @"MemberTypeCellIndentifier";
static NSString *attributeAddCellId = @"AttributeAddCell";
@interface LSMemberRechargeRuleListViewController ()<INavigateEvent ,UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) NSArray *dataSource;/*<<#说明#>>*/
@end

@implementation LSMemberRechargeRuleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubViews];
    [self queryMoneyRuleList];
    [self configHelpButton:HELP_MEMBER_RECHARGE_PROMOTIONS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)configSubViews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"充值优惠设置" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H-64.0) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberTypeCell" bundle:nil] forCellReuseIdentifier:memberTypeCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"AttributeAddCell" bundle:nil] forCellReuseIdentifier:attributeAddCellId];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView setSeparatorColor:[ColorHelper getTipColor3]];
    self.tableView.rowHeight = 66.0;
    self.tableView.sectionHeaderHeight = 30.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

#pragma mark - NavigateTitle2 代理
//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}


#pragma mark - UITableViewDelegate

// 生成sectionHeader
- (SMHeaderItem *)getHeader:(NSString *)string {
    
    SMHeaderItem *item = [SMHeaderItem loadFromNib];
    item.lblVal.text = string ? :@"";
    return item;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LSMemberRechargeSetVo *vo = [self.dataSource objectAtIndex:section];
    return vo.moneyRules.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LSMemberRechargeSetVo *vo = self.dataSource[indexPath.section];
    if (indexPath.row == vo.moneyRules.count) {
        AttributeAddCell *addCell = (AttributeAddCell *)[tableView dequeueReusableCellWithIdentifier:attributeAddCellId];
        addCell.lblName.text = @"添加充值优惠";
        return addCell;
    }
    else {
        MemberTypeCell *cell = (MemberTypeCell *)[tableView dequeueReusableCellWithIdentifier:memberTypeCellId];
        cell.lblMemberTypeDiscount.hidden = YES;
        LSMemberRechargeRuleVo *rule = (LSMemberRechargeRuleVo *)vo.moneyRules[indexPath.row];
        
        NSString *giftDegree = @"";
        if (rule.giftDegree.integerValue > 0) {
            giftDegree = rule.giftDegree.stringValue;
            cell.lblMemberTypeName.text = [NSString stringWithFormat:@"每充值%@元送%@元、%@积分" ,rule.condition,rule.rule,giftDegree];
        } else {
            cell.lblMemberTypeName.text = [NSString stringWithFormat:@"每充值%@元送%@元" ,rule.condition,rule.rule];
        }
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LSMemberRechargeSetVo *vo = self.dataSource[section];
    SMHeaderItem *header = [self getHeader:vo.kindCardName];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberRechargeSetVo *vo = self.dataSource[indexPath.section];
    LSMemberRechargeRuleVo *ruleVo = nil;
    NSInteger type = ACTION_CONSTANTS_ADD;
    if (indexPath.row == vo.moneyRules.count) {
        
        ruleVo = [[LSMemberRechargeRuleVo alloc] init];
        ruleVo.kindCardId = vo.kindCardId;
        ruleVo.kindCardName = vo.kindCardName;
    }
    else if (indexPath.row < vo.moneyRules.count){
        type = ACTION_CONSTANTS_EDIT;
        ruleVo = (LSMemberRechargeRuleVo *)[vo.moneyRules objectAtIndex:indexPath.row];
    }
   
    LSMemberRechargeRuleEditViewController *vc = [[LSMemberRechargeRuleEditViewController alloc]
                                                  init:type vo:ruleVo callBack:^(NSInteger type) {
                                                      
                                                      if (type == ACTION_CONSTANTS_ADD) {
                                                          [self queryMoneyRuleList];
                                                      }
                                                      else {
                                                          if (type == ACTION_CONSTANTS_DEL) {
                                                              NSMutableArray *temp = [NSMutableArray arrayWithArray:vo.moneyRules];
                                                              [temp removeObject:ruleVo];
                                                              vo.moneyRules = [temp copy];
                                                          }
                                                          [self.tableView reloadData];
                                                      }
    }];
    [self pushController:vc from:kCATransitionFromRight];
    
}



#pragma mark - 网络请求

// 获取充值优惠设置列表
- (void)queryMoneyRuleList {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"moneyRule/queryKindCardMoneyRule" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            self.dataSource = [LSMemberRechargeSetVo getMemberRechargeSetVoList:json[@"data"]];
            if ([ObjectUtil isNotEmpty:self.dataSource]) {
                [self.tableView reloadData];
            }
        }
        self.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];

}

@end
