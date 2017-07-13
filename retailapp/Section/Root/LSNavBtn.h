//
//  LSNavBtn.h
//  retailapp
//
//  Created by guozhi on 2017/2/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

typedef enum {
    LSNavBtnDirectLeft,
    LSNavBtnDirectRight
}LSNavBtnDirect;
#import <UIKit/UIKit.h>

@interface LSNavBtn : UIButton
+ (instancetype)navBtn:(LSNavBtnDirect)direct;
/** <#注释#> */
@property (nonatomic, assign) LSNavBtnDirect direct;

@end
