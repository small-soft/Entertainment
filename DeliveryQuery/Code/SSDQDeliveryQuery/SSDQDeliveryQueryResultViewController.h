//
//  SSDQDeliveryQueryResultViewController.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-15.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"
#import "SSDQDeliveryQueryResult.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SSDQDeliveryQueryResultViewController : SSViewController <UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,retain) SSDQDeliveryResult * result;
@property(nonatomic,retain) NSString *companyCode;
@property(nonatomic,retain) NSString *deliveryNumber;

@end
