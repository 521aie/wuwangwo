//
//  TDFRootViewController+NavigationBarConfigure.h
//  Pods
//
//  Created by tripleCC on 1/16/17.
//
//

#import <UIKit/UIKit.h>

@protocol TDFNavigationClickListenerProtocol <NSObject>
@optional
- (void)viewControllerDidTriggerRightClick:(UIViewController *)viewController;
- (void)viewControllerDidTriggerLeftClick:(UIViewController *)viewController;
- (void)viewControllerDidTriggerPopAction:(UIViewController *)viewController;
@end

typedef NS_ENUM (NSInteger, TDFBackItemType) {
    TDFBackItemTypeNone,
    TDFBackItemTypeCancel, //!< 取消
    TDFBackItemTypeBack, //!<  返回
};

typedef NS_ENUM (NSInteger, TDFSureItemType) {
    TDFSureItemTypeNone,
    TDFSureItemTypeSaved, //!< 保存
    TDFSureItemTypeConfirmed, //!< 确定
};

typedef NS_ENUM(NSInteger, TDFNavigationBarType) {
    TDFNavigationBarTypeNormal, //!< 正常   <返回
    TDFNavigationBarTypeSaved, //!< 保存   x取消  ✔︎保存
    TDFNavigationBarTypeConfirmed, //!< 确定   x取消  ✔︎确定
};
@interface UIViewController (NavigationBarConfigure) <TDFNavigationClickListenerProtocol>

/**
 取消弹出警告未保存alert
 
 默认true
 */
@property (assign, nonatomic) BOOL nbc_alertUnsavedWhenCancel;


/**
 导航点击监听者
 
 默认是自己
 */
@property (weak, nonatomic) id <TDFNavigationClickListenerProtocol> nbc_listener;

/**
 tag 表示当前按钮所处类型
 */
@property (strong, nonatomic, readonly) UIButton *nbc_backButton;
@property (strong, nonatomic, readonly) UIButton *nbc_sureButton;

/**
 设置返回导航栏类型

 @param type 类型
 */
- (void)nbc_setupBackItemType:(TDFBackItemType)type;
- (void)nbc_setupBackItemWithTitle:(NSString *)title image:(UIImage *)image;

/**
 设置确定导航栏类型
 
 @param type 类型
 */
- (void)nbc_setupSureItemType:(TDFSureItemType)type;
- (void)nbc_setupSureItemWithTitle:(NSString *)title image:(UIImage *)image;

/**
 设置导航栏类型

 @param type 类型
 */
- (void)nbc_setupNavigationBarType:(TDFNavigationBarType)type;

@end
