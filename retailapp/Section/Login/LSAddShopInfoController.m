//
//  LSAddShopInfoController.m
//  retailapp
//
//  Created by guozhi on 2017/2/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_INDUSTRY 1
#define TAG_LST_ADRESS 2
#import "LSAddShopInfoController.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditItemMemo.h"
#import "LSSettingSystemParameterController.h"
#import "ShopVo.h"
#import "GlobalRender.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "AddressPickerBox.h"
#import "MemoInputView.h"
@interface LSAddShopInfoController ()<IEditItemListEvent, IEditItemMemoEvent, OptionPickerClient, AddressPickerClient, MemoInputClient>
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 店家编号 */
@property (nonatomic, strong) EditItemView *vewShopCode;
/** 店家名称 */
@property (nonatomic, strong) EditItemText *txtShopName;
/** 所属行业 */
@property (nonatomic, strong) EditItemList *lstIndustry;
/** 所在地区 */
@property (nonatomic, strong) EditItemList *lstAdress;
/** 详细地址 */
@property (nonatomic, strong) EditItemMemo *memoAdress;
/** 联系人 */
@property (nonatomic, strong) EditItemText *txtContact;
/** 手机号 */
@property (nonatomic, strong) EditItemText *txtPhone;
/** 店家信息 */
@property (nonatomic, strong) ShopVo *shopVo;
/** 地址列表 */
@property (nonatomic, strong) NSArray *adressList;
/** 行业列表 */
@property (nonatomic, strong) NSMutableArray *professionList;

@end

@implementation LSAddShopInfoController
- (instancetype)initWithShopVo:(ShopVo *)shopVo adressList:(NSArray *)adressList professionList:(NSArray *)professionList {
    if (self = [super init]) {
        self.shopVo = shopVo;
        self.adressList = adressList;
        NameItemVO *item = nil;
        self.professionList = [NSMutableArray array];
        for (NSDictionary *obj in professionList) {
            item = [[NameItemVO alloc] initWithVal:obj[@"name"] andId:[obj[@"code"] stringValue]];
            [self.professionList addObject:item];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"添加店家信息"];
    [self configViews];
    [self loadData];
    [UIHelper refreshUI:self.scrollView];
}


- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H- kNavH)];
    [self.view addSubview:self.scrollView];
    
    //店家编号
    self.vewShopCode = [EditItemView editItemView];
    [self.vewShopCode initLabel:@"店家编号" withHit:nil];
    [self.scrollView addSubview:self.vewShopCode];
    //点击名称
    self.txtShopName = [EditItemText editItemText];
    [self.txtShopName initLabel:@"店家名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.scrollView addSubview:self.txtShopName];
    //所属行业
    self.lstIndustry = [EditItemList editItemList];
    [self.lstIndustry initLabel:@"所属行业" withHit:nil isrequest:YES delegate:self];
    self.lstIndustry.tag = TAG_LST_INDUSTRY;
    [self.scrollView addSubview:self.lstIndustry];
    //所在地区
    self.lstAdress = [EditItemList editItemList];
    [self.lstAdress initLabel:@"所在地区" withHit:nil isrequest:YES delegate:self];
    self.lstAdress.tag = TAG_LST_ADRESS;
    [self.scrollView addSubview:self.lstAdress];
    //详情地址
    self.memoAdress = [EditItemMemo editItemMemo];
    [self.memoAdress initLabel:@"详细地址" isrequest:YES delegate:self];
    [self.scrollView addSubview:self.memoAdress];
    //联系人
    self.txtContact = [EditItemText editItemText];
    [self.txtContact initLabel:@"联系人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.scrollView addSubview:self.txtContact];
    //手机号码
    self.txtPhone = [EditItemText editItemText];
    [self.txtPhone initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.scrollView addSubview:self.txtPhone];
    //下一步按钮
    UIButton *btn = [LSViewFactor addRedButton:self.scrollView title:@"下一步" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadData {
    __weak typeof(self) wself = self;
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    NSString* url = @"shop/detailById";
    self.scrollView.hidden = YES;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.scrollView.hidden = NO;
        //点击信息
        ShopVo *shopVo =  [ShopVo convertToShop:[json objectForKey:@"shop"]];
        //地址列表
        NSArray *addressList = json[@"addressList"];
        //行业列表
        NSArray *professionList = json[@"professionList"];
        wself.shopVo = shopVo;
        wself.adressList = addressList;
        NameItemVO *item = nil;
        self.professionList = [NSMutableArray array];
        for (NSDictionary *obj in professionList) {
            item = [[NameItemVO alloc] initWithVal:obj[@"name"] andId:[obj[@"code"] stringValue]];
            [self.professionList addObject:item];
        }
        [wself configData];
        [UIHelper refreshUI:wself.scrollView];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];

}

#pragma mark - 所在行业
- (NameItemVO *)getIndustory {
    for (NameItemVO *obj in self.professionList) {
        if ([[obj obtainItemId] isEqualToString:self.shopVo.profession.stringValue]) {
            return obj;
        }
    }
    return nil;
   
}

- (void)configData {
    //店家编号
    [self.vewShopCode initData:self.shopVo.code withVal:nil];
    //店家名称
    [self.txtShopName initData:self.shopVo.shopName];
    //所属行业
    NameItemVO *iten = [self getIndustory];
    [self.lstIndustry initData:[iten obtainItemName] withVal:[iten obtainItemId]];
    //所在地区
    NSString *addr = [GlobalRender getAddress:self.adressList PId:self.shopVo.provinceId CId:self.shopVo.cityId DId:self.shopVo.countyId];
    if ([NSString isNotBlank:addr]) {
         [self.lstAdress initData:addr withVal:addr];
    } 
    //详细地址
    [self.memoAdress initData:self.shopVo.address];
    //联系人
    [self.txtContact initData:self.shopVo.linkman];
    //手机号码
    [self.txtPhone initData:self.shopVo.phone1];
    
}

#pragma mark - 下一步按钮
- (void)btnClick:(UIButton *)btn {
    if ([self isValide]) {
        self.shopVo.shopName = [self.txtShopName getStrVal];
        self.shopVo.profession = @([[self.lstIndustry getStrVal] integerValue]);
        self.shopVo.address = [self.memoAdress getStrVal];
        self.shopVo.linkman = [self.txtContact getStrVal];
        self.shopVo.phone1 = [self.txtPhone getStrVal];
        
        NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
        [param setValue:[ShopVo getDictionaryData:self.shopVo] forKey:@"shop"];
        [param setValue:@"edit" forKey:@"operateType"];
        [param setValue:@(NO) forKey:@"synIsShop"];
        [param setValue:@2 forKey:@"interface_version"];
        NSString *url = @"shop/save";
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            LSSettingSystemParameterController *vc = [[LSSettingSystemParameterController alloc] init];
            [self pushViewController:vc];
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json];
        }];
    }
}

