//
//  LogisticRecordDetailView.m
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticRecordDetailView.h"
#import "ServiceFactory.h"
#import "RecordHead.h"
#import "RecordDetailCell.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "AlertBox.h"
#import "LogisticsVo.h"
#import "DateUtils.h"
#import "LogisticsDetailVo.h"
#import "CloShoesEditView.h"
#import "UIView+Sizes.h"

@interface LogisticRecordDetailView ()

@property (nonatomic,strong) LogisticService* logisticService;
@property (nonatomic,strong) NSMutableArray* datas;
/**机构为1 ， 供应商0*/
@property (nonatomic,assign) NSInteger supplyIsHeadShop;
/**单据名称*/
@property (nonatomic,copy) NSString* paperName;
/**单价名称*/
@property (nonatomic,copy) NSString* priceName;
/**101服鞋 102商超*/
@property (nonatomic,assign) NSInteger shopMode;
/**调出门店*/
@property (nonatomic,copy) NSString* outShopName;
/**调入门店*/
@property (nonatomic,copy) NSString* inShopName;
/**是否是第三方供应商*/
@property (nonatomic,assign) BOOL isThirdSupply;
/**单据类型*/
@property (nonatomic,assign) NSInteger paperType;
/**单据的shopid*/
@property (nonatomic,copy) NSString* shopId;
/**是否是进货价 零售价/吊牌价*/
@property (nonatomic,assign) BOOL isPurchasePrice;
/**是否有发货仓库*/
@property (nonatomic,assign) BOOL hasOut;
/**是否有收货仓库*/
@property (nonatomic,assign) BOOL hasIn;
//是否可以查看进货价
@property (nonatomic, assign) BOOL isShowPrice;
@end

@implementation LogisticRecordDetailView



- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    self.mainGrid.frame = CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH);
    [self initNavigate];
    self.datas = [NSMutableArray array];
    //查看
    self.isShowPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    _shopMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue];
    [self addHeaderView];
    [self selectLogisticRecordDetail];
}


//初始化导航
- (void)initNavigate
{
    [self configTitle:@"出入库记录" leftPath:Head_ICON_BACK rightPath:nil];
}


//查询物流记录详情
- (void)selectLogisticRecordDetail
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectLogisticRecordDetail:self.logisticsVo.logisticsId recordType:self.logisticsVo.recordType completionHandler:^(id json) {
        weakSelf.shopId = [json objectForKey:@"shopId"];
        weakSelf.datas = [LogisticsDetailVo converToArr:[json objectForKey:@"logisticsDetailList"]];
        weakSelf.outShopName = [json objectForKey:@"outShopName"];
        weakSelf.inShopName = [json objectForKey:@"inShopName"];
        weakSelf.supplyIsHeadShop = [[json objectForKey:@"supplyIsHeadShop"] integerValue];
        weakSelf.paperName = [json objectForKey:@"typeName"];
        weakSelf.isThirdSupply = [[json objectForKey:@"thirdSupplier"] isEqualToString:@"1"];
        weakSelf.hasOut = [NSString isNotBlank:[json objectForKey:@"outWarehouseName"]];
        weakSelf.hasIn = [NSString isNotBlank:[json objectForKey:@"inWarehouseName"]];
        [weakSelf showWarehouse:[json objectForKey:@"inWarehouseName"] withOutWarehouseName:[json objectForKey:@"outWarehouseName"]];
        NSString *loginShopId = [[Platform Instance] getkey:SHOP_ID];
        weakSelf.isPurchasePrice = weakSelf.isThirdSupply || ![loginShopId isEqualToString:weakSelf.shopId];
        if (weakSelf.shopMode==CLOTHESHOES_MODE) {
            //服鞋版
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"c"]) {
                //叫货单
                weakSelf.paperType = ORDER_PAPER_TYPE;
                weakSelf.priceName = weakSelf.isShowPrice?@"采购价(元)":@"吊牌价(元)";
            }
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"p"]){
                //收货单
                weakSelf.priceName = weakSelf.isShowPrice?@"进货价(元)":@"吊牌价(元)";
                weakSelf.paperType = PURCHASE_PAPER_TYPE;
            }
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"a"]) {
                //调拨单
                weakSelf.paperType = ALLOCATE_PAPER_TYPE;
                weakSelf.priceName = @"吊牌价(元)";
                NSString* outShopName = weakSelf.outShopName.length>5?[weakSelf.outShopName substringToIndex:6]:weakSelf.outShopName;
                weakSelf.lblSupplier.text = [NSString stringWithFormat:@"(%@-%@)",outShopName,weakSelf.inShopName];
            }
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"r"]){
                //退货单
                weakSelf.priceName = weakSelf.isShowPrice?@"退货价(元)":@"吊牌价(元)";
                weakSelf.paperType = RETURN_PAPER_TYPE;
            }
            
        }else{
            //商超版
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"c"]) {
                //叫货单
                weakSelf.priceName = weakSelf.isShowPrice?@"采购价(元)":@"零售价(元)";
            }
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"a"]) {
                //调拨单
                weakSelf.priceName = @"零售价(元)";
                
                NSString* outShopName = weakSelf.outShopName.length>5?[weakSelf.outShopName substringToIndex:6]:weakSelf.outShopName;
                
                weakSelf.lblSupplier.text = [NSString stringWithFormat:@"(%@-%@)",outShopName,weakSelf.inShopName];
            }
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"p"]) {
                //进货单
                weakSelf.priceName = weakSelf.isShowPrice?@"进货价(元)":@"零售价(元)";
            }
            if ([weakSelf.logisticsVo.recordType isEqualToString:@"r"]) {
                //退货单
                weakSelf.priceName = weakSelf.isShowPrice?@"退货价(元)":@"零售价(元)";
            }
        }
        [weakSelf.mainGrid reloadData];
        [weakSelf caculateAmount];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

