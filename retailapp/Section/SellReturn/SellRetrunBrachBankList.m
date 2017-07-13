//
//  SellRetrunBrachBankList.m
//  retailapp
//
//  Created by diwangxie on 16/5/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SellRetrunBrachBankList.h"
#import "XHAnimalUtil.h"
#import "NameItemVO.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "MyMD5.h"
#import "MenuListCell.h"
#import "SellReturnBrachBankCell.h"

@interface SellRetrunBrachBankList ()

@end

@implementation SellRetrunBrachBankList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas=[[NSMutableArray alloc] init];
    [self initTitle];
    [self initView];
    [self loadDate];
    // Do any additional setup after loading the view.
}

-(void)initTitle{
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择支行" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}
-(void)initView{
    [self.lsProvince initLabel:@"选择省份" withHit:nil delegate:self];
    if ([NSString isNotBlank:self.ProvinceId]) {
        [self.lsProvince initData:self.ProvinceName withVal:self.ProvinceId];
        self.lsProvince.tag=1;
    }else{
        [self.lsProvince initData:@"请选择" withVal:nil];
        self.lsProvince.tag=1;
    }
    
    if ([NSString isNotBlank:self.CityId]) {
        [self.lsCity initLabel:@"选择城市" withHit:nil delegate:self];
        [self.lsCity initData:self.CityName withVal:self.CityId];
    }else{
        [self.lsCity initLabel:@"选择城市" withHit:nil delegate:self];
        [self.lsCity initData:@"请选择" withVal:nil];
    }
    self.lsCity.tag=2;
}
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)onItemListClick:(EditItemList *)obj{
    if (obj.tag==1) {
        //省份
        
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSString *url = nil;
        url = @"pay/area/v1/get_bank_province";
        NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
        [param setValue:_bankId forKey:@"bankName"];

        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"data"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"provinceName"] andId:obj[@"provinceNo"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if(obj.tag==2){
        if ([NSString isBlank:[self.lsProvince getStrVal]]) {
            [AlertBox show:@"请选择开户省份"];
            return;
        }
        
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSString *url = nil;
        url = @"pay/area/v1/get_bank_cities";
        NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
        [param setValue:_bankId forKey:@"bankName"];
        [param setValue:[self.lsProvince getStrVal] forKey:@"provinceNo"];
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"data"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"cityName"] andId:obj[@"cityNo"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType==1) {
        [self.lsProvince initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self.lsCity initData:nil withVal:nil];
    }else if (eventType==2){
        [self.lsCity initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self loadDate];
        
    }
    return YES;
}
-(void)loadDate{
    NSString *url = nil;
    url = @"pay/area/v1/get_sub_banks";
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:_bankId forKey:@"bankName"];
    [param setValue:[self.lsCity getStrVal] forKey:@"cityNo"];
    
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [self.datas removeAllObjects];
        for (NSDictionary *obj in  json[@"data"]) {
            MenuListCell *itemVo = [[MenuListCell alloc] initName:obj[@"subBankName"] val:obj[@"subBankNo"]];
            [self.datas addObject:itemVo];
        }
        [self.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

    [self.mainGrid reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuListCell *nameVo = self.datas[indexPath.row];
    static NSString* weChatRebateOrdersCell = @"SellReturnBrachBankCell";
    SellReturnBrachBankCell * cell = [tableView dequeueReusableCellWithIdentifier:weChatRebateOrdersCell];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SellReturnBrachBankCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[SellReturnBrachBankCell class]]) {
                cell = (SellReturnBrachBankCell *)o;
                break;
            }
        }
    }
    cell.lblBankName.text=nameVo.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuListCell *nameVo = self.datas[indexPath.row];
    _brachBankListBlock(nameVo,[self.lsProvince getDataLabel],[self.lsProvince getStrVal],[self.lsCity getDataLabel],[self.lsCity getStrVal]);
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSString*)convertSign:(NSMutableDictionary*)params
{
    NSMutableString *ns = [NSMutableString string];
    
    if ([ObjectUtil isNotEmpty:params]) {
        NSString *val;
        NSArray *keys=[params allKeys];
        NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *key in sortedKeys) {
            val=(NSString *)[params objectForKey:key];
            if ([key isEqualToString:@"sign"] || [key isEqualToString:@"method"] || [key isEqualToString:@"appKey"] || [key isEqualToString:@"v"] || [key isEqualToString:@"format"] || [key isEqualToString:@"timestamp"]) {
                continue;
            }
            if ([NSString isNotBlank:val]) {
                [ns appendString:key];
                [ns appendString:val];
            }
        }
    }
    [ns appendString:APP_CY_API_SECRET];
    return [MyMD5 md5:ns];
}
- (void)loadBrachBankList:(NSInteger)viewType callBack:(BrachBankList)callBack{
    self.brachBankListBlock = callBack;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
