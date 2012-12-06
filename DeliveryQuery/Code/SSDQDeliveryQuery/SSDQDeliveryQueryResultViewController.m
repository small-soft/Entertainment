//
//  SSDQDeliveryQueryResultViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-15.
//
//

#import "SSDQDeliveryQueryResultViewController.h"
#import "FMDatabase.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSQUAppDelegate.h"
#import "SSDQMyDeliveryCell.h"
#import "UIView+UIViewUtil.h"
#import "SSSystemUtils.h"
#import "SSToastView.h"

@interface SSDQDeliveryQueryResultViewController ()

@property(nonatomic,retain) IBOutlet UITableView *manInfo;
@property(nonatomic,retain) IBOutlet UITableView *contentTable;
@property(nonatomic,retain) IBOutlet UILabel *supplier;
@end

@implementation SSDQDeliveryQueryResultViewController
@synthesize manInfo = _manInfo;
@synthesize result = _result;
@synthesize companyCode = _companyCode;
@synthesize deliveryNumber = _deliveryNumber;
@synthesize contentTable = _contentTable;
@synthesize supplier = _supplier;

-(void)dealloc{
    self.manInfo = nil;
    self.result = nil;
    self.companyCode = nil;
    self.deliveryNumber = nil;
    self.supplier = nil;
    self.contentTable = nil;
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
    // Do any additional setup after loading the view from its nib.
    
    [self initRightBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadDB];
    
    self.manInfo.frame = CGRectMake(0, 0, SCREEN_WIDTH, [SSDQMyDeliveryCell cellHeight]);
    self.contentTable.frame = CGRectMake(0, [SSDQMyDeliveryCell cellHeight], SCREEN_WIDTH, SCREEN_HEIGHT - self.manInfo.frame.size.height - 90 - 20);
    self.supplier.frame = CGRectMake(0, [self.contentTable endY] + 5, 320, 21);
    self.supplier.textAlignment = UITextAlignmentCenter;
    
    [self reSet4BellowIOS5];
    
    [super viewWillAppear:animated];
}

-(void)viewDidUnload {
    self.manInfo = nil;
    self.result = nil;
    self.companyCode = nil;
    self.deliveryNumber = nil;
    self.supplier = nil;
    self.contentTable = nil;
    
    [super viewDidUnload];
}

-(void)loadDB{
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from DeliveryQueryHistoryMain"];
        
        if (self.companyCode.length == 0 || self.deliveryNumber.length == 0) {
            return;
        }
        
        [sql appendFormat:@" where companyCode = '%@' and deliveryNumber = '%@'",self.companyCode,self.deliveryNumber];
        
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        
        if ([rs next]) {
            SSDQDeliveryResult *result = [[[SSDQDeliveryResult alloc]init]autorelease];
            result.id = [rs intForColumn:@"id"];
            result.expTextName = [rs stringForColumn:@"companyName"];
            result.expSpellName = [rs stringForColumn:@"companyCode"];
            result.mailNo = [rs stringForColumn:@"deliveryNumber"];
            result.status = [rs intForColumn:@"status"];
            result.latestContext = [rs stringForColumn:@"latestContext"];
            result.sendTime = [rs stringForColumn:@"sendTime"];
            result.signTime = [rs stringForColumn:@"signTime"];
            result.companyPhone = [rs stringForColumn:@"companyPhone"];
            result.comment = [rs stringForColumn:@"comment"];
            
            FMResultSet *items = [db executeQuery:[NSString stringWithFormat:@"SELECT * from DeliveryQueryHistoryItems where mainId = %d order by id DESC",result.id]];
            
            result.data = [NSMutableArray arrayWithCapacity:[items columnCount]];
            while ([items next]) {
                SSDQDeliveryItem *item = [[[SSDQDeliveryItem alloc]init]autorelease];
                item.time = [items stringForColumn:@"time"];
                item.context = [items stringForColumn:@"context"];
                
                [result.data addObject:item];
            }
            
            self.result = result;
            
        }
    }
    
    
    [db close];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSDQDQRC"];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSDQDQRC"]autorelease];
            
            if (cell.backgroundView == nil) {
                cell.backgroundView = [[[UIView alloc]init]autorelease];
            }
        }
        
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView.alpha = 1;
        if (indexPath.row%2 == 0) {
            
            cell.backgroundView.backgroundColor = [UIColor grayColor];
            cell.backgroundView.alpha = 0.1;
        }
        
        SSDQDeliveryItem *item = (SSDQDeliveryItem*)[self.result.data objectAtIndex:indexPath.row];
        
        cell.textLabel.text = item.time;
        cell.detailTextLabel.text = item.context;
        
        cell.detailTextLabel.numberOfLines = 2;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        return cell;

    }
    
    if (tableView == self.manInfo) {
        SSDQMyDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSDQMyDeliveryCell cellIdentifer]];
        
        if (cell == nil) {
            cell = [SSDQMyDeliveryCell createCell:nil];
        }
        
        cell.result = self.result;
        [cell setupView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.contentTable) {
        if (self.result == nil || self.result.data == nil) {
            return 0;
        }
        
        return [self.result.data count];
    }
    
    if (tableView == self.manInfo) {
        return 1;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.manInfo) {
        return [SSDQMyDeliveryCell cellHeight];
    }
    
    return 44.0 + 15.0;
}

