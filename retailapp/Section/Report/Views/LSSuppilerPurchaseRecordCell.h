//
//  LSSuppilerPurchaseRecordCell.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSSuppilerPurchaseVo;

@interface LSSuppilerPurchaseRecordCell : UITableViewCell
@property (nonatomic, strong) LSSuppilerPurchaseVo *obj;
+ (instancetype)suppilerPurchaseDetailCellWithTableView:(UITableView *)tableView;
/** 商品名称 */
@property (nonatomic, strong) UILabel *lblGoodsName;
/** 条形码店内码 */
@property (nonatomic, strong) UILabel *lblCode;
/** 计算cell高度 */
+ (CGFloat)heightForContent:(NSString *)content;
@end
