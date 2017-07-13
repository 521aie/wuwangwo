//
//  AdjustStyleEditView.m
//  retailapp
//
//  Created by hm on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AdjustStyleEditView.h"
#import "SearchBar2.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "LSStyleInfoView.h"
#import "SkcStyleVo.h"
#import "SkcListVo.h"
#import "SizeListVo.h"
#import "StockAdjustDetailVo.h"
#import "NumberUtil.h"
#import "InputTarget.h"
#import "OrderInputBox.h"


@interface AdjustStyleEditView ()<ISearchBarEvent,OrderInputBoxDelegate>

@property (nonatomic, strong) CommonService *commonService;

@property (nonatomic, strong) StockService *stockService;
/**页面回调block*/
@property (nonatomic, copy) AdjustStyleEditHandler editHandler;
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
/**款式id*/
@property (nonatomic, strong) NSString *styleId;
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
//是否是连锁
@property (nonatomic, assign) BOOL isChain;
/**唯一性*/
@property (nonatomic,copy) NSString *token;

@end

@implementation AdjustStyleEditView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    self.stockService = [ServiceFactory shareInstance].stockService;
    [self configViews];
    [self.searchBar initDelagate:self placeholder:@"请精确输入调整商品款号"];
    if (self.action!=ACTION_CONSTANTS_ADD) {
        [self.searchBar setHidden:YES];
        [self.scrollView setLs_top:self.searchBar.ls_top];
        [self.scrollView setLs_height:self.scrollView.ls_height+self.searchBar.ls_height];
    }
    if (self.action==ACTION_CONSTANTS_EDIT) {
        [self selectStyleDetail:@""];
    }
}

- (void)configViews {
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self configTitle:@"库存调整商品详情" leftPath:Head_ICON_BACK rightPath:nil];
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
    
    
}


#pragma mark - 接收前一页面参数
- (void)loadData:(NSString *)shopId withStyleId:(NSString *)styleId withCode:(NSString *)adjustCode withLastVer:(NSInteger)lastVer callBack:(AdjustStyleEditHandler)handler
{
    self.shopId = shopId;
    self.styleId = styleId;
    self.adjustCode = adjustCode;
    self.lastVer = lastVer;
    self.editHandler = handler;
    self.isChain = [[Platform Instance] getShopMode]!=1;
}


- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.isContinue) {
            //保存并进行添加状态时，执行回调block
            self.editHandler();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        //保存
        [self save];
    }
}

