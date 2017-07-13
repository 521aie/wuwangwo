//
//  ReturnPaperEditView.h
//  retailapp
//
//  Created by hm on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class PaperVo;

typedef void(^EditReturnPaperHandler)(PaperVo* item , NSInteger action);
@interface ReturnPaperEditView : LSRootViewController

- (void)loadPaperId:(NSString*)paperId status:(short)billStatus paperType:(NSInteger)paperType action:(NSInteger)action isEdit:(BOOL)isEdit callBack:(EditReturnPaperHandler)callBack;
@end
