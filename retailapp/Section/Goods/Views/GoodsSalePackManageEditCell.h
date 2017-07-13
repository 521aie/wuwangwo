//
//  GoodsSalePackManageEditCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StyleVo;
@protocol GoodsSalePackManageEditCellDelegate <NSObject>

-(void) delCell:(StyleVo *) vo;

@end

@class MyUILabel;
@interface GoodsSalePackManageEditCell : UITableViewCell

// 商品名称
@property (strong, nonatomic) IBOutlet MyUILabel *lblName;
// 价格
@property (strong, nonatomic) IBOutlet UILabel *lblStyleNo;

@property (nonatomic ,strong) StyleVo *goodsStyleVo;

@property (strong , nonatomic) id<GoodsSalePackManageEditCellDelegate> delegate;

@end
