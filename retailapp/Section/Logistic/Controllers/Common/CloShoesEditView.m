//
//  CloShoesEditView.m
//  retailapp
//
//  Created by hm on 15/10/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CloShoesEditView.h"
#import "SearchBar2.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "UIView+Sizes.h"
#import "UIHelper.h"
#import "StyleItem.h"
#import "SkcStyleVo.h"
#import "SkcListVo.h"
#import "SizeListVo.h"
#import "PaperDetailVo.h"
#import "InputTarget.h"
#import "PackBoxRecordView.h"
#import "OrderInputBox.h"
#import "SymbolNumberInputBox.h"
#import "NumberUtil.h"
#import "PurchasePaperEditView.h"

@interface CloShoesEditView ()<ISearchBarEvent,OrderInputBoxDelegate,StyleItemDelegate,SymbolNumberInputClient>

@property (nonatomic, strong) CommonService *commonService;

@property (nonatomic, strong) LogisticService *logisticService;
/**款式vo*/
@property (nonatomic, strong) SkcStyleVo *skcStyleVo;
/**款色vo列表*/
@property (nonatomic, strong) NSArray *skcList;
/**尺码名称列表*/
@property (nonatomic, strong) NSArray *sizeNameList;
/**款色尺码列表*/
@property (nonatomic, strong) NSArray *skcSizeList;
/**回调block*/
@property (nonatomic, copy) EditHandler editHandler;
/**款号*/
@property (nonatomic, copy) NSString *styleCode;
/**来源单据*/
@property (nonatomic, copy) NSString *sourceFrom;
/**来源单据id*/
@property (nonatomic, copy) NSString *sourceId;
/**页面模式*/
@property (nonatomic, assign) NSInteger action;
/**单据类型*/
@property (nonatomic, assign) NSInteger paperType;
/**是否编辑标识位*/
@property (nonatomic, assign) BOOL isChange;
/**是否可编辑*/
@property (nonatomic, assign) BOOL isEdit;
/**是否可编辑装箱单记录*/
@property (nonatomic, assign) BOOL isEditRecord;
/**是否保存并继续添加*/
@property (nonatomic, assign) BOOL isContinue;
/**是否删除*/
@property (nonatomic, assign) BOOL isDel;
/**版本号*/
@property (nonatomic, assign) long lastVer;
/**临时 UITextField*/
@property (nonatomic, strong) UITextField *txtField;
/**传入的单据参数 保存商品用*/
@property (nonatomic, strong) NSMutableDictionary *paperParam;
/**是否需要刷新*/
@property (nonatomic, assign) BOOL isRefresh;
/**UITextField字典*/
@property (nonatomic, strong) NSMutableDictionary *tarDic;
/**当前选中的UITextField*/
@property (nonatomic, strong) InputTarget *currentTarget;
/**价格名称*/
@property (nonatomic, copy) NSString *priceName;
@property (nonatomic, strong) StyleItem *styleItem;
//是否可以编辑价格
@property (nonatomic, assign) BOOL isEditPrice;
//是否可以查看价格
@property (nonatomic, assign) BOOL isSearchPrice;
//价格是否更改
@property (nonatomic, assign) BOOL isPriceChange;
@property (nonatomic, assign) double price;
/**添加的单据类型*/
@property (nonatomic, copy) NSString *type;
/**唯一性*/
@property (nonatomic,copy) NSString *token;
@end

@implementation CloShoesEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self configViews];
    [self initSearchBar];
    [self initNavigate];
    //进货价/退货价查看编辑 修改权限控制
    //1 进货价/退货价查看权限打开 进货价/退货价编辑权限打开时 显示的是采购价 可以编辑
    //2 进货价/退货价查看权限打开 进货价/退货价编辑权限关闭时 显示的是采购价 不可以编辑
    //3 进货价/退货价查看权限关闭 进货价/退货价编辑权限关闭/打开时 商超显示的是零售价 服鞋显示的是吊牌价 不可以编辑
    //编辑
    
    //查看
    self.isEditPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_EDIT] && ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    //查看
    self.isSearchPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    
     [self initPriceName:self.paperType];
    if (self.action==ACTION_CONSTANTS_EDIT) {
        [self loadDataWithCode:self.styleCode];
    }
   
}

