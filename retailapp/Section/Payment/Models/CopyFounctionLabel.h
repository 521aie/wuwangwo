//
//  CopyFounctionLabel.h
//  RestApp
//
//  Created by xueyu on 16/3/31.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol CopyFounctionLabelEvent<NSObject>
@optional
-(void)copyEventFininshed;
@end
@interface CopyFounctionLabel : UILabel
@property (nonatomic,assign) id<CopyFounctionLabelEvent> delegate;

@end
