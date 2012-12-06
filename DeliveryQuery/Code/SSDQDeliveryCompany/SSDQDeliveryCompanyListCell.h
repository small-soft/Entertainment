//
//  SSDQDeliveryCompanyListCell.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-12.
//
//

#import <UIKit/UIKit.h>
#import "SSDQDeliveryCompany.h"

@interface SSDQDeliveryCompanyListCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UIImageView *logo;
@property(nonatomic,retain) IBOutlet UILabel *name;
@property(nonatomic,retain) IBOutlet UILabel *site;
@property(nonatomic,retain) IBOutlet UILabel *phone;

@property(nonatomic,retain) SSDQDeliveryCompany *company;

-(void)setupView;

+(CGFloat)cellHeight;
+(CGFloat)cellWidth;
+(NSString*)cellIdentifer;
+(id)createCell:(SSDQDeliveryCompany *)company;
@end
