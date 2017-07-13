//
//  LSEditShopInfoBox.h
//  retailapp
//
//  Created by guozhi on 2017/4/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "IEditItemImageEvent.h"

@interface LSEditShopInfoBox : EditItemBase

+ (instancetype)editShopInfpBox;

- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate;

- (void)initImgList:(NSArray *)filePathList;

- (void)changeImg:(NSString *)filePath img:(UIImage*)img;

- (void)removeFilePath:(NSString *)path;

- (NSMutableArray *)getFilePathList;
- (NSMutableDictionary *)getFileImageMap;
- (NSMutableDictionary *)getfilePathMap;
- (NSMutableDictionary *)fileImageMap;
- (NSArray *)getImageItemList;
- (void)imageBoxUneditable;

@end
