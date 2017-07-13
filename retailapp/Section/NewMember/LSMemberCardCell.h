//
//  LSMemberCardCell.h
//  retailapp
//
//  Created by byAlex on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSMemberCardVo;
@interface LSMemberCardCell : UICollectionViewCell

- (void)fillCardBackgroundImageVo:(NSString *)imagePath cardInfo:(NSDictionary *)cardInfo;
- (void)fillMemberCardVo:(LSMemberCardVo *)cardVo type:(NSInteger)type;
@end
