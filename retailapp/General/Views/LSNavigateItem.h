//
//  LSNavigateItem.h
//  retailapp
//
//  Created by taihangju on 16/8/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

// LSNavigateItem 高度48.0f 以上 ， 下面@1和 情况二选一
@interface LSNavigateItem : UIControl

// @1 有主副两个标题，一上一下
@property (nonatomic, strong) UILabel *headLabel;/*<标题说明栏>*/
@property (nonatomic, strong) UILabel *assistantLabel;/*<副标题说明>*/

// @2 单一一行标题
@property (nonatomic, strong) UILabel *singleLabel;/*<单一行文字说明>*/

@property (nonatomic, strong) UIImageView *indicateImageView;/*<指示imageView>*/
@property (nonatomic ,strong) UIView *bottomLine;/*<底部分割线>*/

// 创建@1 情形的 LSNavigateItem
+ (LSNavigateItem *)createItem:(NSString *)headText assisantText:(NSString *)assisantText;

// 创建@2 情形的LSNavigateItem
+ (LSNavigateItem *)createItem:(NSString *)singleText;
@end

