//
//  SearchBar.h
//  retailapp
//
//  Created by hm on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"

@interface SearchBar : UIView<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UIView* view;

@property (nonatomic,weak) IBOutlet UIView* panel;

@property (nonatomic,weak) IBOutlet UITextField* keyWordTxt;

@property (nonatomic,weak) IBOutlet UIView* scanView;

@property (nonatomic,weak) IBOutlet UIButton* cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanViewLeftConstrint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelRightConstraint;

@property (nonatomic,weak) id<ISearchBarEvent> searchBarDelegate;

- (IBAction)scanBtnClick:(id)sender;

- (IBAction)onCancelClick:(id)sender;
+ (instancetype)searchBar;
- (void)initDeleagte:(id<ISearchBarEvent>)delegate placeholder:(NSString*)placeholder;

@end
