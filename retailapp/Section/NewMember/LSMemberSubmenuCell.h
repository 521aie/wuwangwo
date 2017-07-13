//
//  LSMemberSubmenuCell.h
//  retailapp
//
//  Created by taihangju on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMemberSubmenuCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *iconImageView;/*<>*/
@property (nonatomic ,strong) UIImageView *lockImageView;/*<>*/
@property (nonatomic ,strong) UILabel *title;/*<>*/

- (void)fill:(NSString *)image title:(NSString *)title action:(NSString *)actionCode;
@end
