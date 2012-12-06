//
//  SSQUMoreViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-30.
//
//

#import "SSMoreViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SSWebViewController.h"
@interface SSMoreViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, retain) IBOutlet UILabel * versionLabel;
@property (nonatomic, retain) IBOutlet UITableView * contentTableView;
@property (nonatomic, retain) IBOutlet UILabel * appName;
@end

@implementation SSMoreViewController
@synthesize versionLabel = _versionLabel;
@synthesize contentTableView = _contentTableView;
@synthesize appName = _appName;
- (void)dealloc
{
    self.versionLabel = nil;
    self.contentTableView = nil;
    self.appName = nil;
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
	// Do any additional setup after loading the view.
    self.versionLabel.text = [NSString stringWithFormat:@"V %@" ,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    self.appName.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.contentTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GRAY_BG]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"关于我们";
    }else{
        return @"支持Small-Soft";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    if ([indexPath section]==0) {
        if ([indexPath row]==0) {
            cell.textLabel.text = @"开发者:Small-Soft";
        }else if([indexPath row]==1){
            cell.textLabel.text = @"Email:small-soft@live.com";
        }
        
    }else if([indexPath section]==1){
        if ([indexPath row]==0) {
            cell.textLabel.text = @"意见反馈";
        }else if([indexPath row]==1){
            cell.textLabel.text = @"给app评分";
        }else if([indexPath row]==2){
            cell.textLabel.text = @"精品推荐";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //appId为
    NSString *appId = @"584393528";
    if (HAS_AD) {
        appId =@"584755872";
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([indexPath section]==0) {
        if ([indexPath row]==1) {
            [self sendEmailToSmallSoft];
        }else if([indexPath row] == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/artist/jia-liu/id%@",appId]]];
        }
    }else if([indexPath section]==1){
        if ([indexPath row]==0) {
            [self sendEmailToSmallSoft];
        }else if([indexPath row]==1){
            
            NSString *urlValue =[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlValue]];
        }else if([indexPath row] == 2){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/artist/jia-liu/id%@",appId]]];
        }
    }
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"意见反馈"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"small-soft@live.com"];
	
	[picker setToRecipients:toRecipients];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                              message:@"已经保存为草稿！^_^"
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
			break;
		case MFMailComposeResultSent:
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"发送成功！感谢您的重要反馈^_^"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
    [self dismissModalViewControllerAnimated:YES];
	
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:small-soft@live.com&subject=意见反馈";
	
	NSString *email = [NSString stringWithFormat:@"%@", recipients];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)sendEmailToSmallSoft{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}
@end
