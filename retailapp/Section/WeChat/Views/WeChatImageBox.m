//
//  WeChatImageBox.m
//  retailapp
//
//  Created by diwangxie on 16/6/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatImageBox.h"

@implementation WeChatImageBox

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"WeChatImageBox" owner:self options:nil];
    [self addSubview:self.view];
    [self borderLine:self.borderView];
}

- (id)initWithFrame:(CGRect)frame action:(NSInteger) action tag:(NSInteger)tag delegate:(id<EditItemImageDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"WeChatImageBox" owner:self options:nil];
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
    if (action == 1) {
        self.view.frame       = CGRectMake(0, 0, 320, 200);
        self.borderView.frame = CGRectMake(9, 9, 302, 188);
        self.btnAdd.frame     = CGRectMake(10, 10, 300, 186);
        self.imgAdd.frame     = CGRectMake(140, 68, 40, 40);
        self.img.frame        = CGRectMake(10, 10, 300, 186);
        
        self.lblAdd.frame     = CGRectMake(0, 118, 320, 21);
        self.lblAdd.font      = [UIFont systemFontOfSize:15];
        if(tag == 1) {
            self.lblAdd.text=@"轮播图";
        }else{
            self.lblAdd.text=@"单列商品图";
        }
        
    }else if (action == 2) {
        self.view.frame       = CGRectMake(4, 0, 150, 77);
        self.borderView.frame = CGRectMake(5, 0, 150, 77);
        self.btnAdd.frame     = CGRectMake(6, 1, 148, 75);
        self.imgAdd.frame     = CGRectMake(65, 15, 30, 30);
        self.img.frame        = CGRectMake(6, 1, 148, 75);
        
        self.lblAdd.frame     = CGRectMake(5, 50, 150, 21);
        self.lblAdd.font      = [UIFont systemFontOfSize:11];
        self.lblAdd.text=@"双列焦点图";
    }else if (action == 3) {
        self.view.frame       = CGRectMake(0, 0, 320, 100);
        self.borderView.frame = CGRectMake(9, 0, 302, 98);
        self.btnAdd.frame     = CGRectMake(10, 1, 300, 96);
        self.imgAdd.frame     = CGRectMake(145, 24, 30, 30);
        self.img.frame        = CGRectMake(10, 1, 300, 96);
        
        self.lblAdd.frame     = CGRectMake(0, 59, 320, 21);
        self.lblAdd.font      = [UIFont systemFontOfSize:15];
        self.lblAdd.text=@"单列焦点图";
    }else if (action == 4){
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

- (void)initBoxView:(NSString *)filePath homePageId:(NSString *)homePageId {
    self.currentVal = [NSString getImagePath:filePath];
    self.oldVal = [NSString getImagePath:filePath];
    self.homePageId = homePageId;
    if([NSString isBlank:filePath])
    {
        [self showAdd:YES];
    }
    else
    {
        UIImage *loadingIcon = [UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon_loading" ofType:@"jpg"]];
        //图片加载时，显示加载中提示图片，如果失败显示加载失败提示图片，成功则显示加载成功的图片
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:loadingIcon completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error && !image) {
                UIImage *loadFailIcon = [UIImage imageNamed:[[NSBundle mainBundle]
                                                             pathForResource:@"icon_load_fail" ofType:@"jpg"]];
                self.img.image = loadFailIcon;
            }
            else if (image)
            {
                if ([self.delegate respondsToSelector:@selector(itemImageDownloadSuccess:)])
                {
                    [self.delegate itemImageDownloadSuccess:self];
                }
            }
        }];
        [self showAdd:NO];
    }
}

- (void)initBoxViewToCornerRadius:(NSString *)cateGoryName {
    
    if ([NSString isNotBlank:cateGoryName]) {
        self.lblCateGoryName.text=cateGoryName;
        self.lblCateGoryName.font=[UIFont systemFontOfSize:10];
        self.lblCateGoryName.textAlignment=NSTextAlignmentCenter;
        self.lblCateGoryName.textColor=[UIColor colorWithRed:153/255 green:153/255 blue:153/255 alpha:0.3];
    }
}

- (void)showAdd:(BOOL)showAdd {
    [self.img setHidden:showAdd];
    [self.imgAdd setHidden:!showAdd];
    [self.lblAdd setHidden:!showAdd];
}

- (void)borderLine:(UIView *)view {
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    UIColor *color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

- (IBAction)btnAddClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editItemImage:)]) {
        [self.delegate editItemImage:self];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
