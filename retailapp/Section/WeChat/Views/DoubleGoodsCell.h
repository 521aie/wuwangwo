//
//  WeChatDoubleGoodsCell.h
//  retailapp
//
//  Created by diwangxie on 16/5/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoubleGoodsCell;

@protocol DoubleGoodsCellDelegate <NSObject>
- (void)deleteCell:(DoubleGoodsCell *)cell;
@end

@interface DoubleGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBox;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleName;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleCode;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) id<DoubleGoodsCellDelegate> delegate;

-(void)initView:(NSString *) filePath  styleName:(NSString *) styleName styleCode:(NSString *) styleCode indexPathRow:(NSInteger) pathRow delegate:(id<DoubleGoodsCellDelegate>)delegate ;
@end
