//
//  LSMemberDataPanel1.h
//  retailapp
//
//  Created by 小龙虾 on 2017/5/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,DataPanelType1) {
    DataPanelOne,
    DataPanelTwo,
};


@interface LSMemberDataPanel1 : UIView
@property (strong, nonatomic) UILabel *title;
@property (nonatomic ,strong) UILabel *time;/*<时间>*/

+ (LSMemberDataPanel1 *)memberDataPanel:(DataPanelType1)type block:(void(^)())block;
- (void)fillData:(NSArray<NSNumber *> *)array time:(NSString *)timeString;

@end
