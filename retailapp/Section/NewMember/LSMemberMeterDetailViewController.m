//
//  LSMemberMeterDetailViewController.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#define METER_TXT_NAME 1
#define METER_TXT_PRICE 2
#define METER_LIST_PERIOD 3
#define METER_RDO_IS_RETURN 4
#define METER_VEW_IS_RETURN 5
#define METER_CELL_CONCUMETIME 6

#import "LSMemberMeterDetailViewController.h"
#import "ServiceFactory.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "SymbolNumberInputBox.h"
#import "LSEditItemRadio.h"
#import "LSEditItemTitle.h"
#import "LSEditItemMemo.h"
#import "MemoInputView.h"
#import "ItemTitle.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "AlertBox.h"
#import "SearchView.h"
#import "MobClick.h"
#import "DateUtils.h"

#import "LSMemberMeterViewController.h"
#import "LSMemberMeterVo.h"
#import "LSMemberMeterGoodsVo.h"
#import "LSMemberMeterDetailCell.h"
#import "LSMeterAdjustStyleCell.h"

#import "GoodsBatchChoiceView1.h"
#import "GoodsVo.h"

@interface LSMemberMeterDetailViewController ()<IEditItemListEvent,SymbolNumberInputClient,IEditItemRadioEvent,IItemTitleEvent,IEditItemMemoEvent,MemoInputClient,UITableViewDelegate,UITableViewDataSource,LSMemberMeterDetailCellDelagate>

/** 编辑状态传值*/
@property (nonatomic,strong) LSMemberMeterVo *obj;
/**区分添加和编辑*/
@property (nonatomic,assign) NSInteger action;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSNumber *currentPage;

/**名称*/
@property (nonatomic, strong) LSEditItemMemo *txtName;
/**销售价格（元）*/
@property (nonatomic, strong) LSEditItemList *txtPrice;
/**有效期（天）*/
@property (nonatomic, strong) LSEditItemList *lstPeriod;
/**可退卡*/
@property (nonatomic,strong) LSEditItemRadio *rdoIsReturn;
@property (nonatomic, strong) LSEditItemList *vewIsReturn;
/**计次商品*/
@property (nonatomic,strong) LSEditItemTitle *meteringView;
/**添加计次商品*/
@property (nonatomic, strong) SearchView *addMeterBtn;
/**计次商品vo*/
@property (nonatomic,strong) LSMemberMeterGoodsVo *meterGoodsVo;
/**已存在的计次商品list*/
@property (nonatomic, strong) NSMutableArray *meterGoodsList;
/**删除商品数据列表*/
@property (nonatomic,strong) NSMutableArray  *delGoodsList;
/**添加*/
@property (nonatomic, strong) NSMutableDictionary *param;

/**手动设置添加计次商品数量 记录cell*/
@property (nonatomic, assign) NSInteger rowNow;
/** 后台判断是否可以添加计次商品*/
//@property (nonatomic,assign) BOOL checkGoodsId;
@end

@implementation LSMemberMeterDetailViewController

- (instancetype)initWith:(LSMemberMeterVo *)memberMeterVo action:(NSInteger)action {
    
    self = [super init];
    if (self) {
        _action = action;
        if (memberMeterVo == nil) {
            _obj = [[LSMemberMeterVo alloc] init];
        } else {
            _obj = memberMeterVo;
        }
        
        _meterGoodsList = [NSMutableArray array];
        _delGoodsList = [NSMutableArray array];
        _param = [[NSMutableDictionary alloc] init];
        _currentPage = nil;
        _rowNow = nil;
//        _checkGoodsId =  NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configViews];
    
    if (self.action == ACTION_CONSTANTS_EDIT) {
        //编辑
        [self configTitle:@"计次服务详情" leftPath:Head_ICON_BACK rightPath:nil];
        [self loadData];
    } else {
        //添加
        [self configTitle:@"添加计次服务" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        [self tableViewRefreshUI];
    }
}

- (void)configViews {
 
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 88.0f;
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.view).offset(64);
        make.left.right.bottom.equalTo(wself.view);
    }];
    
    if (self.action == ACTION_CONSTANTS_EDIT) {
        
        [self.tableView ls_addHeaderWithCallback:^{
            wself.currentPage = nil;
            [wself loadData];
        }];
        
        [self.tableView ls_addFooterWithCallback:^{
            [wself loadData];
        }];
    }
}

