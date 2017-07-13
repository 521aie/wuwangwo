//
//  WeChatSetImageBox.m
//  retailapp
//
//  Created by diwangxie on 16/6/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatSetImageBox.h"

@implementation WeChatSetImageBox

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"WeChatSetImageBox" owner:self options:nil];
    [self addSubview:self.view];
    [self borderLine:self.borderView];
}

- (id)initWithFrame:(CGRect)frame action:(NSInteger) action tag:(NSInteger)tag delegate:(id<IEditItemImageEvent>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"WeChatSetImageBox" owner:self options:nil];
        [self addSubview:self.view];
        [self borderLine:self.borderView];
    }
    self.delegate=delegate;
    self.btnAdd.tag=tag;
    self.view.layer.masksToBounds=YES;
    self.borderView.layer.masksToBounds=YES;
    self.btnAdd.layer.masksToBounds=YES;
    self.imgAdd.layer.masksToBounds=YES;
    self.img.layer.masksToBounds=YES;
    //action=1,轮播图预览；action=2,双列焦点图；单列焦点图和单列商品另外处理
    if (action==1) {
        self.view.frame       = CGRectMake(0, 0, 320, 200);
        self.borderView.frame = CGRectMake(9, 9, 302, 188);
        self.btnAdd.frame     = CGRectMake(10, 10, 300, 186);
        self.imgAdd.frame     = CGRectMake(140, 68, 40, 40);
        self.img.frame        = CGRectMake(10, 10, 300, 186);
        
        self.lblAdd.frame     = CGRectMake(0, 118, 320, 21);
        self.lblAdd.font      = [UIFont systemFontOfSize:15];
        self.lblAdd.text=@"添加图片";
    }else if (action==2){
        self.view.frame       = CGRectMake(4, 0, 152, 77);
        self.borderView.frame = CGRectMake(5, 0, 150, 77);
        self.btnAdd.frame     = CGRectMake(6, 1, 148, 75);
        self.imgAdd.frame     = CGRectMake(65, 15, 30, 30);
        self.img.frame        = CGRectMake(6, 1, 148, 75);
        
        self.lblAdd.frame     = CGRectMake(5, 50, 150, 21);
        self.lblAdd.font      = [UIFont systemFontOfSize:11];
        self.lblAdd.text=@"添加图片";
    }else if (action==3) {
        self.view.frame       = CGRectMake(0, 0, 320, 100);
        self.borderView.frame = CGRectMake(9, 0, 302, 98);
        self.btnAdd.frame     = CGRectMake(10, 1, 300, 96);
        self.imgAdd.frame     = CGRectMake(145, 24, 30, 30);
        self.img.frame        = CGRectMake(10, 1, 300, 96);
        
        self.lblAdd.frame     = CGRectMake(0, 59, 320, 21);
        self.lblAdd.font      = [UIFont systemFontOfSize:15];
        self.lblAdd.text=@"添加图片";
    }else if (action==4){
        self.view.frame       = CGRectMake(0, 0, 106, 128);
        
        self.borderView.layer.cornerRadius=43;
        self.borderView.frame = CGRectMake(10, 10, 86, 86);
        
        self.btnAdd.layer.cornerRadius=43;
        self.btnAdd.frame     = CGRectMake(10, 10, 86, 86);
        
        self.imgAdd.frame     = CGRectMake(41, 41, 25, 25);
        
        self.img.frame        = CGRectMake(11, 11, 84, 84);
        self.img.layer.cornerRadius=42;
        
        self.lblCateGoryName=[[UILabel alloc] initWithFrame:CGRectMake(10, 103, 86, 25)];
        [self.view addSubview:self.lblCateGoryName];
        
        self.lblAdd.hidden=YES;
    }
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    return self;
}
-(void) borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

-(IBAction)btnAddClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    sheet.tag=1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0 || buttonIndex==1) {
        [self.delegate onConfirmImgClick:buttonIndex];
    }
}
-(void)initBoxView:(NSString *)filePath homePageId:(NSString *)homePageId{
    self.currentVal = [NSString getImagePath:filePath];
    self.oldVal = [NSString getImagePath:filePath];
    self.homePageId=homePageId;
    if([NSString isBlank:filePath]){
        [self showAdd:YES];
    } else {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil options:SDWebImageRetryFailed];
        [self showAdd:NO];
    }
}
- (void)changeImg:(NSString *)filePath img:(UIImage*)image
{
     self.currentVal = filePath;
    self.imgFilePath = filePath;
    self.currentVal = filePath;
    self.changed = YES;
    if (image != nil) {
        [self showAdd:NO];
        self.img.contentMode = UIViewContentModeScaleToFill;
        [self.img setImage:image];
    } else {
        [self showAdd:YES];
        [self.img setImage:nil];
    }
    [self changeStatus];
}

- (void)changeStatus
{
    [super isChange];
}

- (void) showAdd:(BOOL)showAdd
{
    [self.img setHidden:showAdd];
    [self.imgAdd setHidden:!showAdd];
    [self.lblAdd setHidden:!showAdd];
}

@end
