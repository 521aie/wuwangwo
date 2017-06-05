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
@interface EditImageBox1 : EditItemBase
{
    NSMutableArray *selectImgItemList;
    
    SelectImgItem *currentSelectImgItem;
    
    NSMutableArray *filePathList;
    
    NSMutableDictionary *filePathMap;
    
    NSMutableDictionary *fileImageMap;
    
    int num;
}

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

@property (nonatomic, weak) id<IEditItemImageEvent> delegate;
@property (nonatomic) BOOL Change;

- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate;

- (void)initImgList:(NSArray *)filePathList;

- (void)changeImg:(NSString *)filePath img:(UIImage*)img;

- (void)removeFilePath:(NSString *)path;

-(void)upFilePath:(NSString *)path;

-(void)downFilePath:(NSString *)path;

- (NSMutableArray *)getFilePathList;

- (NSMutableDictionary *)fileImageMap;

- (NSMutableArray *)selectImgItemList;

- (NSArray *)getImageItemList;
- (void)imageBoxUneditable;
@end
