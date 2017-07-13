//
//  LSSmsMainCell.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Notice;

@interface LSSmsMainCell : UITableViewCell
//标题
@property (nonatomic,strong)  UILabel* lblName;
//读取状态
@property (nonatomic,strong)  UILabel* lblVal;
//发布时间
@property (nonatomic,strong)  UILabel* lblDetail;
+ (instancetype)smsMainCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) Notice *obj;
@end
