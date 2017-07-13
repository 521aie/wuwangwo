//
//  LSVideoItemVo.h
//  retailapp
//
//  Created by guozhi on 2017/3/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSVideoItemVo : NSObject
/** 视频标志 */
@property (nonatomic, copy) NSString *itemCode;
/** 视频名称 */
@property (nonatomic, copy) NSString *vedioName;
/** 视频路径 */
@property (nonatomic, copy) NSString *vedioUrl;
@end
