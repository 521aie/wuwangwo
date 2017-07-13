//
//  WeChatImageBox.h
//  retailapp
//
//  Created by diwangxie on 16/6/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "IEditItemImageEvent.h"

@class WeChatImageBox;
@protocol EditItemImageDelegate <NSObject>
- (void)editItemImage:(WeChatImageBox *)item;
@optional;
- (void)itemImageDownloadSuccess:(WeChatImageBox *)item;
@end

@interface WeChatImageBox : EditItemBase<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UILabel *lblAdd;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) UILabel *lblCateGoryName;
@property (nonatomic, strong) id<EditItemImageDelegate> delegate;

@property(nonatomic,strong) NSString *homePageId;

- (id)initWithFrame:(CGRect)frame action:(NSInteger) action tag:(NSInteger)tag delegate:(id<EditItemImageDelegate>)delegate;
-(void)initBoxView:(NSString *) filePath homePageId:(NSString *)homePageId;
-(void)initBoxViewToCornerRadius:(NSString *)cateGoryName;
@end