//详情头部显示内容
- (void)addHeaderView
{
    self.lblPaperName.text = self.logisticsVo.typeName;
    self.lblSupplier.text = [NSString stringWithFormat:@"(%@)",self.logisticsVo.supplyName];
    self.lblNo.text = self.logisticsVo.logisticsNo;
    self.lblNo.textColor = [ColorHelper getBlueColor];
    self.lblDate.text = [DateUtils formateTime:self.logisticsVo.sendEndTime];
    self.lblDate.textColor = [ColorHelper getBlueColor];
    self.mainGrid.tableHeaderView = self.headerView;
    self.mainGrid.tableFooterView = self.footerView;
}

#pragma mark - 显示收货仓库 发货仓库
- (void)showWarehouse:(NSString *)inWarehouseName withOutWarehouseName:(NSString *)outWarehouseName
{
    NSString *name = nil;
    NSDictionary *attribute = @{NSFontAttributeName: self.lblDeliveWarehouse.font};
    if (self.hasOut) {
        //发货仓库
        name = [NSString stringWithFormat:@"发货仓库：%@",outWarehouseName];
        NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:name];
        [nameAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getBlueColor] range:NSMakeRange(5,name.length-5)];
        self.lblDeliveWarehouse.attributedText = nameAttr;
        nameAttr = nil;
    }
    
    if (self.hasIn) {
        //收货仓库
        name = [NSString stringWithFormat:@"收货仓库：%@",inWarehouseName];
        NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:name];
        [nameAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getBlueColor] range:NSMakeRange(5,name.length-5)];
        self.lblReceiveWarehouse.attributedText = nameAttr;
        nameAttr = nil;
    }
    if (self.hasOut&&!self.hasIn) {
        CGRect rect =  [name boundingRectWithSize:CGSizeMake(320, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        [self.lblDeliveWarehouse setLs_width:rect.size.width];
    }
    if (self.hasIn&&!self.hasOut) {
        CGRect rect =  [name boundingRectWithSize:CGSizeMake(320, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        [self.lblReceiveWarehouse setLs_left:10];
        [self.lblReceiveWarehouse setLs_width:rect.size.width];
    }
    if (self.hasIn&&self.hasOut) {
        CGRect rect =  [name boundingRectWithSize:CGSizeMake(320, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        [self.lblReceiveWarehouse setLs_left:160];
        [self.lblReceiveWarehouse setLs_width:150];
        self.lblReceiveWarehouse.textAlignment = rect.size.width>150?NSTextAlignmentLeft:NSTextAlignmentRight;
    }
    self.warehouseView.hidden = !(self.hasIn||self.hasOut);
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
}

#pragma mark - 计算合计
- (void)caculateAmount
{
    double totalCount = 0;
    double totalMoney = 0;
    BOOL isHasSC = NO;//是否是散称
    for (LogisticsDetailVo *vo in self.datas) {
        totalCount += vo.goodsSum;
        totalMoney +=(self.isShowPrice ?vo.goodsTotalPrice :([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? vo.goodsHangTagTotalPrice : vo.goodsRetailTotalPrice) );
        if (vo.goodsType == 4) {
            isHasSC = YES;
        }
//        if (self.shopMode == CLOTHESHOES_MODE) {
//            totalMoney += vo.goodsTotalPrice;
//        }else{
//            totalMoney +=(self.isPurchasePrice?vo.goodsSum*vo.goodsPrice:vo.goodsSum*vo.retailPrice);
//        }
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"合计 "];
    NSString *str = isHasSC ? [NSString stringWithFormat:@"%.3f 件",totalCount] : [NSString stringWithFormat:@"%.f 件",totalCount];
    NSMutableAttributedString* amountStr = [[NSMutableAttributedString alloc] initWithString:str];
    [amountStr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0, str.length-2)];
    [amountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str.length-2)];
    [attrString appendAttributedString:amountStr];
    
    self.lblTotalCount.attributedText = attrString;
    
    NSString* priceStr = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    
    NSMutableAttributedString* priceAttr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0, priceStr.length)];
    [priceAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, priceStr.length)];
    self.lbltotalPrice.attributedText = priceAttr;
    attrString = nil;
    amountStr = nil;
    priceAttr = nil;
}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* recordHeadId = @"RecordHead";
    RecordHead* headItem = [tableView dequeueReusableCellWithIdentifier:recordHeadId];
    if (!headItem) {
        [tableView registerNib:[UINib nibWithNibName:@"RecordHead" bundle:nil] forCellReuseIdentifier:recordHeadId];
        headItem =  [tableView dequeueReusableCellWithIdentifier:recordHeadId];
    }
    headItem.lblPrice.text = self.priceName;
    return headItem;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* recordDetailCellId = @"RecordDetailCell";
    RecordDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:recordDetailCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"RecordDetailCell" bundle:nil] forCellReuseIdentifier:recordDetailCellId];
        cell =  [tableView dequeueReusableCellWithIdentifier:recordDetailCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordDetailCell* detailItem = (RecordDetailCell*)cell;
    if (self.datas.count>0) {
        LogisticsDetailVo* vo = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = vo.goodsName;
        detailItem.lblCode.text = (_shopMode==102)?[NSString stringWithFormat:@"%@",vo.goodsBarcode]:[NSString stringWithFormat:@"款号：%@",vo.styleCode];
        detailItem.lblCount.text = (vo.type==4)?[NSString stringWithFormat:@"%.3f",vo.goodsSum]:[NSString stringWithFormat:@"%.0f",vo.goodsSum];
        if (_shopMode==CLOTHESHOES_MODE) {
            detailItem.lblPrice.text = self.isShowPrice?[NSString stringWithFormat:@"￥%.2f",vo.goodsPrice]:[NSString stringWithFormat:@"￥%.2f",vo.hangTagPrice];
        }else{
            detailItem.lblPrice.text = self.isShowPrice?[NSString stringWithFormat:@"￥%.2f",vo.goodsPrice]:[NSString stringWithFormat:@"￥%.2f",vo.retailPrice];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_shopMode==CLOTHESHOES_MODE) {
        //服鞋版可以查看款式详情
        LogisticsDetailVo *detailVo = [self.datas objectAtIndex:indexPath.row];
        CloShoesEditView* editView = [[CloShoesEditView alloc] init];
        editView.shopId = self.shopId;
        editView.recordType = self.logisticsVo.recordType;
        editView.isThirdSupply = self.isThirdSupply;
        if (self.isPurchasePrice) {
            editView.goodsPrice = detailVo.goodsPrice;
        }
        [editView loadDataWithCode:detailVo.styleCode withParam:nil withSourceId:self.logisticsVo.logisticsId withAction:ACTION_CONSTANTS_EDIT withType:self.paperType withEdit:NO callBack:^{
        }];
        [self.navigationController pushViewController:editView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}


@end
