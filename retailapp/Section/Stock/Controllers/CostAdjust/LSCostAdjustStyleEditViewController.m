//
//  LSCostAdjustStyleEditViewController.m
//  retailapp
//
//  Created by guozhi on 2017/4/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostAdjustStyleEditViewController.h"
#import "SearchBar2.h"
#import "XHAnimalUtil.h"
#import "LSStyleInfoView.h"
#import "SkcStyleVo.h"
#import "SkcListVo.h"
#import "SizeListVo.h"
#import "InputTarget.h"
#import "OrderInputBox.h"
#import "LSCostAdjustVo.h"
#import "LSCostAdjustDetailVo.h"
#import "LSFooterView.h"
#import "LSCostAdjustStyleBatchViewController.h"
#import "LSCostAdjustDetailVo.h"
@interface LSCostAdjustStyleEditViewController ()<ISearchBarEvent,OrderInputBoxDelegate, LSFooterViewDelegate>

/**页面回调block*/
@property (nonatomic, copy) StyleDetailCallBlock callBlock;
/**款式数据模型*/
@property (nonatomic, strong) SkcStyleVo *skcStyleVo;
/**款色列表*/
@property (nonatomic, strong) NSArray *skcList;
/**尺码名称列表*/
@property (nonatomic, strong) NSArray *sizeNameList;
/**款色尺码列表*/
@property (nonatomic, strong) NSArray *skcSizeList;
/**门店|仓库id*/
@property (nonatomic, strong) NSString *shopId;
/**调整单号*/
@property (nonatomic, strong) NSString *adjustCode;
/**编辑模式页面是否有编辑*/
@property (nonatomic, assign) BOOL isChange;
/**是否保存并继续添加*/
@property (nonatomic, assign) BOOL isContinue;
/**是否删除款式*/
@property (nonatomic, assign) BOOL isDel;
/**版本号*/
@property (nonatomic, assign) NSInteger lastVer;
/**临时 UITextField*/
@property (nonatomic, strong) UITextField *txtField;
/**UITextField字典*/
@property (nonatomic, strong) NSMutableDictionary *tarDic;
/**当前选中的UITextField*/
@property (nonatomic, strong) InputTarget *currentTarget;
/** <#注释#> */
@property (nonatomic, strong) LSCostAdjustVo *costAdjustVo;
/**唯一性*/
@property (nonatomic,copy) NSString *token;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footerView;
/** <#注释#> */
@property (nonatomic, strong) LSCostAdjustDetailVo *costAdjustDetailVo;
@end

@implementation LSCostAdjustStyleEditViewController
- (instancetype)initWithShopId:(NSString *)shopId obj:(LSCostAdjustVo *)obj costAdjustDetailVo:(LSCostAdjustDetailVo *)costAdjustDetailVo action:(int)action isEdit:(BOOL)isEdit callBlock:(StyleDetailCallBlock)callBlock {
    if (self = [super init]) {
        self.shopId = shopId;
        self.costAdjustVo = obj;
        self.costAdjustDetailVo = costAdjustDetailVo;
        self.action = action;
        self.isEdit = isEdit;
        self.callBlock = callBlock;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
   
}

- (void)configViews {
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self configTitle:@"成本价调整商品详情" leftPath:Head_ICON_BACK rightPath:nil];
    } else {
        [self configTitle:@"选择款式" leftPath:Head_ICON_BACK rightPath:nil];
    }
    
    CGFloat y = kNavH;
    self.searchBar = [SearchBar2 searchBar2];
    self.searchBar.ls_top = y;
    [self.view addSubview:self.searchBar];
    y = y + self.searchBar.ls_height;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    [self.view addSubview:self.scrollView];
    
    [self.searchBar initDelagate:self placeholder:@"请精确输入调整商品款号"];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self selectStyleDetail:@""];
        [self.searchBar setHidden:YES];
        [self.scrollView setLs_top:self.searchBar.ls_top];
        [self.scrollView setLs_height:self.scrollView.ls_height+self.searchBar.ls_height];
    }
    
    self.footerView = [LSFooterView footerView];
    self.footerView.hidden = YES;
    [self.footerView initDelegate:self btnsArray:@[kFootBatch]];
    self.footerView.ls_bottom = SCREEN_H;
    [self.view addSubview:self.footerView];
    
    
}

#pragma mark - 接收前一页面参数



- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.isContinue) {
            //保存并进行添加状态时，执行回调block
            self.callBlock();
        }
        [self popViewController];
    }else{
        //保存
        [self save];
    }
}