#pragma mark - 输入查询款式
- (void)imputFinish:(NSString *)keyWord
{
    if ([NSString isNotBlank:keyWord]) {
        [self selectStyleDetail:keyWord];
    }else{
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark - 查询款式详情
- (void)selectStyleDetail:(NSString *)styleCode
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    __weak typeof(self) weakSelf = self;
    [self.stockService selectStyleAdjustDetail:self.shopId withAdjustCode:self.adjustCode withStyleId:self.styleId withStyleCode:styleCode CompletionHandler:^(id json) {
        weakSelf.skcStyleVo = [SkcStyleVo converToVo:[json objectForKey:@"skcGoodsStyleVo"]];
        weakSelf.skcList = weakSelf.skcStyleVo.skcList;
        weakSelf.sizeNameList = weakSelf.skcStyleVo.sizeNameList;
        if (weakSelf.skcList!=nil&&weakSelf.skcList.count>0) {
            if (weakSelf.action==ACTION_CONSTANTS_ADD) {
                weakSelf.isChange = YES;
                [weakSelf changeNavUI];
            }
            [weakSelf layoutScrollView];
        }else{
            [weakSelf.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [weakSelf.scrollView addSubview:[ViewFactory setClearView:weakSelf.scrollView.frame]];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 绘制二维表格
- (void)layoutScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *detailView = [[UIView alloc] init];
    CGFloat height = 0;
    CGFloat width = self.scrollView.ls_width;
    //款式信息
    LSStyleInfoView *view = [LSStyleInfoView styleInfoView];
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, 88)];
    styleView.backgroundColor = [UIColor whiteColor];
    [styleView addSubview:view];
    NSString *filePath = self.skcStyleVo.filePath;
//    NSString *goodsName = self.skcStyleVo.styleName;
    NSString *goodsCode = [NSString stringWithFormat:@"款号：%@",self.skcStyleVo.styleCode];
    short updownStatus = 1;//默认1上架 2下架
    if ([ObjectUtil isNotNull:self.skcStyleVo.styleStatus]) {
        updownStatus = [self.skcStyleVo.styleStatus shortValue];
    }
    [view setStyleInfo:filePath goodsName:self.skcStyleVo.styleName styleCode:goodsCode upDownStatus:updownStatus goodsPrice:nil showPrice:NO];
  
    [detailView addSubview:styleView];
    styleView.ls_height = view.ls_height;
    height+=styleView.ls_height+15;
    
    UIColor *bgColor = [UIColor whiteColor];
    
    if (self.skcList.count<=3) {
        //款色小于等于3时，显示一个二维表
        CGFloat w = (width-70.0f)/self.skcList.count;
        NSInteger row = self.sizeNameList.count+2;
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
            }
//            else if (i == row-3) {
//                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"总库存\n(调整前)"];
//                [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(4, 5)];
//                label.numberOfLines = 2;
//                label.attributedText = attrString;
//                attrString = nil;
//            }else if (i == (row-2)) {
//                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"总库存\n(调整后)"];
//                [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(4, 5)];
//                label.numberOfLines = 2;
//                label.attributedText = attrString;
//                attrString = nil;
//            }
            else if (i == (row-1)) {
                label.text = @"总调整";
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
                tfDh.textColor = self.isEdit&&([sizeVo.hasStore shortValue]==1)?RGB(0, 136, 204):RGB(102, 102, 102);
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.keyboardType = UIKeyboardTypeNumberPad;
                tfDh.backgroundColor = bgColor;
                tfDh.enabled = self.isEdit&&([sizeVo.hasStore shortValue]==1);
                tfDh.delegate = self;
                tfDh.tag = i;
                tfDh.text = (((self.billStatus==3||self.billStatus==4)&&[sizeVo.adjustCount doubleValue]==0)||[sizeVo.hasStore shortValue]==0)?@"-":[NSString stringWithFormat:@"%.0f",[sizeVo.totalStore doubleValue]];
                [goodsView addSubview:tfDh];
                
                [skcVo.tfDhList addObject:tfDh];
                [skcVo.oldDhList addObject:[NSNumber numberWithDouble:[tfDh.text doubleValue]]];
            }
            
            //总库存调整前
//            label = [[UILabel alloc] initWithFrame:CGRectMake(70 + w * i, 1 + 44 * (skcVo.sizeListVos.count + 1), w - 1, 43)];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = RGB(51, 51, 51);
//            label.backgroundColor = bgColor;
//            label.tag = i;
//            label.text = [self getTotalCount:skcVo.sizeListVos withSkcVo:skcVo];
//            [goodsView addSubview:label];
//            skcVo.labelTotalCount = label;
            
            //总库存调整后
//            label = [[UILabel alloc] initWithFrame:CGRectMake(70 + w * i, 1 + 44 * (skcVo.sizeListVos.count + 2), w - 1, 43)];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = RGB(51, 51, 51);
//            label.backgroundColor = bgColor;
//            label.tag = i;
//            label.text = [NSString stringWithFormat:@"%.0f",([skcVo.totalCount doubleValue]+[skcVo.totalAdjust doubleValue])];
//            [goodsView addSubview:label];
//            skcVo.labelNowCount = label;
            
            //总调整
            label = [[UILabel alloc] initWithFrame:CGRectMake(70 + w * i, 1 + 44 * (skcVo.sizeList.count + 1), w - 1, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
//            label.text = [NSString stringWithFormat:@"%.0f",[skcVo.totalAdjust doubleValue]];
            label.text = [self getTotalAdjustCount:skcVo];
            [goodsView addSubview:label];
            skcVo.labelTotalMoney = label;
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
            
//            NSString *totalCount = [self getTotalCount:skcVo.sizeListVos withSkcVo:skcVo];
            //颜色 款式
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, width, 22)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = RGB(221, 221, 221);
            [self getTotalAdjustCount:skcVo];
            [self changeAdjustLabel:label withVo:skcVo];
            [goodsView addSubview:label];
            skcVo.labelTotalMoney = label;
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1+22, width, 21)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = RGB(221, 221, 221);
            label.text = [NSString stringWithFormat:@"(%@)",skcVo.colorNumber];
            [goodsView addSubview:label];
            
            //调整前库存
//            label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44, w, 43)];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = RGB(51, 51, 51);
//            label.backgroundColor = bgColor;
//            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"总库存\n(调整前)"];
//            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(4, 5)];
//            label.numberOfLines = 2;
//            label.attributedText = attrString;
//            attrString = nil;
//            [goodsView addSubview:label];
//            
//            label = [[UILabel alloc] initWithFrame:CGRectMake(2 + w, 1 + 44, w, 43)];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = RGB(51, 51, 51);
//            label.backgroundColor = bgColor;
//            label.tag = i;
//            label.text= totalCount;
//            [goodsView addSubview:label];
//            skcVo.labelTotalCount = label;

            //调整后库存
//            label = [[UILabel alloc] initWithFrame:CGRectMake(3 + w * 2, 1 + 44, w, 43)];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = RGB(51, 51, 51);
//            label.backgroundColor = bgColor;
//            attrString = [[NSMutableAttributedString alloc] initWithString:@"总库存\n(调整后)"];
//            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(4, 5)];
//            label.numberOfLines = 2;
//            label.attributedText = attrString;
//            attrString = nil;
//            [goodsView addSubview:label];
//            
//            
//            label = [[UILabel alloc] initWithFrame:CGRectMake(4 + w*3, 1 + 44, w, 43)];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = RGB(51, 51, 51);
//            label.backgroundColor = bgColor;
//            label.tag = i;
//            label.text= [NSString stringWithFormat:@"%.0f",([skcVo.totalCount doubleValue]+[skcVo.totalAdjust doubleValue])];
//            [goodsView addSubview:label];
//            skcVo.labelNowCount = label;
            
            
            
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
                tfDh.textColor = self.isEdit&&([sizeVo.hasStore shortValue]==1)?RGB(0, 136, 204):RGB(102, 102, 102);
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.keyboardType = UIKeyboardTypeNumberPad;
                tfDh.backgroundColor = bgColor;
                tfDh.enabled = self.isEdit&&([sizeVo.hasStore shortValue]==1);
                tfDh.delegate = self;
                tfDh.tag = i;
                tfDh.text = (((self.billStatus==3||self.billStatus==4)&&[sizeVo.adjustCount doubleValue]==0)||[sizeVo.hasStore shortValue]==0)?@"-":[sizeVo.totalStore stringValue];
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
    
    
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, height, self.scrollView.ls_width - 20, 42)];
    lblMessage.font = [UIFont systemFontOfSize:12];
    lblMessage.numberOfLines = 2;
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.text = (self.billStatus==3||self.billStatus==4)?@"提示：以上默认显示各个商品的调整后库存数，未进行库存调整的商品库存数以“-”表示。":@"提示：以上默认显示各个商品的调整前库存数，如需调整，请直接输入需调整商品的实际库存数。";
    [detailView addSubview:lblMessage];
    
    if (self.action==ACTION_CONSTANTS_ADD) {
        //保存并添加按钮
        height+=51;
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保存并继续添加" forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
        saveBtn.frame = CGRectMake(10, height, self.scrollView.ls_width - 20, 44);
        [detailView addSubview:saveBtn];
        [saveBtn addTarget:self action:@selector(onContinueEventClick) forControlEvents:UIControlEventTouchUpInside];
        height+=44;
    }
    if (self.action==ACTION_CONSTANTS_EDIT&&self.isEdit) {
        //删除按钮
        height+=51;
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(10, height, self.scrollView.ls_width - 20, 44);
        [detailView addSubview:delBtn];
        [delBtn addTarget:self action:@selector(onDelEventClick) forControlEvents:UIControlEventTouchUpInside];
        height+=44;
    }
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


#pragma mark - 获取总库存 总调整
- (NSString *)getTotalCount:(NSMutableArray *)arr withSkcVo:(SkcListVo *)skcVo
{
    double count = 0;
    double totalAdjust = 0;
    for (SizeListVo *sizeVo in arr) {
        count+=[sizeVo.nowStore doubleValue];
        totalAdjust += [sizeVo.totalStore doubleValue];
    }
    skcVo.totalCount = [NSNumber numberWithDouble:count];
    skcVo.totalAdjust = [NSNumber numberWithDouble:(totalAdjust-count)];
    return [NSString stringWithFormat:@"%.0f",count];
}

- (NSString *)getTotalAdjustCount:(SkcListVo *)skcVo
{
    double totalAdjust = 0;
    for (SizeListVo *sizeVo in skcVo.sizeList) {
        if (sizeVo.hasStore.integerValue == 1) {
            totalAdjust += [sizeVo.adjustCount doubleValue];
        }
    }
    skcVo.totalAdjust = [NSNumber numberWithDouble:totalAdjust];
    return [NSString stringWithFormat:@"%.0f",totalAdjust];
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
    [OrderInputBox show:self.currentTarget delegate:self isFloat:NO isSymbol:YES];
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

#pragma mark - 总调整、调整后库存计算
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
    double dhl = 0;
    if (textField.tag >= self.skcList.count) {
        return;
    }
    
    SkcListVo *skcVo = [self.skcList objectAtIndex:textField.tag];
    double totalCount = 0;
    for (int i = 0; i < skcVo.tfDhList.count; i++) {
        UITextField *tfDhl = [skcVo.tfDhList objectAtIndex:i];
        SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:i];
        totalCount += [sizeVo.nowStore doubleValue];
        dhl += [tfDhl.text intValue];
    }
    //调整后
//    skcVo.labelNowCount.text = [NSString stringWithFormat:@"%.0f",dhl];
    //总调整
    skcVo.totalAdjust = [NSNumber numberWithDouble:(dhl-totalCount)];
    if (self.skcList.count<=3) {
        skcVo.labelTotalMoney.text = [NSString stringWithFormat:@"%.0f",dhl-totalCount];
    }else{
        [self changeAdjustLabel:skcVo.labelTotalMoney withVo:skcVo];
    }
    if (self.action==ACTION_CONSTANTS_EDIT) {
        [self checkDhChange];
    }
}

- (void)changeAdjustLabel:(UILabel *)label withVo:(SkcListVo *)skcVo
{
    NSString *str = skcVo.colorVal;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSString *astr = [NSString stringWithFormat:@"(总调整：%.0f)",[skcVo.totalAdjust doubleValue]];
    NSMutableAttributedString *adjustStr = [[NSMutableAttributedString alloc] initWithString:astr];
    [attrString appendAttributedString:adjustStr];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(str.length, astr.length)];
    label.attributedText = attrString;
    attrString = nil;
    adjustStr = nil;
    str = nil;
}


