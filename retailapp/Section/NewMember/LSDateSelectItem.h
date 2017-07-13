//
//  LSDateSelectItem.h
//  retailapp
//
//  Created by taihangju on 2016/10/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSDateSelectItem : UIView

@property (nonatomic ,strong) UILabel *label;/*<>*/
+ (LSDateSelectItem *)dateSelectItem:(id)target selecter:(SEL)method;
@end
