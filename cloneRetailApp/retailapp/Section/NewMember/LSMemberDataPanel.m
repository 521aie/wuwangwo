//
//  LSMemberDataPanel.m
//  retailapp
//
//  Created by taihangju on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberDataPanel.h"
#import "NSNumber+Extension.h"
#import "DateUtils.h"

@interface LSMemberDataPanel()

@property (nonatomic ,strong) UIControl *wrapperView;/*<wrapper>*/

//@property (strong, nonatomic) UILabel *memberNumber;
//@property (strong, nonatomic) UILabel *cardNumber;
//@property (strong, nonatomic) UILabel *memberBalance;
//@property (strong, nonatomic) UILabel *memberNumberNew;
//@property (strong, nonatomic) UILabel *orderNumber;
//@property (strong, nonatomic) UILabel *orderAmount;
@property (nonatomic ,assign) DataPanelType type;/*<>*/
@property (nonatomic ,strong) void(^callBlock)();/* <回调block*/
@property (nonatomic ,strong) NSArray *labelArray;/*<展示数据的label组成的数组>*/
@end

@implementation LSMemberDataPanel

+ (LSMemberDataPanel *)memberDataPanel:(DataPanelType)type block:(void(^)())block {
    
    CGFloat height = type == DataPanelHomePage ? 180.f : 156.f;
    LSMemberDataPanel *panel = [[LSMemberDataPanel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
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
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 8.0 + topY, sWidth - 50.0, 16.0)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    if (self.type == DataPanelSummaryPage) {
        self.title.text = @"会员信息汇总";
    }
    self.title.font = [UIFont systemFontOfSize:13.0];
    [self.wrapperView addSubview:self.title];
    topY = CGRectGetMaxY(self.title.frame);
    
    if (self.type == DataPanelSummaryPage) {
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 4.0 + topY, sWidth - 50.0, 14.0)];
        self.time.textAlignment = NSTextAlignmentCenter;
        self.time.textColor = [UIColor whiteColor];
        self.time.text = @"-";
        self.time.font = [UIFont systemFontOfSize:11.0];
        [self.wrapperView addSubview:self.time];
        topY = CGRectGetMaxY(self.time.frame);
    }
   
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10.0, topY + 10.0, sWidth - 20.0, 1.0)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.wrapperView addSubview:line];
    
    
    CGFloat sidesMarginGap = 3.0; // 水平间距，距离父view 左右边界的距离
    CGFloat verticalGap = 8.0;    // subView 竖直方向彼此积极其他view的间隔
    CGFloat subViewWidth = 100.0;
    CGFloat subViewHeight = 46.0;


    // 生成显示收益各方面信息的view, label的高度固定20.0，则上面的label距离父view上边距离（46.0-20*2）= 3.0
    int total = self.type == DataPanelHomePage ? 6:3;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:total];
    for (NSInteger index = 0; index < total ; ++index) {

        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(sidesMarginGap+(index%3)*subViewWidth ,CGRectGetMaxY(line.frame) + verticalGap+(index/3)*(subViewHeight+verticalGap), subViewWidth, subViewHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 3.0, subViewWidth, 20)];
        titleLabel.font = [UIFont systemFontOfSize:11.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = [self getSubPanelTitel:index];
        [subView addSubview:titleLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0, CGRectGetMaxY(titleLabel.frame), subViewWidth, 20)];
        numLabel.font = [UIFont systemFontOfSize:11.0];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.tag = 100 + index;
        numLabel.text = @"-";
        [subView addSubview:numLabel];
        [array addObject:numLabel];
        
        // 最右边的 没有右边界线
        if ((index+1)%3 != 0) {
            UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(subViewWidth - 0.4, 1.0, 1.0, 44.0)];
            line.backgroundColor = [UIColor whiteColor];
            line.alpha = 0.5;
            [subView addSubview:line];
        }
        
        [self.wrapperView addSubview:subView];
    }
    self.labelArray = [array copy];
}

// array 中的数据顺序要对应label进行设置
- (void)fillData:(NSArray<NSNumber *> *)array time:(NSString *)date {
    
    if (date) {

        NSString *yesterday = [DateUtils getDateString:[DateUtils getTimeSinceNow:-24*60*60] format:@"yyyyMMdd"];
        // “yyyyMMdd” 格式时间转为 “yyyy年MM月dd天” 格式
        NSString *dateString = [DateUtils getDateString:[DateUtils getDate:date format:@"yyyyMMdd"] format:@"yyyy年MM月dd日"];
        if (self.type == DataPanelHomePage) {
            self.title.text = [NSString stringWithFormat:@"昨日会员信息汇总(%@)",[DateUtils getDateString:[DateUtils getDate:yesterday format:@"yyyyMMdd"] format:@"yyyy年MM月dd日"]];
        }else{
            if ([yesterday isEqualToString:date]) {
                self.title.text = [NSString stringWithFormat:@"昨日会员信息汇总(%@)" ,dateString];
            } else {
                self.title.text = [NSString stringWithFormat:@"会员信息汇总(%@)" ,dateString];
            }
        }
    }
    if (self.type ==  DataPanelHomePage) {
        [self.labelArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ((obj.tag - 100 == 2) || (obj.tag - 100 == 5)) {
                obj.text = [NSString stringWithFormat:@"%.2f" ,[array objectAtIndex:obj.tag-100].floatValue];
            }
            else {
                obj.text = [[array objectAtIndex:obj.tag-100] stringValue];
            }
        }];
    }else{
        [self.labelArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.text = [[array objectAtIndex:idx+3] stringValue];
        }];
    }
}

- (NSString *)getSubPanelTitel:(NSInteger)index {
    
    if (self.type == DataPanelHomePage) {
        switch (index) {
            case 0:
                return @"会员总数 (人)";
                break;
            case 1:
                return @"发卡总数（张）";
                break;
            case 2:
                return @"会员储蓄余额 (元)";
                break;
            case 3:
                return @"新增会员 (人)";
                break;
            case 4:
                return @"新发卡数 (张)";
                break;
            case 5:
                return @"充值金额 (元)";
                
#warning “jicika"
//                return @"储值充值金额 (元)";
                break;
            default:
                break;
        }
    }else{
        switch (index) {
            case 0:
                return @"新增会员 (人)";
                break;
            case 1:
                return @"新发卡数 (张)";
                break;
            case 2:
                return @"充值金额 (元)";
                
#warning “jicika"
//                return @"储值充值金额 (元)";
                break;
            default:
                break;
        }
    }
    return @"";
}

//- (NSString *)getTitleContent {
//    
//   NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
//   return [NSString stringWithFormat:@"(%@)" ,[DateUtils formateShortChineseDate:date]];
//}


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
