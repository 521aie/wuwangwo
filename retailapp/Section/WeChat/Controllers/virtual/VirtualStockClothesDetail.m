//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#define COLOR_WHITE RGB(221, 221, 221)
#define COLOR_GRAY RGB(51, 51, 51)
#define COLOR_BG [UIColor whiteColor]
#import "VirtualStockClothesDetail.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "EditItemView.h"
#import "UIHelper.h"
#import "SymbolNumberInputBox.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SearchBar2.h"
#import "StockInfoVo.h"
#import "SkcListVo.h"
#import "sizeListVo.h"
#import "JSONKit.h"
#import "JsonHelper.h"
#import "FooterListView4.h"
#import "VirtualStockBatchView.h"
#import "BaseView.h"
#import "ColorHelper.h"
#import "VirtualStockManagementView.h"
#import "ViewFactory.h"
#import "StyleItem1.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"

@implementation VirtualStockClothesDetail
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil param:(NSMutableDictionary *)param stockInfoVo:(StockInfoVo *)stockInfoVo shopId:(NSString *)shopId action:(int)action edit:(BOOL)isEdit{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.stockInfoVo = stockInfoVo;
        service = [ServiceFactory shareInstance].stockService;
        self.styleCode = self.stockInfoVo.styleCode;
        self.isEdit = isEdit;
        self.action = action;
        self.actionInit = action;
        self.shopId = shopId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    self.footView.imgHelp.hidden = YES;
    [self.footView initDelegate:self btnArrs:@[]];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self loadDataWithStyleId:self.styleCode];
    }
    
}

//初始化导航栏
- (void)initNavigate {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"微店商品详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        VirtualStockManagementView *vc = nil;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[VirtualStockManagementView class]]) {
                vc = (VirtualStockManagementView *)controller;
            }
        }
        [vc loadVirtualListAndVirtualCount];
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController popToViewController:vc animated:NO];
        }
        
        
    } else {
        [self saveStyle];
    }
}

#pragma mark - 保存
- (void)saveStyle
{
//    if (![self isValide]) {
//        [AlertBox show:@"商品数量必须大于0!"];
//        return;
//    }
    self.isContinue = NO;
    self.isDel = NO;
    [self saveData];
}


//初始化页面
- (void)initMainView {
    self.searchBar.hidden = !(self.action == ACTION_CONSTANTS_ADD);
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self.scrollView setLs_top:self.searchBar.ls_top];
        [self.scrollView setLs_height:self.scrollView.ls_height+self.searchBar.ls_height];
        [self.searchBar initDelagate:self placeholder:@"款号"];
    } else {
        [self.searchBar initDelagate:self placeholder:@"款号"];
    }
    [self.searchBar limitKeyWords:50];
    
}


- (void)initFooterView {
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.footView initDelegate:self btnArrs:@[@"BATCH"]];
    } else {
        if (self.isEdit) {
            [self.footView initDelegate:self btnArrs:@[@"BATCH"]];
        } else {
            [self.footView initDelegate:self btnArrs:@[]];
        }
    }
}

- (void)showBatchEvent {
    NSMutableArray *goodIds = [[NSMutableArray alloc] init];
    for (SkcListVo *skcListVo in self.skcList) {
        for (SizeListVo *sizeListVo in skcListVo.sizeList) {
            if ([NSString isNotBlank:sizeListVo.goodsId]) {
                [goodIds addObject:sizeListVo.goodsId];
                
            }
        }
    }
    
    VirtualStockBatchView *vc = [[VirtualStockBatchView alloc] initWithNibName:[SystemUtil getXibName:@"VirtualStockBatchView"] bundle:nil shopId:self.shopId goodsVos:goodIds action:ACTION_CONSTANTS_ADD];
    [self.navigationController pushViewController:vc animated:NO];
    vc.goodsVos = goodIds;
    vc.styleId = self.skcStyleVo.styleId;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}

