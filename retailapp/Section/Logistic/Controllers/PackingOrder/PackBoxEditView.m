//
//  PackBoxEditView.m
//  retailapp
//
//  Created by hm on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PackBoxEditView.h"
#import "LogisticModuleEvent.h"
#import "ServiceFactory.h"
#import "LSEditItemTitle.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "TimePickerBox.h"
#import "ShoesClothingCell.h"
#import "AlertBox.h"
#import "PackGoodsVo.h"
#import "PaperDetailVo.h"
#import "ExportView.h"
#import "CloShoesEditView.h"

@interface PackBoxEditView ()<IEditItemListEvent,DatePickerClient,TimePickerClient>

@property (nonatomic,strong ) LogisticService * logisticService;
//版本号
@property (nonatomic,assign ) long            lastVer;

@property (nonatomic,assign ) NSInteger       action;

@property (nonatomic,assign ) short           status;

@property (nonatomic, strong) NSMutableArray  *styleList;

@property (nonatomic, strong) NSMutableArray  *delStyleList;

@property (nonatomic, copy  ) NSString        *packGoodsId;

@property (nonatomic, copy  ) NSString        *boxCode;

/**页面是否可编辑*/
@property (nonatomic, assign) BOOL            isEdit;
/**基本信息是否折叠*/
@property (nonatomic, assign) BOOL            isFold;
/**回调block*/
@property (nonatomic, copy  ) PackBoxHandler  boxHandler;

@property (nonatomic, strong) PaperDetailVo   * detailVo;

/**是否第一次添加*/
@property (nonatomic, assign) BOOL            isFirstAdd;
/**是否添加标识*/
@property (nonatomic, assign) NSInteger       flg;
/**门店id*/
@property (nonatomic,copy   ) NSString        * shopId;
/**唯一性*/
@property (nonatomic,copy   ) NSString        * token;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintExportView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintDelView;
@end

@implementation PackBoxEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    self.mainGrid.frame = CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH);
    [self initNavigate];
    [self configHeaderView];
    [self initMainView];
    self.styleList = [NSMutableArray array];
    self.delStyleList = [NSMutableArray array];
    self.mainGrid.tableHeaderView = self.headerView;
    self.mainGrid.tableFooterView = self.footerView;
    [self showPackEditView];
}

- (void)configHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [self.headerView addSubview:self.baseTitle];
    
    self.txtPaperNo = [LSEditItemText editItemText];
    [self.headerView addSubview:self.txtPaperNo];
    
    self.txtBoxNo = [LSEditItemText editItemText];
    [self.headerView addSubview:self.txtBoxNo];
    
    self.lsDate = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsDate];
    
    self.lsTime = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsTime];
    
    self.txtMemo = [LSEditItemText editItemText];
    [self.headerView addSubview:self.txtMemo];
    
    [LSViewFactor addClearView:self.headerView y:0 h:20];
    
    self.goodsTitle = [LSEditItemTitle editItemTitle];
    [self.headerView addSubview:self.goodsTitle];
    
    
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

