//
//  SSMenuItemView.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-25.
//
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

typedef enum {
    SSMenuItemViewStyleImageAndText,
//    SSMenuItemViewStyleTextOnly,
//    SSMenuItemViewStyleImageOnly
    SSMenuItemViewStyleTextOnly
}SSMenuItemViewStyle;

@interface SSMenuItemView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) IBOutlet UIImageView * maskImageView;
@property (retain, nonatomic) IBOutlet UIImageView * backgroundImageView;
@property (retain, nonatomic) IBOutlet HJManagedImageV *imageFromNet;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(id)initWithStyle:(SSMenuItemViewStyle)style;
@end