//输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.styleCode = keyWord;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self loadDataWithStyleId:keyWord];
    
}
- (void)loadDataWithStyleId:(NSString *)styleId {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.shopId forKey:@"shopId"];
    if ([NSString isBlank:styleId]) {
        return;
    }
    [param setValue:styleId forKey:@"styleCode"];
    __weak typeof(self) weakSelf = self;
    [service storeDetail:param CompletionHandler:^(id json) {
        if ([ObjectUtil isNull:json[@"skcGoodsStyleVo"]]) {
            [weakSelf.footView initDelegate:self btnArrs:@[]];
            return ;
        }
        [weakSelf initFooterView];
        weakSelf.skcStyleVo = [SkcStyleVo converToVo:json[@"skcGoodsStyleVo"]];
        weakSelf.skcList = weakSelf.skcStyleVo.skcList;
        weakSelf.sizeNameList = weakSelf.skcStyleVo.sizeNameList;
        if (weakSelf.actionInit == ACTION_CONSTANTS_ADD) {
            if ([weakSelf isValide1]) {
                weakSelf.action = ACTION_CONSTANTS_EDIT;
            } else {
                weakSelf.action = ACTION_CONSTANTS_ADD;
            }
        } else {
             weakSelf.action = ACTION_CONSTANTS_EDIT;
        }
        
        
        if (weakSelf.skcList.count > 0) {
            if (weakSelf.action == ACTION_CONSTANTS_ADD) {
                weakSelf.isChange = YES;
            } else {
                weakSelf.isChange = NO;
            }
        }
        [weakSelf changeNavUI];
        [weakSelf layoutScrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)layoutScrollView {
    UIView *detailView = [[UIView alloc] init];
    CGFloat height = 0;
    CGFloat width = self.scrollView.ls_width;
    //款式信息
    StyleItem1 *styleItem = [StyleItem1 loadFromNib];
    styleItem.backgroundColor = [UIColor whiteColor];
    styleItem.lblName.text = self.skcStyleVo.styleName;
    styleItem.lblStyleCode.text = [NSString stringWithFormat:@"款号：%@",self.skcStyleVo.styleCode];
    [styleItem.pic sd_setImageWithURL:[NSURL URLWithString:self.skcStyleVo.filePath] placeholderImage:[UIImage imageNamed:@"img_default.png"]];
    [styleItem resetHeight];
    [detailView addSubview:styleItem];
    height+=styleItem.ls_height+15;
    CGFloat left = 80;
    if (self.skcList.count <= 3) {//颜色不超过3种
        CGFloat w = (width - left)/self.skcList.count;
        //        NSInteger row = [[Platform Instance] getShopMode] == 1 ? self.sizeNameList.count + 4 : self.sizeNameList.count + 7;
        NSInteger row = [[Platform Instance] getShopMode] == 1 ? self.sizeNameList.count + 2 : (self.isSelectAll ? self.sizeNameList.count + 3 : self.sizeNameList.count + 4);
        UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, row*44)];
        goodsView.backgroundColor = COLOR_WHITE;
        //左边栏目 尺码
        // 浅灰色底
        UIView *sizeBackView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, left - 1, goodsView.ls_height - 2)];
        sizeBackView.backgroundColor = [UIColor whiteColor];
        [goodsView addSubview:sizeBackView];
        for (int i=0; i<row; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44 * i, 78, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = COLOR_GRAY;
            label.backgroundColor = COLOR_WHITE;
            [goodsView addSubview:label];
            if ([[Platform Instance] getShopMode] == 1) {
                if (i == 0) {
                    label.text = @"颜色";
                } else if (i == (row-1)) {
                    label.text = @"总数量";
                } else {
                    label.text = [self.sizeNameList objectAtIndex:i - 1];
                }
                
                //款色
                for (int i=0; i<self.skcList.count; i++) {
                    SkcListVo *skcVo = [self.skcList objectAtIndex:i];
                    
                    //颜色
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, 1, w - 1, 43)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = RGB(51, 51, 51);
                    label.backgroundColor = COLOR_BG ;
                    label.numberOfLines = 0;
                    label.text = [NSString stringWithFormat:@"%@\n(%@)",skcVo.colorVal,skcVo.colorNumber];
                    [goodsView addSubview:label];
                    skcVo.tfDhList = [NSMutableArray array];
                    skcVo.oldDhList = [NSMutableArray array];
                    for (int j=0; j<skcVo.sizeList.count; j++) {
                        SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                        //                        UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(80 + w * i, 1 + 44 * (j + 3), w - 1, 43)];
                        UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(80 + w * i, 1 + 44 * (j + 1), w - 1, 43)];
                        tfDh.borderStyle = UITextBorderStyleNone;
                        tfDh.font = [UIFont systemFontOfSize:14];
                        BOOL hasStore = [NSString isNotBlank:sizeVo.goodsId];
                        tfDh.textColor = hasStore?RGB(0, 136, 204): RGB(51, 51, 51);
                        if (self.action == ACTION_CONSTANTS_EDIT) {
                            if (!self.isEdit) {
                                tfDh.textColor = RGB(51, 51, 51);
                            }
                        }
                        tfDh.textAlignment = NSTextAlignmentCenter;
                        tfDh.keyboardType = UIKeyboardTypeNumberPad;
                        tfDh.backgroundColor = COLOR_BG ;
                        tfDh.enabled = hasStore;
                        tfDh.tag = i;
                        
                        NSString *str = hasStore?[NSString stringWithFormat:@"%ld",[sizeVo.virtualStore integerValue]]:@"-";
                        str = [NSString stringWithFormat:@"%@",str];
                        if ([ObjectUtil isNull:sizeVo.lockStore]) {
                            if ([sizeVo.lockStore intValue] != 0) {
                                str = [NSString stringWithFormat:@"%@",str];
                            }
                        }
                        tfDh.text = str;
                        
                        tfDh.delegate = self;
                        [goodsView addSubview:tfDh];
                        
                        [skcVo.tfDhList addObject:tfDh];
                        [skcVo.oldDhList addObject:[NSNumber numberWithInteger:[tfDh.text integerValue]]];
                    }
                    
                    //总数量
                    //                    label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, 1 + 44 * (3+self.sizeNameList.count), w - 1, 43)];
                    label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, 1 + 44 * (1+self.sizeNameList.count), w - 1, 43)];
                    
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = RGB(51, 51, 51);
                    label.backgroundColor = COLOR_BG ;
                    label.tag = i;
                    label.text = [self getTotalCount:skcVo.sizeList withSkcVo:skcVo];
                    [goodsView addSubview:label];
                    skcVo.labelTotalCount = label;
                    
                }
                
                
            } else {
                if (self.isSelectAll) {
                    if (i == 0) {
                        label.text = @"颜色";
                    }else if (i==1){
                        label.text = @"吊牌价";
                    } else if (i == (row-1)) {
                        label.text = @"总数量";
                    }  else {
                        label.text = [self.sizeNameList objectAtIndex:i - 2];
                    }
                    
                } else {
                    if (i == 0) {
                        label.text = @"颜色";
                    }else if (i==1){
                        label.text = @"吊牌价";
                    } else if (i == (row-2)) {
                        label.text = @"总数量";
                    } else if (i == (row-1)) {
                        label.text = @"总金额";
                    } else {
                        label.text = [self.sizeNameList objectAtIndex:i - 2];
                    }
                    
                }
                
                //款色
                for (int i=0; i<self.skcList.count; i++) {
                    SkcListVo *skcVo = [self.skcList objectAtIndex:i];
                    
                    //颜色
                    float y = 1;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, y, w - 1, 43)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = RGB(51, 51, 51);
                    label.backgroundColor = COLOR_BG ;
                    label.numberOfLines = 0;
                    label.text = [NSString stringWithFormat:@"%@\n(%@)",skcVo.colorVal,skcVo.colorNumber];
                    [goodsView addSubview:label];
                    
                    //吊牌价
                    y = y + 44;
                    label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, y, w - 1, 43)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = RGB(51, 51, 51);
                    label.backgroundColor = COLOR_BG ;
                    label.text = [NSString stringWithFormat:@"%.2f",[skcVo.hangTagPrice doubleValue]];
                    [goodsView addSubview:label];
                    
                    skcVo.tfDhList = [NSMutableArray array];
                    skcVo.oldDhList = [NSMutableArray array];
                    for (SizeListVo *sizeVo in skcVo.sizeList) {
                        y = [self createVirtualStock:goodsView SizeListVo:sizeVo SkcListVo:skcVo y:y w:w i:i];
                    }
                    
                    //总数量
                    //                    label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, 1 + 44 * (5+self.sizeNameList.count), w - 1, 43)];
                    y = y + 44;
                    label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, y, w - 1, 43)];
                    
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = RGB(51, 51, 51);
                    label.backgroundColor = COLOR_BG ;
                    label.tag = i;
                    label.text = [self getTotalCount:skcVo.sizeList withSkcVo:skcVo];
                    [goodsView addSubview:label];
                    skcVo.labelTotalCount = label;
                    
                    //总金额
                    //                    label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, 1 + 44 * (6+self.sizeNameList.count), w - 1, 43)];
                    if (!self.isSelectAll) {
                        y = y + 44;
                        label = [[UILabel alloc] initWithFrame:CGRectMake(80 + w * i, y, w - 1, 43)];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.font = [UIFont systemFontOfSize:14];
                        label.textColor = RGB(51, 51, 51);
                        label.backgroundColor = COLOR_BG ;
                        label.tag = i;
                        label.text = [NSString stringWithFormat:@"%.2f",[skcVo.totalMoney doubleValue]];
                        [goodsView addSubview:label];
                        skcVo.labelTotalMoney = label;
                    }
                    
                }
            }
        }
        height += goodsView.ls_height;
        [detailView addSubview:goodsView];
        
    } else {
        if ([[Platform Instance] getShopMode] == 1) {
            CGFloat w = (width-3)/4;
            int row = (int)(self.sizeNameList.count+1)/2;
            for (int i=0; i<self.skcList.count; i++) {
                SkcListVo *skcVo = [self.skcList objectAtIndex:i];
                UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1+44*(row+2))];
                goodsView.backgroundColor = RGB(221, 221, 221);
                //颜色 款式
                CGFloat y = 0;
                y = y + 1;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, width, 43)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = RGB(221, 221, 221);
                label.numberOfLines = 0;
                label.text = [NSString stringWithFormat:@"%@\n(%@)",skcVo.colorVal,skcVo.colorNumber];
                [goodsView addSubview:label];
                skcVo.tfDhList = [NSMutableArray array];
                skcVo.oldDhList = [NSMutableArray array];
                
                for (int j=0; j<self.sizeNameList.count; j++) {
                    int row = j/2;
                    int col = j%2;
                    SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                    //                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col, 1 + 44 * (row + 2), w, 43)];
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col, 1 + 44 * (row + 1), w, 43)];
                    view.backgroundColor = COLOR_BG ;
                    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = RGB(51, 51, 51);
                    label.text = [self.sizeNameList objectAtIndex:j];
                    [view addSubview:label];
                    [goodsView addSubview:view];
                    BOOL hasStore = [NSString isNotBlank:sizeVo.goodsId];
                    //                    UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col + (w+1), 1 + 44 * (row + 2), w, 43)];
                    UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col + (w+1), 1 + 44 * (row + 1), w, 43)];
                    tfDh.borderStyle = UITextBorderStyleNone;
                    tfDh.font = [UIFont systemFontOfSize:14];
                    tfDh.textColor = hasStore?RGB(0, 136, 204): RGB(51, 51, 51);
                    if (self.action == ACTION_CONSTANTS_EDIT) {
                        if (!self.isEdit) {
                            tfDh.textColor = RGB(51, 51, 51);
                        }
                    }
                    tfDh.textAlignment = NSTextAlignmentCenter;
                    tfDh.keyboardType = UIKeyboardTypeNumberPad;
                    tfDh.backgroundColor = COLOR_BG ;
                    tfDh.enabled = hasStore ==1;
                    tfDh.tag = i;
                    tfDh.text = hasStore?[NSString stringWithFormat:@"%ld",[sizeVo.virtualStore integerValue]]:@"-";
                    
                    tfDh.delegate = self;
                    [goodsView addSubview:tfDh];
                    [skcVo.tfDhList addObject:tfDh];
                    [skcVo.oldDhList addObject:[NSNumber numberWithInteger:[tfDh.text integerValue]]];
                }
                
                
                //总数量
                int sizes = ((int)self.sizeNameList.count + 1)/2;
                //                label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44*(2+sizes), w, 43)];
                label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44*(1+sizes), w, 43)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = COLOR_BG ;
                label.text = @"总数量";
                [goodsView addSubview:label];
                
                //                label = [[UILabel alloc] initWithFrame:CGRectMake(2 + w, 1 + 44*(2+sizes), w, 43)];
                label = [[UILabel alloc] initWithFrame:CGRectMake(2 + w, 1 + 44*(1+sizes), w, 43)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = COLOR_BG ;
                label.tag = i;
                label.text= [self getTotalCount:skcVo.sizeList withSkcVo:skcVo];
                [goodsView addSubview:label];
                
                skcVo.labelTotalCount = label;
                
                [detailView addSubview:goodsView];
                height += goodsView.ls_height+15;
            }
            
        }else {
            CGFloat w = (width-3)/4;
            NSInteger row = self.isSelectAll ? ((self.sizeNameList.count+1)/2 + 2) : ((self.sizeNameList.count)/2 + 3);
            for (int i=0; i<self.skcList.count; i++) {
                SkcListVo *skcVo = [self.skcList objectAtIndex:i];
                CGFloat h = self.isSelectAll ? 1+44*row : 1+44*row;
                UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, h)];
                goodsView.backgroundColor = RGB(221, 221, 221);
                //颜色 款式
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, width, 43)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = RGB(221, 221, 221);
                label.numberOfLines = 0;
                label.text = [NSString stringWithFormat:@"%@\n(%@)",skcVo.colorVal,skcVo.colorNumber];
                [goodsView addSubview:label];
                
                //总数量
                label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44, w, 43)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = COLOR_BG ;
                label.text = @"总数量";
                [goodsView addSubview:label];
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(1 + w+1, 1 + 44, w, 43)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = COLOR_BG ;
                label.tag = i;
                label.text= [self getTotalCount:skcVo.sizeList withSkcVo:skcVo];
                [goodsView addSubview:label];
                
                skcVo.labelTotalCount = label;
                
                if (!self.isSelectAll) {
                    //总金额
                    label = [[UILabel alloc] initWithFrame:CGRectMake(1 + (w+1)*2, 1 + 44, w, 43)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = RGB(51, 51, 51);
                    label.backgroundColor = COLOR_BG ;
                    label.text = @"总金额";
                    [goodsView addSubview:label];
                    label = [[UILabel alloc] initWithFrame:CGRectMake(1 + (w+1)*3, 1 + 44, w, 43)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = RGB(51, 51, 51);
                    label.backgroundColor = COLOR_BG ;
                    label.tag = i;
                    label.text = [NSString stringWithFormat:@"%.2f",[skcVo.totalMoney doubleValue]];
                    [goodsView addSubview:label];
                    skcVo.labelTotalMoney = label;

                }
                CGRect frame1 = self.isSelectAll ? CGRectMake(1 + (w+1)*2, 1 + 44, w, 43) : CGRectMake(1, 1 + 44*2, w, 43);
                CGRect frame2 = self.isSelectAll ? CGRectMake(1 + (w+1)*3, 1 + 44, w, 43) : CGRectMake(1 + w+1, 1 + 44*2, w, 43);
                
                //吊牌价
                label = [[UILabel alloc] initWithFrame:frame1];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = COLOR_BG ;
                label.text = @"吊牌价";
                [goodsView addSubview:label];
                
                label = [[UILabel alloc] initWithFrame:frame2];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.backgroundColor = COLOR_BG ;
                label.tag = i;
                label.text= [NSString stringWithFormat:@"%.2f",[skcVo.hangTagPrice doubleValue]];
                [goodsView addSubview:label];
                
                
                skcVo.tfDhList = [NSMutableArray array];
                skcVo.oldDhList = [NSMutableArray array];
                
                if (!self.isSelectAll) {
                    SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:0];
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2, 1 + 44 * 2, w, 43)];
                    view.backgroundColor = COLOR_BG ;
                    label = [[UILabel alloc] initWithFrame:view.bounds];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = RGB(51, 51, 51);
                    label.text = [self.sizeNameList objectAtIndex:0];
                    [view addSubview:label];
                    [goodsView addSubview:view];
                    BOOL hasStore = [NSString isNotBlank:sizeVo.goodsId];
                    UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 3, 1 + 44 * 2, w, 43)];
                    tfDh.borderStyle = UITextBorderStyleNone;
                    tfDh.font = [UIFont systemFontOfSize:14];
                    tfDh.textColor = hasStore?RGB(0, 136, 204): RGB(51, 51, 51);
                    if (self.action == ACTION_CONSTANTS_EDIT) {
                        if (!self.isEdit) {
                            tfDh.textColor = RGB(51, 51, 51);
                        }
                    }
                    tfDh.textAlignment = NSTextAlignmentCenter;
                    tfDh.keyboardType = UIKeyboardTypeNumberPad;
                    tfDh.backgroundColor = COLOR_BG ;
                    tfDh.enabled = hasStore;
                    tfDh.tag = i;
                    NSString *str = hasStore?[NSString stringWithFormat:@"%ld",[sizeVo.virtualStore integerValue]]:@"-"; hasStore?[NSString stringWithFormat:@"%ld",[sizeVo.virtualStore integerValue]]:@"-";
                    tfDh.text = str;
                    if (self.isSelectAll) {
                        [self createLable:sizeVo str:str tfDh:tfDh w:w];
                    }
                    tfDh.delegate = self;
                    [goodsView addSubview:tfDh];
                    [skcVo.tfDhList addObject:tfDh];
                    [skcVo.oldDhList addObject:[NSNumber numberWithInteger:[tfDh.text integerValue]]];
                }
                CGFloat a = self.isSelectAll ? 0 : 1;
                for (int j = a; j<self.sizeNameList.count; j++) {
                    int row = self.isSelectAll ? j/2-1 : (j-1)/2;
                    int col = self.isSelectAll ? j%2 : (j-1)%2;
                    SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                    //                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col, 1 + 44 * (row + 4), w, 43)];
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col, 1 + 44 * (row + 3), w, 43)];
                    view.backgroundColor = COLOR_BG ;
                    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = RGB(51, 51, 51);
                    label.text = [self.sizeNameList objectAtIndex:j];
                    [view addSubview:label];
                    [goodsView addSubview:view];
                    BOOL hasStore = [NSString isNotBlank:sizeVo.goodsId];
                    //                    UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col + (w+1), 1 + 44 * (row + 4), w, 43)];
                    UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col + (w+1), 1 + 44 * (row + 3), w, 43)];
                    tfDh.borderStyle = UITextBorderStyleNone;
                    tfDh.font = [UIFont systemFontOfSize:14];
                    tfDh.textColor = hasStore?RGB(0, 136, 204): RGB(51, 51, 51);
                    if (self.action == ACTION_CONSTANTS_EDIT) {
                        if (!self.isEdit) {
                            tfDh.textColor = RGB(51, 51, 51);
                        }
                    }
                    tfDh.textAlignment = NSTextAlignmentCenter;
                    tfDh.keyboardType = UIKeyboardTypeNumberPad;
                    tfDh.backgroundColor = COLOR_BG ;
                    tfDh.enabled = hasStore;
                    tfDh.tag = i;
                    NSString *str = hasStore?[NSString stringWithFormat:@"%ld",[sizeVo.virtualStore integerValue]]:@"-"; hasStore?[NSString stringWithFormat:@"%ld",[sizeVo.virtualStore integerValue]]:@"-";
                    tfDh.text = str;
                    if (self.isSelectAll) {
                        [self createLable:sizeVo str:str tfDh:tfDh w:w];
                    }
                    tfDh.delegate = self;
                    [goodsView addSubview:tfDh];
                    [skcVo.tfDhList addObject:tfDh];
                    [skcVo.oldDhList addObject:[NSNumber numberWithInteger:[tfDh.text integerValue]]];
                }
                
                
                [detailView addSubview:goodsView];
                height += goodsView.ls_height+15;
            }
            
        }
        
    }
    if (self.skcList.count<= 3) {
        height = height + 15;
    }
