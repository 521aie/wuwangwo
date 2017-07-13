//
//  SearchView.m
//  retailapp
//
//  Created by guozhi on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SearchView.h"
#import "UIView+Sizes.h"

@implementation SearchView

+ (instancetype)editSearchView{
    SearchView *view = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 88)];
    [view awakeFromNib];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:self options:nil];
    self.view.ls_width = [UIScreen mainScreen].bounds.size.width;
    [self addSubview:self.view];
    if (self.ls_height>88) {
        [self.view setLs_height:88];
        [self setLs_height:88];
    }
}

- (void)initDelegate:(id<SearchViewDelegate>)delegate title:(NSString *)title {
    self.lblVal.text = title;
    self.img.image = [UIImage imageNamed:@"ico_search_red"];
    self.delegate = delegate;
    
}
- (IBAction)btnClick:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showSearchEvent:)]) {
        [self.delegate showSearchEvent:self];
    }
}

- (void)visibal:(BOOL)show {
    [self setLs_height:show?88:0];
    self.hidden = !show;
}




@end
