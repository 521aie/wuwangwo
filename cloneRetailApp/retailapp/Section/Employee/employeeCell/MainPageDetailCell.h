//
//  MainPageSortCell.h
//  retailapp
//
//  Created by qingmei on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ShowTypeVo;
@protocol MainPageDetailCellDelegate;


@interface MainPageDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnRadio;
@property (strong, nonatomic) IBOutlet UIImageView *imgOff;
@property (strong, nonatomic) IBOutlet UIImageView *imgOn;

@property (nonatomic, strong) ShowTypeVo *shopTpyeVo;

@property (nonatomic, weak) id<MainPageDetailCellDelegate>delegate;

- (IBAction)clickBtn:(id)sender;
+ (id)getInstance;
- (void)loadCell:(id)obj;
- (BOOL)isDataChange;
@end

@protocol MainPageDetailCellDelegate <NSObject>
- (void)clickBtnRadio:(MainPageDetailCell *)cell;
@end