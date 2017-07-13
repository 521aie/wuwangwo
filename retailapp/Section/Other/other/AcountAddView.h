//
//  AcountInformationList.h
//  retailapp
//
//  Created by guozhi on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerBox.h"
#import "NavigateTitle2.h"

@class NavigateTitle2,FooterListView2,EditItemView,EditItemList,OtherService,EditItemText;
@interface AcountAddView : BaseViewController <INavigateEvent,IEditItemListEvent,OptionPickerClient> {
    OtherService *service;
}
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet EditItemText *txtName;
@property (weak, nonatomic) IBOutlet EditItemList *lstBank;
@property (weak, nonatomic) IBOutlet EditItemList *lstProvince;
@property (weak, nonatomic) IBOutlet EditItemList *lstCity;
@property (weak, nonatomic) IBOutlet EditItemList *lstSubBank;

@property (weak, nonatomic) IBOutlet EditItemText *txtBankNumber;
@property (nonatomic, strong) NSMutableDictionary *param;
/**唯一性*/
@property (nonatomic,copy) NSString *token;

@end