//    if (self.isSelectAll) {
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(45, height, 320, 15)];
//        lab.text = @"表示冻结库存数";
//        lab.font = [UIFont systemFontOfSize:11];
//        lab.textColor = [ColorHelper getWhiteColor];
//        [detailView addSubview:lab];
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, height, 15, 15)];
//        img.image = [UIImage imageNamed:@"ico_snow_white"];
//        [detailView addSubview:img];
//
//    }
    height = height + 15;
    if (self.action==ACTION_CONSTANTS_ADD) {
        height+=30;
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保存并继续添加" forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
        saveBtn.frame = CGRectMake(10, height, 300, 44);
        [detailView addSubview:saveBtn];
        [saveBtn addTarget:self action:@selector(onContinueEventClick) forControlEvents:UIControlEventTouchUpInside];
        height+=44;
    }
    if ([[Platform Instance] getShopMode] == 3) {
        if (self.isEdit) {
//            if (self.action==ACTION_CONSTANTS_EDIT) {
//                height+=15;
//                UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [delBtn setTitle:@"删除" forState:UIControlStateNormal];
//                delBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
//                [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
//                delBtn.frame = CGRectMake(10, height, 300, 44);
//                [detailView addSubview:delBtn];
//                [delBtn addTarget:self action:@selector(onDelEventClick) forControlEvents:UIControlEventTouchUpInside];
//                height+=44;
//                detailView.userInteractionEnabled = YES;
//            }
            
        } else {
            detailView.userInteractionEnabled = NO;
        }
    } else {
//        if (self.action==ACTION_CONSTANTS_EDIT) {
//            height+=15;
//            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [delBtn setTitle:@"删除" forState:UIControlStateNormal];
//            delBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
//            [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
//            delBtn.frame = CGRectMake(10, height, 300, 44);
//            [detailView addSubview:delBtn];
//            [delBtn addTarget:self action:@selector(onDelEventClick) forControlEvents:UIControlEventTouchUpInside];
//            height+=44;
//        }
        
    }
    
    
    height +=60;
    detailView.frame = CGRectMake(0, 0, width, height);
    height =(self.scrollView.ls_height<height)?height:self.scrollView.ls_height+30;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
    [self.scrollView addSubview:detailView];
    
    
    
}

