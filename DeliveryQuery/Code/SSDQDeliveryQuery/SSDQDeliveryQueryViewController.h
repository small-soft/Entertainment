//
//  SSDQDeliveryQueryViewController.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "SSDQDeliveryCompany.h"
#import <RestKit/RestKit.h>
#import "SSViewController.h"

@interface SSDQDeliveryQueryViewController : SSViewController <ZBarReaderDelegate,RKRequestDelegate,UIAlertViewDelegate,UIWebViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain) SSDQDeliveryCompany *company;

@end
