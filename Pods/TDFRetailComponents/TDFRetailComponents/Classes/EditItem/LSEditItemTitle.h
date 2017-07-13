//
//  LSEditItemTitle.h
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSEditItemTitle;
typedef void (^RightClickBlock)(LSEditItemTitle *view);

typedef NS_ENUM(NSInteger, LSEditItemTitleType) {
    LSEditItemTitleTypeOpen,   // 默认展开按钮
    LSEditItemTitleTypeClose,  // 关闭
    LSEditItemTitleTypeDown,   // 向下
};
@interface LSEditItemTitle : UIView
/** 标题名称 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;
/**
 创建标题控件

 @return LSEditItemTitle对象
 */
+ (instancetype)editItemTitle;

/**
 设置标题 这时右边是没有按钮的

 @param title 标题
 */
- (void)configTitle:(NSString *)title;


/**
 设置标题 右边有按钮及图片

 @param title 标题
 @param type 图片类型
 @param rightClickBlock 点击右边按钮回调
 */
- (void)configTitle:(NSString *)title type:(LSEditItemTitleType)type rightClick:(RightClickBlock)rightClickBlock;

- (void)visibal:(BOOL)show;
@end

