//
//  StyleChoiceTopView2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleChoiceTopView2.h"
#import "StyleBatchChoiceView2.h"
#import "EditItemList.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "GoodsModuleEvent.h"
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
#import "ColorHelper.h"
#import "StyleBatchChoiceView.h"

#define STYLE_CHOICE_TOP2_CATEGORY 1
#define STYLE_CHOICE_TOP2_SEX 2
#define STYLE_CHOICE_TOP2_SEASON 3
#define STYLE_CHOICE_TOP2_YEAR 4
#define STYLE_CHOICE_TOP2_MINPRICE 5
#define STYLE_CHOICE_TOP2_MAXPRICE 6
#define STYLE_CHOICE_TOP2_MAINMODEL 7
#define STYLE_CHOICE_TOP2_AUXILIARYMODEL 8

@interface StyleChoiceTopView2 ()

@property (nonatomic, strong) StyleBatchChoiceView2* parent;

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, retain) NSMutableArray *categoryList;

@property (nonatomic, retain) NSMutableArray *attributeList;

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic, retain) NSString *shopName;

@property (nonatomic) int fromViewTag;

@end

@implementation StyleChoiceTopView2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(StyleBatchChoiceView2 *)parentTemp {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _parent = parentTemp;
    }
    return self;
}

-(void) loadDatas:(NSString *)shopId fromViewTag:(int)fromViewTag
{
    _fromViewTag = fromViewTag;
    _shopId = shopId;
}

//初始化条件项内容
- (void)initMainView
{
    [self.lsCategory initLabel:@"中品类" withHit:nil delegate:self];
    
    [self.lsSex initLabel:@"性别" withHit:nil delegate:self];
    
    [self.lsMainModel initLabel:@"主型" withHit:nil delegate:self];
    
    [self.lsAuxiliaryModel initLabel:@"辅型" withHit:nil delegate:self];
    
    [self.lsYear initLabel:@"年份" withHit:nil delegate:self];
    
    [self.lsSeason initLabel:@"季节" withHit:nil delegate:self];
    
    [self.lsMaxHangTagPrice initLabel:@"吊牌价(元)" withHit:nil delegate:self];
    
    self.lsCategory.tag = STYLE_CHOICE_TOP2_CATEGORY;
    self.lsSex.tag = STYLE_CHOICE_TOP2_SEX;
    self.lsSeason.tag = STYLE_CHOICE_TOP2_SEASON;
    self.lsYear.tag = STYLE_CHOICE_TOP2_YEAR;
    self.txtMinHangTagPrice.tag = STYLE_CHOICE_TOP2_MINPRICE;
    self.lsMaxHangTagPrice.tag = STYLE_CHOICE_TOP2_MAXPRICE;
    self.lsMainModel.tag = STYLE_CHOICE_TOP2_MAINMODEL;
    self.lsAuxiliaryModel.tag = STYLE_CHOICE_TOP2_AUXILIARYMODEL;
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
    
    [self.lsMainModel initData:@"全部" withVal:@""];
    
    [self.lsAuxiliaryModel initData:@"全部" withVal:@""];
    
    [self.lsYear initData:@"请输入" withVal:@""];
    
    [self.lsSeason initData:@"全部" withVal:@""];
    
    [self.lsMaxHangTagPrice initData:@"请输入" withVal:@""];
    
    [self.txtMinHangTagPrice setTextColor:[ColorHelper getBlueColor]];
    self.txtMinHangTagPrice.text = @"请输入";
}

