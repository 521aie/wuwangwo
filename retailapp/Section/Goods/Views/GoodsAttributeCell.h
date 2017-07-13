//
//  GoodsAttributeCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class AttributeValVo;
@interface GoodsAttributeCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;

@property (nonatomic, strong) IBOutlet UILabel *lblCode;

@property (nonatomic, strong) AttributeValVo* attributeValVo;

@property (nonatomic, strong) NSString* event;

@property (nonatomic, strong) id<ISampleListEvent> delegate;

@end
