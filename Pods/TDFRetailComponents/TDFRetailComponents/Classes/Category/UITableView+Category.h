//
//  UITableView+Category.h
//  UITableVIew
//
//  Created by guozhi on 2016/12/23.
//  Copyright © 2016年 guozhi. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger ,LSEmptyTableNoticeType){
//    LSEmptyTableNoticeDefault,
//    LSEmptyTableNoticeByTimeService,
//};

@interface UIScrollView (Category)

/** 没有数据的默认图片 */
@property (nonatomic, strong, readonly) UIView *defaultView;
/** 显示没有数据时的默认图片(刷新数据之后调用才有效果) */
@property (nonatomic, assign) BOOL ls_show;
/** 配置UITableView 无数据提示文字和图片 */
- (void)emptyNoticeImage:(NSString *)imageName noticeText:(NSString *)text;
@end