#pragma mark - 判断数量是否有修改
- (void)checkDhChange
{
    for (int i=0; i<self.skcList.count; i++) {
        SkcListVo *skcVo = [self.skcList objectAtIndex:i];
        for (int j=0; j<skcVo.tfDhList.count; j++) {
            UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
            NSNumber *oldCount = [skcVo.oldDhList objectAtIndex:j];
            if ([NumberUtil isNotEqualNum:[textField.text doubleValue] num2:[oldCount doubleValue]]) {
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
                StockAdjustDetailVo *detailVo = [[StockAdjustDetailVo alloc] init];
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UITextField *textField = [skcVo.tfDhList objectAtIndex:j];
                NSNumber *oldCount = [skcVo.oldDhList objectAtIndex:j];
                double dhl = [textField.text doubleValue];
                detailVo.goodsId = sizeVo.goodsId;
                detailVo.styleCode = self.skcStyleVo.styleCode;
                detailVo.styleName = self.skcStyleVo.styleName;
                detailVo.adjustStore = [NSNumber numberWithDouble:(dhl-[sizeVo.nowStore doubleValue])];
                detailVo.sumAdjustMoney = [NSNumber numberWithDouble:self.price*dhl];
                detailVo.nowStore = sizeVo.nowStore;
                if (self.isDel) {
                    //删除商品
                    detailVo.operateType = @"del";
                    if ([NSString isNotBlank:detailVo.goodsId]) {
                        [goodsList addObject:detailVo];
                    }
                }else{
                    if (self.action==ACTION_CONSTANTS_ADD) {
                        detailVo.operateType = [NumberUtil isNotEqualNum:dhl num2:[detailVo.nowStore doubleValue]]?@"add":@"";
                    }else{
                        detailVo.operateType = [NumberUtil isEqualNum:[oldCount doubleValue] num2:[detailVo.nowStore doubleValue]]?(([NumberUtil isNotEqualNum:dhl num2:[oldCount doubleValue]])?@"add":@""):(([NumberUtil isEqualNum:dhl num2:[detailVo.nowStore doubleValue]])?@"del":([NumberUtil isNotEqualNum:dhl num2:[oldCount doubleValue]]?@"edit":@""));
                    }
                    if ([NSString isNotBlank:detailVo.goodsId]) {
                        [goodsList addObject:detailVo];
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
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:8];
    [param setValue:self.adjustCode forKey:@"adjustCode"];
    [param setValue:[NSNumber numberWithShort:1] forKey:@"opType"];
    [param setValue:[NSNumber numberWithShort:0] forKey:@"modifyStatusOnly"];
    [param setValue:[NSNumber numberWithLong:self.lastVer] forKey:@"lastver"];
    [param setValue:[NSNumber numberWithLongLong:self.adjustTime] forKey:@"adjustTime"];
    [param setValue:self.memo forKey:@"memo"];
    [param setValue:[StockAdjustDetailVo converArrToDicArr:[self obtainGoodsList]] forKey:@"stockAdjustDetailList"];
    [param setValue:self.token forKey:@"token"];
    [param setValue:nil forKey:@"shopOrOrgId"];
    [param setValue:self.shopType forKey:@"shopType"];
    NSString *url = @"stockAdjust/saveStockAdjustDetail";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        weakSelf.token = nil;
        weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
        if (weakSelf.isContinue) {
            weakSelf.searchBar.keyWordTxt.text = @"";
            weakSelf.isChange = NO;
            [weakSelf changeNavUI];
            [weakSelf.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }else{
            weakSelf.isChange = NO;
            [weakSelf changeNavUI];
            weakSelf.editHandler();
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}


@end