- (void)configViews {
    CGFloat y = kNavH;
    self.searchBox = [SearchBar2 searchBar2];
    [self.view addSubview:self.searchBox];
    self.searchBox.ls_top = y;
    y = self.searchBox.ls_bottom;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    [self.view addSubview:self.scrollView];
}

- (void)initSearchBar
{
    self.searchBox.hidden = !(self.action==ACTION_CONSTANTS_ADD);
    if (self.action!=ACTION_CONSTANTS_ADD) {
        [self.scrollView setLs_top:self.searchBox.ls_top];
        [self.scrollView setLs_height:self.scrollView.ls_height+self.searchBox.ls_height];
    }
    if (self.paperType==ORDER_PAPER_TYPE||self.paperType==CLIENT_ORDER_PAPER_TYPE) {
        [self.searchBox initDelagate:self placeholder:@"请精确输入采购商品款号"];
    }else if (self.paperType == PURCHASE_PAPER_TYPE) {
        [self.searchBox initDelagate:self placeholder:@"请精确输入收货商品款号"];
    }else if (self.paperType==RETURN_PAPER_TYPE||self.paperType==CLIENT_RETURN_PAPER_TYPE) {
        [self.searchBox initDelagate:self placeholder:@"请精确输入退货商品款号"];
    }else if (self.paperType==ALLOCATE_PAPER_TYPE) {
        [self.searchBox initDelagate:self placeholder:@"请精确输入调拨商品款号"];
    }else{
        [self.searchBox initDelagate:self placeholder:@"请精确输入装箱商品款号"];
    }
    self.searchBox.keyWordTxt.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigate
{
    [self configTitle:@"商品详情" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.isContinue||self.isRefresh) {
            self.editHandler();
        }
        [XHAnimalUtil animalEdit:self.navigationController action:self.action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self saveStyle];
    }
}

- (void)changeNavUI
{
    self.isPriceChange = self.isEditPrice?[NumberUtil isNotEqualNum:self.price num2:[self.skcStyleVo.stylePrice doubleValue]]:[NumberUtil isNotEqualNum:self.price num2:[self.skcStyleVo.hangTagPrice doubleValue]];
    [self editTitle:self.isChange||self.isPriceChange act:ACTION_CONSTANTS_EDIT];
}

//设置页面参数
- (void)loadDataWithCode:(NSString *)styleCode withParam:(NSMutableDictionary *)param withSourceId:(NSString *)sourceId withAction:(NSInteger)action withType:(NSInteger)paperType withEdit:(BOOL)isEdit callBack:(EditHandler)handler
{
    self.styleCode = styleCode;
    self.supplyId = [param objectForKey:@"supplyId"];
    self.paperParam = param;
    self.sourceId = sourceId;
    self.action = action;
    self.paperType = paperType;
    self.isEditRecord = isEdit;
    self.isEdit = self.isOpenPackBox?NO:isEdit;
    self.editHandler = handler;
    if (paperType==ORDER_PAPER_TYPE||paperType==CLIENT_ORDER_PAPER_TYPE) {
        self.sourceFrom = (paperType==ORDER_PAPER_TYPE)?@"order":@"customerOrder";
    }else if (paperType==PURCHASE_PAPER_TYPE) {
        self.sourceFrom = ([@"p" isEqualToString:self.recordType])?@"stockin":@"distribute";
    }else if (paperType==RETURN_PAPER_TYPE||paperType==CLIENT_RETURN_PAPER_TYPE) {
        self.sourceFrom = (paperType==RETURN_PAPER_TYPE)?@"return":@"customerReturn";
    }else if (paperType==ALLOCATE_PAPER_TYPE) {
        self.sourceFrom = @"allocate";
    }else if (paperType==PACK_BOX_PAPER_TYPE) {
        self.sourceFrom = @"pack";
    }
}

