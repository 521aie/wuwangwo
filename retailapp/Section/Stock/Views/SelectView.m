//
//  SelectView.m
//  retailapp
//
//  Created by guozhi on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectView.h"
#import "EditItemList.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "GoodsService.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "MenuList.h"
#import "AlertBox.h"
#import "Platform.h"
#import "NameItemVO.h"
#import "DateUtils.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "TreeNode.h"
#import "JsonHelper.h"
@implementation SelectView
- (void)awakeFromNib {
    [super awakeFromNib];
    service = [ServiceFactory shareInstance].goodsService;
}
- (void)initView {
    if([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {//商超
        [self.lstClass initLabel:@"分类" withHit:nil delegate:self];

    } else if([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        [self.lstClass initLabel:@"中品类" withHit:nil delegate:self];

    }
    [self.lstState initLabel:@"状态" withHit:nil delegate:self];
    self.backgroundView.frame = self.container.frame;
    self.labName.text = @"虚拟库存数";
    [self.lstYear initLabel:@"年份" withHit:nil delegate:self];
    [self.lstSeason initLabel:@"季节" withHit:nil delegate:self];
    [self.lstSex initLabel:@"性别" withHit:nil delegate:self];
    self.virtualStock.textColor = [ColorHelper getTipColor3];
    
    self.lstClass.tag = 1;
    self.lstState.tag = 2;
    self.txtStart.tag = 3;
    self.txtEnd.tag = 4;
    self.lstYear.tag = 5;
    self.lstSeason.tag = 6;
    self.lstSex.tag = 7;
    [self initData];

}

- (void)initData {
    [self.lstClass initData:@"全部" withVal:@""];
    [self.lstState initData:@"全部" withVal:@""];
    [self.lstSex initData:@"全部" withVal:@""];
    [self.lstYear initData:@"" withVal:@""];
    self.txtStart.text = @"";
    self.txtEnd.text = @"";
    if ([[Platform Instance] getShopMode] == 1) {
        [self.lstState visibal:NO];
    }
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {//商超
        [self.lstYear visibal:NO];
        [self.lstSeason visibal:NO];
        [self.lstSex visibal:NO];
    }
    [self.lstSeason initData:@"全部" withVal:@""];
     [UIHelper refreshUI:self.container];
}
- (void)onItemListClick:(EditItemList *)obj {
    if (obj.tag == 5) {
        if([[self.lstYear getDataLabel] isEqual:@"请输入"]){
            [SymbolNumberInputBox initData:@""];

        }else{
            [SymbolNumberInputBox initData:self.lstYear.lblVal.text];
        }
        [SymbolNumberInputBox show:@"当前年度" client:self isFloat:NO isSymbol:NO event:self.lstYear.tag];
        [SymbolNumberInputBox limitInputNumber:4 digitLimit:0];
        return;
    }

    if (obj.tag == 1) {
        NSString *url = @"category/lastCategoryInfo";
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"1" forKey:@"hasNoCategory"];
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
            NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
            NSMutableArray *categoryList = [[NSMutableArray alloc] init];
           NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
           [categoryList addObject:itemVo];
            for (CategoryVo* vo in list) {
                itemVo = [[NameItemVO alloc] initWithVal:vo.name andId:vo.categoryId];
                [categoryList addObject:itemVo];
            }
            [OptionPickerBox initData:categoryList itemId:[obj getStrVal]];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

    }
    if (obj.tag == 2) {
        [OptionPickerBox initData:[MenuList list1FromArray:@[@"全部",@"正常",@"异常"]] itemId:[obj getStrVal]];
    }
    if (obj.tag == 6) {
        [service selectBaseAttributeValList:@"2" completionHandler:^(id json) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            NameItemVO *item = [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
            [arr addObject:item];
            for (NSDictionary *obj in  json[@"attributeValList"]) {
                NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:obj[@"attributeVal"] andId:[NSString stringWithFormat:@"%@",obj[@"attributeValId"]]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];

        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    if (obj.tag == 7) {
        [OptionPickerBox initData:[MenuList list1FromArray:@[@"全部",@"男",@"女",@"中性"]] itemId:[obj getStrVal]];
    }
    
    
      [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    
    
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == 1) {
        [self.lstClass initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    if (eventType == 2){
        [self.lstState initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    if (eventType == 6){
        [self.lstSeason initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    if (eventType == 7){
        [self.lstSex initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}


- (IBAction)onResetClick:(UIButton *)sender {
    [self initData];
}

- (IBAction)onCompleteClick:(UIButton *)sender {
    if ([self isValid]) {
        self.hidden = YES;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showFinishEventWithParam:)]) {
            [self.delegate showFinishEventWithParam:nil];
        }
    }
}
- (IBAction)onButtonStart:(UIButton *)sender {
    [SymbolNumberInputBox initData:self.txtStart.text];
    [SymbolNumberInputBox show:@"开始数量" client:self isFloat:NO isSymbol:NO event:self.txtStart.tag];
    [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
}
- (IBAction)onButtonEnd:(UIButton *)sender {
    [SymbolNumberInputBox initData:self.txtEnd.text];
    [SymbolNumberInputBox show:@"结束数量" client:self isFloat:NO isSymbol:NO event:self.txtEnd.tag];
    [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == 3) {
        self.txtStart.text = val;
    }
    if (eventType == 4) {
        self.txtEnd.text = val;
    }
    if (eventType == 5) {
        self.lstYear.lblVal.text = val;
    }
}

- (BOOL)isValid {
    if ([self.txtEnd.text intValue] < [self.txtStart.text intValue]) {
        [AlertBox show:@"开始数量应小于等于结束数量"];
        return NO;
    } else {
        return YES;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.hidden = YES;
}

@end
