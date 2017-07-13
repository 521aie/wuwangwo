//
//  GoodsSplitView.m
//  retailapp
//
//  Created by guozhi on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSplitView.h"
#import "XHAnimalUtil.h"
#import "SearchTitle.h"
#import "SearchView.h"
#import "UIHelper.h"
#import "SelectGoodsList.h"
#import "SelectGoodsItem.h"
#import "GoodsOperationVo.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "GoodsService.h"
#import "ServiceFactory.h"
#import "GoodsOperationList.h"
#import "LSGoodsHandleVo.h"

@interface GoodsSplitView ()<SearchTitleDelegate,SearchViewDelegate,SelectGoodsItemDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) SearchTitle *baseTitle1;
@property (nonatomic, strong) SearchView *searchBig;
@property (nonatomic, strong) SearchView *searchSmall;
@property (nonatomic, strong) SearchTitle *baseTitle2;
@property (nonatomic, strong) UIView *btnView;
/**被拆分的商品*/
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) GoodsService *service;
/**当前操作的对象*/
@property (nonatomic, strong) SelectGoodsItem *selectGoodsItem;
@property (nonatomic, strong) LSGoodsHandleVo *goodsHandleVo;
@end

@implementation GoodsSplitView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configSubViews];
    [self initNavigate];
    [self initMainView];
    if ([self.title1 containsString:@"商品拆分"]) {
         [self configHelpButton:HELP_GOODS_SPLIT];
    } else if ([self.title1 containsString:@"商品组装"]) {
        [self configHelpButton:HELP_GOODS_ASSEMBLE];
    } else if ([self.title1 containsString:@"商品加工"]) {
         [self configHelpButton:HELP_GOODS_MACHINING];
    }
    if (self.action == ActionEditEvent) {
        [self loadData];
    }
}

- (void)configDatas{
    self.service = [ServiceFactory shareInstance].goodsService;
}