- (void)initPriceName:(NSInteger)paperType
{
    if (self.paperType == ORDER_PAPER_TYPE || paperType == CLIENT_ORDER_PAPER_TYPE) {//采购单 客户采购单
        self.priceName = self.isSearchPrice ? @"采购价:" : @"吊牌价:";
    } else if (paperType == PURCHASE_PAPER_TYPE) { //收货入库单
        self.priceName = self.isSearchPrice?@"进货价:":@"吊牌价:";
    } else if (paperType == RETURN_PAPER_TYPE || paperType == CLIENT_RETURN_PAPER_TYPE) {//退货出库单 客户退货单
        self.priceName = self.isSearchPrice?@"退货价:":@"吊牌价:";
    }else if (paperType == ALLOCATE_PAPER_TYPE) {//门店调拨单不受进货价/退货价查看编辑 修改权限控制 一直显示吊牌价
        self.priceName = @"吊牌价:";
        self.isSearchPrice = NO;
        self.isEditPrice = NO;
    }else if (paperType == PACK_BOX_PAPER_TYPE) {//装箱单不受进货价/退货价查看编辑 修改权限控制 一直显示吊牌价
        self.isSearchPrice = NO;
        self.isEditPrice = NO;
        self.priceName = @"吊牌价:";
    }
}

