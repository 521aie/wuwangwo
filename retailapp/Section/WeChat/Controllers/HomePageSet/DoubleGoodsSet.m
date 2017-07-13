//
//  WeChatHomeSetDoubleGoods.m
//  retailapp
//
//  Created by diwangxie on 16/4/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "DoubleGoodsSet.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "WeChatStyleGoodsList.h"
#import "Wechat_StyleVo.h"
#import "MicroShopHomepageDetailVo.h"
#import "MicroShopHomepageVo.h"
#import "SortTableView2.h"
#import "NavigateTitle2.h"
#import "FooterListView8.h"
#import "DoubleGoodsCell.h"
#import "LSWechatHomeSetBatchSelectViewController.h"
#import "MicroWechatGoodsVo.h"

@interface DoubleGoodsSet ()<INavigateEvent,FooterListEvent,DoubleGoodsCellDelegate>

@property (nonatomic,strong) NSDictionary *styleList;
@property (nonatomic,strong) NSMutableArray *styleGoodsList;
@property (nonatomic,strong) NSMutableArray *tempStyleGoodsList;
@property (nonatomic,strong) NSMutableArray *tempList;
@property (nonatomic,strong) NSMutableArray *checkStyleList;
@property (nonatomic,strong) MicroShopHomepageVo *microShopHomepageVo;
@property (nonatomic,strong) NSMutableArray *microShopHomepageList;
@property (nonatomic,strong) NSString *shopId;

@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;
@property (weak, nonatomic) IBOutlet FooterListView8 *footView;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic,strong) NSString *homePageId;
@property (nonatomic ,copy) void (^refreshHomepage)();/* <回调block，刷新微店主页*/
/**唯一性*/
@property (nonatomic,copy) NSString *token;
@end

@implementation DoubleGoodsSet

- (void)setCallBack:(void(^)())block {
    self.refreshHomepage = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.microShopHomepageVo = [[MicroShopHomepageVo alloc] init];
    self.microShopHomepageList = [[NSMutableArray alloc] init];
    self.styleGoodsList = [[NSMutableArray alloc] init];
    self.styleList = [[NSDictionary alloc] init];
    self.tempStyleGoodsList = [[NSMutableArray alloc] init];
    self.tempList = [[NSMutableArray alloc] init];

    [self initTitleBox];
    
    [self.footView initDelegate:self btnArrs:@[@"ADD", @"SORT"]];
    [self loadDate];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

- (void)initTitleBox {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"双列商品设置" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self saveSet];
    }
}

