//
//  SSDQDeliveryCompanyListCell.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-12.
//
//

#define DEFAULT_CONTEXT @"暂无"

#import "SSDQMyDeliveryCell.h"
#import "SSDQDeliveryCompany.h"
#import "SSSystemUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"

@interface SSDQMyDeliveryCell ()

@property(nonatomic,retain) IBOutlet UIImageView *companyLogo;
@property(nonatomic,retain) IBOutlet UILabel *companyName;
@property(nonatomic,retain) IBOutlet UILabel *sendTime;
@property(nonatomic,retain) IBOutlet UILabel *latestContext;
@property(nonatomic,retain) IBOutlet UILabel *deliveryNumber;
@property(nonatomic,retain) IBOutlet UILabel *companyPhone;
@property(nonatomic,retain) IBOutlet UIControl *call;
@property(nonatomic,retain) IBOutlet UIView *bg;
@property(nonatomic,retain) IBOutlet UITextField *comment;
@property(nonatomic,retain) IBOutlet UILabel *signedTime;

-(IBAction)closeKeyBoard:(id)sender;

@end

@implementation SSDQMyDeliveryCell

@synthesize companyLogo = _companyLogo;
@synthesize companyName = _companyName;
@synthesize sendTime = _sendTime;
@synthesize latestContext = _latestContext;
@synthesize deliveryNumber = _deliveryNumber;
@synthesize companyPhone = _companyPhone;
@synthesize call = _call;
@synthesize bg = _bg;
@synthesize comment = _comment;
@synthesize signedTime = _signedTime;

- (void)dealloc {
    self.companyLogo = nil;
    self.companyName = nil;
    self.sendTime = nil;
    self.latestContext = nil;
    self.deliveryNumber = nil;
    self.companyPhone = nil;
    self.call = nil;
    self.bg = nil;
    self.comment = nil;
    self.signedTime = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupView
{
    self.bg.layer.borderWidth = 1;
    self.bg.layer.cornerRadius = 12;
    self.bg.layer.borderColor = [[UIColor grayColor] CGColor];
    
    if (self.backgroundView == nil) {
        self.backgroundView = [[[UIView alloc]init]autorelease];
    }
    
    self.call.layer.cornerRadius = 12;
    
    self.comment.backgroundColor = [UIColor whiteColor];
     
    _companyName.text = [NSString stringWithFormat:@"%@(%@)",self.result.expTextName,[self.result getStatusDescription]];
    _companyLogo.image = [UIImage imageNamed:self.result.expSpellName];
    _deliveryNumber.text = [NSString stringWithFormat:@"单号:%@", self.result.mailNo];
    self.comment.text = self.result.comment;
    
    NSString *st = DEFAULT_CONTEXT;
    if (self.result.sendTime.length > 0) {
        st = self.result.sendTime;
    }
    _sendTime.text = [NSString stringWithFormat:@"发货时间：%@",st];
    
    NSString *lc = DEFAULT_CONTEXT;
    if (self.result.latestContext.length>0) {
        lc = self.result.latestContext;
    }    
    _latestContext.text = [NSString stringWithFormat:@"当前情况：%@",lc];
    
    NSString *cp = DEFAULT_CONTEXT;
    if (self.result.companyPhone) {
        cp = self.result.companyPhone;
    }
    _companyPhone.text = [NSString stringWithFormat:@"%@：%@",self.result.expTextName ,cp];
    
    NSString *sdt = DEFAULT_CONTEXT;
    if (self.result.signTime) {
        sdt = self.result.signTime;
    }
    _signedTime.text = [NSString stringWithFormat:@"签收时间：%@",sdt];
    
    [self.call addTarget:self action:@selector(callTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.call addTarget:self action:@selector(callTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    [self.call addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}
+(CGFloat)cellHeight
{
    return 221.0;
}
+(CGFloat)cellWidth
{
    return SCREEN_WIDTH;
}
+(NSString*)cellIdentifer
{
    return @"SSDQMD";
}
+(id)createCell:(SSDQDeliveryResult *)result
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSDQMyDeliverCell"
                                                 owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[SSDQMyDeliveryCell class]])
        {
            SSDQMyDeliveryCell *obj = (SSDQMyDeliveryCell *)oneObject;
            obj.frame = CGRectMake(0.0, 0.0, [SSDQMyDeliveryCell cellWidth], [SSDQMyDeliveryCell cellHeight]);
            obj.result = result;
            
            [obj setupView];
            
            return  obj;
        }
    }
    return nil;
}

-(void)callPhone {
    
    [self callTouchUp];
    [SSSystemUtils makeCallWithNumber:self.result.companyPhone];
}

-(void)callTouchDown {
    self.call.alpha = 0.7;
}

-(void)callTouchUp {
    self.call.alpha = 1.0;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            [SSSystemUtils makeCallWithNumber:self.result.companyPhone];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self saveComment];
    self.result.comment = self.comment.text;
}

-(void)closeKeyBoard:(id)sender {
    [sender resignFirstResponder];
    [self saveComment]; 
}

-(void)saveComment {
    if (self.comment.text.length <= 0) {
        return;
    }
    
    FMDatabase *db = GETDB;
    
    if ([db open]) {
        NSString *str= [NSString stringWithFormat:@"update DeliveryQueryHistoryMain set comment='%@' where id = %d",self.comment.text, self.result.id];
        
        BOOL success = [db executeUpdate:str];
        NSLog(@"result is %d",success);
        
    }
    
    [db close];
}

@end
