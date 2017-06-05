//
//  GoodsStyleListCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleListCell.h"
#import "ListStyleVo.h"
#import "MyUILabel.h"

@implementation GoodsStyleListCell


- (void)fillStyleVoInfo:(ListStyleVo *)item {
    
    self.lblName.text = item.styleName;
    self.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@", item.styleCode];
    [self.lblName setVerticalAlignment:VerticalAlignmentTop];
    
    //暂无图片
    UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
    if (item.filePath != nil && ![item.filePath isEqualToString:@""]) {
        
        [self.img.layer setMasksToBounds:YES];
        [self.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
        NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.filePath]];
        
//        [self.img sd_setImageWithURL:url placeholderImage:placeholder];
        [self.img sd_setImageWithURL:url placeholderImage:placeholder
                             options:SDWebImageRetryFailed|SDWebImageRefreshCached];
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

@end
