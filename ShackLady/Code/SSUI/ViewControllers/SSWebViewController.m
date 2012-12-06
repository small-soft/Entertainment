//
//  SSWebViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-28.
//
//

#import "SSWebViewController.h"
#import "SSToastView.h"

@interface SSWebViewController ()
@property (nonatomic,retain) IBOutlet UIWebView *webView;

@end

@implementation SSWebViewController
@synthesize webView = _webView;
@synthesize url = _url;

-(void)viewDidUnload {
    self.webView = nil;
    self.url = nil;
    
    [super viewDidUnload];
}

-(void)dealloc {
    [self.webView release];
    [self.url release];
    
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
    self.backTitle = @"返回";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.loadingView showLoadingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gogoLast {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (IBAction)gotoNext {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
- (IBAction)gotoHome {
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc ] initWithURL: self.url];
    [self.webView loadRequest: request ];
    [ request release ];
}
- (IBAction)gotoRefresh:(id)sender {
    [self.webView reload];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView hideLoadingView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.loadingView hideLoadingView];
    [SSToastView MakeToastWithType:TOAST_STYLE_FAIL info:@"访问失败，请查看网络连接是否正常"];
}

@end