//页面返回及编辑保存
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        if (!self.isFirstAdd&&self.flg==ACTION_CONSTANTS_ADD) {
            self.boxHandler(0,ACTION_CONSTANTS_ADD);
        }
        [XHAnimalUtil animalEdit:self.navigationController action:self.action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if (self.isFirstAdd) {
            if (![self isValide]) {
                return;
            }
            [self saveForGoods:ACTION_CONSTANTS_EDIT];
        }else{
            [self save];
        }
    }
}
#pragma mark - 初始化主视图
- (void)initMainView
{
    __weak typeof(self) wself = self;
    [self.baseTitle configTitle:@"基本信息" type:LSEditItemTitleTypeOpen rightClick:^(LSEditItemTitle *view) {
        [wself expandBaseInfo];
    }];
    [self.txtPaperNo initLabel:@"装箱单号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtMemo.txtVal.enabled = NO;
    self.txtMemo.txtVal.textColor = [ColorHelper getTipColor6];
    [self.txtBoxNo initLabel:@"箱号" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtBoxNo initMaxNum:10];
    [self.lsDate initLabel:@"装箱日期" withHit:nil delegate:self];
    [self.lsTime initLabel:@"装箱时间" withHit:nil delegate:self];
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    
    [self.goodsTitle configTitle:@"装箱商品" type:LSEditItemTitleTypeDown rightClick:^(LSEditItemTitle *view) {
        float cHeight = self.mainGrid.contentSize.height;
        float mHeight = self.mainGrid.bounds.size.height;
        if (cHeight>mHeight) {
            [wself.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
        }
    }];
    self.lsDate.tag = DATE;
    self.lsTime.tag = TIME;
}

#pragma mark - 设置UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.headerView event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification *)notification
{
    [self editTitle:[UIHelper currChange:self.headerView] act:self.action];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置参数
- (void)loadDataById:(NSString *)paperId withAction:(NSInteger)action withEdit:(BOOL)isEidt callBack:(PackBoxHandler)handler
{
    self.packGoodsId = paperId;
    self.action = action;
    self.isEdit = isEidt;
    self.boxHandler = handler;
}

#pragma mark - 显示页面
- (void)showPackEditView
{
    [self registerNotification];
    [self showHeaderView:self.action isEdit:self.isEdit];
    [self showFooterView:self.action isEdit:self.isEdit];
    [self expandBaseInfo];
    if ([[Platform Instance] getShopMode]==3) {
        self.shopId = [[Platform Instance] getkey:ORG_ID];
    }else{
        self.shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.flg = ACTION_CONSTANTS_ADD;
        self.isFirstAdd = YES;
//        self.titleBox.lblTitle.text = @"添加";
        [self configTitle:@"添加装箱单"];
        [self clearDo];
    }else{
        self.flg = ACTION_CONSTANTS_EDIT;
        [self selectPackBoxDetailById:self.packGoodsId];
    }
    
}

#pragma mark - 显示页面项(是否可编辑)
- (void)showHeaderView:(NSInteger)action isEdit:(BOOL)isEdit
{
    [self.txtPaperNo visibal:(ACTION_CONSTANTS_EDIT==action)];
    [self.txtPaperNo editEnabled:NO];
    [self.txtBoxNo editEnabled:isEdit];
    [self.lsDate editEnable:isEdit];
    [self.lsTime editEnable:isEdit];
    [self.txtMemo editEnabled:isEdit];
}

- (void)showFooterView:(NSInteger)action isEdit:(BOOL)isEdit
{
    self.addView.hidden = !isEdit;
    self.exportView.hidden = !(self.styleList.count>0);
    self.delView.hidden = !(self.status==1);
    self.sumView.hidden = !(self.styleList.count>0);
    
    self.heightConstraintAddView.constant = self.addView.hidden ? 0 : 64;
    self.heightConstraintExportView.constant = self.exportView.hidden ? 0 : 64;
    self.heightConstraintDelView.constant = self.delView.hidden ? 0 : 64;
    [self.footerView layoutIfNeeded];
    [UIHelper refreshUI:self.footerView];
    self.mainGrid.tableFooterView = self.footerView;
}


#pragma mark - 添加
- (void)clearDo
{
    NSDate* date = [NSDate date];
    NSString* dateStr = [DateUtils formateDate2:date];
    NSString* timeStr = [DateUtils formateChineseTime:date];
    [self.txtBoxNo initData:nil];
    [self.lsDate initData:dateStr withVal:dateStr];
    [self.lsTime initData:timeStr withVal:timeStr];
    [self.txtMemo initData:nil];
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
    [UIHelper refreshUI:self.footerView];
    self.mainGrid.tableFooterView = self.footerView;
    [self.mainGrid reloadData];
}

#pragma mark - 详情查看编辑
- (void)selectPackBoxDetailById:(NSString *)paperId
{
    __weak typeof(self) weakSelf = self;
    [self.logisticService selectPackBoxDetailById:paperId completionHandler:^(id json) {
        weakSelf.status = [[json objectForKey:@"billStatus"] shortValue];
        [weakSelf configTitle:[json objectForKey:@"packCode"]];
        [weakSelf.txtPaperNo initData:[json objectForKey:@"packCode"]];
        [weakSelf.txtBoxNo initData:[json objectForKey:@"boxCode"]];
        [weakSelf.lsDate initData:[json objectForKey:@"packDate"] withVal:[json objectForKey:@"packDate"]];
        NSString* dateTime = [DateUtils formateTime:[[json objectForKey:@"packTime"] longLongValue]];
        NSString* date = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString* time = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:1];
        [weakSelf.lsDate initData:date withVal:date];
        [weakSelf.lsTime initData:time withVal:time];
        [weakSelf.txtMemo initData:[json objectForKey:@"memo"]];
        weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
        weakSelf.styleList = [PaperDetailVo converToArr:[json objectForKey:@"packGoodsDetailList"] paperType:PACK_BOX_PAPER_TYPE];
        [weakSelf showHeaderView:weakSelf.action isEdit:weakSelf.isEdit];
        [weakSelf showFooterView:weakSelf.action isEdit:weakSelf.isEdit];
        [weakSelf caculateAmount];
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}


#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    NSDate* date = nil;
    if (obj.tag==DATE) {
        date = [DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else{
        date=[DateUtils parseDateTime6:[obj getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formateDate2:date];
    
    [self.lsDate changeData:dateStr withVal:dateStr];
    
    return YES;
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    NSString* timeStr=[DateUtils formateChineseTime:date];
    
    [self.lsTime changeData:timeStr withVal:timeStr];
    
    return YES;
}

- (void)expandBaseInfo
{
    [self.txtPaperNo visibal:(_action==ACTION_CONSTANTS_EDIT)&&!_isFold];
    [self.txtBoxNo visibal:!_isFold];
    [self.lsDate visibal:!_isFold];
    [self.lsTime visibal:!_isFold];
    [self.txtMemo visibal:!_isFold];
    _isFold= !_isFold;
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
}

//移动到页面底部
- (void)onTitleMoveToBottomClick:(NSInteger)event
{
    float cHeight = self.mainGrid.contentSize.height;
    float mHeight = self.mainGrid.bounds.size.height;
    if (cHeight>mHeight) {
        [self.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
    }
}

#pragma mark - 计算合计
- (void)caculateAmount
{
    NSInteger num = self.styleList.count;
    double amount = 0.00;
    double sum = 0.00;
    for (PaperDetailVo* detailVo in self.styleList) {
        amount+=detailVo.goodsTotalPrice;
        sum+=detailVo.goodsSum;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"合计 "];
    NSString* str = [NSString stringWithFormat:@"%ld 项, ",(long)num];
    NSMutableAttributedString *amoutAttr = [[NSMutableAttributedString alloc] initWithString:str];
    [amoutAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,str.length-4)];
    [attrString appendAttributedString:amoutAttr];
    
    NSString *sumStr = [NSString stringWithFormat:@"%.0f 件 ",sum];
    NSMutableAttributedString *sumAttr = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [sumAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,sumStr.length-3)];
    [attrString appendAttributedString:sumAttr];
    
    NSString* priceStr = [NSString stringWithFormat:@"¥%.2f ",amount];
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,priceStr.length-1)];
    
    [priceAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:16.0] range:NSMakeRange(1, priceStr.length-1)];
    [attrString appendAttributedString:priceAttr];
    _lblAmount.attributedText = attrString;
    amoutAttr = nil;
    sumAttr = nil;
    priceAttr = nil;
    attrString = nil;
}



#pragma mark - UITableview 商品列表
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.styleList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* shoesClothingCellId = @"ShoesClothingCell";
    ShoesClothingCell* cell = [tableView dequeueReusableCellWithIdentifier:shoesClothingCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ShoesClothingCell" bundle:nil] forCellReuseIdentifier:shoesClothingCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:shoesClothingCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoesClothingCell* detailItem = (ShoesClothingCell*) cell;
    if (self.styleList.count>0) {
        self.detailVo = [self.styleList objectAtIndex:indexPath.row];
        detailItem.lblName.text = self.detailVo.goodsName;
        detailItem.lblStyleCount.text = [NSString stringWithFormat:@"x%.0f",self.detailVo.goodsSum];
        detailItem.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@",self.detailVo.styleCode];
        detailItem.lblTotalMoney.text = [NSString stringWithFormat:@"￥%.2f",self.detailVo.goodsTotalPrice];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.detailVo = [self.styleList objectAtIndex:indexPath.row];
    [self showSelectCloShoesView:ACTION_CONSTANTS_EDIT];
}

#pragma mark - 添加、导出、删除事件处理
- (IBAction)onTypeEventClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag==100) {
    //添加
        if (![self isValide]) {
            return;
        }
        if (self.isFirstAdd) {
            [self saveForGoods:ACTION_CONSTANTS_ADD];
        }else{
            [self showSelectCloShoesView:ACTION_CONSTANTS_ADD];
        }
        
    }else if (button.tag==101) {
    //导出
        ExportView *exportView = [[ExportView alloc] init];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[NSMutableArray arrayWithObjects:self.packGoodsId, nil] forKey:@"packGoodsIdList"];
        __weak typeof(self) weakSelf = self;
        [exportView loadData:param withPath:@"packGoods/exportExcel" withIsPush:YES callBack:^{
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:exportView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        exportView = nil;
    }else{
    //删除
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除装箱单[%@]吗?",[self.txtBoxNo getStrVal]]];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self operatePackBox:@"del" message:@"正在删除..."];
    }
}

#pragma mark - 第一次添加保存
- (void)saveForGoods:(NSInteger)type
{
    NSMutableDictionary *param = [self obtainParams];
    [param setValue:@"firstadd" forKey:@"operateType"];
    __weak typeof(self) weakSelf = self;
    [self.logisticService operatePackBoxDetailById:param withMessage:@"正在保存..." completionHandler:^(id json) {
        weakSelf.token = nil;
        weakSelf.isFirstAdd = NO;
        if (type==ACTION_CONSTANTS_ADD) {
            [weakSelf addClothShoesStyle:json];
        }else{
            [weakSelf removeNotification];
            weakSelf.boxHandler(0,ACTION_CONSTANTS_ADD);
            [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)addClothShoesStyle:(id)json
{
    self.action = ACTION_CONSTANTS_EDIT;
    self.lastVer = [[json objectForKey:@"lastVer"] longValue];
    self.packGoodsId = [json objectForKey:@"packGoodsId"];
    [self configTitle:[json objectForKey:@"packGoodsNo"]];
    [self.txtPaperNo visibal:YES];
    [self.txtPaperNo initData:[json objectForKey:@"packGoodsNo"]];
    [UIHelper clearChange:self.headerView];
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
    [self showSelectCloShoesView:ACTION_CONSTANTS_ADD];
}

#pragma mark - 添加|编辑款式商品
- (void)showSelectCloShoesView:(NSInteger)action
{
    if (self.styleList.count==200) {
        [AlertBox show:@"最多只能添加200款!"];
        return ;
    }
    CloShoesEditView *editView = [[CloShoesEditView alloc] init];
    editView.shopId = self.shopId;
    __weak typeof(self) weakSelf = self;
    [editView loadDataWithCode:self.detailVo.styleCode withParam:[self obtainParams] withSourceId:self.packGoodsId withAction:action withType:PACK_BOX_PAPER_TYPE withEdit:self.isEdit callBack:^{
        [weakSelf selectPackBoxDetailById:weakSelf.packGoodsId];
    }];
    [self.navigationController pushViewController:editView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    editView = nil;
}

#pragma mark - 验证
- (BOOL)isValide
{
    if ([NSString isBlank:[self.txtBoxNo getStrVal]]) {
        [AlertBox show:@"请输入箱号!"];
        return NO;
    }

    return YES;
}
#pragma mark - 保存
- (void)save
{
    if (![self isValide]) {
        return;
    }
    if (self.isFirstAdd) {
        [self operatePackBox:@"add" message:@"正在保存..."];
    }else{
        [self operatePackBox:@"edit" message:@"正在保存..."];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}
//获取操作单据参数map
- (NSMutableDictionary *)obtainParams
{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    [param setValue:self.token forKey:@"token"];
    
    [param setValue:[self.txtBoxNo getStrVal] forKey:@"boxCode"];
    
    [param setValue:self.packGoodsId forKey:@"packGoodsId"];
    
    NSString* dateTime = [NSString stringWithFormat:@"%@ %@",[self.lsDate getStrVal],[self.lsTime getStrVal]];
    
    [param setValue:[NSNumber numberWithLongLong:[DateUtils formateDateTime4:dateTime]] forKey:@"packTime"];
    
    if ([NSString isNotBlank:[self.txtMemo getStrVal]]) {
        [param setValue:[self.txtMemo getStrVal] forKey:@"memo"];
    }
    [param setValue:[NSNumber numberWithLong:self.lastVer] forKey:@"lastVer"];

    return param;
}
//更新单据信息
- (void)operatePackBox:(NSString *)operateType message:(NSString *)message
{
    NSMutableDictionary *param = [self obtainParams];
    [param setValue:[PaperDetailVo converToDicArr:self.styleList paperType:PACK_BOX_PAPER_TYPE ] forKey:@"packGoodsDetailList"];
    [param setValue:operateType forKey:@"operateType"];
    __weak typeof(self) weakSelf = self;
    [self.logisticService operatePackBoxDetailById:param withMessage:message completionHandler:^(id json) {
        [weakSelf removeNotification];
        weakSelf.token = nil;
        if (weakSelf.flg==ACTION_CONSTANTS_ADD) {
            weakSelf.boxHandler(nil,ACTION_CONSTANTS_ADD);
        }else if ([operateType isEqualToString:@"edit"]){
            PackGoodsVo *packGoodsVo = [[PackGoodsVo alloc] init];
            packGoodsVo.packGoodsId = weakSelf.packGoodsId;
            packGoodsVo.boxCode = [param objectForKey:@"boxCode"];
            packGoodsVo.packTimeL = [[param objectForKey:@"packTime"] longLongValue];
            weakSelf.boxHandler(packGoodsVo,ACTION_CONSTANTS_EDIT);
        }else if ([operateType isEqualToString:@"del"]){
            weakSelf.boxHandler(nil,ACTION_CONSTANTS_DEL);
        }
        [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
