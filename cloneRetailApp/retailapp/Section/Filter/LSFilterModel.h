//
//  LSFilterModel.h
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSFilterItem.h"
@class LSFilterCell;
typedef NS_ENUM(NSInteger, LSFilterModelType) {
    LSFilterModelTypeDefult,//在当前页面进行点击选择不跳转页面也不弹出选择框
    LSFilterModelTypeRight,//点击后进入下一个页面
    LSFilterModelTypeBottom,//点击后从下方弹出一个选择框
  
};
@interface LSFilterModel : NSObject
/** 点击跳转方式 */
@property (nonatomic, assign) LSFilterModelType type;
/** 数据源 */
@property (nonatomic, strong) NSArray<LSFilterItem *> *items;
/** 当前选中的对象 */
@property (nonatomic, strong) LSFilterItem *selectItem;
/** 默认的对象 */
@property (nonatomic, strong) LSFilterItem *oldSelectItem;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 记录数据源对应的单元格防止循环引用 */
@property (nonatomic, weak) LSFilterCell *cell;
/** 单元格高度 */
@property (nonatomic, assign) CGFloat height;
+ (instancetype)filterModel:(LSFilterModelType)type items:(NSArray<LSFilterItem *> *)items selectItem:(LSFilterItem *)selectItem title:(NSString *)title;
- (void)initData:(NSString *)itemName withVal:(NSString *)itemId;
- (NSString *)getSelectItemName;
- (NSString *)getSelectItemId;
@end
