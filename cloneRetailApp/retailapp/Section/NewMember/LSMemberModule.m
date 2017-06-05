//
//  LSMemberModule.m
//  retailapp
//
//  Created by taihangju on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberModule.h"
#import "LSMemberQueryViewController.h"
#import "LSMemberDetailViewController.h"
#import "LSMemberInfoSummaryViewController.h"
#import "LSMemberListViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberSubmenus.h"
#import "LSMemberSubmenuCell.h"
#import "LSMemberDataPanel1.h"
#import "LSMemberSearchBar.h"
#import "LSMemberInfoVo.h"
#import "LSMemberSummaryInfoVo.h"
#import "DateUtils.h"
#import "UIView+Sizes.h"
#import "LSAlertHelper.h"


static NSString *mbSubmenuCell = @"mbSubmenuCell";
static NSString *mbReusableHeader = @"mbReusableViewHeader";
//static NSString *mbReusableFooter = @"mbReusableViewFooter";
@interface LSMemberModule ()<UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout ,INavigateEvent>

@property (nonatomic ,strong) UICollectionView *collectionView;/*<>*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) NSArray *dataArray;/*<数据源>*/
@property (nonatomic, strong) LSMemberDataPanel1 *dataPanel1;/*<会员信息汇总1>*/
@property (nonatomic, strong) LSMemberDataPanel1 *dataPanel2;/*<会员信息汇总2>*/
@property (nonatomic ,strong) LSMemberSearchBar *mbSearchBar;/*<搜索框>*/
@end

@implementation LSMemberModule

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initNavigate];
    [self initCollectionView];
    [self configHelpButton:HELP_MEMBER_HOEMPAGE];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getPhotoUploadPath];
    [self getMemberSummaryInfo];
    [self getMemberSummaryInfo1];
}


- (NSArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [LSMemberSubmenus memberSubmenus];
    }
    return _dataArray;
}

- (LSMemberSearchBar *)mbSearchBar {
    
   __weak typeof(self) weakSelf = self;
    if (!_mbSearchBar) {
        _mbSearchBar = [LSMemberSearchBar memberSearchBar:^(NSString *queryString) {
            
            if ([NSString isNotBlank:queryString]) {
                [weakSelf queryMemberInfo:queryString];
            } else {
                // 没有进入会员一览界面的权限，提示输入手机号码/会员卡号
                if ([[Platform Instance] lockAct:ACTION_CARD_SEARCH]) {
                    [LSAlertHelper showAlert:@"请输入会员卡号/手机号！" block:nil];
                    return ;
                }
                LSMemberQueryViewController *vc = [[LSMemberQueryViewController alloc] init:@""];
                [weakSelf pushController:vc from:kCATransitionFromRight];
            }
        }];
    }
    return _mbSearchBar;
}


-(LSMemberDataPanel1 *)dataPanel1
{
    if (!_dataPanel1) {
        __weak typeof (self)weakSelf = self;
        _dataPanel1 = [LSMemberDataPanel1 memberDataPanel:DataPanelOne block:^{
            LSMemberInfoSummaryViewController *vc = [[LSMemberInfoSummaryViewController alloc] init];
            [weakSelf pushController:vc from:kCATransitionFromRight];
        }];
        _dataPanel1.ls_top = 44.0;
    }
    return _dataPanel1;
}

-(LSMemberDataPanel1 *)dataPanel2
{
    if (!_dataPanel2) {
        _dataPanel2 = [LSMemberDataPanel1 memberDataPanel:DataPanelTwo block:nil];
        _dataPanel2.ls_top = 154.0;
    }
    return _dataPanel2;
}

- (UILabel *)getLabel:(NSInteger)sectionIndex {
    
    NSArray *itemArray = @[@"会员短信管理",@"基础设置",@"会员卡管理"];
    CGFloat topY = sectionIndex == 0 ? 280.0: 30.0;
    if ([[Platform Instance] lockAct:ACTION_CARD_INFO_COLLECT]) {
        topY = 50.0;
    }
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, topY, self.view.frame.size.width, 20)];
    label.text = itemArray[sectionIndex];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13.0];
    return label;
}


#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"会员" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

#pragma mark - UICollectionView

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(74, 78);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H - 64.0) collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44.0, 0);
    [self.collectionView registerClass:[LSMemberSubmenuCell class] forCellWithReuseIdentifier:mbSubmenuCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mbReusableHeader];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:mbReusableFooter];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberSubmenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mbSubmenuCell forIndexPath:indexPath];
    LSMemberSubmenus *model = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell fill:model.icon title:model.name action:model.actionCode];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mbReusableHeader forIndexPath:indexPath];
        [header.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (indexPath.section == 0) {
            [header addSubview:self.mbSearchBar];
            // 判断是否有查看“会员信息汇总”的权限
            if (![[Platform Instance] lockAct:ACTION_CARD_INFO_COLLECT]) {
//                [header addSubview:self.dataPanel];
                [header addSubview:self.dataPanel1];
                [header addSubview:self.dataPanel2];
            }
        }
        
        [header addSubview:[self getLabel:indexPath.section]];
        return header;
    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
//    {
//        if (indexPath.section == 2) {
//            
//            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:mbReusableFooter forIndexPath:indexPath];
//            footer.backgroundColor = [UIColor clearColor];
//            return footer;
//        }
//    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if ([[Platform Instance] lockAct:ACTION_CARD_INFO_COLLECT]) {
            return CGSizeMake(320 ,70);
        }
        return CGSizeMake(320 ,300);
    }
    return CGSizeMake(320 ,60);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//    if (section == 2) {
