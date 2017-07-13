//
//  EditImageBox.h
//  RestApp
//
//  Created by YouQ-MAC on 15/1/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "IEditItemImageEvent.h"


@class SelectImgItem;
@interface EditImageBox : EditItemBase
{
    NSArray *selectImgItemList;
    
    SelectImgItem *currentSelectImgItem;
    
    NSMutableArray *filePathList;
    
    NSMutableDictionary *filePathMap;
    
    NSMutableDictionary *fileImageMap;
}

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

@property (nonatomic, weak) id<IEditItemImageEvent> delegate;
@property (nonatomic) BOOL Change;
+ (instancetype)editItemBox;
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
