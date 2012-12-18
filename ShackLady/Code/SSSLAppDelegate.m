//
//  SSQUAppDelegate.m
//  QueryUtilities
//
//  Created by 佳 刘 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSSLAppDelegate.h"

#import <RestKit/RestKit.h>
#import "SSMoreViewController.h"
#import "MobWinBannerView.h"
#import "SSUncaughtExceptionService.h"
#import "SSSLShakeViewController.h"
#import "HJObjManager.h"
#import "SSSLMainMenuViewController.h"
@interface SSSLAppDelegate()
@property (nonatomic, retain) MobWinBannerView *advBannerView;
@end
@implementation SSSLAppDelegate

@synthesize window = _window;
@synthesize rootViewController = _rootViewController;
@synthesize advBannerView = _advBannerView;
@synthesize navigationController = _navigationController;

- (void)dealloc
{
    [self.advBannerView stopRequest];
    [self.advBannerView removeFromSuperview];
    self.advBannerView = nil;
    [_window release];
    self.navigationController = nil;
    self.rootViewController = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initDB];
    
    // Initialize RestKit
    RKClient* client = [RKClient clientWithBaseURLString: @"http://aisoucang.com/"];
    
    // Enable automatic network activity indicator management
    client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    //由于存在默认路径下的缓存及缓存策略 因此只需设定过期时间即可。
    client.cachePolicy = RKRequestCachePolicyNone;
    
    HJObjManager *objManager = [HJObjManager sharedManager];
    NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/HJCaches/imgcache"] ;
    
	HJMOFileCache * fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	objManager.fileCache = fileCache;
	fileCache.fileCountLimit = 10000;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
    
    application.applicationSupportsShakeToEdit = YES;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
//    SSSLShakeViewController* mainViewController = [[SSSLShakeViewController alloc] initWithNibName:@"SSSLShakeViewController" bundle:nil] ;
    SSSLMainMenuViewController* mainViewController = [[SSSLMainMenuViewController alloc] initWithNibName:@"SSSLMainMenuViewController" bundle:nil] ;
    mainViewController.navigationItem.title = @"主菜单";
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIButton * infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];

    UIBarButtonItem * infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [infoButton addTarget:self action:@selector(infoBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    mainViewController.navigationItem.leftBarButtonItem = infoButtonItem ;
    
    [infoButtonItem release];
    [mainViewController release];
    
    _rootViewController = [[UIViewController alloc] init];
    UIView * rootView = [[UIView alloc] initWithFrame:self.window.frame];
    _rootViewController.view = rootView;
    [rootView release];
    
    [self setFrame4Ad];
    
    [self.rootViewController.view addSubview:self.navigationController.view];
    
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    [SSUncaughtExceptionService setDefaultHandler];
    return YES;
}

-(void)setFrame4Ad {
    
    if (HAS_AD) {
        self.navigationController.view.frame = CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height - 25);
        
        [self setAd];
    }
}


-(void)setAd{
    _advBannerView = [[MobWinBannerView alloc] initMobWinBannerSizeIdentifier:MobWINBannerSizeIdentifier320x25];
    
    self.advBannerView.rootViewController = self.rootViewController;
	[self.advBannerView setAdUnitID:@"B3F1C5C314536E9752204C699B2EB8E1"];
    //    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
    self.advBannerView.frame = CGRectMake(self.rootViewController.view.frame.origin.x, self.rootViewController.view.frame.size.height-45, self.advBannerView.frame.size.width, 25);
    //    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
    //	[self.viewController.view addSubview:self.advBannerView];
    [self.rootViewController.view addSubview:self.advBannerView];
    self.advBannerView.adGpsMode = NO;
    [self.advBannerView startRequest];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

- (void)infoBtnPress{
    SSMoreViewController *moreViewController = [[SSMoreViewController alloc] initWithNibName:@"SSMoreViewController" bundle:nil];
    SET_GRAY_BG(moreViewController);
    moreViewController.navigationItem.title = @"关于";
    [self.navigationController pushViewController:moreViewController animated:YES];
    [moreViewController release];
}

- (void)initDB {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mydb.sqlite"];
    
    NSLog(@"db path:%@",writableDBPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:writableDBPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"ShakeLadyDB" ofType:@"sqlite" ] toPath:writableDBPath error:nil];
    }
    
    
    self.db = [FMDatabase databaseWithPath:writableDBPath];
}
@end