- (void)onItemListClick:(EditItemList *)obj {
    if (obj == self.lstIndustry) {//所属行业
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        [OptionPickerBox initData:self.professionList itemId:[obj getStrVal]];
    } else if (obj == self.lstAdress) {//所在地址
        //选择地区
        [AddressPickerBox initAddress:self.adressList pId:self.shopVo.provinceId cId:self.shopVo.cityId dId:self.shopVo.countyId];
        [AddressPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_INDUSTRY) {//所属行业
        [self.lstIndustry initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

#pragma mark - 选择地址
- (BOOL)pickAddress:(NSMutableArray *)selectArr event:(NSInteger)eventType
{
    NSString *provinceName = [[selectArr objectAtIndex:0] objectForKey:@"provinceName"];
    self.shopVo.provinceId = [[selectArr objectAtIndex:0] objectForKey:@"provinceId"];
    
    NSString* cityName = [[selectArr objectAtIndex:1] objectForKey:@"cityName"];
    self.shopVo.cityId = [[selectArr objectAtIndex:1] objectForKey:@"cityId"];
    self.shopVo.countyId = @"1";//此值是必传值有可能没有所以随便赋值了
    NSString *districtName = @"";
    if (selectArr.count==3) {
        districtName = [[selectArr objectAtIndex:2] objectForKey:@"districtName"];
        self.shopVo.countyId = [[selectArr objectAtIndex:2] objectForKey:@"districtId"];
    }
    
    NSString* address = nil;
    if ([self.shopVo.provinceId isEqualToString:@"33"]||[self.shopVo.provinceId isEqualToString:@"34"]) {
        address = [NSString stringWithFormat:@"%@",provinceName];
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,districtName];
    }
    
    [self.lstAdress initData:address withVal:address];
    
    return YES;
}

#pragma mark - 输入地址多行输入的
- (void)onItemMemoListClick:(EditItemMemo*)obj {
    if (obj == self.memoAdress) {
        int tag = (int)obj.tag;
        MemoInputView *vc = [[MemoInputView alloc] init];
        [vc limitShow:tag delegate:self title:self.memoAdress.lblName.text val:[self.memoAdress getStrVal] limit:500];
        [self pushViewController:vc direct:AnimationDirectionV];
    }
}

- (void)finishInput:(int)event content:(NSString*)content {
    [self.memoAdress initData:content];
    [UIHelper refreshUI:self.scrollView];
}

#pragma mark - 判断是否可以保存
- (BOOL)isValide {
    if ([NSString isBlank:[self.txtShopName getStrVal]]) {
        [LSAlertHelper showAlert:@"店家名称不能为空，请重新输入！"];
        return NO;
    }
    if ([NSString isBlank:[self.lstIndustry getStrVal]]) {
        [LSAlertHelper showAlert:@"所属行业不能为空，请重新输入！"];
        return NO;
    }
    if ([NSString isBlank:[self.lstIndustry getStrVal]]) {
        [LSAlertHelper showAlert:@"所属行业不能为空，请重新输入！"];
        return NO;
    }
    if ([NSString isBlank:[self.lstAdress getStrVal]]) {
        [LSAlertHelper showAlert:@"所在地区不能为空，请重新输入！"];
        return NO;
    }
    if ([NSString isBlank:[self.memoAdress getStrVal]]) {
        [LSAlertHelper showAlert:@"详细地址不能为空，请重新输入！"];
        return NO;
    }
    if ([NSString isBlank:[self.txtContact getStrVal]]) {
        [LSAlertHelper showAlert:@"联系人不能为空，请重新输入！"];
        return NO;
    }
    if ([NSString isBlank:[self.txtPhone getStrVal]]) {
        [LSAlertHelper showAlert:@"手机号码不能为空，请重新输入！"];
        return NO;
    }
    if (![NSString validateMobile:[self.txtPhone getStrVal]]) {
        [LSAlertHelper showAlert:@"手机号码格式不正确，请重新输入!"];
        return NO;
    }
    return YES;
}


@end