-(IBAction)clickMinPrice:(id)sender
{
    if ([self.txtMinHangTagPrice.text isEqualToString:@"请输入"]) {
        [SymbolNumberInputBox initData:nil];
    } else {
        [SymbolNumberInputBox initData:self.txtMinHangTagPrice.text];
    }
    [SymbolNumberInputBox show:@"吊牌价(开始)" client:self isFloat:YES isSymbol:NO event:STYLE_CHOICE_TOP2_MINPRICE];
    [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
}

-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == STYLE_CHOICE_TOP2_CATEGORY) {
        __weak StyleChoiceTopView2* weakSelf = self;
        [_goodsService selectFirstCategoryInfo:^(id json) {
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
    }else if (obj.tag == STYLE_CHOICE_TOP2_SEX){
        [OptionPickerBox initData:[GoodsRender listSex:YES]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == STYLE_CHOICE_TOP2_SEASON){
        __weak StyleChoiceTopView2* weakSelf = self;
        [_goodsService selectBaseAttributeValList:@"2" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"attributeValList"];
            _attributeList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_attributeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (obj.tag == STYLE_CHOICE_TOP2_YEAR){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:4 digitLimit:0];
        
    }else if (obj.tag == STYLE_CHOICE_TOP2_MAXPRICE){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:@"吊牌价(结束)" client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == STYLE_CHOICE_TOP2_MAINMODEL) {
        __weak StyleChoiceTopView2* weakSelf = self;
        [_goodsService selectBaseAttributeValList:@"5" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"attributeValList"];
            _attributeList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_attributeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == STYLE_CHOICE_TOP2_AUXILIARYMODEL) {
        __weak StyleChoiceTopView2* weakSelf = self;
        [_goodsService selectBaseAttributeValList:@"6" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"attributeValList"];
            _attributeList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_attributeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == STYLE_CHOICE_TOP2_CATEGORY) {
        [self.lsCategory initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == STYLE_CHOICE_TOP2_SEX){
        [self.lsSex initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == STYLE_CHOICE_TOP2_SEASON){
        [self.lsSeason initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == STYLE_CHOICE_TOP2_MAINMODEL) {
        [self.lsMainModel initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == STYLE_CHOICE_TOP2_AUXILIARYMODEL) {
        [self.lsAuxiliaryModel initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    
    if (eventType==STYLE_CHOICE_TOP2_MINPRICE) {
        
        if ([NSString isBlank:val]) {
            val = @"请输入";
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        
        self.txtMinHangTagPrice.text = val;
        
    }else if (eventType==STYLE_CHOICE_TOP2_MAXPRICE) {
        
        if ([NSString isBlank:val]) {
            [self.lsMaxHangTagPrice initData:@"请输入" withVal:nil];
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            [self.lsMaxHangTagPrice initData:val withVal:val];
        }
    }
    
    if (eventType==STYLE_CHOICE_TOP2_YEAR) {
        
        if ([NSString isBlank:val]) {
            [self.lsYear initData:@"请输入" withVal:@""];
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
            [self.lsYear initData:val withVal:val];
        }
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
    NSString* minPrice = self.txtMinHangTagPrice.text;
    if ([minPrice isEqualToString:@"请输入"]) {
        minPrice = @"";
    }
    if ([NSString isNotBlank:[self.lsMaxHangTagPrice getStrVal]] && [NSString isNotBlank:self.txtMinHangTagPrice.text]) {
        if ([self.lsMaxHangTagPrice getStrVal].doubleValue < minPrice.doubleValue) {
            [AlertBox show:@"吊牌价下限应小于等于上限!"];
            return ;
        }
    }
    
    [self hideMoveOut];
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"2" forKey:@"searchType"];
    [condition setValue:_shopId forKey:@"shopId"];
    [condition setValue:_shopName forKey:@"shopName"];
    [condition setValue:@"" forKey:@"searchCode"];
    if ([[self.lsCategory getStrVal] isEqualToString:@"noCategory"]) {
        [condition setValue:@"0" forKey:@"categoryId"];
    }else{
        [condition setValue:[self.lsCategory getStrVal] forKey:@"categoryId"];
    }
    
    [condition setValue:[self.lsSex getStrVal] forKey:@"applySex"];
    [condition setValue:[self.lsMainModel getStrVal] forKey:@"prototypeValId"];
    [condition setValue:[self.lsAuxiliaryModel getStrVal] forKey:@"auxiliaryValId"];
    [condition setValue:[self.lsYear getStrVal] forKey:@"year"];
    [condition setValue:[self.lsSeason getStrVal] forKey:@"seasonValId"];
    if ([self.txtMinHangTagPrice.text isEqualToString:@"请输入"]) {
        [condition setValue:@"" forKey:@"minHangTagPrice"];
    } else {
        [condition setValue:self.txtMinHangTagPrice.text forKey:@"minHangTagPrice"];
    }
    [condition setValue:[self.lsMaxHangTagPrice getStrVal] forKey:@"maxHangTagPrice"];
    [condition setValue:@"" forKey:@"createTime"];
    if (_fromViewTag == STYLE_BATCH_CHOICE_VIEW2) {
        [_parent showView:STYLE_BATCH_CHOICE_VIEW2];
        [_parent loadDatasFromSelect:condition];
    }
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

@end