#pragma mark - 输入查询款式
- (void)imputFinish:(NSString *)keyWord {
    if ([NSString isNotBlank:keyWord]) {
        [self selectStyleDetail:keyWord];
    }else{
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark - 查询款式详情
- (void)selectStyleDetail:(NSString *)styleCode
{
    self.footerView.hidden = YES;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //商店ID
    [param setValue:self.shopId forKey:@"shopId"];
    //款式id
    [param setValue:self.costAdjustDetailVo.styleId forKey:@"styleId"];
    //成本价调整单号
    [param setValue:self.costAdjustVo.costPriceOpNo forKey:@"costPriceOpNo"];
    //款号
    [param setValue:styleCode forKey:@"styleCode"];
    
    NSString *url = @"costPriceOpBills/styleCostPriceOpDetail";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.skcStyleVo = [SkcStyleVo converToVo:[json objectForKey:@"skcGoodsStyleVo"]];
        [wself reloadData];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
    
}

#pragma mark - 刷新数据
- (void)reloadData {
    self.skcList = self.skcStyleVo.skcList;
    self.sizeNameList = self.skcStyleVo.sizeNameList;
    if (self.skcList.count > 0) {
        if (self.action==ACTION_CONSTANTS_ADD) {
            self.isChange = YES;
            for (SkcListVo *skcListVo in self.skcList) {
                for (SizeListVo *sizeListVo in skcListVo.sizeList) {
                    if ([ObjectUtil isNotNull:sizeListVo.laterCostPrice]) {
                        self.isChange = NO;
                        self.action = ACTION_CONSTANTS_EDIT;
                        continue;
                    }
                }
            }
           
        }
        [self changeNavUI];
        self.footerView.hidden = !self.isEdit;
        [self layoutScrollView];
    }else{
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.scrollView addSubview:[ViewFactory setClearView:self.scrollView.frame]];
    }

}

#pragma mark - 绘制二维表格
- (void)layoutScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    CGFloat height = 0;
    CGFloat width = self.scrollView.ls_width;
    //款式信息
    LSStyleInfoView *view = [LSStyleInfoView styleInfoView];
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, 88)];
    styleView.backgroundColor = [UIColor whiteColor];
    [styleView addSubview:view];
    NSString *filePath = self.skcStyleVo.filePath;
    NSString *goodsCode = [NSString stringWithFormat:@"款号：%@",self.skcStyleVo.styleCode];
    short updownStatus = 1;//默认1上架 2下架
    if ([ObjectUtil isNotNull:self.skcStyleVo.styleStatus]) {
        updownStatus = [self.skcStyleVo.styleStatus shortValue];
    }

    NSString *hangTagPrice = [NSString stringWithFormat:@"吊牌价：¥%.2f", self.skcStyleVo.hangTagPrice.doubleValue];
    [view setStyleInfo:filePath goodsName:self.skcStyleVo.styleName styleCode:goodsCode upDownStatus:updownStatus goodsPrice:hangTagPrice showPrice:YES];
    styleView.ls_height = view.ls_height;
   
    [detailView addSubview:styleView];
    height+=styleView.ls_height+15;
    
    UIColor *bgColor = [UIColor whiteColor];
    
    if (self.skcList.count<=3) {
        //款色小于等于3时，显示一个二维表
        CGFloat w = (width-70.0f)/self.skcList.count;
        NSInteger row = self.sizeNameList.count + 1;
        UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, row*44)];
        goodsView.backgroundColor = RGB(221, 221, 221);
        //左边栏目 尺码
        // 浅灰色底
        UIView *sizeBackView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 69, goodsView.ls_height - 2)];
        sizeBackView.backgroundColor = [UIColor whiteColor];
        [goodsView addSubview:sizeBackView];
        for (int i=0; i<row; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44 * i, 68, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = RGB(221, 221, 221);
            [goodsView addSubview:label];
            if (i == 0) {
                label.text = @"颜色";
            } else {
                label.text = [self.sizeNameList objectAtIndex:i - 1];
            }
        }
        
        //款色
        for (int i=0; i<self.skcList.count; i++) {
            SkcListVo *skcVo = [self.skcList objectAtIndex:i];
            
            //颜色 款式
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70 + w * i, 1, w - 1, 22)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = bgColor;
            label.text = skcVo.colorVal;
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(70 + w * i, 1+22, w - 1, 21)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.text = [NSString stringWithFormat:@"(%@)",skcVo.colorNumber];
            [goodsView addSubview:label];
            
            skcVo.tfDhList = [NSMutableArray array];
            skcVo.oldDhList = [NSMutableArray array];
            for (int j = 0; j<skcVo.sizeList.count; j++) {
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(70 + w * i, 1 + 44 * (j + 1), w - 1, 43)];
                tfDh.borderStyle = UITextBorderStyleNone;
                tfDh.font = [UIFont systemFontOfSize:14];
                tfDh.textColor = self.isEdit?RGB(0, 136, 204):RGB(102, 102, 102);
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.backgroundColor = bgColor;
                tfDh.enabled = self.isEdit;
                tfDh.delegate = self;
                tfDh.tag = i;
                if (sizeVo.hasStore.intValue == 1) {//
                    double costPrice = sizeVo.laterCostPrice == nil ? sizeVo.beforeCostPrice.doubleValue : sizeVo.laterCostPrice.doubleValue;
                    tfDh.text = [NSString stringWithFormat:@"%.2f", costPrice];
                } else {
                    tfDh.text = @"-";
                    tfDh.textColor = RGB(102, 102, 102);
                    tfDh.enabled = NO;
                }
                [goodsView addSubview:tfDh];
                
                [skcVo.tfDhList addObject:tfDh];
                [skcVo.oldDhList addObject:[NSNumber numberWithDouble:[tfDh.text doubleValue]]];
            }
        }
        
        height += goodsView.ls_height;
        [detailView addSubview:goodsView];
        height += 10;
    }else{
        //款色大于3时，每个款式单独显示
        CGFloat w = (width-5)/4;
        int row = (int)(self.sizeNameList.count+1)/2;
        
        for (int i=0; i<self.skcList.count; i++) {
            SkcListVo *skcVo = [self.skcList objectAtIndex:i];
            UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1+44*(row+1))];
            goodsView.backgroundColor = RGB(221, 221, 221);
            
            //颜色 款式
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, width, 22)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = RGB(221, 221, 221);
            label.text = skcVo.colorVal;
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1+22, width, 21)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = RGB(221, 221, 221);
            label.text = [NSString stringWithFormat:@"(%@)",skcVo.colorNumber];
            [goodsView addSubview:label];
            
                
            
            skcVo.tfDhList = [NSMutableArray array];
            skcVo.oldDhList = [NSMutableArray array];
            for (int j=0; j<self.sizeNameList.count; j++) {
                int row = j/2;
                int col = j%2;
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col, 1 + 44 * (row + 1), w, 43)];
                view.backgroundColor = bgColor;
                UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.text = [self.sizeNameList objectAtIndex:j];
                [view addSubview:label];
                [goodsView addSubview:view];
                
                UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col + (w+1), 1 + 44 * (row + 1), w, 43)];
                tfDh.borderStyle = UITextBorderStyleNone;
                tfDh.font = [UIFont systemFontOfSize:14];
                tfDh.textColor = self.isEdit?RGB(0, 136, 204):RGB(102, 102, 102);
                tfDh.enabled = self.isEdit;
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.keyboardType = UIKeyboardTypeNumberPad;
                if (sizeVo.hasStore.intValue == 1) {//没有商品id显示-
                    double costPrice = sizeVo.laterCostPrice == nil ? sizeVo.beforeCostPrice.doubleValue : sizeVo.laterCostPrice.doubleValue;
                    tfDh.text = [NSString stringWithFormat:@"%.2f", costPrice];
                } else {
                    tfDh.text = @"-";
                    tfDh.textColor = RGB(102, 102, 102);
                    tfDh.enabled = NO;
                }
                tfDh.backgroundColor = bgColor;
                tfDh.delegate = self;
                tfDh.tag = i;
                [goodsView addSubview:tfDh];
                [skcVo.tfDhList addObject:tfDh];
                [skcVo.oldDhList addObject:[NSNumber numberWithDouble:[tfDh.text doubleValue]]];
            }
            
            [detailView addSubview:goodsView];
            height += goodsView.ls_height+15;
        }
    }
    
    if (self.isEdit) {
        [self bandInputTarget];
    }
    UIView *btnSuperView;
    if (self.action==ACTION_CONSTANTS_ADD) {
        //保存并添加按钮
        UIButton *saveBtn = [LSViewFactor addGreenButton:detailView title:@"保存并继续添加" y:height];
        btnSuperView = saveBtn.superview;
        [saveBtn addTarget:self action:@selector(onContinueEventClick) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.action==ACTION_CONSTANTS_EDIT&&self.isEdit) {
        //删除按钮
        UIButton *delBtn = [LSViewFactor addRedButton:detailView title:@"删除" y:height];
        [delBtn addTarget:self action:@selector(onDelEventClick) forControlEvents:UIControlEventTouchUpInside];
        btnSuperView = delBtn.superview;
    }
    height = height + btnSuperView.ls_height;
    height +=15;
    detailView.frame = CGRectMake(0, 0, width, height);
    height =(self.scrollView.ls_height<height)?height:self.scrollView.ls_height;
    [self.scrollView addSubview:detailView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height+60);
    
}

