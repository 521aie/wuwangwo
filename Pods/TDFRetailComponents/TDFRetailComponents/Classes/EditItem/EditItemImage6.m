//
//  EditItemImage3.m
//  retailapp
//
//  Created by zhangzt on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemImage6.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "LSAlertHelper.h"
#import "ObjectUtil.h"
#import "UIImageView+SDAdd.h"

@implementation EditItemImage6

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemImage6" owner:self options:nil];
    [self addSubview:self.view];
    [self borderLine:self.borderView];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<EditItemImage6Delegate>)delegate{
    self = [super initWithFrame:frame];
    self.delegate=delegate;
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EditItemImage6" owner:self options:nil];
        [self addSubview:self.view];
        [self borderLine:self.borderView];
    }
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

#pragma  initHit.
- (void)initHit:(NSString *)hit {
    
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)hit {
    
    [self initHit:hit];
}

- (void)initListView:(NSDictionary *)dic delegate:(id<EditItemImage6Delegate>)delegate {
   
    self.delegate = delegate;
    if ([ObjectUtil isNotNull:dic]) {
        [self.lblWeChatPrice setHidden:NO];
        [self.lblStyleName setHidden:NO];
        [self.title setHidden:NO];
        [self.imgAdd setHidden:YES];
        if([ObjectUtil isNotNull:[dic objectForKey:@"relevanceWeixinPrice"]]){
            self.lblWeChatPrice.text=[NSString stringWithFormat:@"￥%0.2f",[[dic objectForKey:@"relevanceWeixinPrice"] doubleValue]];
        }
        
//        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
//            self.lblStyleName.text = [dic objectForKey:@"styleName"];
//        } else {
//            self.lblStyleName.text = [dic objectForKey:@"goodsName"];
//        }
        NSString *name = [dic valueForKey:@"styleName"];
        if (!name) {
            name = [dic objectForKey:@"goodsName"];
        }
        self.lblStyleName.text = name;
        [self.lblHint setHidden:YES];
    }else{
        [self.lblWeChatPrice setHidden:YES];
        [self.lblStyleName setHidden:YES];
        [self.title setHidden:YES];
        [self.imgAdd setHidden:NO];
        [self.lblHint setHidden:NO];
    }
}
- (void)changeImg:(NSString *)filePath img:(UIImage*)image
{
    self.imgFilePath = filePath;
    self.currentVal = filePath;
    self.changed = YES;
    if (image != nil) {
        [self showAdd:NO];
        self.img.contentMode = UIViewContentModeScaleAspectFill;
        [self.img setImage:image];
    } else {
        [self showAdd:YES];
        [self.img setImage:nil];
    }
    [self changeStatus];
}

-(void)initImgId:(NSString *) homePageId{
    self.paperId=homePageId;
}

-(NSString *)getImgId{
    return self.paperId;
}

- (IBAction)addClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editItemImage2:)]) {
        [self.delegate editItemImage2:self];
    }
}

- (void)initView:(NSString *)filePath path:(NSString *)path  styleCode:(NSString *) styleCode
{
    self.oldVal=filePath;
    self.currentVal=filePath;
    self.imgFilePath=path;
    self.styleCode=styleCode;
    if([NSString isBlank:filePath]){
        if([NSString isNotBlank:styleCode]){
            [self.img sd_setImageWithURL_Angle:nil placeholderImage:nil];
            [self showAdd:NO];
        }else{
            [self showAdd:YES];
        }
    } else {
        [self.img sd_setImageWithURL_Angle:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
        [self showAdd:NO];
    }
    self.changed = NO;
    [self changeStatus];
}

- (void) showAdd:(BOOL)showAdd
{
    [self.img setHidden:showAdd];
    [self.imgAdd setHidden:!showAdd];
//    [self.lblAdd setHidden:!showAdd];
}

- (void)changeStatus
{
    [super isChange];
}

- (NSString *)getImageFilePath
{
    return self.imgFilePath;
}

@end
