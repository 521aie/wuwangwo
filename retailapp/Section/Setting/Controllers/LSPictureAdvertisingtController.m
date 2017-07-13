//
//  LSPictureAdvertisingtController.m
//  retailapp
//
//  Created by guozhi on 2016/11/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPictureAdvertisingtController.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "LSPictureAdvertisingView.h"
#import "TZImagePickerController.h"
#import "AlertBox.h"
#import "LSSystemAuthority.h"
#import "LSImageDataVo.h"
#import "LSPictureAdvertisingVo.h"
#import "ImageUtils.h"
#import "UIImage+Orientation.h"



@interface LSPictureAdvertisingtController ()< IEditItemImageEvent, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/** 表格 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 头部文字 */
@property (nonatomic, strong) UILabel *lblText;
/** 图片容器 */
@property (nonatomic, strong) LSPictureAdvertisingView *boxPicture;
/** 当前操作的图片 */
@property (nonatomic, strong) UIImage *goodsImage;
/** 当前操作的路径图 */
@property (nonatomic, copy) NSString *imgFilePathTemp;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *oldFilePathList;

/** 接口次数 */
@property (nonatomic, assign) int count;
/** 是否正在上传 */
@property (nonatomic, assign) BOOL isUpLoading;
/** 是否是取消按钮 */
@property (nonatomic, assign) BOOL isCancel;

@end

@implementation LSPictureAdvertisingtController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self refreshUI];
    [self loadData];
}

- (void)configViews {
    self.oldFilePathList = [NSMutableArray array];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"图片广告" leftPath:Head_ICON_BACK rightPath:nil];
    //scrollView
    self.scrollView =[[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 64;
    CGFloat scrollViewW = SCREEN_W;
    CGFloat scrollViewH = SCREEN_H - 64;
    
    self.scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    [self.view addSubview:self.scrollView];
    
    //头部文字
    self.lblText = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, scrollViewW - 40,100)];
    self.lblText.textColor = [ColorHelper getTipColor6];
    self.lblText.numberOfLines = 0;
    self.lblText.font = [UIFont systemFontOfSize:13];
    NSString *text = @"说明：\n1.最佳图片分辨率为1920×1080；\n2.单张图片容量大小请控制在5M以内；\n3.最多可上传15张图片；\n4.图片播放顺序按照上传时间排列，先上传的先播放。\n5.若图片上传失败，点击保存后会继续上传失败的图片。";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    self.lblText.attributedText = attr;
    [self.lblText sizeToFit];
    [self.scrollView addSubview:self.lblText];
    
    //图片容器
    self.boxPicture = [LSPictureAdvertisingView pictureAdvertisingView:15];
    //图片框位置
    
    self.boxPicture.ls_top = self.lblText.ls_bottom + 20;
    //设置代理
    [self.boxPicture initDelegate:self];
    //初始化数据
    [self.boxPicture initImgList:nil];
    [self.scrollView addSubview:self.boxPicture];
    
}

- (void)loadData {
    __weak typeof(self) wself = self;
    NSString *url = @"file_res/v1/get_advert_imgs";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseSucess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


- (void)refreshUI {
    UIView *container = self.boxPicture;
    CGFloat contentH = container.ls_bottom;
    contentH = contentH > SCREEN_H - 64 ? contentH : SCREEN_H - 64;
    contentH = contentH + 60;
    self.scrollView.contentSize = CGSizeMake(0, contentH);
    
}

- (void)responseSucess:(id)json {
    if ([ObjectUtil isNotNull:json[@"data"]]) {
        self.datas = [LSPictureAdvertisingVo mj_objectArrayWithKeyValuesArray:json[@"data"]];
    }
    [self.boxPicture initImgList:self.datas];
    [self refreshUI];
    [self.oldFilePathList addObjectsFromArray:self.boxPicture.filePathList];

}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    
    if (event == LSNavigationBarButtonDirectLeft) {
        if (self.isUpLoading) {
            __weak typeof(self) wself = self;
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片正在上传中，确认要取消本次上传吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [wself.navigationController popViewControllerAnimated:NO];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];

        }
        if ([self isUploadImageSucessed:YES]) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }
    } else {
        if (![self isEditing]) {//正在上传中不可以编辑
            return;
        }
        [self save];
    }
}

- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag
{
    if (btnIndex==1) {
        if ([LSSystemAuthority isCanUseCamera]) {
            UIImagePickerController *vc = [[UIImagePickerController alloc] init];
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;
            vc.delegate = self;
             [self presentViewController:vc animated:YES completion:nil];
        }
    
    } else if(btnIndex==0) {
        if ([LSSystemAuthority isCanUsePhotos]) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:15-self.boxPicture.filePathList.count delegate:self];
            [self presentViewController:imagePickerVc animated:YES completion:nil];

        }
        
        
    }
}

#pragma mark - 选择相册
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    if (![self isEditing]) {//正在上传中不可以编辑
        return;
    }
    for (UIImage *img in photos) {
        NSString *unid = [NSString stringWithFormat:@"%@/advertisingimg", [[Platform Instance] getkey:RELEVANCE_ENTITY_ID]];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",unid,[NSString getUniqueStrByUUID]];
        self.goodsImage = img;
        self.imgFilePathTemp = filePath;
        [self uploadImgFinsh];
    }
     [self refreshNavigateTitle];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (![self isEditing]) {//正在上传中不可以编辑
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *unid = [NSString stringWithFormat:@"%@/advertisingimg", [[Platform Instance] getkey:RELEVANCE_ENTITY_ID]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",unid,[NSString getUniqueStrByUUID]];
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    self.goodsImage = [image tdf_upOrientation];
    self.imgFilePathTemp = filePath;
    [self uploadImgFinsh];
    [self refreshNavigateTitle];
}

#pragma mark - 点击上移按钮
- (void)upImg:(NSString *)path{
    if (![self isEditing]) {//正在上传中不可以编辑
        return;
    }
    [self.boxPicture upFilePath:path];
    [self refreshNavigateTitle];
    
}
#pragma mark - 点击下移按钮
-(void)downImg:(NSString *)path{
    if (![self isEditing]) {//正在上传中不可以编辑
        return;
    }
    [self.boxPicture downFilePath:path];
}
- (void)uploadImgFinsh {
//    UIImage *image = [ImageUtils scaleImage:self.goodsImage width:1920 height:1080];
    UIImage *image = self.goodsImage;
    [self.boxPicture changeImg:self.imgFilePathTemp img:image];
    [self refreshUI];
    [self refreshNavigateTitle];
   
}
#pragma mark - 改变标题
- (void)refreshNavigateTitle {
    BOOL isChange = ![self.boxPicture.filePathList isEqual:self.oldFilePathList];
    [self editTitle:isChange act:ACTION_CONSTANTS_EDIT];
    self.isCancel = isChange;
}



#pragma mark - 点击保存
- (void)save {
    self.count = 0;
    __weak typeof(self) wself = self;
    //上传开始
    self.isUpLoading = YES;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self.boxPicture.filePathList enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = self.boxPicture.fileImageMap[filePath];
        LSPictureAdvertisingVo *vo = self.boxPicture.filePathMap[filePath];
        SelectImgItem3 *selectImgItem = self.boxPicture.selectImgItemList[idx];
        if (image != nil && vo.isChange) {
            selectImgItem.viewUploading.hidden = NO;
            selectImgItem.lblFailed.hidden = YES;
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [BaseService uploadImageWithFilePath:filePath image:image width:1920 heigth:1080 completionHandler:^(id json) {
                //图片路径保存接口
                NSString *url = @"file_res/v1/add_advert_img";
                [param removeAllObjects];
                [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
                [param setValue:filePath forKey:@"imgPath"];
                [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
                    if ([ObjectUtil isNotNull:json[@"data"]]) {
                        wself.count ++;
                        vo.isChange = NO;
                        vo.isShowFailImage = NO;
                        vo.id = json[@"data"];
                        vo.path = filePath;
                        [wself savePictureIDs];
                        selectImgItem.viewUploading.hidden = YES;
                        [wself.boxPicture renderSelectImgItem];
                    }
                } errorHandler:^(id json) {
                    wself.count ++;
                    vo.isChange = YES;
                    vo.isShowFailImage = YES;
                    vo.path = filePath;
                    [wself.boxPicture renderSelectImgItem];
                      selectImgItem.viewUploading.hidden = YES;
                    [AlertBox show:json];
                }];

            } errorHandler:^(id json) {
                vo.isChange = YES;
                vo.isShowFailImage = YES;
                [wself.boxPicture renderSelectImgItem];
                selectImgItem.viewUploading.hidden = YES;
                wself.count ++;
                [wself savePictureIDs];
            }];
        } else {
            vo.isChange = NO;
            vo.isShowFailImage = NO;
            wself.count ++;
            [wself.boxPicture renderSelectImgItem];
        }
    }];
    [wself savePictureIDs];
}

