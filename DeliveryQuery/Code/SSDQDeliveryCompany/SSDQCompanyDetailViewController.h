//
//  SSDQCompanyDetailViewController.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-26.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"
#import "SSDQDeliveryCompany.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SSDQCompanyDetailViewController : SSViewController<MFMessageComposeViewControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic,retain) SSDQDeliveryCompany *company;
@property(nonatomic) BOOL cannotFav;

@end
