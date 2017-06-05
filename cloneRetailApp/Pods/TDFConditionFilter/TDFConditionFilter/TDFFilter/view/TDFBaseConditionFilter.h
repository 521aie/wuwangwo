//
//  TDFBaseConditionFilter.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/10.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFFilterMoel.h"

@protocol TDFConditionFilterDelegate;
@interface TDFBaseConditionFilter : UIView

@property (nonatomic ,strong) UITableView *tableView;/**<>*/
@property (nonatomic ,strong) UILabel *titleLabel;/**<>*/
@property (nonatomic ,strong) UIView *rightView;/**<>*/
@property (nonatomic ,strong) UIButton *filterButton;/**<>*/
@property (nonatomic ,weak) id <TDFConditionFilterDelegate>delegate;/**<>*/

- (instancetype)initFilter:(NSString *)title image:(NSString *)imageName highlightImage:(NSString *)highlightImageName;
- (void)changeFilterFrame;
@end

@protocol TDFConditionFilterDelegate <NSObject>

@optional;
- (void)tdf_filterCompleted;
- (void)tdf_filter:(TDFBaseConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model;
- (void)tdf_filterReset;
- (BOOL)tdf_filterWillShow;
- (BOOL)tdf_filterShouldHide;
@end
