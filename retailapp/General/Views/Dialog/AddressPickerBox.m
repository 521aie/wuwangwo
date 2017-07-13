//
//  AddressPickerBox.m
//  retailapp
//
//  Created by hm on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AddressPickerBox.h"
//#import "AppController.h"
#import "SystemUtil.h"

static AddressPickerBox *addressPickerBox;
@interface AddressPickerBox ()

@end

@implementation AddressPickerBox

+ (void)initAddressPickerBox
{
    addressPickerBox = [[AddressPickerBox alloc] init];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    addressPickerBox.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [window addSubview:addressPickerBox.view];
    addressPickerBox.view.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        city = [[province objectAtIndex: row] objectForKey:@"cityVoList"];
        district = [[city objectAtIndex:0] objectForKey:@"districtVoList"];
        [_picker reloadComponent: CITY_COMPONENT];
        [_picker reloadComponent: DISTRICT_COMPONENT];
        [_picker selectRow: 0 inComponent: CITY_COMPONENT animated: NO];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: NO];
        
    }
    else if (component == CITY_COMPONENT) {
        district = [[city objectAtIndex:row] objectForKey:@"districtVoList"];
        [_picker reloadComponent: DISTRICT_COMPONENT];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: NO];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 100;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 100;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [[province objectAtIndex:row] objectForKey:@"provinceName"];
        myView.font = [UIFont systemFontOfSize:17];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [[city objectAtIndex:row] objectForKey:@"cityName"];
        myView.font = [UIFont systemFontOfSize:17];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [[district objectAtIndex:row] objectForKey:@"districtName"];
        myView.font = [UIFont systemFontOfSize:17];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}


+ (void)show:(NSString*)title client:(id<AddressPickerClient>)client event:(NSInteger)event
{
    addressPickerBox.lblTitle.text = title;
    addressPickerBox.event = event;
    addressPickerBox.addressPickerClient = client;
    [addressPickerBox.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [addressPickerBox showMoveIn];
}

+ (void)initAddress:(NSArray*)addressList pId:(NSString*)provinceId cId:(NSString*)cityId dId:(NSString*)districtId
{
    if ([NSString isBlank:provinceId]) {
        provinceId = @"0";
    }
    if ([NSString isBlank:cityId]) {
        cityId = @"0";
    }
    if ([NSString isBlank:districtId]) {
        districtId = @"0";
    }
    
    addressPickerBox->province = addressList;
    __block NSInteger provinceIndex = 0;
    __block NSInteger cityIndex = 0;
    __block NSInteger districtIndex = 0;
    __block NSArray* cityArr = nil;
    __block NSArray* districtArr = nil;
    if (![provinceId isEqualToString:@"0"]) {//0是默认值
        [addressList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* dic = obj;
            if ([provinceId isEqualToString:[dic objectForKey:@"provinceId"]]) {
                *stop = YES;
            }
            if (*stop==YES) {
                provinceIndex = idx;
                cityArr = [dic objectForKey:@"cityVoList"];
            }
        }];
        
        [cityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* dic = obj;
            if ([cityId isEqualToString:[dic objectForKey:@"cityId"]]) {
                *stop=YES;
            }
            if (*stop==YES) {
                cityIndex = idx;
                districtArr = [dic objectForKey:@"districtVoList"];
            }
        }];
        
        if ([NSString isNotBlank:districtId]) {
            [districtArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary* dic = obj;
                if ([districtId isEqualToString:[dic objectForKey:@"districtId"]]) {
                    *stop=YES;
                }
                if (*stop==YES) {
                    districtIndex = idx;
                }
            }];
        }
    }else{
    
        cityArr = [[addressList objectAtIndex:0] objectForKey:@"cityVoList"];
        districtArr = [[cityArr objectAtIndex:0] objectForKey:@"districtVoList"];
    }
    addressPickerBox->city = cityArr;
    addressPickerBox->district = districtArr;
    
    [addressPickerBox.picker reloadAllComponents];
    [addressPickerBox.picker selectRow:provinceIndex inComponent:PROVINCE_COMPONENT animated:YES];
    [addressPickerBox.picker selectRow:cityIndex inComponent: CITY_COMPONENT animated: YES];
    [addressPickerBox.picker selectRow:districtIndex inComponent: DISTRICT_COMPONENT animated: YES];
}