- (UIView *)headerView {
  
    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _headerView.ls_width = SCREEN_W;
        
        _txtName = [LSEditItemMemo editItemMemo];
        [_txtName initLabel:@"名称" isrequest:YES delegate:self];
        [_txtName initData:nil];
        [_headerView addSubview:_txtName];
        
        //小数点前6位
        _txtPrice = [LSEditItemList editItemList];
        [_txtPrice initLabel:@"销售价格（元）" withHit:nil isrequest:YES delegate:self];
        [_txtPrice initData:@"" withVal:nil];
        [_headerView addSubview:_txtPrice];
        
        //默认“不限期”，点击弹出数字键盘；删除数字，点击确认后，显示不限期
        _lstPeriod = [LSEditItemList editItemList];
        [_lstPeriod initLabel:@"有效期（天）" withHit:nil delegate:self];
        [_lstPeriod initData:@"不限期" withVal:nil];
        [_headerView addSubview:_lstPeriod];
        
        //默认打开，若开关关闭，则隐藏【充值后几天内可退】
        _rdoIsReturn = [LSEditItemRadio editItemRadio];
        [_rdoIsReturn initLabel:@"可退款" withHit:nil delegate:self];
        [_rdoIsReturn initData:@"1"];
        [_headerView addSubview:_rdoIsReturn];
        
         //默认不限期，点击弹出数字键盘，限制长度999；删除数字，点击确认后，充值后几天内可退显示为“不限期”；0天表示当天的23：59：59前可
        _vewIsReturn = [LSEditItemList editItemList];
        [_vewIsReturn initLabel:@"▪︎ 充值后几天可退" withHit:@"    0天表示仅限当天可退" delegate:self];
        [_vewIsReturn initData:@"不限期" withVal:nil];
        [_headerView addSubview:_vewIsReturn];
        
        _meteringView = [LSEditItemTitle editItemTitle];
        [_meteringView configTitle:@"计次商品"];
        _meteringView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:_meteringView];
        
        // 是否可编辑
        BOOL editAble = _action == ACTION_CONSTANTS_ADD;
        [_rdoIsReturn editable:editAble];
        [_vewIsReturn editEnable:editAble];
        
        _txtName.tag = METER_TXT_NAME;
        _txtPrice.tag = METER_TXT_PRICE;
        _lstPeriod.tag = METER_LIST_PERIOD;
        _rdoIsReturn.tag = METER_RDO_IS_RETURN;
        _vewIsReturn.tag = METER_VEW_IS_RETURN;
    }
    
    return _headerView;
}

- (UIView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [[UIView alloc] init];
        UIView *add = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 88)];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 0, SCREEN_W, 48);
        [addBtn setImage:[UIImage imageNamed:@"ico_add_rr"] forState:UIControlStateNormal];
        [addBtn setImageEdgeInsets:UIEdgeInsetsMake(13,SCREEN_W/2-44,13,SCREEN_W/2+22)];
        [addBtn setTitle:@"添加计次商品" forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(10, 20, SCREEN_W-20, 48-10);
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
        [add addSubview:delBtn];
        
        if (self.action == ACTION_CONSTANTS_EDIT) {
           
            _footerView.backgroundColor = [UIColor clearColor];
            add.backgroundColor = [UIColor clearColor];
            [_footerView addSubview:add];
        } else {
            
            _footerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            [_footerView addSubview:addBtn];
        }
    }
    
    return _footerView;
}