-(void)sendMessage {

    [SSSystemUtils sendShotMessage:self content:[self getSendContent:NO]];
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
    [SSSystemUtils sendEmail:self title:[self getSendTitle] content:[self getSendContent:YES] toRecipients:nil];
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
    if (self.result.comment.length > 0) {
        return [NSString stringWithFormat:@"［%@的快递信息］",self.result.comment];
    }else {
        return [NSString stringWithFormat:@"［%@-%@的快递信息］",self.result.expTextName,self.result.mailNo];
    }
}

-(NSString*)getSendContent:(BOOL)needDetail {
    NSMutableString *content = [NSMutableString stringWithCapacity:100];
    if (self.result.comment.length > 0) {
        [content appendFormat:@"［%@的快递信息］",self.result.comment];
    }else {
        [content appendString:@"［快递信息］"];
    }
    
    [content appendFormat:@"\n 快递公司：%@",self.result.expTextName];
    [content appendFormat:@"\n 快递单号：%@",self.result.mailNo];
    [content appendFormat:@"\n 当前状态：%@",[self.result getStatusDescription]];
    [content appendFormat:@"\n 发货时间：%@",self.result.sendTime];
    if (self.result.signTime) {
        [content appendFormat:@"\n 签收时间：%@",self.result.signTime];
    }
    [content appendFormat:@"\n 当前情况：%@",self.result.latestContext];
    [content appendFormat:@"\n 快递公司电话：%@",self.result.companyPhone];
    
    if (needDetail && self.result.data && [self.result.data count] > 0) {
        [content appendFormat:@"\n\n ［详细追踪信息］"];
        for (SSDQDeliveryItem *item in self.result.data) {
            [content appendFormat:@"\n %@：%@",item.time,item.context];
        }
    }
    
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
    [self reSet4BellowIOS5OnCloseModal];
}

-(void)setFrame4Ad {
    if (HAS_AD) {
        [self.navigationController.view setHeight:[self.navigationController.view height]-25];
        [self.manInfo setHeight:[self.manInfo height]+25];
        [self.contentTable setHeight:[self.contentTable height]+25];
    }
}

-(void)reSet4BellowIOS5{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version < 5.0) {
        [self.manInfo setHeight:295];
        [self.contentTable setHeight:220];
    }
}

-(void)reSet4BellowIOS5OnCloseModal{
    self.manInfo.frame = CGRectMake(0, 0, SCREEN_WIDTH, [SSDQMyDeliveryCell cellHeight]);
    self.contentTable.frame = CGRectMake(0, [SSDQMyDeliveryCell cellHeight], SCREEN_WIDTH, SCREEN_HEIGHT - self.manInfo.frame.size.height - 90 - 20);
}
@end