#pragma mark -  绑定UITextField 键盘
- (void)bandInputTarget
{
    self.tarDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.skcList.count; i++) {
        SkcListVo *skcListVo = [self.skcList objectAtIndex:i];
        NSMutableArray* arr = [NSMutableArray array];
        if (skcListVo.tfDhList.count > 0) {
            for (int j=0; j<skcListVo.tfDhList.count; j++) {
                UITextField *textField = [skcListVo.tfDhList objectAtIndex:j];
                if (textField.enabled) {
                    InputTarget* tar = [[InputTarget alloc] initWithTarget:textField nextTarget:nil];
                    [arr addObject:tar];
                }
            }
            if (arr.count>0) {
                for (int k=0;k < arr.count-1;k++) {
                    InputTarget* tar = [arr objectAtIndex:k];
                    tar.nextTarget = [arr objectAtIndex:k+1];
                }
                NSString* key = [NSString stringWithFormat:@"UITextField_%d",i];
                [self.tarDic setValue:arr forKey:key];
            }
        }
    }
}


#pragma mark - 输入数量
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.txtField = textField;
    for (NSString* key in [self.tarDic allKeys]) {
        for (InputTarget* tar in [self.tarDic objectForKey:key]) {
            if (tar.textField==textField) {
                self.currentTarget = tar;
            }
        }
    }
    [OrderInputBox show:self.currentTarget delegate:self isFloat:YES isSymbol:NO];
    [OrderInputBox limitInputNumber:6 digitLimit:2];
    return NO;
}