- (void)loadData {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *url = @"accountcard/entityGoodsList";
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_obj.id forKey:@"accountCardId"];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        
        if (weakSelf.currentPage == nil) {
            [weakSelf.meterGoodsList removeAllObjects];
        }
        
        NSArray *list = json[@"goodsList"];
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSMemberMeterGoodsVo mj_objectArrayWithKeyValuesArray:list];
            [weakSelf.meterGoodsList addObjectsFromArray:objs];
        }
        
        [self.txtName initData:self.obj.accountCardName];
        
        [self.txtPrice initData:[NSString stringWithFormat:@"%.2f",self.obj.price.floatValue] withVal:nil];
        
        if (self.obj.expiryDate.integerValue == -1) {
            [self.lstPeriod initData:@"不限期" withVal:nil];
        } else {
            [self.lstPeriod initData:[NSString stringWithFormat:@"%ld",self.obj.expiryDate.integerValue] withVal:nil];
        }
        
        [self.rdoIsReturn initData:[NSString stringWithFormat:@"%ld",(long)self.obj.isReturn.integerValue]];
        
        if (self.obj.returnDays.integerValue == -1) {
            [self.vewIsReturn initData:@"不限期" withVal:nil];
        } else {
            [self.vewIsReturn initData:[NSString stringWithFormat:@"%ld",self.obj.returnDays.integerValue] withVal:nil];
        }
        
        if ([[self.rdoIsReturn getStrVal] isEqualToString:@"1"]) {
            [self.vewIsReturn visibal:YES];
        } else {
            [self.vewIsReturn visibal:NO];
        }
        
        [self.txtName editEnable:NO];
        [self.txtPrice editEnable:NO];
        [self.lstPeriod editEnable:NO];
        [self.rdoIsReturn editable:NO];
        [self.vewIsReturn editEnable:NO];
        
        [self tableViewRefreshUI];
       
    } errorHandler:^(id json) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct{
   
    if (direct == LSNavigationBarButtonDirectRight) {
      
        [self save];
    } else {
        
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self popViewController];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self popViewControllerDirect:AnimationDirectionV];
        }
    }
}

