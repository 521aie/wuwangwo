//
//  StyleItem.h
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StyleItemDelegate <NSObject>

@optional
- (void)inputNumber;

@end

@interface StyleItem : UIView
@property (nonatomic, weak) IBOutlet UIImageView* pic;
@property (nonatomic, weak) IBOutlet UILabel* lblName;
@property (nonatomic, weak) IBOutlet UILabel* lblStyleCode;
@property (nonatomic, weak) IBOutlet UILabel* lblPriceName;
@property (nonatomic, weak) IBOutlet UILabel* lblPrice;
@property (nonatomic, weak) IBOutlet UIButton* priceButton;
@property (nonatomic, weak) IBOutlet UIImageView* imgNext;
@property (nonatomic, weak) id<StyleItemDelegate> styleItemDelegate;
- (IBAction)onEditPriceClick:(id)sender;

+ (StyleItem *)loadFromNib;

- (void)loadDataWithPath:(NSString *)filePath withName:(NSString *)name withCode:(NSString *)code withPrice:(NSString *)price;
- (void)changeUIWithPriceName:(NSString *)priceName withPrice:(NSString *)price isEdit:(BOOL)isEdit;
- (void)initStretchWidth:(NSString *)price;
@end