#pragma mark - 保存图片Ids 
- (void)savePictureIDs {
    //图片路径保存成后获得Id所有接口调用成功后
    
    if (self.count == self.boxPicture.filePathList.count) {
        NSMutableArray *ids = [NSMutableArray array];
        __weak typeof(self) wself = self;
        [self.boxPicture.filePathList enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.boxPicture.filePathMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LSPictureAdvertisingVo *obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:path]) {
                    if ([NSString isNotBlank:obj.id]) {
                        [ids addObject:obj.id];
                        *stop = YES;
                    }
                }
            }];
        }];
        //保存图片IDs
        NSString *url = @"file_res/v1/sort_advert_imgs";
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
        [dict setValue:ids forKey:@"ids"];
        [param setValue:dict.mj_JSONString forKey:@"data"];
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
            //上传结束
            wself.isUpLoading = NO;
            if ([wself isUploadImageSucessed:NO]) {
                [AlertBox show:@"图片上传成功！"];
                [wself editTitle:NO act:ACTION_CONSTANTS_EDIT];
                self.isCancel = NO;
            }
        } errorHandler:^(id json) {
            [SVProgressHUD dismiss];
            [AlertBox show:json];
        }];
    }

}
#pragma mark - 判断图片是否上传图片成功
//是否点击左上角的取消或返回按钮
- (BOOL)isUploadImageSucessed:(BOOL)isLeft{
    __block int failCount = 0;
    __weak typeof(self) wself = self;
    [self.boxPicture.filePathList enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        LSPictureAdvertisingVo *vo = wself.boxPicture.filePathMap[filePath];
        if (isLeft) {
            if (vo.isShowFailImage) {
                failCount ++;
            }
        } else {
            if (vo.isChange) {
                failCount ++;
            }
        }
        
    }];
    if (failCount == 0) {
        return YES;
    }
    NSString *str = [NSString stringWithFormat:@"有%d张图片上传失败，是否继续上传失败的图片？", failCount];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isLeft) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popViewControllerAnimated:NO];
        }
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself save];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
    return NO;
                                  
}

#pragma mark - 点击删除

- (void)onDelImgClickWithPath:(NSString *)path {
    if (![self isEditing]) {//正在上传中不可以删除
        return;
    }
    __block NSString *pictureId = @"";
    [self.boxPicture.filePathMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LSPictureAdvertisingVo *obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:path]) {
            pictureId = obj.id;
        }
    }];
    if ([NSString isBlank:pictureId]) {//如果删除的是新添加的图片不需要调后台接口删除
        [self.boxPicture removeFilePath:path];
        
        if (self.isCancel) {
            [self refreshNavigateTitle];
            [self refreshUI];
        }
        return;
    }
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:pictureId forKey:@"id"];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    NSString *url = @"file_res/v1/del_advert_img";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:@"正在删除..." show:YES CompletionHandler:^(id json) {
        [wself.boxPicture removeFilePath:path];
         [wself refreshUI];
        if (wself.isCancel) {
            [wself refreshNavigateTitle];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

  
}

/**
 @return 判断页面按钮是否可以编辑
 */
- (BOOL)isEditing {
    if (self.isUpLoading) {
        [AlertBox show:@"图片正在上传，请勿操作！"];
        return NO;
    }
    return YES;
    
}


@end
