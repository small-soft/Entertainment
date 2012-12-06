//
//  SSDQMyDeliveryViewController.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-18.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"

@interface SSDQMyDeliveryViewController : SSViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) NSArray *statusArray;

@end
