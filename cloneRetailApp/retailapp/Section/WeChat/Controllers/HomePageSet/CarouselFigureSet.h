//
//  WeChatHomeSetCarouselSet.h
//  retailapp
//
//  Created by diwangxie on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "EditItemRadio.h"
#import "EditItemCorrelation.h"
#import "EditItemAddCorrelation.h"
#import "EditItemList3.h"
#import "TZImagePickerController.h"
#import "MHImagePickerMutilSelector.h"

#import "WeChatSetImageBox.h"

@interface CarouselFigureSet : BaseViewController

- (void)setHomepageId:(NSString *)pageId callBack:(void(^)())block;
@end