//名称
-(void) onItemMemoListClick:(LSEditItemMemo*)obj {
    if (obj == self.txtName) {
        int tag = (int)obj.tag;
        MemoInputView *vc = [[MemoInputView alloc] init];
        [vc limitShow:tag delegate:self title:self.txtName.lblName.text val:[self.txtName getStrVal] limit:50];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}

-(void) finishInput:(int)event content:(NSString*)content {
    if (event == METER_TXT_NAME) {
        [self.txtName changeData:content];
    }
    [self tableViewRefreshUI];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj {
    
    if (obj.tag == METER_TXT_PRICE) {
        
        //销售价格
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
   
    } else if (obj.tag == METER_LIST_PERIOD) {
        
        //有效期
        if ([obj.lblVal.text isEqualToString:@"不限期"]) {
            [SymbolNumberInputBox initData:@""];
        } else {
            [SymbolNumberInputBox initData:obj.lblVal.text];
        }
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    
    } else if (obj.tag == METER_VEW_IS_RETURN) {
        //充值后可退几天
        if ([obj.lblVal.text isEqualToString:@"不限期"]) {
            [SymbolNumberInputBox initData:@""];
        } else {
            [SymbolNumberInputBox initData:obj.lblVal.text];
        }
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
    }
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if (eventType == METER_TXT_PRICE) {
        if ([NSString isBlank:val]) {
            val = nil;
            [self.txtPrice changeData:@"" withVal:val];
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.floatValue];
            [self.txtPrice changeData:val withVal:val];
        }
    } else if (eventType == METER_LIST_PERIOD) {
        if ([NSString isBlank:val]) {
            val = nil;
            [self.lstPeriod changeData:@"不限期" withVal:val];
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
            [self.lstPeriod changeData:val withVal:val];
        }
    } else if (eventType == METER_VEW_IS_RETURN) {
        if ([NSString isBlank:val]) {
            val = nil;
            [self.vewIsReturn changeData:@"不限期" withVal:val];
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
            [self.vewIsReturn changeData:val withVal:val];
        }
    }else  if (eventType == METER_CELL_CONCUMETIME) {
        if ([NSString isNotBlank:val]) {
            LSMemberMeterGoodsVo *model = self.meterGoodsList[self.rowNow];
            val = [NSString stringWithFormat:@"%ld",(long)val.integerValue];
             model.consumeTime = val.intValue;
        }
    }
    [self tableViewRefreshUI];
}

#pragma mark - 可退卡开关
- (void)onItemRadioClick:(LSEditItemRadio *)obj {
    
    if (obj.tag == METER_RDO_IS_RETURN) {
        self.vewIsReturn.hidden = ![obj getVal];
    }
    [self tableViewRefreshUI];
}

// 更新tableView显示
- (void)tableViewRefreshUI {
    
    [UIHelper refreshUI:self.headerView];
    [UIHelper refreshUI:self.footerView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView reloadData];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.meterGoodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.action == ACTION_CONSTANTS_EDIT) {
        LSMeterAdjustStyleCell *cell = [LSMeterAdjustStyleCell meterAdjustStyleCellWithTableView:tableView];
        cell.obj = self.meterGoodsList[indexPath.row];
        return cell;
    } else {
        return [self tableView:tableView marketCellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView marketCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberMeterDetailCell *cell = [LSMemberMeterDetailCell meterDetailCellWithTableView:tableView];
    cell.delegate = self;
    [cell setObj:self.meterGoodsList[indexPath.row]];
    return cell;
}

#pragma mark -LSMemberMeterDetailCellDelegate协议
/**
 *  实现加减按钮点击代理事件
 *
 *  @param cell 当前单元格
 *  @param flag 按钮标识，11 为减按钮，12为加按钮
 */
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag {
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    switch (flag) {
        case 11:
        {
            //做减法
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            LSMemberMeterGoodsVo *model = self.meterGoodsList[index.row];
            if (model.consumeTime == 1) {
                [self delSelectObject:model];
            }else {
                model.consumeTime --;
            }
        }
            break;
            
        case 12:
        {
            //做加法
            LSMemberMeterGoodsVo *model = self.meterGoodsList[index.row];
            if (model.consumeTime < 999999) {
                model.consumeTime ++;
            }
//            model.consumeTime ++;
        }
            break;
            
        case 10:
        {
            //自定义数量
            LSMemberMeterGoodsVo *model = self.meterGoodsList[index.row];
            self.rowNow = index.row;
            NSString *consume = [NSString stringWithFormat:@"%d",model.consumeTime];
            [SymbolNumberInputBox initData:consume];
            [SymbolNumberInputBox show:nil client:self isFloat:NO isSymbol:NO event:METER_CELL_CONCUMETIME];
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        }
            break;
            
        default:
            break;
    }
    //刷新表格
    [self.tableView reloadData];
}

- (void)delSelectObject:(LSMemberMeterGoodsVo *)obj {
    
    self.meterGoodsVo = obj;
    NSString *title = [NSString stringWithFormat:@"删除商品[%@]吗?", obj.goodsName];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:^{
        [self.tableView reloadData];
    } selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        [self.meterGoodsList removeObject:self.meterGoodsVo];
        if (![self.meterGoodsVo.operateType isEqualToString:@"add"]) {
            self.meterGoodsVo.operateType = @"del";
            [self.delGoodsList addObject:self.meterGoodsVo];
        }
        [self.tableView reloadData];
    }];
}

