//
//  LSEditItemView.h
//  retailapp
//
//  Created by guozhi on 2017/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"

@interface LSEditItemView : EditItemBase
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *line;
/**
 初始化控件 默认宽和屏幕一样宽 高是48

 @return <#return value description#>
 */
+ (instancetype)editItemView;

/**
 设置左侧名称 和详情介绍

 @param label 左侧名称
 @param _hit 详情介绍
 */
- (void)initLabel:(NSString*)label withHit:(NSString *)_hit;


/**
 设置右侧内容

 @param data 右侧内容
 */
- (void)initData:(NSString*)data;


/**
 获取右侧内容

 @return 右侧内容
 */
- (NSString*)getStrVal;

- (void)initHit:(NSString *)hit;

@end