- (void)createLable:(SizeListVo *)sizeVo str:(NSString *)str tfDh:(UITextField *)tfDh w:(CGFloat)w{
    if ([ObjectUtil isNotNull:sizeVo.lockStore] && [sizeVo.lockStore intValue] != 0) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w-1, 43)];
        str = [NSString stringWithFormat:@"%@\n%@",str,sizeVo.lockStore];
        lab.numberOfLines = 0;
        lab.textColor = RGB(51, 51, 51);
        NSRange rang = [str rangeOfString:@"\n"];
        lab.font = [UIFont systemFontOfSize:14];
        NSRange rang1 = NSMakeRange(rang.location+1, str.length - (rang.location+1));
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:rang1];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:rang1];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.attributedText = attr;
        [tfDh addSubview:lab];
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 10, 10)];
//        img.image = [UIImage imageNamed:@"ico_snow_red"];
//        [tfDh addSubview:img];
        tfDh.text = @"";
    }

}



#pragma mark -保存并继续添加
- (void)onContinueEventClick
{
//    if (![self isValide]) {
//        [AlertBox show:@"商品数量必须大于0!"];
//        return;
//    }
    self.isContinue = YES;
    self.isDel = NO;
    [self saveData];
}

#pragma mark - 删除
-(void)onDelEventClick
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除款式[%@]吗?",self.skcStyleVo.styleName]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        self.isContinue = NO;
        self.isDel = YES;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (SkcListVo *skcListVo in self.skcList) {
            for (SizeListVo *sizeListVo in skcListVo.sizeList) {
                if ([NSString isNotBlank:sizeListVo.goodsId]) {
                    [arr addObject:sizeListVo.goodsId];
                    
                }
            }
        }
        [param setValue:arr forKey:@"goodsIdList"];
        [param setValue:self.shopId forKey:@"shopId"];
        [service deleteVirtualStore:param CompletionHandler:^(id json) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[VirtualStockManagementView class]]) {
                    VirtualStockManagementView *list= (VirtualStockManagementView *)vc;
                    [list loadVirtualListAndVirtualCount];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }
}