//商超模式
- (void)showSelectGoodsView {
    
    GoodsBatchChoiceView1 *goodsView = [[GoodsBatchChoiceView1 alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    [goodsView loaddatas:[[Platform Instance] getkey:SHOP_ID] callBack:^(NSMutableArray *goodsList) {
        
        if (goodsList == nil) {//左侧
            
            [self popViewController];
        } else {//右侧
            
            if (goodsList.count>0) {
                [self checkGoodsIds:goodsList];
            }
        }
        }];
        
    [self pushViewController:goodsView];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)checkGoodsIds:(NSMutableArray *)goodsList{
    
    __weak typeof(self) wself = self;
    NSString *url = @"goods/checkGoodsInGoodsHandle";
    
    //有选择商品
    NSMutableArray *addArr = [NSMutableArray arrayWithCapacity:goodsList.count];
    
    NSMutableArray *checkArr = [NSMutableArray array];
    for (GoodsVo* goodsVo in goodsList) {
        [checkArr addObject:goodsVo.goodsId];
    }

    NSDictionary *param = [NSDictionary dictionaryWithObject:checkArr forKey:@"goodsIds"];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        for (GoodsVo* vo in goodsList) {
            
        BOOL flag = NO;
        BOOL isHave = NO;
        
        if (wself.delGoodsList.count>0) {
            //添加删除队列中存在的商品
            for (LSMemberMeterGoodsVo* detailVo in wself.delGoodsList) {
                if ([vo.goodsId isEqualToString:detailVo.ID]) {
                    flag = YES;
                    [addArr addObject:detailVo];
                    [wself.delGoodsList removeObject:detailVo];
                    break;
                }
            }
        }
        
        if (wself.meterGoodsList.count > 0) {
            //已经存在的商品不添加
            for (LSMemberMeterGoodsVo* detailVo in wself.meterGoodsList) {
                if ([vo.goodsId isEqualToString:detailVo.ID]) {
                    isHave = YES;
                    break;
                }
            }
        }

        //exist = true ,不添加该商品
        if (vo.type != 1 || vo.upDownStatus == 2 || [json[@"exist"] boolValue] == YES) {
            /*商品类型(1.普通商品、2.拆分商品、3.组装商品、4.称重商品、5.原料商品、6:加工商品')
             选择的商品中是否含有散称、下架、拆分、组装、加工的商品，若存在则提示：散称、下架或拆分\组装\加工商品不能选为计次商品，请重新选择！*/
            [LSAlertHelper showAlert:@"散称、下架或拆分\\组装\\加工商品不能选为计次商品，请重新选择！"];
            [wself.meterGoodsList removeObjectsInArray:goodsList];
            return  ;
        }else{
            //添加不存在以上两种情况的商品
            if (!flag && !isHave) {
            LSMemberMeterGoodsVo* detailVo = [[LSMemberMeterGoodsVo alloc] init];
            detailVo.ID = vo.goodsId;
            detailVo.goodsName = vo.goodsName;
            detailVo.barCode= vo.barCode;
            detailVo.consumeTime = 1;
            detailVo.operateType = @"add";
            [addArr addObject:detailVo];
            }
        }
        
        
        if ((wself.meterGoodsList.count+addArr.count) > 20) {
            //选择的商品总数超过20件,放回原删除的商品
            for (LSMemberMeterGoodsVo* detailVo in addArr) {
                if ([detailVo.operateType isEqualToString:@"del"]) {
                    [wself.delGoodsList addObject:detailVo];
                }
            }
            [LSAlertHelper showAlert:@"计次服务最多添加20项计次商品！"];
            return ;
        }
       
        }
        
        if (addArr.count>=0) {
            //未超过20件，将原删除的商品重置
            for (LSMemberMeterGoodsVo *detailVo in addArr) {
                if ([detailVo.operateType isEqualToString:@"del"]) {
                    detailVo.operateType = @"edit";
                    detailVo.consumeTime = 1;
                }
            }
            [wself.meterGoodsList addObjectsFromArray:addArr];
            [self popViewController];
        }
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

- (NSMutableArray *)obtainGoodsList {
    
    NSMutableArray *goodsList = [NSMutableArray array];
    
    if (self.delGoodsList.count > 0) {
        [goodsList addObjectsFromArray:self.delGoodsList];
    }
    
    [goodsList addObjectsFromArray:self.meterGoodsList];
    
    return goodsList;
}

- (void)addClick {
    
    /*跳转至【选择商品】页面，选择需要添加的商品
     点击保存，需要Check：
     选择的商品中是否含有散称和下架的商品，若存在则提示：散称或下架的商品不能选为计次商品，请重新选择！
     添加的计次商品是否超过20项，若超过则提示：计次卡最多添加20项计次商品！
     */
    if (self.meterGoodsList.count == 20) {
        [LSAlertHelper showAlert:@"计次服务最多添加20项计次商品！"];
        return ;
    } else {
        [self showSelectGoodsView];
    }
    
    [self tableViewRefreshUI];
}

- (void)delClick {
    
    [MobClick event:@"Member_ByTimeService_Del"];
    
    NSString *mas = [NSString stringWithFormat:@"确认要删除%@吗？", [self.txtName getStrVal]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:mas message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        [self configTitle:@"计次服务详情" leftPath:Head_ICON_BACK rightPath:nil];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //删除
         NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.obj.id forKey:@"id"];
        NSString *url = @"accountcard/delete";
        
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            
            LSMemberMeterViewController *vc = nil;
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LSMemberMeterViewController class]]) {
                    vc = (LSMemberMeterViewController *)controller;
                    vc.lastDateTime = nil;
                    [vc loadData];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self popViewController];
        } errorHandler:^(id json) {
             [AlertBox show:json];
        }];
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    [self tableViewRefreshUI];
}

