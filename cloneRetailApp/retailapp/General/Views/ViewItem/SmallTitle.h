//
//  SmallTitle.h
//  RestApp
//
//  Created by hm on 15/1/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemBase.h"
#import "ISmallTitleEvent.h"

typedef enum MethodType{
    EXPAND_TYPE,
    MOVE_TYPE
} MethodType;

@interface SmallTitle : UIView<ItemBase>{
    UIView *view;
}
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIView *line;

@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) IBOutlet UIButton* btn;

@property (nonatomic) id<ISmallTitleEvent> delegate;
@property NSInteger event;

//仅支持单按钮.
-(void) initDelegate:(id<ISmallTitleEvent>)delegate event:(int)event title:(NSString*)titleName;

-(void) visibal:(BOOL)show;

-(IBAction) btnClick:(id)sender;

@end