#pragma mark - 验证商品数量
- (BOOL)isValide
{
    NSInteger count = 0;
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        count += [skcVo.labelTotalCount.text integerValue];
    }
    return (count>0);
}

- (BOOL)isValide1
{
    double count = 0;
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        for (SizeListVo *sizeListvo in skcVo.sizeList) {
            count +=[sizeListvo.virtualStore doubleValue];
        }
    }
    return (count>0);
}

#pragma mark - 虚拟库存数
- (CGFloat)createVirtualStock:(UIView *)goodsView SizeListVo:(SizeListVo *)sizeVo SkcListVo:(SkcListVo *)skcVo y:(CGFloat)y w:(CGFloat)w i:(CGFloat)i  {
    y = y + 44;
    UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(80 + w * i, y, w - 1, 43)];
    tfDh.borderStyle = UITextBorderStyleNone;
    tfDh.font = [UIFont systemFontOfSize:14];
    BOOL hasStore = [NSString isNotBlank:sizeVo.goodsId];
    tfDh.textColor = hasStore?RGB(0, 136, 204): RGB(51, 51, 51);
    if (self.action == ACTION_CONSTANTS_EDIT) {
        if (!self.isEdit) {
            tfDh.textColor = RGB(51, 51, 51);
        }
    }
    tfDh.textAlignment = NSTextAlignmentCenter;
    tfDh.keyboardType = UIKeyboardTypeNumberPad;
    tfDh.backgroundColor = COLOR_BG ;
    tfDh.enabled = hasStore ==1;
    tfDh.tag = i;
    NSString *str = hasStore?[NSString stringWithFormat:@"%ld",[sizeVo.virtualStore integerValue]]:@"-";
    tfDh.text = str;
    if (self.isSelectAll) {
        [self createLable:sizeVo str:str tfDh:tfDh w:w];
    }
    tfDh.delegate = self;
    [goodsView addSubview:tfDh];
    [skcVo.tfDhList addObject:tfDh];
    [skcVo.oldDhList addObject:[NSNumber numberWithInteger:[tfDh.text integerValue]]];
    return y;
}


