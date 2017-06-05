//
//  LSPictureAdvertisingView.h
//  retailapp
//
//  Created by guozhi on 2016/11/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectImgItem3.h"
#import "IEditItemImageEvent.h"
@interface LSPictureAdvertisingView : UIView
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *selectImgItemList;
/** <#注释#> */
@property (nonatomic, strong) SelectImgItem3 *currentSelectImgItem;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *filePathList;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *filePathMap;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *fileImageMap;
/** 最大的图片数量 */
@property (nonatomic, assign) int maxNum;
@property (nonatomic, assign) int num;
@property (nonatomic, weak) id<IEditItemImageEvent> delegate;
@property (nonatomic) BOOL isChange;
+ (instancetype)pictureAdvertisingView:(int)maxNum;
- (void)initDelegate:(id<IEditItemImageEvent>)delegate;

- (void)initImgList:(NSArray *)filePathList;

- (void)changeImg:(NSString *)filePath img:(UIImage*)img;

- (void)removeFilePath:(NSString *)path;

-(void)upFilePath:(NSString *)path;

-(void)downFilePath:(NSString *)path;
- (void)renderSelectImgItem;


@end
