//
//  LSMemberAccessView.h
//  retailapp
//
//  Created by byAlex on 16/9/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,MBAccessViewType) {
    MBAccessCardsInfoDetailPage, //会员所有卡 及信息(可显示"重发此卡按钮")
    MBAccessCardsInfo, // 会员所有卡 及信息
    MBAccessFunctions, // 会员相关功能
};
@class LSMemberCardVo;
@protocol MBAccessViewDelegate;
@interface LSMemberAccessView : UIView

+ (instancetype)memberAccessView:(MBAccessViewType)type delegate:(id<MBAccessViewDelegate>)delegate;
/**
 * page 是初始化后显示的page
 */
- (void)setCardDatas:(NSArray<LSMemberCardVo *> *)array initPage:(NSInteger)page;
@end

@protocol MBAccessViewDelegate <NSObject>

@optional;
// 滑动停止时显示的当前的page, 用以多会员卡时
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj;

// 点击指定的功能点
- (void)memberAccessView:(LSMemberAccessView *)view tapFunction:(id)obj;

// 重新发已经删除的卡
- (void)memberAccessView:(LSMemberAccessView *)view reSendCard:(id)cardVo;
@end