#pragma mark - 计算总数量
- (NSString *)getTotalCount:(NSArray *)arr withSkcVo:(SkcListVo *)skcVo
{
    NSInteger count = 0;
    for (SizeListVo *sizeVo in arr) {
        count+=[sizeVo.virtualStore integerValue];
    }
    skcVo.totalCount = [NSNumber numberWithInteger:count];
    skcVo.totalMoney = [NSNumber numberWithDouble:[skcVo.hangTagPrice doubleValue]*count];
    if (count>0) {
        return [NSString stringWithFormat:@"%ld",count];
    }else{
        return @"0";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.txtField = textField;
    [SymbolNumberInputBox initData:textField.text];
    if (textField.tag >= 1000) {
        [SymbolNumberInputBox show:@"" client:self isFloat:YES isSymbol:NO event:textField.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        return NO;
    } else {
        [SymbolNumberInputBox show:@"" client:self isFloat:NO isSymbol:NO event:textField.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        return NO;
    }
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType >= 1000) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:eventType-1000];
        if (skcVo.maxValidSupplyPriceRate == nil || skcVo.maxValidSupplyPriceRate == (id)[NSNull null]) {
            val = [NSString stringWithFormat:@"%.2f",[val doubleValue]];
            if ([val doubleValue] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"供货价为0，是否继续保存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag = 2;
                [alert show]; 
                val = [NSString stringWithFormat:@"%.2f",[val doubleValue]];
                self.val = val;
                return;
                
            }

            self.txtField.text = val;
            [self textFieldTextDidChange:self.txtField];
            return;
            
        }
        double maxprice = [skcVo.hangTagPrice doubleValue] * [skcVo.maxValidSupplyPriceRate doubleValue]/100.0;
        if ([val doubleValue] > maxprice) {
            [AlertBox show:@"输入的供货价不能大于总部设置的最高供货价"];
            return;
        }
        if ([val doubleValue] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"供货价为0，是否继续保存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 2;
            [alert show];
            val = [NSString stringWithFormat:@"%.2f",[val doubleValue]];
            self.val = val;
            return;

        }
        val = [NSString stringWithFormat:@"%.2f",[val doubleValue]];
        self.txtField.text = val;
        [self textFieldTextDidChange:self.txtField];
    } else {
        
        SkcListVo *skcVo = [self.skcList objectAtIndex:eventType];
        int i = 0;
        double max = 0;
        for (UITextField *textField in skcVo.tfDhList) {
            if (textField == self.txtField) {
                SizeListVo *sizeListVo = skcVo.sizeList[i];
                max = [sizeListVo.maxValidVirtualStore doubleValue];
            }
            i++;
        }
        if ([val doubleValue] > max) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置的可销售数量大于商品实际库存数，确认要设置吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            alert.tag = 1;
            val = [NSString stringWithFormat:@"%.0f",[val doubleValue]];
            self.val = val;
        } else {
            val = [NSString stringWithFormat:@"%.0f",[val doubleValue]];
            self.txtField.text = val;
            [self textFieldTextDidChange:self.txtField];
        }
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1) {
            self.txtField.text = self.val;
            [self textFieldTextDidChange:self.txtField];
        } else if (alertView.tag == 2) {
            self.txtField.text = self.val;
            [self textFieldTextDidChange:self.txtField];
        }
       
    }
}

