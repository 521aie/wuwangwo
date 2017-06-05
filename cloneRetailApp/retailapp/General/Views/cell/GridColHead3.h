//
//  GridColHead3.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#define LEFT 1
#define RIGHT 2

#import <UIKit/UIKit.h>

@protocol GridColHead3Delegate <NSObject>

- (void)pressLeftButton;

- (void)pressRightButton;

@end

@interface GridColHead3 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnGoods;

@property (strong, nonatomic) IBOutlet UIButton *btnStyle;

@property (strong, nonatomic) IBOutlet UIImageView *leftImgView;

@property (strong, nonatomic) IBOutlet UIImageView *rightImgView;

@property (nonatomic,strong) id<GridColHead3Delegate> delegate;

- (void)changeStatus:(short) type;

@end
