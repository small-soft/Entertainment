//
//  SSWebViewController.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"

@interface SSWebViewController : SSViewController<UIWebViewDelegate>

@property(nonatomic,retain) NSURL *url;

@end
