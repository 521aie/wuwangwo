//
//  LSEditItemList.h
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "IEditItemListEvent.h"

@interface LSEditItemList : EditItemBase
/** 左侧名称 */
@property (nonatomic, strong) UILabel *lblName;
/** 右侧内容 */
@property (nonatomic, strong) UITextField *lblVal;
/** 右侧内容默认不显示多行显示时需要 */
@property (nonatomic, strong) UILabel *lblVal1;
/** 详情描述 */
@property (nonatomic, strong) UILabel *lblDetail;
/** 右侧图标 */
@property (nonatomic, strong) UIImageView *imgMore;
/** 分割线 */
@property (nonatomic, strong) UIView *line;
@property (nonatomic, weak) id<IEditItemListEvent> delegate;

/**
 初始化控件

 @return 初始化控件
 */
+ (instancetype)editItemList;

/**
 赋值默认是非必填的

 @param label 左边名称
 @param hit 详情
 @param delegate 详情
 */
- (void)initLabel:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>)delegate;

/**
 赋值

 @param label 左边名称
 @param hit 详情
 @param req 是否必填
 @param delegateTmp 详情
 */
- (void)initLabel:(NSString *)label withHit:(NSString *)hit isrequest:(BOOL)req delegate:(id<IEditItemListEvent>)delegateTmp;

/**
 给右边内容赋值 右边内容分为 name Id

 @param dataLabel 内容name
 @param data 内容Id id和上次的不一样时不会显示未保存按钮
 */
- (void)initData:(NSString *)dataLabel withVal:(NSString *)data;
/**
 给右边内容赋值 右边内容分为 name Id
 
 @param dataLabel 内容name
 @param data 内容Id id和上次的不一样时会显示未保存按钮
 */
- (void)changeData:(NSString *)dataLabel withVal:(NSString *)data;

/**
 获取内容Id

 @return Id
 */
- (NSString *)getStrVal;

/**
 获取内容name

 @return name
 */
- (NSString *)getDataLabel;

/**
 是否可以编辑

 @param enable YES 可以编辑  NO 编辑
 */
- (void)editEnable:(BOOL)enable;

- (void)initHit:(NSString *)hit;
@end