#pragma mark - 总数量、总金额动态计算
- (void)textFieldTextDidChange:(id)obj
{
    UITextField *textField =nil;
    textField = (UITextField *)obj;
    NSInteger dhl = 0;
    SkcListVo *skcVo;
    if (textField.tag < 1000) {
        skcVo = [self.skcList objectAtIndex:textField.tag];
    } else {
        skcVo = [self.skcList objectAtIndex:textField.tag-1000];
    }
    
    //总定量
    for (int i = 0; i < skcVo.tfDhList.count; i++) {
        UITextField *tfDhl = [skcVo.tfDhList objectAtIndex:i];
        dhl += [tfDhl.text intValue];
    }
    skcVo.labelTotalCount.text = [NSString stringWithFormat:@"%ld",dhl];
    
    //总金额
    skcVo.labelTotalMoney.text = [NSString stringWithFormat:@"%.2f",[skcVo.textField.text doubleValue]*dhl];
    
    if (self.action==ACTION_CONSTANTS_EDIT) {
        [self checkDhChange];
    }
}
#pragma mark - 比较数据是否修改
- (void)checkDhChange
{
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        if ([skcVo.textField.text doubleValue] != skcVo.oldValue) {
            self.isChange = YES;
            break;
        }
        for (int j=0; j<skcVo.tfDhList.count; j++) {
            UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
            NSNumber *oldCount = [skcVo.oldDhList objectAtIndex:j];
            if ([textField.text integerValue] != [oldCount integerValue]) {
                self.isChange = YES;
                break;
            }
        }
    }
    [self changeNavUI];
}




