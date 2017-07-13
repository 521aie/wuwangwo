//
//  LSImageCropController.m
//  ScropViewController
//
//  Created by byAlex on 16/7/14.
//  Copyright © 2016年 DIY. All rights reserved.
//

#import "LSImageCropController.h"
#import "LSImageCropView.h"


@interface LSImageCropController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIView *toolbar;/* <<#desc#>*/
@property (nonatomic ,strong) UIImage *rawImage;/* <<#desc#>*/
@property (nonatomic ,strong) LSImageCropView *imageCropView;/* <<#desc#>*/
@end

@implementation LSImageCropController

- (instancetype)initWithImage:(UIImage *)originImage {
    self = [super init];
    if (self) {
        self.rawImage = originImage;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCropView];
    [self setupToolbar];
    
    // 禁止ViewController 自动调整scrollview的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.imageCropView.frame = self.view.bounds;
    self.toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - kBottomToolBarHeight, self.view.frame.size.width, kBottomToolBarHeight);
}

#pragma mark - Crop Rect Normalizing
- (CGSize)cropSize {
    
    if (CGSizeEqualToSize(CGSizeZero, _cropSize)) {
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 2*kCropPadding;
        return CGSizeMake(width, width*9/16);
    }
    return _cropSize;
}

- (void)setupCropView {

    self.imageCropView = [[LSImageCropView alloc] initWithFrame:self.view.bounds];
    [self.imageCropView setImageToCrop:self.rawImage];
    [self.imageCropView setCropSize:self.cropSize];
    self.imageCropView.clipsToBounds = YES;
    [self.view addSubview:self.imageCropView];
}
- (void)setupToolbar {

    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat screentWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - kBottomToolBarHeight, screentWidth, kBottomToolBarHeight)];
    self.toolbar.backgroundColor = [UIColor colorWithRed:20./255. green:20./255. blue:20./255. alpha:0.65];
    [self.view addSubview:self.toolbar];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[cancelButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [[cancelButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [cancelButton setFrame:CGRectMake(13, 12, 58, 30)];
    [cancelButton setTitle:@"放弃" forState:UIControlStateNormal];
    [cancelButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
    [cancelButton  addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[useButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [[useButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [useButton setFrame:CGRectMake(screentWidth - 58 - 13, 12, 58, 30)];
    [useButton setTitle:@"使用" forState:UIControlStateNormal];
    [useButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
    [useButton  addTarget:self action:@selector(actionUse) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolbar addSubview:cancelButton];
    [self.toolbar addSubview:useButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), 12, screentWidth - CGRectGetWidth(cancelButton.frame) - CGRectGetWidth(useButton.frame) - 26, 30)];
    label.text = @"移动、缩放图片进行剪切";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    [self.toolbar addSubview:label];
}

- (void)actionCancel {
    UIViewController *parentViewController = self.parentViewController;
    if ([parentViewController isKindOfClass:[UIImagePickerController class]]){
        UIImagePickerController *picker = (UIImagePickerController *)parentViewController;
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)actionUse {
    
    UIImage *cropImage = [self.imageCropView croppedImage];
    if ([self.cropDelegate respondsToSelector:@selector(imageCropController:didFinishWithCroppedImage:)]) {
        [self.cropDelegate imageCropController:self didFinishWithCroppedImage:cropImage];
    }
}
@end
