//
//  SSDQMyDeliveryCell.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "SSDQDeliveryQueryResult.h"

@interface SSDQMyDeliveryCell : UITableViewCell<UIAlertViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain) SSDQDeliveryResult *result;

-(void)setupView;

+(CGFloat)cellHeight;
+(CGFloat)cellWidth;
+(NSString*)cellIdentifer;
+(id)createCell:(SSDQDeliveryResult *)result;
@end