- (void)selectTarget:(InputTarget *)inputTarget
{
    [inputTarget.textField.layer setCornerRadius:2.0];
    [inputTarget.textField.layer setBorderWidth:1.0];
    [inputTarget.textField.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void)deSelectTarget:(InputTarget *)inputTarget
{
    [inputTarget.textField.layer setCornerRadius:0];
    [inputTarget.textField.layer setBorderWidth:0];
    [inputTarget.textField.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void)inputOkClick:(NSString *)num textField:(UITextField *)textField
{
    textField.text = [NSString stringWithFormat:@"%.2f", num.doubleValue];
    [self textFieldTextDidChange:textField];
}

#pragma mark - 总调整、调整后库存计算
- (void)textFieldTextDidChange:(id)obj
{
        if (self.action==ACTION_CONSTANTS_EDIT) {
        [self checkDhChange];
    }
}


#pragma mark - 判断数量是否有修改
- (void)checkDhChange
{
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        for (int j=0; j<skcVo.tfDhList.count; j++) {
            UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
            NSNumber *oldCount = [skcVo.oldDhList objectAtIndex:j];
            if (textField.text.doubleValue != oldCount.doubleValue) {
                self.isChange = YES;
                break;
            }
        }
    }
    [self changeNavUI];
}

#pragma mark - 更改导航栏状态
- (void)changeNavUI
{
    [self editTitle:self.isChange act:ACTION_CONSTANTS_EDIT];
}

#pragma mark - 获取款式下商品
- (NSMutableArray *)obtainGoodsList
{
    NSMutableArray *goodsList = [NSMutableArray array];
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        if (skcVo.tfDhList.count>0) {
            for (int j=0; j<skcVo.tfDhList.count; j++) {
                LSCostAdjustDetailVo *obj = [[LSCostAdjustDetailVo alloc] init];
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                if (sizeVo.hasStore.integerValue != 1) {
                    continue;
                }
                UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
                NSNumber *oldCost = [skcVo.oldDhList objectAtIndex:j];
                double dhl = [textField.text doubleValue];
                double oldDhl = [oldCost doubleValue];
                obj.goodsId = sizeVo.goodsId;
                obj.styleCode = self.skcStyleVo.styleCode;
                obj.styleName = self.skcStyleVo.styleName;
                obj.beforeCostPrice = sizeVo.beforeCostPrice.doubleValue;
                obj.laterCostPrice = dhl;
                if (self.isDel) {
                    //删除商品
                    obj.operateType = @"del";
                    if ([NSString isNotBlank:obj.goodsId]) {
                        [goodsList addObject:obj];
                    }
                }else{
                    if (oldDhl == dhl) {
                        obj.operateType = nil;
                    } else {
                        obj.operateType = sizeVo.laterCostPrice == nil ? @"add" : @"edit";
                    }
                    if ([NSString isNotBlank:obj.goodsId]) {
                        [goodsList addObject:obj];
                    }
                }
            }
        }
    }
    return goodsList;
}
#pragma mark - 保存并继续添加
- (void)onContinueEventClick
{
    self.isContinue = YES;
    self.isDel = NO;
    [self saveGoodsDetail];
}

