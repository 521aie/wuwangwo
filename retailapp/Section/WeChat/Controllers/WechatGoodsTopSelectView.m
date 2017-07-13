//
//  WechatGoodsTopSelectView.m
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatGoodsTopSelectView.h"
#import "EditItemList.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "OptionPickerBox.h"
#import "MemberRender.h"
#import "DateUtils.h"
#import "SymbolNumberInputBox.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "GoodsRender.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "DatePickerBox2.h"
#import "ColorHelper.h"
#import "WechatGoodsManagementStyleView.h"



//款式帅选
#define STYLE_TOP_SELECT_CATEGORY 1 // 分来
#define STYLE_TOP_SELECT_SEX 2 //  性别
#define STYLE_TOP_SELECT_YEAR 1000 // 年度
#define STYLE_TOP_SELECT_SEASON 4 //   季节
#define STYLE_TOP_SELECT_MINPRICE 5 // 最低吊牌价
#define STYLE_TOP_SELECT_MAXPRICE 6 // 最高吊牌价


@interface WechatGoodsTopSelectView ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, retain) NSMutableArray *categoryList;

@property (nonatomic, retain) NSMutableArray *seasonList;

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic, retain) NSString *shopName;

@end

@implementation WechatGoodsTopSelectView
{
    int parentfromview;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(WechatModule *)parentTemp {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        isExpanded = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initButton];
    [self resetLblVal];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDatas:(NSString*) shopId shopName:(NSString*) shopName fromViewTag:(int) fromViewTag
{
    _shopId = shopId;
    _shopName = shopName;
    parentfromview = fromViewTag;
}


//初始化条件项内容
- (void)initMainView
{
    [self.lsCategory initLabel:@"中品类" withHit:nil delegate:self];
    
    [self.lsSex initLabel:@"性别" withHit:nil delegate:self];
    
    [self.lsYear initLabel:@"年份" withHit:nil delegate:self];
    
//    [self.lsYear initLabel:@"年份" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    
    [self.lsSeason initLabel:@"季节" withHit:nil delegate:self];
    
    [self.lsMaxHangTagPrice initLabel:@"吊牌价(元)" withHit:nil delegate:self];
    
    self.lsCategory.tag = STYLE_TOP_SELECT_CATEGORY;
    self.lsSex.tag = STYLE_TOP_SELECT_SEX;
    self.lsSeason.tag = STYLE_TOP_SELECT_SEASON;
    self.lsYear.tag = STYLE_TOP_SELECT_YEAR;
    self.txtMinHangTagPrice.tag = STYLE_TOP_SELECT_MINPRICE;
    self.lsMaxHangTagPrice.tag = STYLE_TOP_SELECT_MAXPRICE;
}

//计算mainContainer的高度
- (void)changeHeight:(UIView*)container  {
    float height=0;
    for (UIView*  view in container.subviews) {
        [view setLs_top:height];
        height+=view.ls_height;
    }
    [container setLs_height:(height)];
    [container setNeedsDisplay];
}

- (void)initButton
{
    [self.btnReset setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    [self.btnConfirm setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
}

#pragma mark - 重置
//重置选项栏的值
- (void)resetLblVal
{
    [self.lsCategory initData:@"全部" withVal:@""];
    
    [self.lsSex initData:@"全部" withVal:@""];
    
    NSString* dateStr=[DateUtils formateDate4:[NSDate date]];
    [self.lsYear initData:dateStr withVal:dateStr];
    
//    [self.lsYear initData:dateStr];
    
    [self.lsSeason initData:@"全部" withVal:@""];
    
    [self.lsMaxHangTagPrice initData:@"" withVal:@""];
    
    [self.txtMinHangTagPrice setTextColor:[ColorHelper getBlueColor]];
}

-(IBAction)clickMinPrice:(id)sender
{
    [SymbolNumberInputBox initData:self.txtMinHangTagPrice.text];
    [SymbolNumberInputBox show:@"吊牌价(开始)" client:self isFloat:YES isSymbol:NO event:STYLE_TOP_SELECT_MINPRICE];
}

-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == STYLE_TOP_SELECT_CATEGORY) {
        __weak WechatGoodsTopSelectView* weakSelf = self;
        [_goodsService selectCategoryList:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"categoryList"];
            _categoryList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_categoryList addObject:[CategoryVo convertToCategoryVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listCategoryList:_categoryList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (obj.tag == STYLE_TOP_SELECT_SEX){
        [OptionPickerBox initData:[GoodsRender listSex:YES]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == STYLE_TOP_SELECT_SEASON){
        __weak WechatGoodsTopSelectView* weakSelf = self;
        [_goodsService selectBaseAttributeValList:@"2" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"attributeValList"];
            _seasonList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_seasonList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeVal:_seasonList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (obj.tag == STYLE_TOP_SELECT_YEAR){
        NSDate *date=[DateUtils parseDateTime5:obj.lblVal.text];
        [DatePickerBox2 show:obj.lblName.text date:date client:self event:(int)obj.tag];
    }else if (obj.tag == STYLE_TOP_SELECT_MAXPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:@"吊牌价(结束)" client:self isFloat:YES isSymbol:NO event:obj.tag];
    }
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (event == STYLE_TOP_SELECT_CATEGORY) {
        [self.lsCategory initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (event == STYLE_TOP_SELECT_SEX){
        [self.lsSex initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (event == STYLE_TOP_SELECT_SEASON){
        [self.lsSeason initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    if (event == STYLE_TOP_SELECT_YEAR) {
        
        NSString* dateStr=[DateUtils formateDate4:date];
        [self.lsYear initData:dateStr withVal:dateStr];
//        [self.lsYear initData:dateStr];
    }
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (val.doubleValue>=999999.99) {
        
        val = @"999999.99";
        
    }else{
        
        val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
    }
    
    if (eventType==STYLE_TOP_SELECT_MINPRICE) {
        
        self.txtMinHangTagPrice.text = val;
        
    }else if (eventType==STYLE_TOP_SELECT_MAXPRICE) {
        
        [self.lsMaxHangTagPrice initData:val withVal:val];
    }
}

//module中调用
- (void)oper{
    
    [self showMoveIn];
    
}

//视图动画效果
- (void)showMoveIn
{
    self.view.hidden = NO;
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 0.5;
    self.view.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hideMoveOut
{
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterMoveOut:finished:context:)];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 1.0;
    self.view.alpha = 0.5;
    [UIView commitAnimations];
    [self.view removeFromSuperview];
}

- (void)afterMoveOut:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext
{
    self.view.hidden = YES;
}

//重置按钮
- (IBAction)btnReset:(id)sender
{
    
    [self resetLblVal];
    
}

//空白按钮
- (IBAction)btnTopClick
{
    [self hideMoveOut];
    
}

//确认按钮
- (IBAction)btnConfirm:(id)sender
{
//    [self hideMoveOut];
//    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
//    [condition setValue:@"1" forKey:@"searchType"];
//    [condition setValue:_shopId forKey:@"shopId"];
//    //[condition setValue:_shopName forKey:@"shopName"];
//    [condition setValue:@"" forKey:@"searchCode"];
//    [condition setValue:[self.lsCategory getStrVal] forKey:@"categoryId"];
//    [condition setValue:[self.lsSex getStrVal] forKey:@"applySex"];
//    [condition setValue:[self.lsYear getStrVal] forKey:@"year"];
//    [condition setValue:[self.lsSeason getStrVal] forKey:@"season"];
//    [condition setValue:self.txtMinHangTagPrice.text forKey:@"minHangTagPrice"];
//    [condition setValue:[self.lsMaxHangTagPrice getStrVal] forKey:@"maxHangTagPrice"];
//    [condition setValue:@"" forKey:@"createTime"];
//   // [parent showView:WECHAT_GOODS_LIST_STYLE_VIEW];
//   //  [parent.wechatGoodsManagementStyleView loaddatas:condition];
//    
//    if (parentfromview == WECHAT_GOODS_HOME_STYLE_VIEW) {
//        WechatGoodsManagementStyleView *wechatGoodsManagementStyleView = [[WechatGoodsManagementStyleView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleView"] bundle:nil];
//        [wechatGoodsManagementStyleView loaddatas:condition];
//        [self.navigationController pushViewController:wechatGoodsManagementStyleView animated:YES];
//    }
// 
}


@end
