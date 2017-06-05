//
//  ViewFactory.m
//  retailapp
//
//  Created by hm on 15/7/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ViewFactory.h"
#import "UIView+Sizes.h"
#import "ImageUtils.h"

@implementation ViewFactory
+ (UIView *)generateFooter:(CGFloat)height
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

+ (UIView *)backgroundOfTableView:(UITableView *)table
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, table.ls_height)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tablebg.png"]];
    return view;
}

+ (UIView *)setTableViewOfClear:(UITableView *)table
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 88)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

+ (void)clearTableView:(UITableView *)table
{
    table.tableFooterView = [ViewFactory setTableViewOfClear:table];
}

+ (UIView *)setClearView:(CGRect)frame
{
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    clearView.backgroundColor = [UIColor clearColor];
    
    //默认图片
    UIImage *image = [UIImage imageNamed:@"data_clear"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [clearView addSubview:imageView];
    //默认图片布局
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(clearView.centerX);
        make.top.equalTo(clearView.top);
    }];
    [clearView layoutIfNeeded];
    //默认文字
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:12];
    lable.alpha = 0.7;
    lable.text = @"没有查询到符合条件的数据！";
    lable.textColor = [UIColor whiteColor];
    [clearView addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.centerX);
        make.top.equalTo(imageView.bottom).offset(20);
    }];
    [clearView layoutIfNeeded];
    CGFloat y = (frame.size.height - lable.ls_bottom)/2 - 40;
    [imageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clearView.top).offset(y);
    }];
    
    return clearView;
}

@end
