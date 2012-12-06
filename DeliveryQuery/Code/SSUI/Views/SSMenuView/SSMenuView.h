//
//  SSMenuView.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-25.
//
//

#import <UIKit/UIKit.h>

@class SSMenuView,SSMenuItemView;
@protocol SSMenuViewDelegate <NSObject>
@required
-(NSUInteger)menuViewNumberOfItems:(SSMenuView*)menuView;

- (void)menuView:(SSMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index;
@optional
- (SSMenuItemView *)menuView:(SSMenuView *)menuView ItemViewForRowAtIndex:(NSUInteger)index;

//用于用户点击后响应，如更改背景图片，背景颜色等
- (void)menuView:(SSMenuView*)menuView  ItemPressedDownAtIndex:(NSUInteger)index;
- (void)menuView:(SSMenuView*)menuView  ItemPressedAtIndex:(NSUInteger)index;
- (void)menuView:(SSMenuView*)menuView  ItemPressedUpOutsideActionAtIndex:(NSUInteger)index;
- (void)menuView:(SSMenuView*)menuView  ItemPressedCancelActionAtIndex:(NSUInteger)index;
@end

@interface SSMenuView : UIScrollView

@property (nonatomic, assign) id<SSMenuViewDelegate>menuDelegate;
@property (nonatomic, retain) UIImageView * backgroundImageView;

@property (nonatomic) NSUInteger columnCount;// default is 4
@property (nonatomic) CGSize itemSize; // default is 80*80.
@property (nonatomic) NSInteger topPadding;
@property (nonatomic) NSInteger leftPadding;
@property (nonatomic) NSInteger bottomPadding;
//其中Ypadding必须大于-1 如果等于-1则说明没有设定。
@property (nonatomic) NSInteger yPadding;

-(void)reloadData;
@end
