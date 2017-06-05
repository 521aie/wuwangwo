//
//  GoodsBrandLibraryManageCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsBrandLibraryManageCellDelegate <NSObject>

-(void) delCell:(int) index;

@end

@interface GoodsBrandLibraryManageCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;

@property (nonatomic, weak) id<GoodsBrandLibraryManageCellDelegate> delegate;

@property (nonatomic) int index;

-(IBAction) btnDelClick:(id)sender;

@end
