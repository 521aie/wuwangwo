//
//  MemberTypeCell.h
//  RestApp
//
//  Created by zhangzhiliang on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTypeCell : UITableViewCell<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UILabel *lblMemberTypeName; /*<会员卡类型名称>*/
@property (nonatomic, strong) IBOutlet UILabel *lblMemberTypeDiscount; /*<会员卡折扣>*/

- (void)setCardName:(NSString *)name primedRate:(NSString *)rate;
@end
