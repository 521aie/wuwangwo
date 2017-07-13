//
//  ModuleConfigView.h
//  retailapp
//
//  Created by taihangju on 16/6/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfoVO.h"
typedef NS_ENUM(NSInteger ,ModuleConfigType){
    ModuleDailyRun = 0, // 日常运维
    ModuleBackgroundSet // 后台设置
};

@protocol ModuleConfigViewDelegate;
@interface ModuleConfigView : UIView

@property (nonatomic, weak) id<ModuleConfigViewDelegate> delegate;/*<代理为了响应>*/
@property (nonatomic, assign) CGFloat totalHeight;  /*<ModuleConfigView对象初始化完成后自身的高度>*/
@property (nonatomic, strong) NSArray *modules;/*<日常运维或后台设置部分功能细分模块>*/
/**
 *  请使用该方法进行初始化
 *
 *  @param modules 某一功能模块下的小分类列表，如“日常运维”、“后台设置”
 *  @param title   如“日常运维”、“后台设置”
 *  @param agent   响应点击事件的对象
 *  @return 返回初始化了模块分类的对象
 */
- (instancetype)init:(ModuleConfigType)type top:(CGFloat)topY title:(NSString *)title owner:(id)agent shopInfoVo:(ShopInfoVO *)shopInfoVO;
@end


@interface ModuleView : UIView

@property (nonatomic, strong) UIButton* button;  /*<相应点击事件的button>*/
@property (nonatomic, strong) UIImageView *limitImageView;/*<当前用户是否有权限指示image>*/
/**
 *  根据参数创建ModuleView对象
 *
 *  @param imageName 图片名
 *  @param title     标题
 *  @param frame     ModuleView对象的frame
 *
 *  @return 初始化完成的ModuleView对象
 */
+ (ModuleView *)creatModule:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame;
@end


@protocol ModuleConfigViewDelegate <NSObject>

@required
/**
 *  ModuleConfigView实例的子view(ModuleView 对象)被选中通过该代理方法通知实现了该协议方法的代理对象
 *
 *  @param view ModuleConfigView 实例
 *  @param code 点击的ModuleView 对象所对应的数据项(业务)，指示界面跳转到指定的控制器
 */
- (void)moduleConfigView:(ModuleConfigView *)view action:(NSString *)code actionName:(NSString *) item;
@end