//        return CGSizeMake(30 ,100);
//    }
//    return CGSizeZero;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    LSMemberSubmenus *model = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // 权限判断
    if ([[Platform Instance] lockAct:model.actionCode]) {
        [LSAlertHelper showAlert:[NSString stringWithFormat:@"您没有[%@]的权限",model.name] block:nil];
        return;
    }
    
    if ([model.relatedClass length]) {
        [model statisticsUMengEvent];
        Class relatedClass = NSClassFromString(model.relatedClass);
        UIViewController *vc = (UIViewController *)[[relatedClass alloc] init];
        if ([model.relatedClass isEqualToString:@"LSMemberCheckViewController"]) {
            [vc setValue:@(model.subModuleType) forKey:@"type"];
        }
        [self pushController:vc from:kCATransitionFromRight];
    }
}


#pragma mark - 网络请求

// 获取上传图片的服务路径
- (void)getPhotoUploadPath {
    
    [BaseService getRemoteLSOutDataWithUrl:@"kindCard/getImageUploadPath" param:nil withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] integerValue] == 1) {
            
            [[Platform Instance] saveKeyWithVal:@"imageUploadPath" withVal:[json[@"data"] valueForKey:@"imageUploadPath"]];
        }
    } errorHandler:nil];
}

// 查询指定的会员，根据手机号
- (void)queryMemberInfo:(NSString *)queryString {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:3];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:queryString forKey:@"keyword"];
    [param setValue:@(NO) forKey:@"isOnlySearchMobile"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/queryCustomerInfo" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            NSArray *customerList = json[@"data"][@"customerList"];
            if ([ObjectUtil isNotEmpty:customerList]) {
                
                if (customerList.count == 1) {
                    LSMemberPackVo *vo = [LSMemberPackVo getMemberPackVo:customerList[0]];
                    LSMemberDetailViewController *vc = [[LSMemberDetailViewController alloc] initWithPhoneNum:[vo getMemberPhoneNum]];
                    [self pushController:vc from:kCATransitionFromRight];
                }
                else {
                    // 有多条的时候跳到选择页面
                    NSArray *packVos = [LSMemberPackVo getMemberPackVoList:customerList];
                    LSMemberListViewController *listVc = [[LSMemberListViewController alloc] init:0 packVos:packVos];
                    [self pushController:listVc from:kCATransitionFromRight];
                }
            }
            else {
                [LSAlertHelper showAlert:@"没有找到该会员信息！" block:nil];
            }
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 获取当日会员信息汇总
- (void)getMemberSummaryInfo {
    
    NSString *dateString = [DateUtils currentDateWith:@"yyyyMMdd"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:2];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:dateString forKey:@"date"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"memberstat/getMemberInfoStatisticsByDay" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotEmpty:json[@"data"]]) {
            
            LSMemberSummaryInfoVo *vo = [LSMemberSummaryInfoVo getMembberSummaryInfoVo:json[@"data"]];
            NSArray *datas = @[vo.customerNum?:@0 ,vo.cardNum?:@0 ,vo.cardBalance?:@0 ,vo.customerNumDay?:@0 ,vo.freshCardNum?:@0 ,vo.rechargeMoneyDay?:@0];
            [self.dataPanel1 fillData:datas time:vo.date];
        }
    } errorHandler:^(id json) {
         [LSAlertHelper showAlert:json block:nil];
    }];
}

// 获取昨日会员信息汇总
- (void)getMemberSummaryInfo1 {
    
    NSString *dateString = [DateUtils getDateString:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)] format:@"yyyyMMdd"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:2];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:dateString forKey:@"date"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"memberstat/getMemberInfoStatisticsByDay" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotEmpty:json[@"data"]]) {
            
            LSMemberSummaryInfoVo *vo = [LSMemberSummaryInfoVo getMembberSummaryInfoVo:json[@"data"]];
            NSArray *datas = @[vo.customerNum?:@0 ,vo.cardNum?:@0 ,vo.cardBalance?:@0 ,vo.customerNumDay?:@0 ,vo.freshCardNum?:@0 ,vo.rechargeMoneyDay?:@0];
            [self.dataPanel2 fillData:datas time:vo.date];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

@end
