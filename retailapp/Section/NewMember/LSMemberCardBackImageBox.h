//
//  LSMemberCardBackImageBox.h
//  retailapp
//
//  Created by taihangju on 16/9/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMemberCardBackImageBox : UIControl

@property (nonatomic ,strong) UILabel *textLabel;
@property (nonatomic ,strong) UIImageView *imageView;/*<>*/
@property (nonatomic ,strong) UILabel *shopName;/* <店铺名*/
@property (nonatomic ,strong) UILabel *cardTypeName;/* <会员卡名*/
@property (nonatomic ,strong) UILabel *cardNumber;/* <会员卡编号*/
@property (nonatomic ,strong) UILabel *noticeLabel;/* <提示添加图片文字*/
@property (nonatomic ,assign) BOOL baseChangeStatus;/*<状态是否改变>*/
//@property (nonatomic ,strong) UIColor *fontColor;/* <会员卡 字体颜色*/

- (void)initTarget:(id)target method:(SEL)selector;
- (void)initFontColor:(NSString *)colorString imagePath:(NSString *)path;
- (void)changeFontColor:(NSString *)colorString imagePath:(NSString *)path;
- (void)changeFontColor:(NSString *)colorString;
- (void)set:(NSString *)shopName cardTypeName:(NSString *)cardName cardNum:(NSString *)number;
@end
