//
//  SSDQAllDeliveryCompanyListViewController.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-10.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"

typedef enum
{
    DeliverCompanyListDisplayModeViewOnly = 0, // default
    DeliverCompanyListDisplayModeSelect,
    
} DeliverCompanyListDisplayMode;

typedef enum
{
    DeliverCompanyListContentModeAll = 0, // default
    DeliverCompanyListContentModeFavOnly,
    DeliverCompanyListContentModeOtherOnly,
    
} DeliverCompanyListContentMode;

@interface SSDQAllDeliveryCompanyListViewController : SSViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic) DeliverCompanyListDisplayMode displayMode;
@property(nonatomic) DeliverCompanyListContentMode contentMode;
@end
