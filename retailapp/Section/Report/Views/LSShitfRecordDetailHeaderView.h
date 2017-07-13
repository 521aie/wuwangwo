//
//  LSShitfRecordDetailHeaderView.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/2.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSUserHandoverVo;

@interface LSShitfRecordDetailHeaderView : UIView
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, strong) LSUserHandoverVo *userHandoverVo;

+ (instancetype)shitfRecordDetailHeaderView;
- (void)setShiftHeader :(LSUserHandoverVo *)obj ;
@end
