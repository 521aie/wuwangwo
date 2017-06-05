//
//  FooterListView.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface FooterListView : UIView{
    UIView *view;
}
@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIImageView *imgHelp;
@property (nonatomic, strong) IBOutlet UIButton *btnHelp;

@property (nonatomic, strong) IBOutlet UIImageView *imgBatch;
@property (nonatomic, strong) IBOutlet UIButton *btnBatch;

@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;

@property (nonatomic, strong) IBOutlet UIImageView *imgDel;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) IBOutlet UIImageView *imgSort;
@property (nonatomic, strong) IBOutlet UIButton *btnSort;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, weak) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;
-(void) showDel:(BOOL)showFlag;

- (IBAction) onBatchClickEvent:(id)sender;
- (IBAction) onAddClickEvent:(id)sender;
- (IBAction) onDelClickEvent:(id)sender;
- (IBAction) onSortClickEvent:(id)sender;
- (IBAction) onHelpClickEvent:(id)sender;

@end
