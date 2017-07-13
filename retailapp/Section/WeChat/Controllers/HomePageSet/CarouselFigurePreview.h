//
//  WeChatHomeSetCarousel.h
//  retailapp
//
//  Created by diwangxie on 16/4/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,OrientationType) {
    DownOrientation = 0,
    UpOrientation
};
@interface CarouselFigurePreview : BaseViewController

- (void)callBack:(void(^)())block;
@end


@interface CarouselCollectionCell : UICollectionViewCell

/**
 *  direction : 0 向下调整 ，1 向上调整
 */
@property (nonatomic ,copy) void(^RankBlock)(CarouselCollectionCell *cell ,OrientationType direction);/* <<#desc#>*/
- (void)fill:(NSString *)imagePath isFirst:(BOOL)first isLast:(BOOL)last;
- (void)hideUpButton:(BOOL)upButtonHidden downButton:(BOOL)downButtonHidden;
@end