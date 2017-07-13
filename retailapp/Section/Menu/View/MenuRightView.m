//
//  MenuRightView.m
//  retailapp
//
//  Created by taihangju on 16/6/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuRightView.h"
#import "MenuRightCell.h"

extern const CGFloat kMarginValue;
static NSString *cellIdentifer       = @"MenuRightCell";
static NSString *tabHeaderIdentifier = @"tabHeaderIdentifier";
@interface MenuRightView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeadingContraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<MenuRightViewDelegate> delegate;/*<<#说明#>>*/
@property (nonatomic, strong) NSArray *dataSource;/*<<#说明#>>*/
@end

@implementation MenuRightView

+ (MenuRightView *)menuRightView:(id<MenuRightViewDelegate>)delegate{
    MenuRightView *right = [[NSBundle mainBundle] loadNibNamed:@"MenuRightView" owner:nil options:nil][0];
    right.ls_height = SCREEN_H;
    right.delegate = delegate;
    [right initNotification];
    return right;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self.tableViewLeadingContraint setConstant:kMarginValue];
    self.tableView.rowHeight = 54.0f;
    self.tableView.tableHeaderView = [[MenuRightTabHeader alloc] initWithReuseIdentifier:tabHeaderIdentifier];
}
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePushed:) name:Notification_Message_Push object:nil];
}
- (void)messagePushed:(NSNotification *)notification {

    [self.tableView reloadData];
}
- (void)reloadData {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)refreshUserInfo{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    MenuRightTabHeader *header = (MenuRightTabHeader *)self.tableView.tableHeaderView;
    [header performSelector:@selector(setUserInfo)];
#pragma clang diagnostic pop
}

/**
 *  对应首页右边栏的各个cell，以后增加或者减少，改动该出，并且在实现MenuRightViewDelegate的代理中更改代理方法即可
 *
 *  @return tableView需要的数据源
 */
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@{@"image":@"ico_more_pw" ,@"title":@"修改密码" ,@"hiddeLine":@(0)},
                        @{@"image":@"ico_more_bg" ,@"title":@"更换背景图" ,@"hiddeLine":@(0)},
                        @{@"image":@"ico_system_notification" ,@"title":@"系统通知" ,@"hiddeLine":@(0)},
                        @{@"image":@"ico_more_contact" ,@"title":@"消息中心" ,@"hiddeLine":@(0)},
                        @{@"image":@"ico_more_about" ,@"title":@"关于" ,@"hiddeLine":@(0)},
                        @{@"image":@"ico_more_quit" ,@"title":@"退出" ,@"hiddeLine":@(1)}];
    }
    return _dataSource;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuRightCell *cell = [MenuRightCell menuRightCellWithTableView:tableView];
    [cell fillData:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(rightMenu:selectType:)]) {
        [self.delegate rightMenu:self selectType:indexPath.row];
    }
}
@end

@interface MenuRightTabHeader()

@property (strong, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *complanyInfoLabel;

@end
@implementation MenuRightTabHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MenuRightTabHeader" owner:self options:nil]
        ;
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 165);
        [self.contentView addSubview:self.customView];
    }
    
    return self;
}

- (void)setUserInfo
{
    //侧边栏店铺名
    NSString* shopName = [[Platform Instance] getkey:SHOP_NAME];
    NSString* shopCode = [[Platform Instance] getkey:SHOP_CODE];
    self.complanyInfoLabel.text = [NSString stringWithFormat:@"%@ (%@)",shopName,shopCode];

    //侧边栏用户名
    NSString *userName = [[Platform Instance] getkey:EMPLOYEE_NAME];
    NSString *roleName = [[Platform Instance] getkey:USER_NAME];//ROLE_NAME
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:userName];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:17.0] range:NSMakeRange(0,userName.length)];
    NSString *roleStr = [NSString stringWithFormat:@"  %@",roleName];
    NSMutableAttributedString *roleAttr = [[NSMutableAttributedString alloc] initWithString:roleStr];
    [roleAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:13.0] range:NSMakeRange(0,roleStr.length - 1)];
    [attrString appendAttributedString:roleAttr];
    self.userNameLabel.attributedText = attrString;
    
    //侧边栏头像
    CGFloat userImgVCornerR = CGRectGetWidth(self.userImgV.frame)/2;
    CGFloat userImaVCornerL = 1.0;
    self.userImgV.layer.cornerRadius = userImgVCornerR;
    self.userImgV.layer.masksToBounds = YES;
    self.userImgV.layer.borderWidth = userImaVCornerL;
    self.userImgV.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.userImgV sd_setImageWithURL:[NSURL URLWithString:[[Platform Instance] getkey:USER_PIC]] placeholderImage:[UIImage imageNamed:@"img_nopic_user.png"]];
}

@end