- (void)loadDataWithCode:(NSString *)styleCode
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    __weak typeof(self) weakSelf = self;
    [self.commonService selectCloShoes:styleCode withSourceFrom:self.sourceFrom withSourceId:self.sourceId withShopId:self.shopId withSupplyId:self.supplyId withInShopId:self.inShopId withIsThird:self.isThirdSupply withGoodsPrice:self.goodsPrice completionHandler:^(id json) {
        weakSelf.skcStyleVo = [SkcStyleVo converToVo:[json objectForKey:@"skcGoodsStyleVo"]];
        weakSelf.skcList = weakSelf.skcStyleVo.skcList;
        weakSelf.sizeNameList = weakSelf.skcStyleVo.sizeNameList;
        if (weakSelf.skcList.count>0) {
            if (weakSelf.action==ACTION_CONSTANTS_ADD) {
                weakSelf.isChange = YES;
                [weakSelf changeNavUI];
            }
            [weakSelf layoutScrollView];
        }else{
            [weakSelf.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            weakSelf.scrollView.ls_show = YES;
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}
#pragma mark - 检索款号
- (void)imputFinish:(NSString *)keyWord
{
    if ([NSString isNotBlank:keyWord]) {
        [self loadDataWithCode:keyWord];
    }else{
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark - 绘制表格
- (void)layoutScrollView
{
    if (self.scrollView.subviews.count>0) {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    UIView *detailView = [[UIView alloc] init];
    CGFloat height = 0;
    CGFloat width = self.scrollView.ls_width;
    //款式信息
    self.styleItem = [StyleItem loadFromNib];
    self.styleItem.styleItemDelegate = self;
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, 88)];
    [styleView addSubview:self.styleItem];
    styleView.backgroundColor = [UIColor whiteColor];
    short updownStatus = 1;//默认1上架 2下架
    if ([ObjectUtil isNotNull:self.skcStyleVo.styleStatus]) {
        updownStatus = [self.skcStyleVo.styleStatus shortValue];
    }
    // 1.创建一个富文本
    NSMutableString *goodsName = [NSMutableString string];
    UIImage *beginImage = nil;
    if (updownStatus == 2) {//商品已下架
        [goodsName appendString:@" "];
        beginImage = [UIImage imageNamed:@"ico_alreadyOffShelf"];
    }
    if ([NSString isNotBlank:self.skcStyleVo.styleName]) {
        [goodsName appendString:self.skcStyleVo.styleName];
    }
    
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:goodsName];
    if (updownStatus == 2) {
        // 2.添加开始表情图片
        NSTextAttachment *attchBegin = [[NSTextAttachment alloc] init];
        // 表情图片
        attchBegin.image = beginImage;
        attchBegin.bounds = CGRectMake(0, 0, 40, 15);
        // 设置图片大小
        // 创建带有图片的富文本
        NSMutableAttributedString *stringBegin = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attchBegin]];
        [stringBegin addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, stringBegin.length)];
        
        
        [attri insertAttributedString:stringBegin atIndex:0];// 插入某个位置
    }
    
    
    self.styleItem.lblName.attributedText = attri;
    self.styleItem.lblStyleCode.text = [NSString stringWithFormat:@"款号：%@",self.skcStyleVo.styleCode?:@""];
    self.price = self.isSearchPrice?[self.skcStyleVo.stylePrice doubleValue]:[self.skcStyleVo.hangTagPrice doubleValue];
    [self.styleItem changeUIWithPriceName:self.priceName withPrice:[NSString stringWithFormat:@"￥%.2f",self.price] isEdit:(self.isEditPrice &&self.isEdit)];
    [self.styleItem.pic sd_setImageWithURL:[NSURL URLWithString:self.skcStyleVo.filePath] placeholderImage:[UIImage imageNamed:@"img_default.png"]];
    
    [detailView addSubview:styleView];
    height+=styleView.ls_height+15;
    
    UIColor *bgColor = [UIColor whiteColor];
    
    if (self.skcList.count<=3) {
        
        CGFloat w = (width-70.0f)/self.skcList.count;
        NSInteger row = self.sizeNameList.count+3;
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
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = RGB(221, 221, 221);
            [goodsView addSubview:label];
            if (i == 0) {
                label.text = @"颜色";
            }else if (i == (row-2)) {
                label.text = @"总数量";
            } else if (i == (row-1)) {
                label.text = @"总金额";
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
            for (int j=0; j<skcVo.sizeList.count; j++) {
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(70 + w * i, 1 + 44 * (j + 1), w - 1, 43)];
                tfDh.borderStyle = UITextBorderStyleNone;
                tfDh.font = [UIFont systemFontOfSize:14];
                tfDh.textColor = ([NSString isNotBlank:sizeVo.goodsId] && self.isEdit&& [@"1" isEqualToString:sizeVo.isValid])?RGB(0, 136, 204):RGB(102, 102, 102);
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.keyboardType = UIKeyboardTypeNumberPad;
                tfDh.backgroundColor = bgColor;
                tfDh.enabled = [NSString isNotBlank:sizeVo.goodsId] && self.isEdit && [@"1" isEqualToString:sizeVo.isValid];
                tfDh.tag = i;
                tfDh.text = ([NSString isNotBlank:sizeVo.goodsId] && [@"1" isEqualToString:sizeVo.isValid])?[NSString stringWithFormat:@"%tu",[sizeVo.count integerValue]]:@"-";
                tfDh.delegate = self;
                [goodsView addSubview:tfDh];
                
                [skcVo.tfDhList addObject:tfDh];
                [skcVo.oldDhList addObject:[NSNumber numberWithInteger:[tfDh.text integerValue]]];
            }
            
            //总数量
            label = [[UILabel alloc] initWithFrame:CGRectMake(70 + w * i, 1 + 44 * (skcVo.sizeList.count + 1), w - 1, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text = [self getTotalCount:skcVo.sizeList withSkcVo:skcVo];
            [goodsView addSubview:label];
            
            skcVo.labelTotalCount = label;
            
            //总金额
            label = [[UILabel alloc] initWithFrame:CGRectMake(70 + w * i, 1 + 44 * (skcVo.sizeList.count + 2), w - 1, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text = [NSString stringWithFormat:@"%.2f",[skcVo.totalMoney doubleValue]];
            [goodsView addSubview:label];
            
            skcVo.labelTotalMoney = label;
        }
        
        height += goodsView.ls_height;
        [detailView addSubview:goodsView];
        
    }else{
        CGFloat w = (width-5)/4;
        int row = (int)(self.sizeNameList.count+1)/2;
        
        for (int i=0; i<self.skcList.count; i++) {
            SkcListVo *skcVo = [self.skcList objectAtIndex:i];
            UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1+44*(row+2))];
            goodsView.backgroundColor = RGB(221, 221, 221);
            //颜色 款式
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, width, 22)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = RGB(221, 221, 221);
            
            label.text = skcVo.colorVal;
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1+22, width, 22)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = RGB(221, 221, 221);
            label.text = [NSString stringWithFormat:@"(%@)",skcVo.colorNumber];
            [goodsView addSubview:label];
            
            
            //总数量
            label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = bgColor;
            label.text = @"总数量";
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(2 + w, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text= [self getTotalCount:skcVo.sizeList withSkcVo:skcVo];
            [goodsView addSubview:label];
            
            skcVo.labelTotalCount = label;
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(3 + w * 2, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = bgColor;
            label.text = @"总金额";
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(4 + w*3, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text= [skcVo.totalMoney stringValue];
            [goodsView addSubview:label];
            
            skcVo.labelTotalMoney = label;
            
            skcVo.tfDhList = [NSMutableArray array];
            skcVo.oldDhList = [NSMutableArray array];
            
            for (int j=0; j<self.sizeNameList.count; j++) {
                int row = j/2;
                int col = j%2;
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col, 1 + 44 * (row + 2), w, 43)];
                view.backgroundColor = bgColor;
                UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.text = [self.sizeNameList objectAtIndex:j];
                [view addSubview:label];
                [goodsView addSubview:view];
                
                UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col + (w+1), 1 + 44 * (row + 2), w, 43)];
                tfDh.borderStyle = UITextBorderStyleNone;
                tfDh.font = [UIFont systemFontOfSize:14];
                tfDh.textColor = ([NSString isNotBlank:sizeVo.goodsId] && self.isEdit && [@"1" isEqualToString:sizeVo.isValid])?RGB(0, 136, 204):RGB(102, 102, 102);
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.keyboardType = UIKeyboardTypeNumberPad;
                tfDh.backgroundColor = bgColor;
                tfDh.enabled = [NSString isNotBlank:sizeVo.goodsId] && self.isEdit && [@"1" isEqualToString:sizeVo.isValid];
                tfDh.tag = i;
                tfDh.text = ([NSString isNotBlank:sizeVo.goodsId] && [@"1" isEqualToString:sizeVo.isValid])?[NSString stringWithFormat:@"%tu",[sizeVo.count integerValue]]:@"-";
                tfDh.delegate = self;
                [goodsView addSubview:tfDh];
                [skcVo.tfDhList addObject:tfDh];
                [skcVo.oldDhList addObject:[NSNumber numberWithInteger:[tfDh.text integerValue]]];
            }
            
            [detailView addSubview:goodsView];
            height += goodsView.ls_height+15;
        }
    }
    
    if (self.isEdit) {
        [self bandInputTarget];
    }
    
    if (self.action==ACTION_CONSTANTS_ADD) {
        height+=30;
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保存并继续添加" forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
        saveBtn.frame = CGRectMake(10, height, SCREEN_W - 20, 44);
        [detailView addSubview:saveBtn];
        [saveBtn addTarget:self action:@selector(onContinueEventClick) forControlEvents:UIControlEventTouchUpInside];
        height+=44;
    }
    if (self.action==ACTION_CONSTANTS_EDIT&&self.isEdit&&!self.isOpenPackBox) {
        height+=15;
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(10, height, SCREEN_W - 20, 44);
        [detailView addSubview:delBtn];
        [delBtn addTarget:self action:@selector(onDelEventClick) forControlEvents:UIControlEventTouchUpInside];
        height+=44;
    }
    
    if (self.isOpenPackBox) {
        height+=15;
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setTitle:@"查看装箱记录" forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(10, height, SCREEN_W - 20, 44);
        [detailView addSubview:delBtn];
        [delBtn addTarget:self action:@selector(onCheckRecordEventClick) forControlEvents:UIControlEventTouchUpInside];
        height+=44;
    }
    height +=15;
    detailView.frame = CGRectMake(0, 0, width, height);
    height =(self.scrollView.ls_height<height)?height:self.scrollView.ls_height+30;
    [self.scrollView addSubview:detailView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
    
}

