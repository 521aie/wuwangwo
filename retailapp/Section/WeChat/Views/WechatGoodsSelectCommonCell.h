//
//  WechatGoodsSelectCommonCell.h
//  retailapp
//
//  Created by geek on 15/10/30.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WechatGoodsSelectCommonCell : UITableViewCell


// 商品名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 商品条码
@property (strong, nonatomic) IBOutlet UILabel *lblBarcode;
// 选中图标

@property (strong, nonatomic) IBOutlet UIImageView *imgCheck;

// 未选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgUnCheck;



@end