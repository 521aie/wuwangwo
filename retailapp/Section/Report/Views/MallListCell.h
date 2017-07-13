//
//  MemberTransactionListCell.h
//  retailapp
//
//  Created by 果汁 on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MallTransactionListVo;
@interface MallListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCard;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
/**初始话交易记录列表数据*/
- (void)initDataWithMallTransactionListVo:(MallTransactionListVo *)item mallCard:(NSString *)mallCard;


@end
