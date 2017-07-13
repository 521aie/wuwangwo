//
//  LSBarCodeIdentificationCell.h
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSBarCodeMark.h"
@interface LSBarCodeIdentificationCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSBarCodeMark *obj;
+ (instancetype)barCodeIdentificationCellWithTableView:(UITableView *)tableView;
@end
