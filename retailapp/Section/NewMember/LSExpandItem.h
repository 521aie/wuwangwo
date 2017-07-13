//
//  LSExpandItem.h
//  retailapp
//
//  Created by taihangju on 2016/10/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSExpandItem : UIView

@property (nonatomic ,strong) UILabel *leftLabel;/*<>*/
@property (nonatomic ,strong) UILabel *rightLabel;/*<>*/
@property (nonatomic ,strong) UIImageView *arrowImageView;/*<>*/

+ (instancetype)expandItem:(id)targert selector:(SEL)method;
@end
