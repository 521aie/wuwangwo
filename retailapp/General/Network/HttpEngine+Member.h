//
//  HttpEngine+Member.h
//  retailapp
//
//  Created by taihangju on 16/9/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "HttpEngine.h"

@interface HttpEngine (Member)

// 会员模块上传图片
+ (void)mb_upLoadImage:(NSString *)path param:(NSDictionary *)param imageData:(NSArray *)imageList CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;
@end
