//
//  DatePickerView.h
//  RestApp
//
//  Created by guozhi on 16/8/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerView;
@protocol DatePickerViewEvent<NSObject>
-(void)pickerOption:(DatePickerView *)obj eventType:(NSInteger)evenType;
@end
@interface DatePickerView : UIView
@property(nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, assign)id<DatePickerViewEvent>delegate;
@property (nonatomic, assign) NSUInteger year;
@property (nonatomic, assign) NSUInteger month;
/** <#注释#> */
@property (nonatomic, assign) int minYear;
- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title client:(id<DatePickerViewEvent>)delegate;
-(void)initDate:(NSUInteger)year month:(NSUInteger)month;

@end
