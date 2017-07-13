//
//  LSMemberInfoChartCell.h
//  retailapp
//
//  Created by taihangju on 2016/10/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMemberInfoChartCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

- (void)fill:(NSNumber *)maxMemberNum oldMemberNum:(NSNumber *)oldNum newMemberNum:(NSNumber *)newNum;
@end