- (void)changeNavUI
{
    [self.titleBox editTitle:self.isChange act:ACTION_CONSTANTS_EDIT];
}



- (void)saveData {
    __weak typeof(self) weakSelf = self;
    [service saveVirtualStore:self.param CompletionHandler:^(id json) {
        if (!weakSelf.isContinue) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[VirtualStockManagementView class]]) {
                    VirtualStockManagementView *list= (VirtualStockManagementView *)vc;
                    [list loadVirtualListAndVirtualCount];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            weakSelf.searchBar.keyWordTxt.text = @"";
            weakSelf.isChange = NO;
            [weakSelf changeNavUI];
            [weakSelf.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    NSMutableArray *goodsItems = [[NSMutableArray alloc] init];
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        if (skcVo.tfDhList.count>0) {
            for (int j=0; j<skcVo.tfDhList.count; j++) {
                NSMutableDictionary *detailVo = [[NSMutableDictionary alloc] init];
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
                NSNumber *oldCount = [skcVo.oldDhList objectAtIndex:j];
                NSInteger dhl = [textField.text integerValue];
                if (dhl != [oldCount integerValue]) {
                    [detailVo setValue:sizeVo.goodsId forKey:@"goodsId"];
                    [detailVo setValue:textField.text forKey:@"virtualStore"];
                    [goodsItems addObject:detailVo];
                }
            }
        }
    }
    [_param setValue:@"0" forKey:@"batchMode"];
    [_param setValue:goodsItems forKey:@"goodsList"];
    [_param setValue:self.shopId forKey:@"shopId"];
    return _param;
}
@end