- (void)showAddEvent {
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        WeChatStyleGoodsList*vc = [[WeChatStyleGoodsList alloc] initWithNibName:@"WeChatStyleGoodsList" bundle:nil];
        vc.mode=1;
        vc.check=1;
        [vc loadStyleGoodsList:1 callBack:^(NSMutableArray *styleList) {
            _checkStyleList=styleList;
            [_tempList removeAllObjects];
            [_tempStyleGoodsList removeAllObjects];
            if (self.styleGoodsList.count>0) {
                for (Wechat_StyleVo *styleVo in styleList) {
                    for (MicroShopHomepageVo *vo in self.styleGoodsList) {
                        if ([vo.relevanceId isEqualToString:styleVo.styleId]) {
                            [_tempStyleGoodsList addObject:vo];
                        }
                    }
                }
                _tempList=_tempStyleGoodsList;
                if (_tempStyleGoodsList.count>0) {
                    BOOL flag=false;
                    for (Wechat_StyleVo *styleVo in styleList) {
                        for (MicroShopHomepageVo *vo in _tempStyleGoodsList) {
                            if ([styleVo.styleId isEqualToString:vo.relevanceId]) {
                                flag=false;
                                break;
                            }else if (![vo.relevanceId isEqualToString:styleVo.styleId]) {
                                flag=true;
                            }
                        }
                        if (flag) {
                            _microShopHomepageVo=[[MicroShopHomepageVo alloc] init];
                            _microShopHomepageVo.relevanceId=styleVo.styleId;
                            _microShopHomepageVo.relevanceType=2;
                            _microShopHomepageVo.filePath=styleVo.filePath;
                            _microShopHomepageVo.fileName=styleVo.fileName;
                            _microShopHomepageVo.setType=6;
                            _microShopHomepageVo.hasRelevance=1;
                            _microShopHomepageVo.styleCode=styleVo.styleCode;
                            _microShopHomepageVo.styleName=styleVo.styleName;
                            [_tempList addObject:_microShopHomepageVo];
                        }
                    }
                }else{
                    for (Wechat_StyleVo *styleVo in styleList) {
                        _microShopHomepageVo=[[MicroShopHomepageVo alloc] init];
                        _microShopHomepageVo.relevanceId=styleVo.styleId;
                        _microShopHomepageVo.relevanceType=2;
                        _microShopHomepageVo.filePath=styleVo.filePath;
                        _microShopHomepageVo.fileName=styleVo.fileName;
                        _microShopHomepageVo.setType=6;
                        _microShopHomepageVo.hasRelevance=1;
                        _microShopHomepageVo.styleCode=styleVo.styleCode;
                        _microShopHomepageVo.styleName=styleVo.styleName;
                        [_tempList addObject:_microShopHomepageVo];
                    }
                }
            }else{
                for (Wechat_StyleVo *styleVo in styleList) {
                    _microShopHomepageVo=[[MicroShopHomepageVo alloc] init];
                    _microShopHomepageVo.relevanceId=styleVo.styleId;
                    _microShopHomepageVo.relevanceType=2;
                    _microShopHomepageVo.filePath=styleVo.filePath;
                    _microShopHomepageVo.fileName=styleVo.fileName;
                    _microShopHomepageVo.setType=6;
                    _microShopHomepageVo.hasRelevance=1;
                    _microShopHomepageVo.styleCode=styleVo.styleCode;
                    _microShopHomepageVo.styleName=styleVo.styleName;
                    [_tempList addObject:_microShopHomepageVo];
                }
            }
            [self.titleBox initWithName:@"双列商品图设置"
                                backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
            self.titleBox.lblRight.text=@"保存";
            [self.mainGrid reloadData];
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController
                        type:kCATransitionPush direction:kCATransitionFromRight];
    } else {
        //商超
        LSWechatHomeSetBatchSelectViewController *vc = [[LSWechatHomeSetBatchSelectViewController alloc] initWithBlock:^(NSMutableArray *WechatGoodsList) {
            NSMutableArray *oldStyleList = [NSMutableArray arrayWithArray:_tempList];
            for (MicroWechatGoodsVo *wechatGoodsVo in WechatGoodsList) {
                _microShopHomepageVo = [[MicroShopHomepageVo alloc] init];
                _microShopHomepageVo.relevanceId = wechatGoodsVo.goodsId;
                _microShopHomepageVo.relevanceType = 1;
                _microShopHomepageVo.filePath=wechatGoodsVo.filePath;
                _microShopHomepageVo.fileName=wechatGoodsVo.fileName;
                _microShopHomepageVo.setType=6;
                _microShopHomepageVo.hasRelevance=1;
                _microShopHomepageVo.goodsBarCode = wechatGoodsVo.barCode;
                _microShopHomepageVo.goodsName = wechatGoodsVo.goodsName;
                BOOL isContain = NO;
                for (MicroShopHomepageDetailVo *oldDetailVo in oldStyleList) {
                    if ([oldDetailVo.relevanceId isEqualToString:_microShopHomepageVo.relevanceId]) {
                        isContain = YES;
                        break;
                    }
                }
                if (!isContain) {
                    [_tempList addObject:_microShopHomepageVo];
                }
                
            }
            _microShopHomepageVo.hasRelevance = 1;
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
            if (_tempList.count > 12) {
                [AlertBox show:@"最多设置12个双列商品!"];
                NSRange range = NSMakeRange(12, _tempList.count - 12);
                [_tempList removeObjectsInRange:range];
            }
            [self.mainGrid reloadData];
            
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];

    }
}

// 排序
- (void)showSortEvent {
    
    if (self.tempList.count < 2) {
        [AlertBox show:@"请至少添加两条内容，才能进行排序。"];
        return;
    }
    __weak typeof(self) weakself = self;
    SortTableView2 *vc = [[SortTableView2 alloc] initWithNibName:[SystemUtil getXibName:@"SortTableView2"] bundle:nil datas:self.tempList onRightBtnClick:^(NSMutableArray *datas) {
        
        [weakself.tempList removeAllObjects];
        weakself.tempList = datas;
        
        [XHAnimalUtil animal:weakself.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakself.navigationController popViewControllerAnimated:NO];
        
        [weakself.titleBox initWithName:@"双列商品图设置"
                                backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        weakself.titleBox.lblRight.text=@"保存";
        [weakself.mainGrid reloadData];
        
    } setCellContext:^(SortTableViewCell2 *cell, NSIndexPath *indexPath) {
    
    }];
    
    [weakself.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:weakself.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}
#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tempList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DoubleGoodsCell *detailItem = (DoubleGoodsCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"DoubleGoodsCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.tempList]) {
        MicroShopHomepageVo *vo = [self.tempList objectAtIndex:indexPath.row];
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            [detailItem initView:vo.filePath styleName:vo.styleName styleCode:vo.styleCode indexPathRow:indexPath.row delegate:self];
        } else {
            [detailItem initView:vo.filePath styleName:vo.goodsName styleCode:vo.goodsBarCode indexPathRow:indexPath.row delegate:self];
        }
       
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailItem;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 网络请求
- (void)loadDate {

    __weak typeof(self) weakSelf = self;
   weakSelf.shopId=[[Platform Instance] getkey:SHOP_ID];
    //获取双列商品列表
    NSString *url = @"microShopHomepage/selectDoubleGoodsList";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:weakSelf.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithInt:6] forKey:@"setType"];
    [param setValue:@2 forKey:@"interface_version"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        self.styleList=[json objectForKey:@"microShopHomepageList"];
        if([ObjectUtil isNotNull:self.styleList]){
            for(NSDictionary *dic in self.styleList) {
                [self.styleGoodsList addObject:[MicroShopHomepageVo convertToMicroGoodsVo:dic]];
                [self.tempList addObject:[MicroShopHomepageVo convertToMicroGoodsVo:dic]];
            }
        }
        [self.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)saveSet {
    
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    
    __weak typeof(self) weakSelf = self;
    weakSelf.shopId=[[Platform Instance] getkey:SHOP_ID];
    
     NSString *url = @"microShopHomepage/saveDoubleGoodsList";
    
    _microShopHomepageList = [[NSMutableArray alloc] init];
    for (MicroShopHomepageVo *vo in self.tempList) {
        [_microShopHomepageList addObject:[vo convertToDictionary]];
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary dictionary]init];
    [param setValue:weakSelf.shopId forKey:@"shopId"];
    [param setValue:weakSelf.microShopHomepageList forKey:@"microShopHomepageList"];
    [param setValue:weakSelf.token forKey:@"token"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        self.token=nil;
        if (weakSelf.refreshHomepage) {
            weakSelf.refreshHomepage();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (void)deleteCell:(DoubleGoodsCell *)cell{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
    [self.navigationController presentViewController:alertVc animated:YES completion:nil];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger tag=cell.btnDel.tag;
        [self.tempList removeObjectAtIndex:tag];
        [self.mainGrid reloadData];
        [self.titleBox initWithName:@"双列商品图设置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        self.titleBox.lblRight.text=@"保存";
        
    }]];
}

@end
