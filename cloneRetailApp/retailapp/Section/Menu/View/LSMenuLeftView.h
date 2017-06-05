//
//  LSMenuLeftView.h
//  retailapp
//
//  Created by guozhi on 2017/2/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

typedef enum {
    LSMenuLeftViewTypeHelpVideo,
    LSMenuLeftViewTypeCommonProblem
}LSMenuLeftViewType;
#import <UIKit/UIKit.h>
@class LSModuleModel;
@protocol LSMenuLeftViewDelegate;

@interface LSMenuLeftView : UIView

@property (nonatomic, weak) id<LSMenuLeftViewDelegate> delegate;

- (void)reloadData;

@end

@protocol LSMenuLeftViewDelegate <NSObject>

- (void)menuLeftView:(LSMenuLeftView *)menuLeftView didSelectobj:(LSModuleModel *)obj;
- (void)menuLeftView:(LSMenuLeftView *)menuLeftView didSelectType:(LSMenuLeftViewType)type;
@end
