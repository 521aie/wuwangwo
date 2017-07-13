//
//  LSMemberElectronicCardStep2ViewController.h
//  retailapp
//
//  Created by byAlex on 16/9/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//  会员卡发卡

#import "BaseViewController.h"

// 发会员卡
@interface LSMemberElectronicCardSendViewController : BaseViewController

- (instancetype)init:(NSString *)phoneStr member:(id)vo fromPage:(BOOL)isFromDetailPage;
@end
