//
//  SearchBar3.h
//  retailapp
//
//  Created by hm on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"

@interface SearchBar3 : UIView<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UIView* panel;
@property (nonatomic,weak) IBOutlet UILabel* lblName;
@property (nonatomic,weak) IBOutlet UIImageView* pic;
@property (nonatomic,weak) IBOutlet UIImageView* img;
@property (nonatomic,weak) IBOutlet UITextField* txtKeyWord;
@property (nonatomic,weak) IBOutlet UIButton* btnSelect;
@property (nonatomic,weak) IBOutlet UIView* scanView;
@property (nonatomic,weak) IBOutlet UIButton* cancelBtn;

@property (nonatomic,assign) id<ISearchBarEvent> delegate;
@property (nonatomic,assign) NSInteger conditionType;

- (void)initDeleagte:(id<ISearchBarEvent>)delegate withName:(NSString*)title placeholder:(NSString *)placeholder;

- (void)changeLimitCondition:(NSString*)condition;
- (void)changePlaceholder:(NSString*)placeholder;

- (void)showCondition:(BOOL)isShow;

+ (instancetype)searchBar3;
@end
