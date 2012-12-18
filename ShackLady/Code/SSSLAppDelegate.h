//
//  SSQUAppDelegate.h
//  QueryUtilities
//
//  Created by 佳 刘 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface SSSLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIViewController *rootViewController;

@property (nonatomic,retain) FMDatabase *db;

@end