- (void)configSubViews{
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    self.baseTitle1 =[SearchTitle editSearchTitle];
    [self.container addSubview:self.baseTitle1];
    
    self.searchBig = [SearchView editSearchView];
    [self.container addSubview:self.searchBig];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.baseTitle2 =[SearchTitle editSearchTitle];
    [self.container addSubview:self.baseTitle2];
    
    self.searchSmall = [SearchView editSearchView];
    [self.container addSubview:self.searchSmall];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnView = btn.superview;
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma mark - 导航栏
//初始化导航栏
- (void)initNavigate {

    NSString *title = @"";
    if (self.action == ActionAddEvent) {
        if ([self.title1 containsString:@"商品拆分"]) {
            title = @"添加拆分规则";
        } else if ([self.title1 containsString:@"商品组装"]) {
            title = @"添加组装规则";
        } else if ([self.title1 containsString:@"商品加工"]) {
            title = @"添加加工规则";
        }
        [self configTitle:title leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    } else {
        [self configTitle:self.title1 leftPath:Head_ICON_BACK rightPath:nil];
    }
}

//导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        if (self.action == ActionAddEvent) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        NSMutableArray *arr = self.param[@"goodsHandle"][@"oldGoodsList"];
        if (arr.count > 20) {
            [AlertBox show:@"小件商品控制最多添加20个！"];
            return;
        }
        __weak GoodsSplitView *weakSelf = self;
        if ([self isValid]) {
            NSString *urlPath = nil;
            if ([self.title1 containsString:@"商品拆分"]) {
                urlPath = @"split/save";
            } else if ([self.title1 containsString:@"商品组装"]) {
                urlPath = @"assemble/save";
            } else if ([self.title1 containsString:@"商品加工"]) {
                urlPath = @"processing/save";
            }
            [self.service getGoodsInfo:urlPath param:self.param completionHandler:^(id json) {
                GoodsOperationList *vc = nil;
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[GoodsOperationList class]]) {
                        vc = (GoodsOperationList *)controller;
                    }
                }
                [vc loadData];
                if (self.action == ActionAddEvent) {
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                } else {
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                }
                [weakSelf.navigationController popViewControllerAnimated:NO];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

//加载数据
- (void)loadData {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    __weak GoodsSplitView *weakSelf = self;
    NSString *urlPath = nil;
    if ([self.title1 containsString:@"商品拆分"]) {
        [param setValue:self.goodsId forKey:@"oldGoodsId"];
        urlPath = @"split/detail";
    } else if ([self.title1 containsString:@"商品组装"]) {
        urlPath = @"assemble/detail";
        [param setValue:self.goodsId forKey:@"newGoodsId"];
    } else if ([self.title1 containsString:@"商品加工"]) {
        urlPath = @"processing/detail";
        [param setValue:self.goodsId forKey:@"newGoodsId"];
    }
    
    [self.service getGoodsInfo:urlPath param:param completionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json]) {
            NSDictionary *dict = json[@"goodsHandle"];
            if ([ObjectUtil isNotNull:dict]) {
                LSGoodsHandleVo *goodsHangleVo = [LSGoodsHandleVo goodsHandleVoWithDict:dict];
                self.goodsHandleVo = goodsHangleVo;
                SelectGoodsItem *item = nil;
                GoodsOperationVo *vo = nil;
                for (LSOldGoodsVo *oldGoodsVo in goodsHangleVo.oldGoodsList) {
                    item = [SelectGoodsItem createItem];
                    [weakSelf.container insertSubview:item belowSubview:weakSelf.searchBig];
                    vo = [[GoodsOperationVo alloc] init];
                    vo.goodsName = oldGoodsVo.goodsName;
                    vo.barCode = oldGoodsVo.barCode;
                    vo.goodsId = oldGoodsVo.goodsId;
                    item.goodsVo = vo;
                    item.tag = 11;
                    if (![weakSelf.title1 containsString:@"商品拆分"]) {
                        [item initDelegate:self value:[oldGoodsVo.oldGoodsNum intValue]];
                    }
                }
                item = [SelectGoodsItem createItem];
                [weakSelf.container insertSubview:item aboveSubview:weakSelf.searchSmall];
                vo = [[GoodsOperationVo alloc] init];
                vo.goodsName = goodsHangleVo.goodsName;
                vo.barCode = goodsHangleVo.goodsBarCode;
                vo.goodsId = goodsHangleVo.goodsId;
                item.goodsVo = vo;
                item.tag = 12;
                if (![weakSelf.title1 containsString:@"商品组装"]) {
                    [item initDelegate:self value:[goodsHangleVo.goodsNum intValue]];
                }
            }
        }
        [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 初始化主页面
-(void)initMainView {
    [self.baseTitle1 initDelegate:self title:@"大件商品"];
    [self.baseTitle2 initDelegate:self title:@"小件商品"];
    [self.searchBig initDelegate:self title:@"选择大件商品..."];
    [self.searchSmall initDelegate:self title:@"添加小件商品..."];
    if ([self.title1 containsString:@"商品组装"]) {
        self.baseTitle1.lblName.text = @"小件商品";
        self.baseTitle1.img.image = [UIImage imageNamed:@"add_little"];
        self.baseTitle2.lblName.text = @"大件商品";
        self.searchBig.img.image = [UIImage imageNamed:@"ico_add_rr"];
        self.searchBig.lblVal.text = @"添加小件商品...";
        self.searchSmall.lblVal.text = @"选择大件商品...";
    }
    if ([self.title1 containsString:@"商品加工"]) {
        self.baseTitle1.lblName.text = @"原料商品";
        self.baseTitle2.lblName.text = @"加工商品";
        self.baseTitle1.img.image = [UIImage imageNamed:@"add_little"];
        self.searchBig.lblVal.text = @"添加原料商品...";
        self.searchBig.img.image = [UIImage imageNamed:@"ico_add_rr"];
        self.searchSmall.lblVal.text = @"选择加工商品...";
    }
    if (self.action == ActionEditEvent) {
        [self.baseTitle1 isShow:NO];
        [self.baseTitle2 isShow:NO];
    }
    BOOL visibal = self.action == ActionAddEvent;
    [self.searchBig visibal:visibal];
    [self.searchSmall visibal:visibal];
    self.btnView.hidden = visibal;
    if (![self.title1 containsString:@"商品拆分"]) {
        [self.searchBig visibal:YES];
        [self.baseTitle1 isShow:YES];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 搜索框点击事件
- (void)showSearchEvent:(id)item {
    BOOL isBig = NO;
    BOOL isUp = NO;
    int fileType = 0;
    if (item == self.baseTitle1 || item == self.searchBig) {
        isUp = YES;
    } else {
        isUp = NO;
    }
    if ([self.title1 containsString:@"商品拆分"]) {
        fileType = 2;
        if (item == self.baseTitle1 || item == self.searchBig) {
            isBig = YES;
        } else {
            isBig = NO;
        }
    } else if ([self.title1 containsString:@"商品组装"]) {
        fileType = 3;
        if (item == self.baseTitle1 || item == self.searchBig) {
            NSMutableArray *arr = self.param[@"goodsHandle"][@"oldGoodsList"];
            if (arr.count >= 20) {
                [AlertBox show:@"小件商品不能超过20个！"];
                return;
            }
            isBig = NO;
        } else {
            isBig = YES;
        }
        
    } else if ([self.title1 containsString:@"商品加工"]) {
        fileType = 6;
        if (item == self.baseTitle1 || item == self.searchBig) {
            NSMutableArray *arr = self.param[@"goodsHandle"][@"oldGoodsList"];
            if (arr.count >= 20) {
                [AlertBox show:@"原料商品不能超过20个！"];
                return;
            }
            isBig = NO;
        } else {
            isBig = YES;
        }
    }
    __weak typeof(self) weakSelf = self;
    SelectGoodsList *vc = [[SelectGoodsList alloc] initWithBig:isBig fileType:fileType searchCodeList:[self getBarCodeList] goodsIndoBlock:^(GoodsOperationVo *goodsOperationVo) {
        if (weakSelf.action == ActionEditEvent) {
            [self editTitle:NO act:ACTION_CONSTANTS_ADD];
        }
        SelectGoodsItem *item = [SelectGoodsItem createItem];
        item.goodsVo = goodsOperationVo;
        if (isUp) {
            if ([self.title1 containsString:@"商品拆分"]) {
                for (UIView *vc in self.container.subviews) {
                    if ([vc isKindOfClass:[SelectGoodsItem class]] && vc.tag == 11) {
                        [vc removeFromSuperview];
                    }
                }
                [weakSelf.searchBig visibal:NO];
            } else {
                [weakSelf.searchBig visibal:YES];
                [item initDelegate:self value:1];
            }
            [weakSelf.container insertSubview:item belowSubview:weakSelf.searchBig];
            item.tag = 11;
        } else {
                for (UIView *vc in self.container.subviews) {
                    if ([vc isKindOfClass:[SelectGoodsItem class]] && vc.tag == 12) {
                        [vc removeFromSuperview];
                    }
                }
            [weakSelf.container insertSubview:item aboveSubview:weakSelf.searchSmall];
            if (![self.title1 containsString:@"商品组装"]) {
                [item initDelegate:self value:1];
            }
            item.tag = 12;
            [weakSelf.searchSmall visibal:NO];
        }
        [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

////当点击-按钮由1变为0时调用此方法
- (void)showDelEvent:(SelectGoodsItem *)item value:(double)value {
    [self editTitle:NO act:ACTION_CONSTANTS_ADD];
    self.selectGoodsItem = item;
    if (value < 1) {
        item.stepper.lblCount.text = @"1";
        item.stepper.valueNow = 1;
        if ([self.title1 containsString:@"商品拆分"] && self.action == ActionEditEvent) {
            [AlertBox show:@"无法删除小件商品！"];
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定删除[%@]吗？",item.lblName.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 1;
        [alert show];
    }
}

//当点击-按钮由1变为0时删除当前商品的对象并且把搜索对象显示出来
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self.selectGoodsItem removeFromSuperview];
            SelectGoodsItem *item = (SelectGoodsItem *)[self.container viewWithTag:11];
            if (item == nil) {
                [self.searchBig visibal:YES];
            }
            item = (SelectGoodsItem *)[self.container viewWithTag:12];
            if (item == nil) {
                [self.searchSmall visibal:YES];
            }
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            NSString *urlPath = nil;
            if ([self.title1 containsString:@"商品拆分"]) {
                SelectGoodsItem *item = (SelectGoodsItem *)[self.view viewWithTag:11];
                [param setValue:item.goodsVo.goodsId forKey:@"oldGoodsId"];
                urlPath = @"split/delete";
            } else if ([self.title1 containsString:@"商品组装"]) {
                SelectGoodsItem *item = (SelectGoodsItem *)[self.view viewWithTag:12];
                [param setValue:item.goodsVo.goodsId forKey:@"newGoodsId"];
                urlPath = @"assemble/delete";
            } else if ([self.title1 containsString:@"商品加工"]) {
                SelectGoodsItem *item = (SelectGoodsItem *)[self.view viewWithTag:12];
                [param setValue:item.goodsVo.goodsId forKey:@"newGoodsId"];
                urlPath = @"processing/delete";
            }
            
            [self.service getGoodsInfo:urlPath param:param completionHandler:^(id json) {
                GoodsOperationList *vc = nil;
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[GoodsOperationList class]]) {
                        vc = (GoodsOperationList *)controller;
                    }
                }
                [vc loadData];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

- (NSMutableArray *)getBarCodeList {
    NSMutableArray *barCodeList = [NSMutableArray array];
    SelectGoodsItem *goodsItem = nil;
    for (UIView *item in self.container.subviews) {
        if ([item isKindOfClass:[SelectGoodsItem class]]) {
            goodsItem = (SelectGoodsItem *)item;
            [barCodeList addObject:goodsItem];
        }
    }
    return barCodeList;
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    NSMutableArray *arr = [NSMutableArray array];
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[SelectGoodsItem class]]&&view.tag == 11) {
            SelectGoodsItem *goodsItem = (SelectGoodsItem *)view;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:goodsItem.goodsVo.goodsId forKey:@"goodsId"];
            int oldGoodsNum = goodsItem.delegate ? [goodsItem.stepper.lblCount.text intValue] : 1;
            [dict setValue:[NSNumber numberWithInt:oldGoodsNum] forKey:@"oldGoodsNum"];
            [dict setValue:goodsItem.goodsVo.goodsName forKey:@"goodsName"];
            [dict setValue:goodsItem.goodsVo.barCode forKey:@"barCode"];
            if (self.action == ActionAddEvent) {
                [dict setValue:[NSString stringWithFormat:@"%@",goodsItem.goodsVo.type] forKey:@"type"];
            }
            [arr addObject:dict];
        }
    }
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:arr forKey:@"oldGoodsList"];
    SelectGoodsItem *item = (SelectGoodsItem *)[self.container viewWithTag:12];
    int num = item.delegate ? [item.stepper.lblCount.text intValue] : 1;
    [dict1 setValue:[NSNumber numberWithInt:num] forKey:@"newGoodsNum"];
    [dict1 setValue:item.goodsVo.goodsId forKey:@"newGoodsId"];
    if ([self.title1 containsString:@"商品拆分"]) {
        [dict1 setValue:@2 forKey:@"handleType"];
    } else if ([self.title1 containsString:@"商品组装"]) {
        [dict1 setValue:@1 forKey:@"handleType"];
    } else if ([self.title1 containsString:@"商品加工"]) {
        [dict1 setValue:@3 forKey:@"handleType"];
    }
   
    [dict1 setValue:item.goodsVo.barCode forKey:@"newGoodsBarCode"];
    [dict1 setValue:item.goodsVo.goodsName forKey:@"newGoodsName"];
    [dict1 setValue:@1 forKey:@"checkType"];
    if (self.action == ActionEditEvent) {
        [dict1 setValue:self.goodsHandleVo.goodsHandId forKey:@"goodsHandId"];
         [dict1 setValue:self.goodsHandleVo.lastVer forKey:@"lastVer"];
    }
         [_param setValue:dict1 forKey:@"goodsHandle"];
    if (self.action == ActionAddEvent) {
         [_param setValue:@"add" forKey:@"operateType"];
    } else {
         [_param setValue:@"edit" forKey:@"operateType"];
    }
    return _param;
}

- (BOOL)isValid {
    SelectGoodsItem *item = (SelectGoodsItem *)[self.container viewWithTag:11];
    if (item == nil) {
        [AlertBox show:[NSString stringWithFormat:@"请选择%@！",self.baseTitle1.lblName.text]];
        return NO;
    }
    item = (SelectGoodsItem *)[self.container viewWithTag:12];
    if (item == nil) {
         [AlertBox show:[NSString stringWithFormat:@"请选择%@！",self.baseTitle2.lblName.text]];
        return NO;
    }
    return YES;
}

//按钮删除事件
- (void)delClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该规则吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 2;
    [alert show];
}

@end
