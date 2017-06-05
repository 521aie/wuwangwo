//
//  OrderReasonEditView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderReasonEditView.h"
#import "CommonService.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "OrderReasonAddView.h"
#import "ReasonVo.h"
#import "AlertBox.h"
#import "DicItemConstants.h"
#import "SystemUtil.h"

@interface OrderReasonEditView () <INavigateEvent>

@property (nonatomic, strong) CommonService *commonService;

@end

@implementation OrderReasonEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"原因库管理" backImg:Head_ICON_CANCEL moreImg:nil];
    self.titleBox.lblLeft.text = @"关闭";
    [self.titleDiv addSubview:self.titleBox];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mainGrid reloadData];
}



-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
             [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController popViewControllerAnimated:NO];
           
        }
}

- (IBAction)addReasonClick:(id)sender {
    OrderReasonAddView *reasonAddView = [[OrderReasonAddView alloc] initWithNibName:[SystemUtil getXibName:@"OrderReasonAddView"] bundle:nil];
    reasonAddView.reasonList = self.reasonList;
    [self.navigationController pushViewController:reasonAddView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reasonList.count;
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *label = nil;
    UIButton *button = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(15, 43, 290, 1)];
        viewLine.backgroundColor = RGBA(0, 0, 0, 0.1);
        [cell.contentView addSubview:viewLine];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320-60, 44)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGB(51, 51, 51);
        label.tag = 102;
        [cell.contentView addSubview:label];
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(320-22-15, 11, 22, 22)];
        [button setBackgroundImage:[UIImage imageNamed:@"ico_block.png"] forState:UIControlStateNormal];
        button.tag = 101;
        [cell.contentView addSubview:button];
    } else {
        label = (UILabel *)[cell.contentView viewWithTag:102];
        button = (UIButton *)[cell.contentView viewWithTag:101];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    ReasonVo *dicVo = [self.reasonList objectAtIndex:indexPath.row];
    label.text = dicVo.name;
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(deleteReasonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)deleteReasonClick:(UIButton *)sender {
    
    ReasonVo *dicVo = [self.reasonList objectAtIndex:sender.tag];

    //拒绝原因检索
    __weak typeof(self) weakSelf = self;
    //店铺类型
    [_commonService deleteReasonById:dicVo.dicItemId
                            withCode:DIC_REFUSE_RESON
                 completionHandler:^(id json) {
                     if (!(weakSelf)) {
                         return ;
                     }
                     
                     [weakSelf.reasonList removeObjectAtIndex:sender.tag];
                     [weakSelf.mainGrid reloadData];
                     
                 } errorHandler:^(id json) {
                     [AlertBox show:json];
                 }];
}


@end
