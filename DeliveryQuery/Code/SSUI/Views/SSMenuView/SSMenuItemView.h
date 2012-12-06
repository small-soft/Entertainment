//
//  SSMenuItemView.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-25.
//
//

#import <UIKit/UIKit.h>
typedef enum {
    SSMenuItemViewStyleImageAndText,
//    SSMenuItemViewStyleTextOnly,
//    SSMenuItemViewStyleImageOnly
}SSMenuItemViewStyle;

@interface SSMenuItemView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) IBOutlet UIImageView * maskImageView;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(id)initWithStyle:(SSMenuItemViewStyle)style;
@end
