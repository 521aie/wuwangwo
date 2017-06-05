//
//  OptionPickerBox.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionPickerClient.h"
#import "PopupBoxViewController.h"

@interface OptionPickerBox : PopupBoxViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    __weak  id<OptionPickerClient> optionPickerClient;
    
    NSArray *strData;
    
    NSArray *objData;
    
    NSInteger event;
}

@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) IBOutlet UIView *pickerBackground;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) IBOutlet UIButton* btnManager;
@property (nonatomic, strong) IBOutlet UILabel *lblManager;
@property (nonatomic, strong) IBOutlet UIImageView* imgManager;

+ (void)initData:(NSArray *)data itemId:(NSString *)itemId;

+ (void)initOptionPickerBox;

//不显示管理页.
+ (void)show:(NSString *)title client:(id<OptionPickerClient>)client event:(NSInteger)event;

//显示带管理按钮的页.
+ (void)showManager:(NSString *)title managerName:(NSString*)managerName client:(id<OptionPickerClient>) client event:(NSInteger)event;
/**
 显示清空的按钮
 
 @param title     标题
 @param client    代理
 @param event     弹出带清空按钮的选择
 */
+ (void)showClearTitle:(NSString *)title client:(id<OptionPickerClient>) client event:(NSInteger)event;

+ (void)hide;

+(void) changeImgManager:(NSString *) imgStr;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)managerBtnClick:(id)sender;

@end