- (void)initAddress:(NSArray*)addressList pId:(NSString*)provinceId cId:(NSString*)cityId dId:(NSString*)districtId {
    self->province = addressList;
    __block NSInteger provinceIndex = 0;
    __block NSInteger cityIndex = 0;
    __block NSInteger districtIndex = 0;
    __block NSArray* cityArr = nil;
    __block NSArray* districtArr = nil;
    if ([NSString isNotBlank:provinceId]&&[NSString isNotBlank:cityId]) {
        [addressList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* dic = obj;
            if ([provinceId isEqualToString:[dic objectForKey:@"provinceId"]]) {
                *stop = YES;
            }
            if (*stop==YES) {
                provinceIndex = idx;
                cityArr = [dic objectForKey:@"cityVoList"];
            }
        }];
        
        [cityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* dic = obj;
            if ([cityId isEqualToString:[dic objectForKey:@"cityId"]]) {
                *stop=YES;
            }
            if (*stop==YES) {
                cityIndex = idx;
                districtArr = [dic objectForKey:@"districtVoList"];
            }
        }];
        
        if ([NSString isNotBlank:districtId]) {
            [districtArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary* dic = obj;
                if ([districtId isEqualToString:[dic objectForKey:@"districtId"]]) {
                    *stop=YES;
                }
                if (*stop==YES) {
                    districtIndex = idx;
                }
            }];
        }
        
    }else{
        
        cityArr = [[addressList objectAtIndex:0] objectForKey:@"cityVoList"];
        districtArr = [[cityArr objectAtIndex:0] objectForKey:@"districtVoList"];
    }
    self->city = cityArr;
    self->district = districtArr;
    
    [self.picker reloadAllComponents];
    [self.picker selectRow:provinceIndex inComponent:PROVINCE_COMPONENT animated:NO];
    [self.picker selectRow:cityIndex inComponent: CITY_COMPONENT animated: NO];
    [self.picker selectRow:districtIndex inComponent: DISTRICT_COMPONENT animated: NO];
}
- (void)show:(NSString*)title client:(id<AddressPickerClient>)client event:(NSInteger)event {
    self.lblTitle.text = title;
    self.event = event;
    self.addressPickerClient = client;
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self showMoveIn];
}

- (IBAction)confirmBtnClick:(id)sender
{
    BOOL flg = YES;
    NSInteger provinceIndex = [_picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSArray *tCity = [[province objectAtIndex: provinceIndex] objectForKey:@"cityVoList"];
    if (![[[city objectAtIndex:0] objectForKey:@"cityId"] isEqualToString:[[tCity objectAtIndex:0] objectForKey:@"cityId"]]) {
        flg = NO;
    }
    NSInteger cityIndex = 0;
    if (flg) {
        cityIndex = [_picker selectedRowInComponent: CITY_COMPONENT];
        NSArray *tDistrict = [[city objectAtIndex: cityIndex] objectForKey:@"districtVoList"];
        if (tDistrict.count>0&&![[[district objectAtIndex:0] objectForKey:@"districtId"] isEqualToString:[[tDistrict objectAtIndex:0] objectForKey:@"districtId"]]) {
            flg = NO;
        }
    }
    if (flg) {
        NSInteger districtIndex = [_picker selectedRowInComponent: DISTRICT_COMPONENT];
        NSMutableArray* selectArr = [NSMutableArray arrayWithCapacity:3];
        if (province.count>0) {
            [selectArr addObject:[province objectAtIndex:provinceIndex]];
        }
        if (city.count>0) {
            [selectArr addObject:[city objectAtIndex: cityIndex]];
        }
        if (district.count>0) {
            [selectArr addObject:[district objectAtIndex:districtIndex]];
        }
        [_addressPickerClient pickAddress:selectArr event:_event];
    }
    [self hideMoveOut];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

@end