#pragma mark - 输入价格
- (void)inputNumber
{
    [SymbolNumberInputBox initData:[NSString stringWithFormat:@"%.2f",self.price]];
    [SymbolNumberInputBox show:[self.priceName substringToIndex:self.priceName.length-1] client:self isFloat:YES isSymbol:NO event:100];
    [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
}
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    self.price = [val doubleValue];
    [self.styleItem initStretchWidth:[NSString stringWithFormat:@"￥%.2f",self.price]];
    [self calculateTotalMoney];
    [self changeNavUI];
}

- (void)calculateTotalMoney
{
    for (int i=0; i<self.skcList.count; i++) {
        NSInteger dhl = 0;
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        //总定量
        for (int i = 0; i < skcVo.tfDhList.count; i++) {
            UITextField *tfDhl = [skcVo.tfDhList objectAtIndex:i];
            dhl += [tfDhl.text intValue];
        }
        for (SizeListVo *sizeVo in skcVo.sizeList) {
            sizeVo.goodsHangTagPrice = [NSNumber numberWithDouble:self.price];
        }
        skcVo.labelTotalCount.text = [NSString stringWithFormat:@"%tu",dhl];
        //总金额
        skcVo.labelTotalMoney.text = [NSString stringWithFormat:@"%.2f",self.price*dhl];
    }
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


#pragma mark - 计算总数量
- (NSString *)getTotalCount:(NSArray *)arr withSkcVo:(SkcListVo *)skcVo
{
    NSInteger count = 0;
    double totalMoney = 0.00;
    for (SizeListVo *sizeVo in arr) {
        double sum = self.isSearchPrice?self.price*[sizeVo.count integerValue]:[sizeVo.goodsHangTagPrice doubleValue]*[sizeVo.count integerValue];
        totalMoney += sum;
        count+=[sizeVo.count integerValue];
    }
    skcVo.totalCount = [NSNumber numberWithInteger:count];
    skcVo.totalMoney = [NSNumber numberWithDouble:totalMoney];
    if (count>0) {
        return [NSString stringWithFormat:@"%tu",count];
    }else{
        return @"0";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    for (NSString* key in [self.tarDic allKeys]) {
        for (InputTarget* tar in [self.tarDic objectForKey:key]) {
            if (tar.textField==textField) {
                self.currentTarget = tar;
            }
        }
    }
    [OrderInputBox show:self.currentTarget delegate:self isFloat:NO isSymbol:NO];
    [OrderInputBox limitInputNumber:6 digitLimit:0];
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
    textField.text = num;
    [self textFieldTextDidChange:textField];
}


#pragma mark - 总数量、总金额动态计算
- (void)textFieldTextDidChange:(id)obj
{
    UITextField *textField =nil;
    if ([obj isKindOfClass:[UITextField class]]) {
        textField = (UITextField *)obj;
    } else if ([obj isKindOfClass:[NSNotification class]]){
        NSNotification *noti = (NSNotification *)obj;
        textField = (UITextField *)noti.object;
    } else {
        return;
    }
    NSInteger dhl = 0;
    if (textField.tag >= self.skcList.count) {
        return;
    }
    
    SkcListVo *skcVo = [self.skcList objectAtIndex:textField.tag];
    
    //总定量
    double totalMoney = 0.00;
    for (int i = 0; i < skcVo.tfDhList.count; i++) {
        UITextField *tfDhl = [skcVo.tfDhList objectAtIndex:i];
        SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:i];
        double sum = self.isSearchPrice?self.price*[tfDhl.text intValue]:[sizeVo.goodsHangTagPrice doubleValue]*[tfDhl.text intValue];
        totalMoney += sum;
        dhl += [tfDhl.text intValue];
    }
    skcVo.labelTotalCount.text = [NSString stringWithFormat:@"%tu",dhl];
    //总金额
    skcVo.labelTotalMoney.text = [NSString stringWithFormat:@"%.2f",totalMoney];
    if (self.action==ACTION_CONSTANTS_EDIT) {
        [self checkDhChange];
    }
}
#pragma mark - 比较数据是否修改
- (void)checkDhChange
{
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
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

#pragma mark - 保存
- (void)saveStyle
{
    if (![self isValide]) {
        [AlertBox show:@"商品数量必须大于0!"];
        return;
    }
    self.isContinue = NO;
    self.isDel = NO;
    [self saveGoodsDetail];
}

#pragma mark -保存并继续添加
- (void)onContinueEventClick
{
    
    if (![self isValide]) {
        [AlertBox show:@"商品数量必须大于0!"];
        return;
    }
    self.isContinue = YES;
    self.isDel = NO;
    [self saveGoodsDetail];
}

- (NSMutableArray *)obtainGoodsList
{
    NSMutableArray *goodsList = [NSMutableArray array];
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        if (skcVo.tfDhList.count>0) {
            for (int j=0; j<skcVo.tfDhList.count; j++) {
                PaperDetailVo *detailVo = [[PaperDetailVo alloc] init];
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
                NSNumber *oldCount = [skcVo.oldDhList objectAtIndex:j];
                NSInteger dhl = [textField.text integerValue];
                detailVo.paperDetailId = sizeVo.detailId;
                detailVo.goodsId = sizeVo.goodsId;
                detailVo.styleId = self.skcStyleVo.styleId;
                detailVo.goodsName = self.skcStyleVo.styleName;
                detailVo.predictSum = sizeVo.predictSum;
                if (ALLOCATE_PAPER_TYPE == _paperType) {
                    detailVo.goodsPrice = [sizeVo.goodsHangTagPrice doubleValue];
                }else{
                    detailVo.goodsPrice = self.isSearchPrice?self.price:[self.skcStyleVo.stylePrice doubleValue];
                }
                detailVo.retailPrice = [sizeVo.goodsHangTagPrice doubleValue];
                detailVo.styleCode = self.skcStyleVo.styleCode;
                detailVo.goodsSum = dhl;
                detailVo.goodsTotalPrice = detailVo.goodsPrice*detailVo.goodsSum;
                detailVo.resonVal = 0;
                if (self.isDel) {
                    if ([NSString isNotBlank:detailVo.paperDetailId]) {
                        detailVo.operateType = @"del";
                        [goodsList addObject:detailVo];
                    }
                }else{
                    if ([oldCount integerValue] == 0) {
                        detailVo.operateType = (dhl != 0 )?(([NSString isNotBlank:detailVo.paperDetailId])?@"edit":@"add"):@"";
                    }else{
                        detailVo.operateType = (dhl == 0)?@"del":(([textField.text integerValue]!=[oldCount integerValue])||self.isPriceChange?@"edit":@"");
                    }
                    [goodsList addObject:detailVo];
                }
            }
        }
    }
    return goodsList;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}
#pragma mark - 保存款式商品
- (void)saveGoodsDetail
{
    NSString* url = nil;
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    [self.paperParam setValue:self.token forKey:@"token"];
    [self.paperParam setValue:@"edit" forKey:@"operateType"];
    if (self.paperType==RETURN_PAPER_TYPE||self.paperType==CLIENT_RETURN_PAPER_TYPE) {
        [self.paperParam setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"returnGoodsDetailList"];
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/save"];
        
    }else if (self.paperType==ORDER_PAPER_TYPE||self.paperType==CLIENT_ORDER_PAPER_TYPE){
        [self.paperParam setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"orderGoodsList"];
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/save"];
        
    }else if (self.paperType==ALLOCATE_PAPER_TYPE){
        [self.paperParam setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"allocateDetailList"];
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"allocate/save"];
        
    }else if (self.paperType==PACK_BOX_PAPER_TYPE){
        [self.paperParam setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"packGoodsDetailList"];
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/save"];
    }else if (self.paperType==PURCHASE_PAPER_TYPE){
        [self.paperParam setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"stockInDetailList"];
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"purchase/save"];
    }
    [self operatePaper:self.paperParam withUrlStr:url];
}