#pragma mark - 删除
- (void)onDelEventClick
{
    __weak typeof(self) wself = self;
    [LSAlertHelper showSheet:[NSString stringWithFormat:@"删除款式[%@]吗?",self.skcStyleVo.styleName] cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        wself.isContinue = NO;
        wself.isDel = YES;
        [wself saveGoodsDetail];

    }];
}

#pragma mark - 保存
- (void)save
{
    self.isContinue = NO;
    self.isDel = NO;
    [self saveGoodsDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}

#pragma mark - 更新调整单详情列表数据
- (void)saveGoodsDetail
{
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableArray *keyValuesList = [NSMutableArray array];
    for (LSCostAdjustDetailVo *obj in [self obtainGoodsList]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        //调整原因
        [param setValue:obj.adjustReason forKey:@"adjustReason"];
        //调整前成本价
        [param setValue:@(obj.beforeCostPrice) forKey:@"beforeCostPrice"];
        //商品ID
        [param setValue:obj.goodsId forKey:@"goodsId"];
        //调整后成本价
        [param setValue:@(obj.laterCostPrice) forKey:@"laterCostPrice"];
        //操作类型 add:新增 edit:编辑 del:删除
        [param setValue:obj.operateType forKey:@"operateType"];
        [keyValuesList addObject:param];
    }
    //调整商品
    [param setValue:keyValuesList forKey:@"costPriceOpDetailList"];
    //成本价调整单号
    [param setValue:self.costAdjustVo.costPriceOpNo forKey:@"costPriceOpNo"];
    //版本号
    [param setValue:self.costAdjustVo.lastVer forKey:@"lastVer"];
    //备注
    [param setValue:self.costAdjustVo.memo forKey:@"memo"];
    //是否仅改变状态
    [param setValue:@(0) forKey:@"modifyStatusOnly"];
    //1:保存 2:提交 3:确认 4:拒绝
    [param setValue:@(1) forKey:@"opType"];
    [param setValue:self.costAdjustVo.shopOrOrgId forKey:@"shopOrOrgId"];
    //门店/机构 1：门店 2：机构
    [param setValue:@(self.costAdjustVo.shopType) forKey:@"shopType"];
    //款式ID(保存款式信息传入，其他为null)
   
    NSString *styleId = [NSString isBlank:self.costAdjustVo.styleId] ? self.skcStyleVo.styleId : self.costAdjustVo.styleId;
    [param setValue:styleId forKey:@"styleId"];
    
    NSString *url = @"costPriceOpBills/saveCostPriceOpDetail";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.token = nil;
        wself.lastVer = [[json objectForKey:@"lastVer"] longValue];
        if (wself.isContinue) {
            wself.searchBar.keyWordTxt.text = @"";
            wself.isChange = NO;
            [wself changeNavUI];
            [wself.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }else{
            wself.isChange = NO;
            [wself changeNavUI];
            wself.callBlock();
            [wself popViewController];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];

}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    }
}

- (void)showBatchEvent {
    __weak typeof(self) wself = self;
    LSCostAdjustStyleBatchViewController *vc = [[LSCostAdjustStyleBatchViewController alloc] initWithCallBlock:^(double cost) {//成本价
        for (int i=0; i<wself.skcList.count; i++) {
            SkcListVo *skcVo = [wself.skcList objectAtIndex:i];
            if (skcVo.tfDhList.count>0) {
                for (int j=0; j<skcVo.tfDhList.count; j++) {
                    UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
                    if (![textField.text containsString:@"-"]) {
                        textField.text = [NSString stringWithFormat:@"%.2f", cost];
                    }
                }
            }
        }
        [wself checkDhChange];
    }];
    [self pushViewController:vc];
}


@end
