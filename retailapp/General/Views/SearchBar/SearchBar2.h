//
//  SearchBar2.h
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"

@interface SearchBar2 : UIView<UITextFieldDelegate,UISearchBarDelegate>

@property (nonatomic,weak) IBOutlet UIView* view;

@property (nonatomic, weak) IBOutlet UITextField* keyWordTxt;

@property (nonatomic, weak) IBOutlet UIView* panel;

@property (nonatomic, weak) IBOutlet UIButton* cancelBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintPanel;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) id<ISearchBarEvent> searchBarDelegate;
+ (instancetype)searchBar2;
- (void)initDelagate:(id<ISearchBarEvent>)searchBarDelegate placeholder:(NSString*)placeholder;

- (void)limitKeyWords:(int)number;

- (IBAction)onCancelBtnClick:(id)sender;

@end
