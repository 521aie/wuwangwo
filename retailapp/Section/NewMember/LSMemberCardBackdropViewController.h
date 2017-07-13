//
//  LSMemberCardBackdropViewController.h
//  retailapp
//
//  Created by byAlex on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

// 会员卡 背景图列表
@interface LSMemberCardBackdropViewController : BaseViewController

@property (nonatomic ,copy) void(^selectImage)(UIImage *image ,NSString *imagePath ,id obj);

- (instancetype)init:(NSDictionary *)cardInfoDic;
@end
