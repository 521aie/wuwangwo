//
//  PaymentNoteView.m
//  RestApp
//
//  Created by Shaojianqing on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaymentNoteView.h"
#import "ShopInfoVO.h"
@interface PaymentNoteView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;


@end
@implementation PaymentNoteView

- (instancetype)initWithShopInfoVO:(ShopInfoVO *)shopInfoVO {
    self = [super init];
    if (self) {
        self.shopInfoVO = shopInfoVO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    [self setupScrollView];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
}

- (void)setupTitle {
    [self configTitle:@"电子支付代收代付协议" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    __weak typeof(self) wself = self;
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.font = [UIFont boldSystemFontOfSize:20];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"电子支付代收代付协议";
    [self.scrollView addSubview:lblTitle];
    [lblTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.scrollView).offset(10);
        make.right.equalTo(wself.scrollView).offset(-10);
        make.top.equalTo(wself.scrollView);
        make.width.equalTo(wself.scrollView).offset(-20);
        make.height.equalTo(44);
    }];
    
    UILabel *lblContext = [[UILabel alloc] init];
    lblContext.font = [UIFont systemFontOfSize:12];
    lblContext.numberOfLines = 0;
    lblContext.textColor = [UIColor blackColor];
    [self.scrollView addSubview:lblContext];
    [lblContext makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.scrollView).offset(10);
        make.right.equalTo(wself.scrollView).offset(-10);
        make.top.equalTo(lblTitle.bottom);
        make.width.equalTo(wself.scrollView).offset(-20);
        make.bottom.equalTo(wself.scrollView).offset(-44);
    }];
    NSString *name = nil;
    if ([NSString isNotBlank:self.shopInfoVO.bankAccount]) {
        name = self.shopInfoVO.bankAccount;
    } else {
        name = @"二维火收银机使用商户";
    }
    NSString *day = [[NSUserDefaults standardUserDefaults]objectForKey:@"day"];
    NSString *context = [NSString stringWithFormat:@"\n\n乙方：杭州迪火科技有限公司\n地址：浙江省杭州市教工路552号二维火科技大楼2楼\n电话：0571-28058898\n\n鉴于：\n1、乙方作为甲方的收银系统提供商，致力于为甲方的客户和甲方提供便捷、专业的互联网对接服务。\n2、甲方授权乙方提供互联网支付服务相关的信息传输和数据查询及其配套软硬件系统（以下统称“对接系统”）的生产、安装和维护服务。\n3、甲方同意乙方为甲方的用户提供微信支付的入口，甲方的用户使用乙方提供的电子支付入口时，由乙方代收该用户支付的在甲方门店内消费的费用，不向甲方收取额外的税收成本。\n4、乙方向甲方代收本协议约定的根据微信支付服务费费率产生的佣金，不向甲方收取其他费用。双方本着平等自愿、精诚合作的原则签订本协议。\n一、定义\n如无特别说明，下列用语在本协议中的含义为：\n1.1日、工作日：本协议所指之日为日历日，本协议所指之工作日系指中华人民共和国国务院规定的除法定节假日之外的工作日。\n1.2“电子支付”指甲方委托乙方在微信支付平台向甲方提供的移动支付服务。\n1.3“电子支付服务费费率”指甲方根据微信支付系统产生的实际交易金额或者成交笔数向微信支付的服务费费率。\n1.4“用户”指在甲方使用电子支付结算的顾客。\n1.5“微店平台”指乙方提供给甲方的微店分销工具。\n1.6“保密信息”包括但不限于：任何一方的与技术、产品计划、设计、规格、成本、财务、营销计划、商业机会、人员、研究、开发、商业秘密或技术诀窍以及本协议及其支持文件的条款和条件有关的商业或技术信息。协议各方分享的所有信息视为保密信息。\n二、声明及保证\n每一方均声明及保证，自本协议签署之日起有资格从事本协议项下之交易，而该等交易符合其经营范围及国家法律之规定。\n三、有效期\n3.1有效期 \n本协议有效期为叁年，自本协议生效之日起计算。\n3.2延期 \n本协议期限届满前三十日内，双方协商可续签协议。如在上述期限内双方未签续约协议，视为本协议到期之日终结协议。\n四、服务方式 \n4.1支付功能 \n乙方网站主页应有微信支付平台的图标，表明电子支付平台作为乙方网站在线支付手段之一，乙方网站需将在线支付的功能直接链接到电子支付平台，用户点击后进入相关支付页面，实现在线支付。\n4.2结算流程 \n用户在甲方微店平台发生网上支付行为，进入迪火支付平台;\n用户选择迪火支付平台中的微信支付工具付款;\n用户输入电子支付的密码，确认交易后，提示交易结果是否成功;\n交易成功后，迪火支付平台负责将用户的款项根据本协议结算规则从迪火支付平台上划拨到甲方提供给乙方的银行帐户上;\n甲方可随时查询在迪火支付系统的在线交易帐户的交易帐务明细和帐务金额。乙方将开户行：\n兴业银行杭州分行\n银行账号为356980100100526261，作为为甲方提供结算服务的专用账户。\n4.3服务保证 \n乙方保证支付平台正常运行、支付款项及时准确成功划拨(遇不可抗力及乙方无法控制的原因除外)， 同时向甲方提供控制管理后台，甲方可通过控制管理后台进行帐务结算和明细查询。\n乙方保证在销售、结算等方面为甲方提供服务，非乙方原因与用户产生的任何纠纷与乙方无关，均由甲方负责协调解决并承担全部责任。\n甲方保证其利用支付平台经营的业务符合国家法律法规要求，不得利用乙方的产品或服务从事任何违法活动，如果甲方违反前述规定，乙方有权立即解除本协议，因甲方行为给乙方造成损失的，甲方应承担赔偿责任。\n五、费用结算及银行账户信息 \n5.1　微信支付服务费费率为甲方用户通过乙方平台支付后向微信支付平台支付款项金额的%@；\n5.2甲方的用户通过迪火支付平台完成微信支付的，乙方实行T+%@天到账规则，将款项从迪火支付平台上划至甲方在火掌柜中指定的帐户，金额以乙方系统的记录为准;\n5.3甲方认可，具体到账时间取决于银行系统的清算动作及周期。\n5.4甲方提供接收迪火平台的银行账户信息，保证其真实合法有效。\n 六、免责事由\n6.1不可抗力是指本协议双方不能预见、不能避免、不能克服的客观情况。由于不可抗力导致本协议不能全部履行或部分履行的，双方可根据实际情况协商决定部分履行、延期履行或终止本协议。一方因不可抗力事件不能履行协议的，应及时采取措施防止损失扩大，并及时书面通知对方，以减轻可能给对方造成的损失，否则，应就扩大损失向对方承担赔偿责任。\n6.2发生下列情形之一，导致本协议无法继续履行的，双方均可解除本协议且互不担责，本协议另有约定的除外：\n(1)黑客攻击或计算机病毒侵入或发作的；\n(2)非乙方原因造成计算机系统遭到破坏、瘫痪或无法正常使用的；\n(3)电信部门进行技术调整或发生故障的；\n(4)政府部门要求乙方暂时或持续停止提供服务的；\n(5)银行或电信运营商等非乙方原因造成本协议无法继续履行或需做变更的；\n(6)因法律法规变动导致本协议无法继续履行或需做变更的。\n七、违约责任\n7.1任何一方违反在本协议中所做的任何保证、承诺或约定，即构成违约，因违约而给另一方造成的经济损失和法律责任，应由该违约方承担，本协议另有约定的除外。\n7.2甲方有下列情形之一，乙方有权解除本协议，用户和乙方由此遭受的一切经济损失由甲方承担，本另有约定的从其约定：\n(1)直接或间接参与欺诈的；\n(2)经营或财务状况恶化，无法为乙方或用户提供应有的对接系统服务的；\n(3)无理拒绝或拖延乙方合理的查询和监查要求的；\n(4）进入破产程序、解散、营业执照被吊销的；\n(5)协助用户或持卡人进行卡片伪冒交易或恶意欠款的；\n(6)阻止或妨碍用户使用微信支付服务进行交易的；\n(7)销售国家禁止流通、限制流通商品或提供非法服务的；\n(8)经有权机关认定无相关营业资格的；\n(9)利用乙方提供的服务从事非法活动的；\n(10)出现风险事件或经乙方判断交易异常的；\n八、协议更新及关注义务\n8.1乙方建议甲方在使用本协议相关服务前仔细阅读本协议。\n8.2根据国家法律法规变化及乙方运营需要，乙方有权对本协议条款进行修改，修改后的协议被公布在火掌柜APP上即生效，并代替原来的协议。甲方可随时登录查阅最新协议，并有义务不时关注并阅读最新版的协议及公告。如甲方不同意更新后的协议，可以且应立即书面通知乙方；如甲方继续使用乙方提供的相关服务的，即视为同意更新后的协议。\n8.3如果本协议中任何一条被视为废止、无效或因任何理由不可执行，该条应视为可分的且并不影响任何其余条款的有效性和可执行性。\n九、争议解决和法律适用\n9.1本协议的解释、适用、争议解决等一切事宜，均适用中华人民共和国大陆地区法律。\n9.2因本协议存在任何争议的，本协议各方应友好协商，协商不成的，协议各方均应将争议提交乙方住所地人民法院诉讼解决。\n十、风险承担及提示\n 双方对于开展电子商务业务存在的风险性均完全知悉，双方均承诺采取相关风险防范措施，以尽量避免或减小风险。\n十一、反洗钱\n双方应按照《中华人民共和国反洗钱法》和《金融机构客户身份识别和客户身份数据及事务历史记录保存管理办法》、《支付机构反洗钱和反恐怖融资管理办法》等有关反洗钱的法律法规和双方协议约定履行反洗钱义务，并互相为对方在开展反洗钱工作上提供充分的协助。",@"0.6%",day] ;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"甲方："];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName : [ColorHelper getRedColor]}]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:context]];
    lblContext.attributedText = attr;
    
    
    
    
}



@end

