//
//  SellRetrunBrachBankList.h
//  retailapp
//
//  Created by diwangxie on 16/5/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "OptionPickerBox.h"
#import "MenuListCell.h"

@interface SellRetrunBrachBankList : BaseViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient>

typedef void(^BrachBankList)(MenuListCell *cell,NSString *ProvinceName,NSString *ProvinceId,NSString *CityName,NSString *CityId);

@property (nonatomic,copy) BrachBankList brachBankListBlock;

- (void)loadBrachBankList:(NSInteger)viewType callBack:(BrachBankList)callBack;


@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (weak, nonatomic) IBOutlet EditItemList *lsProvince;
@property (weak, nonatomic) IBOutlet EditItemList *lsCity;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;

//银行代号
@property (nonatomic,strong) NSString *bankId;

@property (nonatomic,strong) NSString *ProvinceName;
@property (nonatomic,strong) NSString *ProvinceId;
@property (nonatomic,strong) NSString *CityName;
@property (nonatomic,strong) NSString *CityId;

@property (nonatomic, strong) NSMutableArray *datas;

@end
