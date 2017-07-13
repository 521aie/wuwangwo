//
//  SearchView.h
//  retailapp
//
//  Created by guozhi on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchViewDelegate <NSObject>
- (void)showSearchEvent:(id)item;
@end
@interface SearchView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, assign) id<SearchViewDelegate>delegate;
- (void)initDelegate:(id<SearchViewDelegate>)delegate title:(NSString *)title;
- (void)visibal:(BOOL)show;
+ (instancetype)editSearchView;
@end
