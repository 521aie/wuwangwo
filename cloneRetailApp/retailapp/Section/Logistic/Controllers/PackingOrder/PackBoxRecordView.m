//
//  PackBoxRecordView.m
//  retailapp
//
//  Created by hm on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PackBoxRecordView.h"
#import "ServiceFactory.h"
#import "StyleItem.h"
#import "PackBoxRecordCell.h"
#import "XHAnimalUtil.h"
#import "GoodsPackRecordVo.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "SymbolNumberInputBox.h"
#import "NumberUtil.h"
@interface PackBoxRecordView ()<PackBoxRecordCellDelegate,SymbolNumberInputClient,StyleItemDelegate>

@property (nonatomic, strong) LogisticService *logisticService;
/**展示款式信息项*/
@property (nonatomic, strong) StyleItem *styleItem;
/**商品数据列表*/
@property (nonatomic, strong) NSMutableArray *goodsList;
/**删除的商品数据列表*/
@property (nonatomic, strong) NSMutableArray *delGoodsList;
/**页面回调block*/
@property (nonatomic, copy) CheckRecordHandler checkHandler;
/**页面是否可编辑*/
@property (nonatomic, assign) BOOL isEdit;
/**款式id*/
@property (nonatomic, copy) NSString *styleId;
/**退货单id*/
@property (nonatomic, copy) NSString *returnGoodsId;
/**装箱记录VO*/
@property (nonatomic, strong) GoodsPackRecordVo *recordVo;
/**是否修改过价格*/
@property (nonatomic, assign) BOOL isPriceChange;
/**输入的价格*/
@property (nonatomic, assign) double newPrice;
/**唯一性*/
@property (nonatomic, copy) NSString *token;
@end

@implementation PackBoxRecordView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self selectPackRecord];
}
- (void)configViews {
    CGFloat y = kNavH;
    self.styleView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, 88)];
    self.styleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.styleView];
    
    y = self.styleView.ls_bottom;
    
    [LSViewFactor addClearView:self.view y:y h:20];
    
    y = y + 20;
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.mainGrid];

}
- (void)loadDataWithEdit:(BOOL)isEdit withStyleId:(NSString *)styleId withReturnId:(NSString *)returnId callBack:(CheckRecordHandler)handler
{
    self.isEdit = isEdit;
    self.styleId = styleId;
    self.returnGoodsId = returnId;
    self.checkHandler = handler;
    self.newPrice = self.price;
    self.goodsList = [NSMutableArray array];
    self.delGoodsList = [NSMutableArray array];
}
#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"装箱记录" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    
    }else{
        [self save];
    }
}
#pragma mark - 初始化主视图
- (void)initMainView
{
    self.styleItem = [StyleItem loadFromNib];
    [self.styleView addSubview:self.styleItem];
    self.styleItem.styleItemDelegate = self;
    self.styleItem.lblName.text = self.styleName;
    self.styleItem.lblStyleCode.text = [NSString stringWithFormat:@"款号：%@",self.styleCode];
    [self.styleItem changeUIWithPriceName:self.priceName withPrice:[NSString stringWithFormat:@"￥%.2f",self.price] isEdit:(self.changePrice&&self.isEdit)];
    [self.styleItem.pic sd_setImageWithURL:[NSURL URLWithString:self.filePath] placeholderImage:[UIImage imageNamed:@"img_default.png"]];
}

#pragma mark - 查看装箱记录
- (void)selectPackRecord
{
    __weak typeof(self) weakSelf = self;
    [self.logisticService selectPackGoodsRecordById:self.styleId withReturnId:self.returnGoodsId withMessage:@"" completionHandler:^(id json) {
        weakSelf.goodsList = [GoodsPackRecordVo converToArr:[json objectForKey:@"goodsPackRecordList"]];
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

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
    self.newPrice = [val doubleValue];
    [self.styleItem initStretchWidth:[NSString stringWithFormat:@"￥%.2f",self.newPrice]];
    [self changeNavigateUI];
}

#pragma mark - 编辑后显示保存按钮
- (void)changeNavigateUI
{
    __block BOOL flag =NO;
    [self.goodsList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GoodsPackRecordVo* vo = (GoodsPackRecordVo*)obj;
        if (vo.changeFlag==1) {
            flag = YES;
            *stop = YES;
        }
    }];
    self.isPriceChange = self.changePrice?[NumberUtil isNotEqualNum:self.newPrice num2:self.price]:NO;
    [self editTitle:flag||self.delGoodsList.count>0||self.isPriceChange act:ACTION_CONSTANTS_EDIT];
}
#pragma mark - 删除
- (void)delObj:(NSString *)itemId
{
    for (GoodsPackRecordVo *vo  in self.goodsList) {
        if ([itemId isEqualToString:vo.returnGoodsDetailId]) {
            self.recordVo = vo;
        }
    }
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@ %@]吗？",self.recordVo.goodsColor,self.recordVo.goodsSize]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        self.recordVo.operateType = @"del";
        [self.delGoodsList addObject:self.recordVo];
        [self.goodsList removeObject:self.recordVo];
        [self.mainGrid reloadData];
    }
}

#pragma mark - UITableview 商品列表
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* packBoxRecordCellId = @"PackBoxRecordCell";
    PackBoxRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:packBoxRecordCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PackBoxRecordCell" bundle:nil] forCellReuseIdentifier:packBoxRecordCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:packBoxRecordCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackBoxRecordCell* detailItem = (PackBoxRecordCell*) cell;
    if (self.goodsList.count > 0) {
        self.recordVo = [self.goodsList objectAtIndex:indexPath.row];
        detailItem.lblName.text = [NSString stringWithFormat:@"%@ %@",self.recordVo.goodsColor,self.recordVo.goodsSize];
        detailItem.lblVal.text = [NSString stringWithFormat:@"箱号:%@",self.recordVo.boxCode];
        detailItem.delegate = self;
        [detailItem loadDataWithItem:self.recordVo isEdit:self.isEdit];
    }
}

#pragma mark - 提交商品列表
- (NSMutableArray *)obtainDataList
{
    NSMutableArray * datas = [NSMutableArray array];
    if (self.goodsList.count > 0) {
        if (self.changePrice) {
            for (GoodsPackRecordVo *vo  in self.goodsList) {
                vo.operateType = self.isPriceChange?@"edit":vo.operateType;
                if (self.isPriceChange) {
                    vo.goodsPrice = [NSNumber numberWithDouble:self.newPrice];
                }
            }
        }
        [datas addObjectsFromArray:self.goodsList];
    }
    if (self.delGoodsList.count > 0) {
        [datas addObjectsFromArray:self.delGoodsList];
    }

    return datas;
}

#pragma mark - 保存数据
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}
- (void)save
{
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    __weak typeof(self) weakSelf = self;
    [self.logisticService editPackGoods:[GoodsPackRecordVo converToDicArr:[self obtainDataList]]  withStyleId:self.styleId withReturnId:self.returnGoodsId withToken:self.token withMessage:@"正在保存..." completionHandler:^(id json) {
        weakSelf.token = nil;
        weakSelf.checkHandler();
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


@end
