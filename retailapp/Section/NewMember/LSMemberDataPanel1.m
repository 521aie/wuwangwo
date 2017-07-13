//
//  LSMemberDataPanel1.m
//  retailapp
//
//  Created by 小龙虾 on 2017/5/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberDataPanel1.h"
#import "NSNumber+Extension.h"
#import "DateUtils.h"

@interface LSMemberDataPanel1 ()
@property (nonatomic ,strong) UIControl *wrapperView;/*<wrapper>*/
@property (nonatomic ,assign) DataPanelType1 type;/*<>*/
@property (nonatomic ,strong) void(^callBlock)();/* <回调block*/
@property (nonatomic ,strong) NSArray *labelArray;/*<展示数据的label组成的数组>*/
@property (nonatomic, strong) UIImageView *arrImg;/*<向右箭头>*/
@end

@implementation LSMemberDataPanel1

+(LSMemberDataPanel1 *)memberDataPanel:(DataPanelType1)type block:(void (^)())block
{
    LSMemberDataPanel1 *panel = [[LSMemberDataPanel1 alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 130)];
    panel.callBlock = block;
    panel.type = type;
    panel.backgroundColor = [UIColor clearColor];
    [panel configSubViews];
    return panel;
}

- (void)configSubViews {
    
    // wrapperView 距离左右边界各8point，上下15point
    self.wrapperView = [[UIControl alloc] initWithFrame:CGRectInset(self.bounds, 10.0, 15.0)];
    self.wrapperView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.wrapperView.layer.masksToBounds = YES;
    self.wrapperView.layer.cornerRadius = 6.0f;
    [self addSubview:self.wrapperView];
    if (self.callBlock) {
        [self.wrapperView addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.wrapperView.userInteractionEnabled = NO;
    }
    
    CGFloat sWidth = CGRectGetWidth(self.wrapperView.bounds);
    CGFloat topY = 0.0;
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(10.0, topY+4.0, sWidth - 20.0, 26.0)];
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.textColor = [UIColor whiteColor];
    self.title.text = @"会员信息汇总";
    self.title.font = [UIFont systemFontOfSize:15.0];
    [self.wrapperView addSubview:self.title];
    
    self.arrImg = [[UIImageView alloc] initWithFrame:CGRectMake(sWidth-32, 6.0+topY, 22, 22)];
    [self.arrImg setImage:[UIImage imageNamed:@"ico_next_w"]];
    [self.wrapperView addSubview:self.arrImg];
    if (self.type != DataPanelOne) {
        self.arrImg.hidden = YES;
    }
    
    topY = CGRectGetMaxY(self.title.frame);
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10.0, topY+4.0, sWidth - 20.0, 1.0)];
    line.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    [self.wrapperView addSubview:line];
    
    
    CGFloat sidesMarginGap = 10.0; // 水平间距，距离父view 左右边界的距离
    CGFloat verticalGap = 8.0;    // subView 竖直方向彼此积极其他view的间隔
    CGFloat subViewWidth = (self.wrapperView.frame.size.width-20)/3;
    CGFloat subViewHeight = 46.0;
    
    
    // 生成显示收益各方面信息的view, label的高度固定20.0，则上面的label距离父view上边距离（46.0-20*2）= 3.0
    int total = 3;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:total];
    for (NSInteger index = 0; index < total ; ++index) {
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(sidesMarginGap+(index%3)*subViewWidth ,CGRectGetMaxY(line.frame) + verticalGap+(index/3)*(subViewHeight+verticalGap), subViewWidth, subViewHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 3.0, subViewWidth, 20)];
        titleLabel.font = [UIFont systemFontOfSize:10.0];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = [self getSubPanelTitel:index];
        [subView addSubview:titleLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(titleLabel.frame), subViewWidth, 20)];
        numLabel.font = [UIFont systemFontOfSize:15.0];
        numLabel.textAlignment = NSTextAlignmentLeft;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.tag = 100 + index;
        numLabel.text = @"-";
        [subView addSubview:numLabel];
        [array addObject:numLabel];
        
        // 最右边的 没有右边界线
        if ((index+1)%3 != 0) {
            UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(subViewWidth - 10.0, 0.5, 1.0, 44.0)];
            line.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2];
            [subView addSubview:line];
        }
        
        [self.wrapperView addSubview:subView];
    }
    self.labelArray = [array copy];
}

// array 中的数据顺序要对应label进行设置
- (void)fillData:(NSArray<NSNumber *> *)array time:(NSString *)date {
    
    if (date) {
        // “yyyyMMdd” 格式时间转为 “yyyy年MM月dd天” 格式
        NSString *dateString = [DateUtils getDateString:[DateUtils getDate:date format:@"yyyyMMdd"] format:@"yyyy年MM月dd日"];
        if (self.type == DataPanelOne) {
            self.title.text = [NSString stringWithFormat:@"会员信息汇总(%@)",dateString];
            [self.labelArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //金额处理
                NSString *sText = [[array objectAtIndex:idx+3] stringValue];
                if (idx+3 == 5) {
                    sText = [NSString stringWithFormat:@"%.2f",[[array objectAtIndex:idx+3] floatValue]];
                }
                obj.text = sText;
            }];
        }else{
            self.title.text = [NSString stringWithFormat:@"会员信息汇总(截止到昨日)"];
            [self.labelArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //金额处理
                NSString *sText = [[array objectAtIndex:idx] stringValue];
                if (idx == 2) {
                    sText = [NSString stringWithFormat:@"%.2f",[[array objectAtIndex:idx] floatValue]];
                }
                obj.text = sText;
            }];
        }
    }
}


- (NSString *)getSubPanelTitel:(NSInteger)index {
    
    if (self.type == DataPanelOne) {
        switch (index) {
            case 0:
                return @"新增会员 (人)";
                break;
            case 1:
                return @"新发卡数（张）";
                break;
            case 2:
                return @"充值金额 (元)";
                break;
            default:
                break;
        }
    }else{
        switch (index) {
            case 0:
                return @"会员总数 (人)";
                break;
            case 1:
                return @"发卡总数 (张)";
                break;
            case 2:
                return @"会员储值余额 (元)";
                break;
            default:
                break;
        }
    }
    return @"";
}

- (void)tapAction {
    
    if (self.callBlock) {
        self.callBlock();
    }
}

- (void)dealloc {
    
    if (self.callBlock) {
        [self.wrapperView removeTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    self.callBlock = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.wrapperView pointInside:point withEvent:event]) {
        return self.wrapperView;
    }
    return nil;
}

@end
