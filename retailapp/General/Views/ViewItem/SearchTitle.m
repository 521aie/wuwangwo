//
//  SearchTitle.m
//  retailapp
//
//  Created by guozhi on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SearchTitle.h"
#import "UIView+Sizes.h"
@implementation SearchTitle

+ (instancetype)editSearchTitle{
    SearchTitle *view = [[SearchTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48)];
    [view awakeFromNib];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SearchTitle" owner:self options:nil];
    self.view.ls_width = SCREEN_W;
    [self addSubview:self.view];
    if (self.ls_height>48) {
        [self.view setLs_height:48];
        [self setLs_height:48];
    }
}

- (void)initDelegate:(id<SearchTitleDelegate>)delegate title:(NSString *)title {
    self.delegate = delegate;
    self.lblName.text = title;
    self.img.image = [UIImage imageNamed:@"ico_search_gray"];
    [self isShow:YES];
}

- (void)isShow:(BOOL)isShow {
    self.btn.hidden = !isShow;
    self.img.hidden = !isShow;
}

- (IBAction)btnClick:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showSearchEvent:)]) {
        [self.delegate showSearchEvent:self];
    }
}


@end
