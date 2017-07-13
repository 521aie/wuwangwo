//
//  WeChatAccountInfo.m
//  retailapp
//
//  Created by diwangxie on 16/4/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "AccountInfo.h"
#import "XHAnimalUtil.h"
#import "AccountInfoCell.h"
#import "AlertBox.h"
#import "Platform.h"
#import "BalanceLogList.h"
#import "OrdersRebateList.h"
#import "BaseService.h"
#import "ServiceFactory.h"
#import "UIView+Sizes.h"
#import "ApplyWithdraw.h"
#import "WithdrawRecord.h"
#import "UserBankVo.h"

@interface AccountInfo ()
@property (nonatomic, strong) BaseService             *service;           //网络服务
@property (nonatomic, strong) NSString                *name;              //名称
@property (nonatomic, strong) NSString                *shopName;          //店铺名称
@property (nonatomic, strong) NSString                *shopCode;          //店铺编号
@property (nonatomic, strong) NSString                *faceUrl;           //店铺名称
@property (nonatomic, strong) NSString                *tempBalance;       //临时余额
@property (nonatomic, strong) NSString                *withdrawBalance;   //正式余额(伙伴加门店)
@property (nonatomic, strong) NSString                *ownBalance;        //自己的余额
@property (nonatomic, strong) NSString                *ytxBalance;        //自己的余额
@property (nonatomic, strong) NSString                *smallCompanionWithdraw;
@end

