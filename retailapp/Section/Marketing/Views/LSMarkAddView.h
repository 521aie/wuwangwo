//
//  LSMarkAddView.h
//  retailapp
//
//  Created by guozhi on 2016/10/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
typedef void (^AddBlock)();
#import <UIKit/UIKit.h>
@interface LSMarkAddView : UIView
+ (instancetype)markAddView;
- (void)setText:(NSString *)text addBlock:(AddBlock)addBlock;
@end
@protocol LSMarkAddViewDelegate <NSObject>
- (void)markAddView:(LSMarkAddView *)narkAddView indexPath:(NSIndexPath *)indexPath;
@end

