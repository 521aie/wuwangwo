//
//  SearchTitle.h
//  retailapp
//
//  Created by guozhi on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchTitleDelegate <NSObject>
- (void)showSearchEvent:(id)item;
@end
@interface SearchTitle : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, assign) id<SearchTitleDelegate>delegate;

+ (instancetype)editSearchTitle;
/**title 标题*/
- (void)initDelegate:(id<SearchTitleDelegate>)delegate title:(NSString *)title;
/**title 是否显示右侧的搜索按钮*/
- (void)isShow:(BOOL)isShow;
@end
