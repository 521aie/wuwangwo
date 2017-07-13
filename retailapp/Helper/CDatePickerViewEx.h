//
//  CDatePickerViewEx.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;
-(void)selectToday;

@property (nonatomic, strong) NSString *year;

@end
