//
//  SSDQCompanyDetailViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-26.
//
//

#import "SSDQCompanyDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSSystemUtils.h"
#import "SSDQDeliveryQueryViewController.h"
#import "SSWebViewController.h"
#import "SSToastView.h"
#import "UIView+UIViewUtil.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"

@interface SSDQCompanyDetailViewController ()
@property(nonatomic,retain) IBOutlet UIImageView *logo;
@property(nonatomic,retain) IBOutlet UILabel *name;
@property(nonatomic,retain) IBOutlet UIView *bg;
@property(nonatomic,retain) IBOutlet UIButton *phoneBtn;
@property(nonatomic,retain) IBOutlet UIButton *siteBtn;
@property(nonatomic,retain) IBOutlet UIButton *sendBtn;
@property(nonatomic,retain) IBOutlet UIButton *queryBtn;
@property(nonatomic,retain) IBOutlet UIButton *favBtn;

-(IBAction)phoneBtnClick:(id)sender;
-(IBAction)siteBtnClick:(id)sender;
-(IBAction)queryBtnClick:(id)sender;
-(IBAction)favBtnClick:(id)sender;

@end

@implementation SSDQCompanyDetailViewController
@synthesize company = _company;
@synthesize logo = _logo;
@synthesize name = _name;
@synthesize queryBtn = _queryBtn;
@synthesize siteBtn = _siteBtn;
@synthesize bg = _bg;
@synthesize phoneBtn = _phoneBtn;
@synthesize sendBtn = _sendBtn;
@synthesize favBtn = _favBtn;
@synthesize cannotFav = _cannotFav;

-(void)dealloc {
    self.company = nil;
    self.logo = nil;
    self.name = nil;
    self.queryBtn = nil;
    self.siteBtn = nil;
    self.bg = nil;
    self.phoneBtn = nil;
    self.sendBtn = nil;
    self.favBtn = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initBg];
    SET_GRAY_BG(self);
    [SSSystemUtils setGrayBtn:self.phoneBtn];
    [SSSystemUtils setGrayBtn:self.sendBtn];
    [SSSystemUtils setGrayBtn:self.queryBtn];
    [SSSystemUtils setGrayBtn:self.siteBtn];
    [SSSystemUtils setGrayBtn:self.favBtn];
    
    self.title = self.company.name;
    
    [self initRightBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.cannotFav) {
        self.favBtn.hidden = YES;
    }
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData {
    if (self.company == nil) {
        return;
    }
    
    _logo.image = [UIImage imageNamed:_company.code];
    self.name.text = self.company.name;
    [self.phoneBtn setTitle:[NSString stringWithFormat:@"联系电话：%@",self.company.phone] forState:UIControlStateNormal];
    [self.siteBtn setTitle:[NSString stringWithFormat:@"公司网站：%@",self.company.site] forState:UIControlStateNormal];
    
    
    if (self.company.isFavorite) {
        [self.favBtn setTitle:@"设置为非常用" forState:UIControlStateNormal];
    }else{
        [self.favBtn setTitle:@"设置为常用" forState:UIControlStateNormal];
    }
}

-(void)initBg {
    self.bg.layer.borderWidth = 1;
    self.bg.layer.cornerRadius = 12;
    self.bg.layer.borderColor = [[UIColor grayColor] CGColor];
}

-(void)queryBtnClick:(id)sender {
    SSDQDeliveryQueryViewController *controller = [[[SSDQDeliveryQueryViewController alloc]init]autorelease];
    controller.company = self.company;
    controller.navigationItem.title = @"快递查询";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)phoneBtnClick:(id)sender {
    [SSSystemUtils makeCallWithNumber:self.company.phone];
}

-(void)siteBtnClick:(id)sender {
    SSWebViewController *controller = [[[SSWebViewController alloc]init]autorelease];
    controller.url = [NSURL URLWithString:self.company.site];
    controller.navigationItem.title = self.company.name;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)favBtnClick:(id)sender {
    self.company.isFavorite = !self.company.isFavorite;
    
    if (self.company.isFavorite) {
        [self.favBtn setTitle:@"设置为非常用" forState:UIControlStateNormal];
    }else{
        [self.favBtn setTitle:@"设置为常用" forState:UIControlStateNormal];
    }
    
    [self updateFav:[self.company.id intValue] fav:self.company.isFavorite];
}

-(void)sendMessage {
    
    [SSSystemUtils sendShotMessage:self content:[self getSendContent]];
}

-(void) initRightBtn {
    
    UIBarButtonItem * infoButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendDetailTo)]autorelease];
    [infoButtonItem setTitle:@"发送"];
    
    self.navigationItem.rightBarButtonItem = infoButtonItem ;
    [self.navigationItem.rightBarButtonItem setTitle:@"发送"];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultSent:
        {
            [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"发送成功^_^！"] show];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self setFrame4Ad];
}

-(void)sendMail {
    [SSSystemUtils sendEmail:self title:[self getSendTitle] content:[self getSendContent] toRecipients:nil];
}

-(void)sendDetailTo {
    UIActionSheet *sheet = [[[UIActionSheet alloc]initWithTitle:@"选择发送方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"通过短信发送" otherButtonTitles:@"通过邮件发送", nil]autorelease];
    [sheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self sendMessage];
        }
            break;
        case 1:
        {
            [self sendMail];
        }
            break;
        default:
            break;
    }
}

-(NSString*)getSendTitle{
    return [NSString stringWithFormat:@"［快递公司信息－%@］",self.company.name];
}

-(NSString*)getSendContent {
    NSMutableString *content = [NSMutableString stringWithCapacity:100];
    [content appendFormat:@"［快递公司信息－%@］",self.company.name];
    [content appendFormat:@"\n 公司电话：%@",self.company.phone];
    [content appendFormat:@"\n 公司网址：%@",self.company.site];
    
    return content;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
        {
            [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"已经保存为草稿^_^!"]show];
        }
			break;
		case MFMailComposeResultSent:
        {
            [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"发送成功^_^!"]show];
        }
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
    [self dismissModalViewControllerAnimated:YES];
	[self setFrame4Ad];
}

-(void)setFrame4Ad {
    if (HAS_AD) {
        [self.navigationController.view setHeight:[self.navigationController.view height]-25];
    }
    
}
-(void)updateFav:(int)id fav:(int)fav{
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat: @"update DeliveryCompany set isFavorite = %d where id = %d",fav,id];
        
        [db executeUpdate:sql];
    }
    
    [db close];
}
@end
