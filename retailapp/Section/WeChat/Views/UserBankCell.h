//
//  UserBankCell.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblBankName;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountNo;

@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

@end
