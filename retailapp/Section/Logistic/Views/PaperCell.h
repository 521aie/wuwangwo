//
//  PaperCell.h
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaperCell : UITableViewCell

/**单号*/
@property (nonatomic,weak) IBOutlet UILabel * lblPaperNo;
/**状态*/
@property (nonatomic,weak) IBOutlet UILabel * lblStatus;
/**供应商名称*/
@property (nonatomic,weak) IBOutlet UILabel * lblSupplier;
/**日期*/
@property (nonatomic,weak) IBOutlet UILabel * lblDate;

@property (nonatomic,weak) IBOutlet UIImageView* nextImage;


@end
