//
//  AddressPickerBox.h
//  retailapp
//
//  Created by hm on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@protocol AddressPickerClient <NSObject>

- (BOOL)pickAddress:(NSMutableArray*)selectArr event:(NSInteger)eventType;

@end

@class AppController;
@interface AddressPickerBox : PopupBoxViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *province;
    NSArray *city;
    NSArray *district;
}

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) IBOutlet UIView *pickerBackground;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (nonatomic,assign) NSInteger event;

@property (nonatomic,assign) id<AddressPickerClient> addressPickerClient;

+ (void)initAddressPickerBox;

+ (void)initAddress:(NSArray*)addressList pId:(NSString*)provinceId cId:(NSString*)cityId dId:(NSString*)districtId;

+ (void)show:(NSString*)title client:(id<AddressPickerClient>)client event:(NSInteger)event;

- (void)initAddress:(NSArray*)addressList pId:(NSString*)provinceId cId:(NSString*)cityId dId:(NSString*)districtId;
- (void)show:(NSString*)title client:(id<AddressPickerClient>)client event:(NSInteger)event;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

@end


