//
//  EditItemList2.h
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditItemList4 : UIView
@property (nonatomic, weak) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleCode;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleName;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleAttribute;
@property (weak, nonatomic) IBOutlet UILabel *lblFeeAndCount;
@property (weak, nonatomic) IBOutlet UILabel *lblReturnState;

- (void)initFromNib;
- (void)initCode:(NSDictionary *)dic;
@end