- (void)operatePaper:(NSMutableDictionary *)param withUrlStr:(NSString *)urlStr
{
    __weak typeof(self) weakSelf = self;
    [self.logisticService operatePaperDetail:param withUrl:urlStr completionHandler:^(id json) {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PurchasePaperEditView class]]) {
                PurchasePaperEditView *vc = (PurchasePaperEditView *)obj;
                vc.token = nil;
            }
        }];
        weakSelf.token = nil;
        [weakSelf.paperParam setValue:[json objectForKey:@"lastVer"] forKey:@"lastVer"];
        if (!weakSelf.isContinue) {
            weakSelf.editHandler();
            [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }else{
            weakSelf.searchBox.keyWordTxt.text = @"";
            weakSelf.isChange = NO;
            [weakSelf changeNavUI];
            [weakSelf.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        [self editTitle:NO act:ACTION_CONSTANTS_EDIT];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    } withMessage:@"正在保存..."];
}


#pragma mark - 删除
-(void)onDelEventClick
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除款式[%@]吗?",self.skcStyleVo.styleName]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        self.isContinue = NO;
        self.isDel = YES;
        [self saveGoodsDetail];
    }
}

#pragma mark - 查看装箱记录
- (void)onCheckRecordEventClick
{
    PackBoxRecordView *recordView = [[PackBoxRecordView alloc] init];
    recordView.styleName = self.skcStyleVo.styleName;
    recordView.styleCode = self.skcStyleVo.styleCode;
    recordView.filePath = self.skcStyleVo.filePath;
    recordView.changePrice = self.isSearchPrice;
    recordView.priceName = self.priceName;
    recordView.price = self.price;
    recordView.hangTagPrice = self.skcStyleVo.hangTagPrice;
    __weak typeof(self) weakSelf = self;
    [recordView loadDataWithEdit:self.isEditRecord withStyleId:self.skcStyleVo.styleId withReturnId:self.sourceId callBack:^{
        weakSelf.isRefresh = YES;
        [weakSelf loadDataWithCode:weakSelf.skcStyleVo.styleCode];
    }];
    [self.navigationController pushViewController:recordView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
