//
//  MapView.h
//  retailapp
//
//  Created by 张佳磊 on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NavigateTitle2.h"
#import "IEditItemListEvent.h"

@class MyPoint;
typedef void (^SaveBlock)(MyPoint *point);
@class NavigateTitle2;
@class ItemValue,EditItemList,EditItemText,EditItemView2;
@interface MapView : BaseViewController<INavigateEvent>
@property (strong, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
- (void)loadDataWithlatitude:(NSString *)latitude longitude:(NSString *)longitude Address:(NSString *)address saveBlock:(SaveBlock)saveBlock;
@end
