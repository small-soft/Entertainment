//
//  SSViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-29.
//
//

#import "SSViewController.h"
#import "SSLoadingView.h"
#import "MobWinBannerView.h"
#import "UIView+UIViewUtil.h"
#import "SSToastView.h"

@interface SSViewController ()
//@property (nonatomic, retain) MobWinBannerView *advBannerView;
@end

@implementation SSViewController
@synthesize loadingView = _loadingView;
//@synthesize advBannerView = _advBannerView;
@synthesize isLoading = _isLoading;
@synthesize backTitle = _backTitle;

-(SSLoadingView *)loadingView{
    if (nil==_loadingView) {
        _loadingView = [[SSLoadingView alloc] init];
        _loadingView.frame = self.view.frame;
        
//        [_loadingView setHeight:SCREEN_HEIGHT];
        
        [self.view addSubview:_loadingView];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    self.loadingView = nil;
    self.backTitle = nil;
//    [self.advBannerView stopRequest];
//    [self.advBannerView removeFromSuperview];
//    self.advBannerView = nil;

    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    _advBannerView = [[MobWinBannerView alloc] initMobWinBannerSizeIdentifier:MobWINBannerSizeIdentifier320x50];
//	self.advBannerView.rootViewController = self;
//	[self.advBannerView setAdUnitID:@"A495798C12C030F28E7711F3613DFC1B"];
//    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
//    self.advBannerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height-self.advBannerView.frame.size.height, self.advBannerView.frame.size.width, self.advBannerView.frame.size.height);
//    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
//	[self.view addSubview:self.advBannerView];
//    self.advBannerView.adGpsMode = NO;
//    [self.advBannerView startRequest];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 25);
    
    if (self.backTitle.length > 0) {
        self.navigationItem.leftBarButtonItem.title = self.backTitle;
    }
    
    [self setBg];
    
    SET_GRAY_BG(self);
    
    [self iViewWillApplear];
}

-(void)setBg {
    UIImage *image =  [UIImage imageNamed:@"smallsoftlogo"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    imageView.frame = CGRectMake((SCREEN_WIDTH - image.size.width)/2, SCREEN_HEIGHT - image.size.height - 20 -44 -2, image.size.width, image.size.height);
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.loadingView = nil;
//    [self.advBannerView stopRequest];
//    [self.advBannerView removeFromSuperview];
//    self.advBannerView = nil;
}

-(void)iViewWillApplear{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version < 5.0) {
        [self viewWillAppear:YES];
    }
}

@end
