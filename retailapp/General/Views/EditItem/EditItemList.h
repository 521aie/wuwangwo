//
//  EditItemList.h
//  RestApp
//
//  Created by zxh on 14-4-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "IEditItemListEvent.h"
#import "EditItemChange.h"

@interface EditItemList : EditItemBase<EditItemChange>

@property (nonatomic, weak) id<IEditItemListEvent> delegate;

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName; /*<最左侧text，表示该条目名称*/
@property (nonatomic, strong) IBOutlet UITextField *lblVal; /*<右侧显示选择的设置内容 */
@property (nonatomic, strong) IBOutlet UILabel *lblDetail; /*<详情信息*/
@property (nonatomic, strong) IBOutlet UIImageView *imgMore; /*<最右侧图标指示更多选项*/
@property (nonatomic, strong) IBOutlet UIButton *btn;/*<响应点击事件*/
@property (nonatomic, strong) IBOutlet UIView *line;/*<底部分割线*/
@property (weak, nonatomic) IBOutlet UIImageView *imgIndent;/*<最左侧图标*/

/**默认隐藏多行时需要*/
@property (weak, nonatomic) IBOutlet UILabel *lblVal1;/*<右侧显示状态的：如必填或可选*/
//添加 附加数据
@property (nonatomic) NSInteger additionalData;
@property (nonatomic, assign) double supplyPrice;
/** lblDetail是否显示一行 默认多行 默认不显示  用于员工权限 */
@property (nonatomic, assign) BOOL isShowOneLine;
+ (instancetype)editItemList;

- (void)initHit:(NSString *)hit;

- (void)initLabel:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>)delegate;
- (void)initLabel:(NSString *)label withHit:(NSString *)hit isrequest:(BOOL)req delegate:(id<IEditItemListEvent>)delegate;
- (void)initRightLabel:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>)delegate;
- (void)initIndent:(NSString*)label withHit:(NSString *)hit isrequest:(BOOL)req delegate:(id<IEditItemListEvent>)delegate;

//fillMode时使用.
- (void)initLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString *)data;
- (void)initData:(NSString *)dataLabel withVal:(NSString *)data;
- (void)initData:(NSString *)dataLabel withVal:(NSString *)data groupVal:(NSInteger)val;
//Change时使用.
- (void)changeLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString *)data;
- (void)changeData:(NSString *)dataLabel withVal:(NSString *)data;
- (void)changeData:(NSString *)dataLabel withVal:(NSString *)data groupVal:(NSInteger) val;
//得到具体值.
- (NSString *)getStrVal;
- (NSInteger)getGroupVal;
//得到标签值.
- (NSString *)getDataLabel;

- (void)editEnable:(BOOL)enable;
- (void)initPlaceholder:(NSString *)_placeholder;

- (IBAction)btnMoreClick:(id)sender;
@end
