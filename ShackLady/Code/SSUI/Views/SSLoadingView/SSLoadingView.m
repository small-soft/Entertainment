//
//  SSQULoadingView.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-28.
//
//

#import "SSLoadingView.h"
#import "UIView+UIViewUtil.h"
#import "ADVPercentProgressBar.h"

@interface SSLoadingView()

@property(nonatomic,retain)ADVPercentProgressBar *processBar;
@property(nonatomic,retain)UILabel *updateInfo;

@end

@implementation SSLoadingView
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize noDataView = _noDataView;
@synthesize loadingView = _loadingView;
@synthesize process = _process;
@synthesize useProcessBar = _useProcessBar;
@synthesize processBar = _processBar;
@synthesize updateInfo = _updateInfo;

-(void)dealloc{
    self.activityIndicatorView = nil;
    self.noDataView = nil;
    self.loadingView = nil;
    self.processBar = nil;
    self.updateInfo = nil;
    [super dealloc];
}

-(id)init{
    if (self = [super init]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSLoadingView" owner:self options:nil];
        for (id oneObject in nib){
            if ([oneObject isKindOfClass:[SSLoadingView class]]){
                self = [(SSLoadingView *)oneObject retain];
                break;
            }
        }
            
    
    }
    
    return self;
}

-(id)initWithProcessBar:(BOOL)isUse process:(CGFloat)process {
    [self init];
    
    if (isUse) {
        [self initPrcessBar:process];
    }
    
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)showLoadingView{
    self.hidden = NO;
    self.noDataView.hidden = YES;
    self.loadingView.hidden = NO;
}

-(void)hideLoadingView{
    self.hidden = YES;
    self.noDataView.hidden = YES;
    self.loadingView.hidden = YES;
    self.processBar.hidden = YES;
}

-(void)showNoDataView {
    self.hidden = NO;
    self.noDataView.hidden = NO;
    self.loadingView.hidden = YES;
}

-(void)hideNoDataView{
    self.hidden = YES;
    self.noDataView.hidden = YES;
    self.loadingView.hidden = YES;
    self.processBar.hidden = YES;
}

-(void)hasToolBar {
    [self setHeight:(SCREEN_HEIGHT - (480 -358))];
    [self.noDataView setHeight:(SCREEN_HEIGHT - (480 -358))];
}

-(void)fullScreen {
    [self setHeight:(SCREEN_HEIGHT)];
}

-(void)initPrcessBar:(CGFloat)process {
    self.processBar.hidden = NO;
    if (self.processBar != nil) {
        return;
    }
    
    ADVPercentProgressBar *blueprogressBar = [[ADVPercentProgressBar alloc] initWithFrame:CGRectMake(15, 230, 290, 28) andProgressBarColor:ADVProgressBarBlue];
    
    [blueprogressBar setProgress:process];
    
    self.processBar = blueprogressBar;
    
    [self addSubview:self.processBar];
    
    self.updateInfo = [[[UILabel alloc]init]autorelease];
    self.updateInfo.frame = self.processBar.frame;
    [self.updateInfo verticalMove:-30];
    self.updateInfo.text = [NSString stringWithFormat:@"有0条最新快递信息"];
    self.updateInfo.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.updateInfo];
}

-(void)hasProcessBar:(CGFloat)process {
    [self initPrcessBar:process];
}

-(void)updateProcess:(CGFloat)process {
    [self.processBar setProgress:process];
}

-(void)updateUpdateInfo:(int)count {
    self.updateInfo.text = [NSString stringWithFormat:@"有%d条最新快递信息",count];
}
@end
