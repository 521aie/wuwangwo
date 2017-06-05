//
//  LSShitfRecordDetailController.h
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSUserHandoverVo;
@interface LSShitfRecordDetailController : UIViewController
/**用来接受门店,由上一个页面传入*/
@property (nonatomic, copy) NSString *shopName;
/** <#注释#> */
@property (nonatomic, strong) LSUserHandoverVo *userHandoverVo;
@end
