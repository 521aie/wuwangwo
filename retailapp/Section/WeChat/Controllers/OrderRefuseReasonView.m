//
//  OrderRefuseReasonView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderRefuseReasonView.h"
#import "CommonService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ReasonVo.h"
#import "XHAnimalUtil.h"
#import "OrderReasonEditView.h"
#import "DicItemConstants.h"
#import "SystemUtil.h"
@interface OrderRefuseReasonView () <INavigateEvent>

@property (nonatomic, strong) CommonService *commonService;

@property (nonatomic, strong) NSMutableArray *reasonList;

@property (nonatomic, strong) NSString *selectItemId;

@end

@implementation OrderRefuseReasonView

- (NSMutableArray *)reasonList {
    if (!_reasonList) {
        _reasonList = [NSMutableArray array];
    }
    return _reasonList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.commonService = [ServiceFactory shareInstance].commonService;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"拒绝原因" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
    
    [self loadData];
    [self configHelpButton:HELP_WECHAT_SALE_ORDER_REFUSE_REASON];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainGrid reloadData];

}



-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
    } else {
        //保存
        NSString *reason = nil;
        for (ReasonVo *dicVo in self.reasonList) {
            if ([dicVo.dicItemId isEqualToString:self.selectItemId ]) {
                reason = dicVo.name;
                break;
            }
        }
        
        if ([NSString isBlank:reason]) {
            return;
        }
        if (self.refuseReasonBack) {
            self.refuseReasonBack(reason);
        }
    }
}

- (void)loadData {
    //拒绝原因检索
    __weak typeof(self) weakSelf = self;
    [self.commonService selectReasonListByCode:DIC_REFUSE_RESON completionHandler:^(id json) {
        weakSelf.reasonList = [ReasonVo converToArr:[json objectForKey:@"returnResonList"]];
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}



- (IBAction)reasonManageClick:(id)sender {
    OrderReasonEditView *reasonEditView = [[OrderReasonEditView alloc] initWithNibName:[SystemUtil getXibName:@"OrderReasonEditView"] bundle:nil];
    reasonEditView.reasonList = self.reasonList;
    [self.navigationController pushViewController:reasonEditView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reasonList.count;
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *label = nil;
    UIImageView *imageView = nil;
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
        bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [cell.contentView addSubview:bgView];
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 87, 320, 1)];
        viewLine.backgroundColor = RGBA(0, 0, 0, 0.1);
        [cell.contentView addSubview:viewLine];
        

        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320-60, 88)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGB(51, 51, 51);
        label.tag = 102;
        [cell.contentView addSubview:label];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320-22-15, 33, 22, 22)];
        imageView.image = [UIImage imageNamed:@"ico_check.png"];
        imageView.tag = 101;
        [cell.contentView addSubview:imageView];
       
    } else {
        label = (UILabel *)[cell.contentView viewWithTag:102];
        imageView = (UIImageView *)[cell.contentView viewWithTag:101];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    ReasonVo *dicVo = [self.reasonList objectAtIndex:indexPath.row];
    label.text = dicVo.name;
    if ([dicVo.dicItemId isEqualToString:self.selectItemId ]) {
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReasonVo *dicVo = [self.reasonList objectAtIndex:indexPath.row];
    self.selectItemId = dicVo.dicItemId;
    [self.mainGrid reloadData];
}

@end
