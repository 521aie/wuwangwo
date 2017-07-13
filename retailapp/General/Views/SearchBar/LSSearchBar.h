//
//  LSSearchBar.h
//  retailapp
//
//  Created by guozhi on 16/8/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSSearchBarDelegate;
@interface LSSearchBar : UIView

/**
 *  设置代理 用来监听扫一扫 和文本框输入事件
 */
@property (nonatomic, weak) id<LSSearchBarDelegate> delegate;
/**
 *  设置搜索框默认的提示文字
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  设置文本框内容
 */
@property (nonatomic, copy) NSString *searchCode;
/**
 *  设置搜索框输入的文本长度 默认是50
 */
@property (nonatomic, assign) int maxLength;
/**
 *  搜索框
 */
@property (nonatomic, strong) UITextField *txtField;

/**
 *  创建一个搜索框对象
 *
 *  @return 搜索框
 */
+ (instancetype)searchBar;
@end


@protocol LSSearchBarDelegate <NSObject>
@optional
// 输入完成
- (void)searchBarImputFinish:(NSString *)keyWord;
// 开始扫描
- (void)searchBarScanStart;
@end
