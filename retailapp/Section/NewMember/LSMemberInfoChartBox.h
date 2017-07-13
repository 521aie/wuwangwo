//
//  LSMemberInfoChartBox.h
//  retailapp
//
//  Created by taihangju on 2016/10/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSMemberInfoChartBoxDelegate;
@interface LSMemberInfoChartBox : UIView

@property (nonatomic ,strong) id currentData;/*<当前选择日期对应的数据model>*/

+ (instancetype)memberInfoChartBox:(id<LSMemberInfoChartBoxDelegate>)delegate;
- (void)setData:(NSArray *)dataSource memberNum:(NSNumber *)num startPage:(NSInteger)page;
@end

@protocol LSMemberInfoChartBoxDelegate <NSObject>

- (NSString *)memberInfoChartBox:(LSMemberInfoChartBox *)box page:(NSInteger)index;
@optional
- (void)memberInfoChartBox:(LSMemberInfoChartBox *)box select:(id)obj;
@end
