//
//  SSViewController.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-29.
//
//

#import <UIKit/UIKit.h>
#import "SSLoadingView.h"
#import <RestKit/RestKit.h>

@interface SSViewController : UIViewController

@property (nonatomic, retain) SSLoadingView * loadingView;

@property (nonatomic, retain) NSString *backTitle;
@property (nonatomic) BOOL isLoading;

@end
