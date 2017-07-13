//
//  EnterCircleEditView.h
//  retailapp
//
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#define State_Apply   0
#define State_Appling 1
#define State_Success 2
#define State_Refuse  3
#define State_Unbind  4


#import "LSRootViewController.h"
@interface EnterCircleEditView : LSRootViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary   *detailParams; //详情请求参数
- (id)initWithParent:(id)parent applyType:(NSInteger)type;
@end