#pragma mark - 验证
- (BOOL)isValid {
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([NSString isBlank:[self.txtName getStrVal]] ) {
            [AlertBox show:@"名称不能为空，请输入!"];
            return NO;
        }
        if ([NSString isBlank:[self.txtPrice getStrVal]] ) {
            [AlertBox show:@"销售价格不能为空，请输入!"];
            return NO;
        }
        if (![NSString isFloat:[self.txtPrice getStrVal]]) {
            [AlertBox show:@"销售价格不正确，请重新输入!"];
            return NO;
        }
        if (self.meterGoodsList.count < 1) {
            [AlertBox show:@"请先添加计次商品！"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 数据模型赋值
- (void)transMode {
    
    _obj.accountCardName = [self.txtName getStrVal];    
    
    _obj.price = [NSNumber numberWithFloat:[self.txtPrice getStrVal].floatValue];
    
    if ([self.lstPeriod.lblVal.text  isEqualToString:@"不限期"]) {
        _obj.expiryDate = @-1;
    }else{
        _obj.expiryDate = [NSNumber numberWithLongLong:[self.lstPeriod getStrVal].longLongValue] ;
    }
    _obj.isReturn = [NSNumber numberWithInteger:[self.rdoIsReturn getVal]];
    if ([self.vewIsReturn.lblVal.text  isEqualToString:@"不限期"]) {
        _obj.returnDays = @-1;
    }else{
        _obj.returnDays = [NSNumber numberWithLongLong:[self.vewIsReturn getStrVal].longLongValue] ;
    }
    
    NSMutableArray *addGoodsArray = [NSMutableArray array];
    LSMemberMeterGoodsVo *goodsVo = [[LSMemberMeterGoodsVo alloc] init];
    
    for (int i = 0; i < self.meterGoodsList.count; i++) {
        
        goodsVo = [self.meterGoodsList objectAtIndex:i];
        NSMutableDictionary *addGoodsDic= [[NSMutableDictionary alloc] init];
        [addGoodsDic setValue:goodsVo.ID forKey:@"goodsId"];
        [addGoodsDic setValue:[NSNumber numberWithInt:goodsVo.consumeTime] forKey:@"consumeTime"];
        [addGoodsArray insertObject:addGoodsDic atIndex:i ];
    }
    
    NSMutableDictionary *addGoodsDic = [[NSMutableDictionary alloc] init];
    [addGoodsDic setValue:addGoodsArray forKey:@"accountGoodsList"];
    [addGoodsDic setValue:_obj.accountCardName forKey:@"accountCardName"];
    [addGoodsDic setValue:_obj.expiryDate forKey:@"expiryDate"];
    [addGoodsDic setValue:_obj.isReturn forKey:@"isReturn"];
    [addGoodsDic setValue:_obj.price forKey:@"price"];
    [addGoodsDic setValue:_obj.returnDays forKey:@"returnDays"];
    [self.param setValue:addGoodsDic forKey:@"accountCardVo"];
}

#pragma mark - 更新信息
- (void)save {
    if (![self isValid]) {
        return;
    }
    [self transMode];
    
    
    
    NSString *url = @"accountcard/save";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        LSMemberMeterViewController *vc = nil;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LSMemberMeterViewController class]]) {
                vc = (LSMemberMeterViewController *)controller;
                vc.lastDateTime = nil;
                [vc loadData];
            }
        }
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self popViewControllerDirect:AnimationDirectionV];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
