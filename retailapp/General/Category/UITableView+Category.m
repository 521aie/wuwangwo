//
//  UITableView+Category.m
//  UITableVIew
//
//  Created by guozhi on 2016/12/23.
//  Copyright © 2016年 guozhi. All rights reserved.
//

#import "UITableView+Category.h"

static char ls_emptyImageNameKey;
static char ls_emptyTextKey;
static char ls_emptyView;
@implementation UIScrollView (Category)

- (void)ls_addHeaderWithCallback:(void (^)())callback {
    
    [self performSelector:@selector(addHeaderWithCallback:) withObject:callback];
    
    self.headerRefreshingText = @"正在帮你刷新...";
}

- (void)ls_addFooterWithCallback:(void (^)())callback {

    [self performSelector:@selector(addFooterWithCallback:) withObject:callback];
    self.footerRefreshingText = @"正在帮你加载数据...";
}

- (void)setDefaultView:(UIView *)defaultView {
    
    objc_setAssociatedObject(self, &ls_emptyView, defaultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)defaultView {
    
    UIView *view = (UIView *)objc_getAssociatedObject(self, &ls_emptyView);
    if (view == nil) {
        view = [self generateEmptyView];
        [self setDefaultView:view];
    }
    return view;
}

/**
 tableView没有查询到数据显示的view
 */
- (UIView *)generateEmptyView {

    UIView *defaultView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //默认图片
    UIImage *image = [UIImage imageNamed:[self ls_EmptyTableNoticeImageName]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [defaultView addSubview:imageView];
    //默认图片布局
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(defaultView.centerX);
        make.centerY.equalTo(defaultView.centerY).offset(-15);
    }];
    
    //默认文字
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:12];
    lable.alpha = 0.7;
    lable.text = [self ls_EmptyTableNoticeText];
    lable.textColor = [UIColor whiteColor];
    [defaultView addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.centerX);
        make.top.equalTo(imageView.bottom).offset(20);
    }];
    
//    [defaultView layoutIfNeeded];
    return defaultView;
}

- (void)setLs_show:(BOOL)ls_show {
   
    [self.defaultView removeFromSuperview];
    
    if (ls_show) {
        
        if ([self isKindOfClass:[UITableView class]]) {
           
            UITableView *wself = (UITableView *)self;
            NSInteger sections =  wself.numberOfSections;
            NSInteger rows = 0;
            for (int i = 0; i < sections; i ++) {
                rows = rows + [wself numberOfRowsInSection:i];
            }
          
            if (rows == 0) {
                //更新位置
                self.defaultView.frame = CGRectMake(0, self.frame.size.height - SCREEN_H, self.frame.size.width, SCREEN_H);
                [self insertSubview:self.defaultView atIndex:0];
            }
        } else {

            //更新位置
            self.defaultView.frame = CGRectMake(0, self.frame.size.height - SCREEN_H, self.frame.size.width, SCREEN_H);
            [self insertSubview:self.defaultView atIndex:0];
        }
    }
}


- (BOOL)ls_show {
    return YES;
}


- (void)emptyNoticeImage:(NSString *)imageName noticeText:(NSString *)text {
    
    if (imageName.length > 0) {
        [self setLs_EmptyTableNoticeImageName:imageName];
    }
    
    if (text.length > 0) {
        [self setLs_EmptyTableNoticeText:text];
    }
}


- (void)setLs_EmptyTableNoticeImageName:(NSString *)ls_EmptyTableNoticeImageName {
    
    objc_setAssociatedObject(self, &ls_emptyImageNameKey, ls_EmptyTableNoticeImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)ls_EmptyTableNoticeImageName {
    
   NSString *imageName = objc_getAssociatedObject(self ,&ls_emptyImageNameKey);
   if (imageName) {
        return imageName;
    }
    return @"data_clear";
}


- (void)setLs_EmptyTableNoticeText:(NSString *)ls_EmptyTableNoticeText {
     objc_setAssociatedObject(self, &ls_emptyTextKey, ls_EmptyTableNoticeText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ls_EmptyTableNoticeText {
 
    NSString *text = objc_getAssociatedObject(self ,&ls_emptyTextKey);
    if (text) {
        return text;
    }
     return @"没有查询到符合条件的数据！";
}

@end