@implementation AccountInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [ServiceFactory shareInstance].baseService;
    [self initHead];
    [self initMainGrid];
    [self loadDate];
    // Do any additional setup after loading the view.
}
-(void)initHead{
    self.titileBox = [NavigateTitle2 navigateTitle:self];
    [self.titileBox initWithName:@"账户信息" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titileBox];
}
-(void)initMainGrid{
    [self.mainGrid ls_addHeaderWithCallback:^{
        [self loadDate];
    }];
}
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)loadDate{
    
    NSString *url = nil;
    
    url = @"accountInfo/detail";
    
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        self.name=[json objectForKey:@"name"];
        self.shopName=[json objectForKey:@"buildingShopName"];
        self.shopCode=[json objectForKey:@"shopCode"];
        self.faceUrl=[json objectForKey:@"photo"];
        self.withdrawBalance=[json objectForKey:@"withdrawBalance"];
        self.tempBalance=[json objectForKey:@"tempBalance"];
        self.ytxBalance=[json objectForKey:@"ytxBalance"];
        self.ownBalance=[json objectForKey:@"ownBalance"];
        self.smallCompanionWithdraw = [json objectForKey:@"smallCompanionWithdraw"];
        
        [self.mainGrid reloadData];
        [self.mainGrid headerEndRefreshing];
    } errorHandler:^(id json) {
        [self.mainGrid headerEndRefreshing];
        [AlertBox show:json];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 || indexPath.row==1) {
        return 90;
    }else{
        return 44;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tableViewCell = @"TableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCell];
    if (!cell) {
        //通过xib的名称加载自定义的cell
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCell];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (indexPath.row==0) {
        UIImageView *faceImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        faceImage.layer.masksToBounds=YES;
        faceImage.layer.cornerRadius=35;
        [faceImage sd_setImageWithURL:[NSURL URLWithString:self.faceUrl] placeholderImage:[UIImage imageNamed:@"img_nopic_user.png"]];
        [cell.contentView addSubview:faceImage];
        
        
        UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(88, 14, 180, 21)];
        if([NSString isNotBlank:self.name]){
            lblName.text=self.name;
        }
        lblName.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
        lblName.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [cell.contentView addSubview:lblName];
        
        UILabel *lblShop=[[UILabel alloc] initWithFrame:CGRectMake(88, 52, 180, 21)];
        if([NSString isNotBlank:self.shopName]){
            lblShop.text=[NSString stringWithFormat:@"%@(%@)",self.shopName,self.shopCode];
        }else{
            lblShop.text=@"";
        }
        lblShop.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
        lblShop.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [cell.contentView addSubview:lblShop];
        
        
        UILabel *lblSet=[[UILabel alloc] initWithFrame:CGRectMake(251, 34, 46, 21)];
        lblSet.text=@"设置";
        lblSet.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
        lblSet.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [cell.contentView addSubview:lblSet];
    
        UIImageView *arraw=[[UIImageView alloc] initWithFrame:CGRectMake(290, 34, 20, 20)];
        arraw.image=[UIImage imageNamed:@"ico_next.png"];
        arraw.alpha=0.6;
        [cell.contentView addSubview:arraw];
        [lblSet setHidden:YES];
        [arraw setHidden:YES];
        //微分销的先隐藏掉 以后会用到 不可删除

//        if ((([[Platform Instance] getShopMode]==2 || [[Platform Instance] getShopMode]==3) && [[Platform Instance] getkey:SHOP_BIND_FLG].intValue==1) || [[Platform Instance] isBigCompanion]) {
//            [lblSet setHidden:NO];
//            [arraw setHidden:NO];
//        }else{
//            [lblSet setHidden:YES];
//            [arraw setHidden:YES];
//        }
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 89, 320, 1)];
        line.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        [cell.contentView addSubview:line];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }else if(indexPath.row==1){
        static NSString* accountInfoCell = @"AccountInfoCell";
        AccountInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:accountInfoCell];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:accountInfoCell owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[AccountInfoCell class]]) {
                    cell = (AccountInfoCell *)o;
                    break;
                }
            }
        }
        if(self.withdrawBalance!=nil ){
             cell.lblAllMoney.text=[NSString stringWithFormat:@"%.2f",[self.withdrawBalance doubleValue]];
        }
        if(self.tempBalance!=nil ){
            cell.lblOutMoney.text=[NSString stringWithFormat:@"%.2f元",[self.tempBalance doubleValue]];
        }
        CGFloat h = cell.lblAllMoney.frame.size.height;
        UIFont *font = cell.lblAllMoney.font;
        CGSize maxSize = CGSizeMake(MAXFLOAT, h);
        
        CGSize sizeName = [NSString sizeWithText:[NSString stringWithFormat:@"%.2f",[self.withdrawBalance doubleValue]] maxSize:maxSize font:font];
        
        cell.lblAllMoney.ls_size = sizeName;
        CGFloat w = cell.lblAllMoney.frame.size.width;
        
        cell.lblTitle.frame=CGRectMake(w+10, 45, 20, 15);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }else{
        
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10, 11, 250, 21)];
        if (indexPath.row==2) {
            title.text=@"总部微店订单";
        }else if (indexPath.row==3){
            title.text=@"申请提现";
        }else if (indexPath.row==4){
            title.text=@"提现记录";
        }
        title.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        title.font=[UIFont fontWithName:@"Helvetica Neue" size:15];
        [cell.contentView addSubview:title];
        
        UIImageView *arraw=[[UIImageView alloc] initWithFrame:CGRectMake(290, 12, 20, 20)];
        arraw.image=[UIImage imageNamed:@"ico_next.png"];
        arraw.alpha=0.6;
        [cell.contentView addSubview:arraw];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(10, 44, 300, 1)];
        line.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        [cell.contentView addSubview:line];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row==1){
        BalanceLogList *vc = [[BalanceLogList alloc] initWithNibName:@"BalanceLogList" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }else if (indexPath.row==2){
        OrdersRebateList *vc = [[OrdersRebateList alloc] initWithNibName:[SystemUtil getXibName:@"OrdersRebateList"] bundle:nil];
        vc.accumulatedAmount=[self.tempBalance doubleValue]+[self.withdrawBalance doubleValue]+[self.ytxBalance doubleValue];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }else if (indexPath.row==3){
        [self loadCheck];
    }else if (indexPath.row==4){
        WithdrawRecord*vc = [[WithdrawRecord alloc] initWithNibName:@"WithdrawRecord" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }
}

-(void)loadCheck{
    double withdrawBlance=[self.withdrawBalance doubleValue];
    if (withdrawBlance<=0) {
        [AlertBox show:@"无可提现金额，不能申请提现"];
        return;
    }
    
    NSString *url = nil;
    
    url = @"withdrawCheck/check";
    NSString *proposerId=nil;
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
     proposerId = [[Platform Instance] getkey:SHOP_ID];
    [param setValue:[NSString stringWithFormat:@"%@",proposerId] forKey:@"proposerId"];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        ApplyWithdraw*vc = [[ApplyWithdraw alloc] initWithNibName:[SystemUtil getXibName:@"ApplyWithdraw"] bundle:nil];
        vc.userBank=[UserBankVo converToVo:[json objectForKey:@"userBank"]];
        vc.maxBalance=[_withdrawBalance doubleValue];
        vc.smallCompanionWithdraw = [_smallCompanionWithdraw doubleValue];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
