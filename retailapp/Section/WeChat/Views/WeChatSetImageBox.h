//
//  WeChatSetImageBox.h
//  retailapp
//
//  Created by diwangxie on 16/6/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "IEditItemImageEvent.h"

@interface WeChatSetImageBox : EditItemBase<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UILabel *lblAdd;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic,strong) UILabel *lblCateGoryName;
@property (nonatomic, strong) id<IEditItemImageEvent> delegate;

@property(nonatomic,strong) NSString *homePageId;
@property (nonatomic, strong) NSString *imgFilePath;
@property (nonatomic) BOOL changed;


- (id)initWithFrame:(CGRect)frame action:(NSInteger) action tag:(NSInteger)tag delegate:(id<IEditItemImageEvent>)delegate;

- (void)initBoxView:(NSString *) filePath homePageId:(NSString *)homePageId;

- (void)changeImg:(NSString *)filePath img:(UIImage*)image;

@end
