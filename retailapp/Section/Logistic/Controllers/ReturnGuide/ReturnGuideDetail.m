//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#import "ReturnGuideDetail.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "EditItemList.h"
#import "Platform.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"
#import "EditItemView.h"
#import "ItemTitle.h"
#import "ReturnGoodsGuideVo.h"
#import "ReturnGuideDetailCell.h"
#import "ExportView.h"
#import "SmallTitle.h"
#import "DateUtils.h"
#import "EditItemView.h"

@interface ReturnGuideDetail ()

@property (nonatomic, assign) BOOL isFold;
@end

@implementation ReturnGuideDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    service = [ServiceFactory shareInstance].logisticService;
    self.isFold = NO;
    [self initNavigate];
    [self initMainView];
    [self expandBaseInfo];
    [self loadData];
    
}
- (void)initNavigate {
    [self configTitle:@"退货指导单号" leftPath:Head_ICON_BACK rightPath:nil];
}



- (void)initMainView {
     [self.baseTitle initDelegate:self event:EXPAND_TYPE title:@"基本信息"];
    [self.vewCode initLabel:@"退货指导编号" withHit:nil];
    [self.vewName initLabel:@"退货指导名称" withHit:nil];
    [self.vewStart initLabel:@"开始时间" withHit:nil];
    [self.vewEnd initLabel:@"结束时间" withHit:nil];
    [self.styleTitle initDelegate:self event:MOVE_TYPE title:@"款式信息"];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
 
}
- (void)initWithReturnGoodsGuideVo:(ReturnGoodsGuideVo *)returnGoodsGuideVo {
    [self configTitle:returnGoodsGuideVo.code];
    [self.vewCode initData:returnGoodsGuideVo.code withVal:returnGoodsGuideVo.code];
    [self.vewName initData:returnGoodsGuideVo.name withVal:returnGoodsGuideVo.name];
    [self.vewStart initData:[DateUtils formateTime2:[returnGoodsGuideVo.startDate longLongValue]*1000] withVal:[DateUtils formateTime2:[returnGoodsGuideVo.startDate longLongValue]*1000]];
    [self.vewEnd initData:[DateUtils formateTime2:[returnGoodsGuideVo.endDate longLongValue]*1000] withVal:[DateUtils formateTime2:[returnGoodsGuideVo.endDate longLongValue]*1000]];
    self.styleTitle.lblName.text = [NSString stringWithFormat:@"款式信息(共%ld款)",returnGoodsGuideVo.returnGuideListVos.count];
    for (ReturnGuideListVo *returnGuideListVo in returnGoodsGuideVo.returnGuideListVos) {
        ReturnGuideDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ReturnGuideDetailCell" owner:self options:nil].lastObject;
        [cell initWithReturnGuideListVo:returnGuideListVo];
        [self.container insertSubview:cell belowSubview:self.queryBtn];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}



- (void)loadData {
    [service guideDetail:self.param completionHandler:^(id json) {
        ReturnGoodsGuideVo *returnGoodsGuideVo = [[ReturnGoodsGuideVo alloc] initWithDictionary:json[@"returnGoodsGuideVo"]];
        [self initWithReturnGoodsGuideVo:returnGoodsGuideVo];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    [_param setValue:[NSNumber numberWithInt:[self.guideId intValue]] forKey:@"guideId"];
    if ([[Platform Instance] getShopMode] == 3) {
        
         [_param setValue:[[Platform Instance] getkey:ORG_ID] forKey:@"shopId"];
    } else {
         [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    return _param;
}
- (IBAction)onQueryBtnClicked:(UIButton *)sender {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [vc loadData:self.param withPath:@"guide/exportExcel" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark - ISmallTitle协议
- (void)onTitleExpandClick:(NSInteger)event
{
    if (event==EXPAND_TYPE) {
        [self expandBaseInfo];
    }
}

- (void)expandBaseInfo
{
    [self.vewCode visibal:!_isFold];
    [self.vewName visibal:(!_isFold)];
    [self.vewStart visibal:(!_isFold)];
    [self.vewEnd visibal:!_isFold];
    [self changeTittleImage:!_isFold];
    _isFold= !_isFold;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)changeTittleImage:(BOOL)change
{
    self.baseTitle.img.image = change?[UIImage imageNamed:@"ico_fold.png"]:[UIImage imageNamed:@"ico_fold_up.png"];
}

- (void)onTitleMoveToBottomClick:(NSInteger)event
{
    CGFloat cHeight = self.scrollView.contentSize.height;
    CGFloat mHeight = self.scrollView.bounds.size.height;
    if (cHeight>mHeight) {
        [self.scrollView setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
    }
}

@end
