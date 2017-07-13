//
//  LSMemberDataPanel.h
//  retailapp
//
//  Created by ; on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,DataPanelType) {
    DataPanelHomePage,       // 会员首页 会员信息汇总
    DataPanelSummaryPage,    // 会员信息汇总页面
};
@interface LSMemberDataPanel : UIView

@property (strong, nonatomic) UILabel *title;
@property (nonatomic ,strong) UILabel *time;/*<时间>*/

+ (LSMemberDataPanel *)memberDataPanel:(DataPanelType)type block:(void(^)())block;
- (void)fillData:(NSArray<NSNumber *> *)array time:(NSString *)timeString;
@end

