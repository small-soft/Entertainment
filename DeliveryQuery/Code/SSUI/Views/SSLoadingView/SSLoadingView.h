//
//  SSQULoadingView.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-28.
//
//

#import <UIKit/UIKit.h>


@interface SSLoadingView : UIView
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,retain) IBOutlet UIView *noDataView;
@property (nonatomic,retain) IBOutlet UIView *loadingView;
@property (nonatomic) BOOL useProcessBar;
@property (nonatomic) int process;

-(void)showLoadingView;
-(void)hideLoadingView;
-(void)showNoDataView;
-(void)hideNoDataView;
-(void)hasToolBar;
-(void)fullScreen;

-(void)hasProcessBar:(CGFloat)process;
-(void)updateProcess:(CGFloat)process;
-(void)updateUpdateInfo:(int)count;

-(id)initWithProcessBar:(BOOL)isUse process:(CGFloat)process;
@end
