//
//  AliToastVew.m
//  AlibabaMobile
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSToastView.h"
#import <QuartzCore/QuartzCore.h> 

#define DEFAULT_TOAST_X  60
#define DEFAULT_TOAST_Y  144
#define DEFAULT_TOAST_WIDTH  200
#define DEFAULT_TOAST_HEIGHT  70

#define LABEL_MAX_WIDTH  180
#define LABEL_MAX_HEIGTH 80

const int TOAST_STYLE_COMMON = 0;
const int TOAST_STYLE_SUCC = 1;
const int TOAST_STYLE_FAIL = 2;
const int TOAST_STYLE_FAV = 3;

const int TOAST_SHOW_TIME = 2;

@interface SSToastView()

@property (nonatomic, retain) UILabel * textLabel;
@property (nonatomic, retain) UIImageView * typeImage;

@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSString * text;

- (id)initWithType:(int) type text:(NSString *)text;
- (void) setContent;
- (NSString *)getTypeImage;

@end

@implementation SSToastView

@synthesize textLabel = _textLabel;
@synthesize typeImage = _typeImage;
@synthesize type = _type;
@synthesize text= _text;


+ (SSToastView *)MakeToastWithType:(int)type info:(NSString *)text {
    SSToastView * toastView = [[[SSToastView alloc] initWithType:type text:text] autorelease];
    
    return toastView;
}

- (void) show {
    [self performSelectorOnMainThread:@selector(showThread) withObject:nil waitUntilDone:YES];
}

-(void) showAllTime {
    [self performSelectorOnMainThread:@selector(showThreadAllTime) withObject:nil waitUntilDone:YES];
}

- (void) showThreadAllTime {
    UIWindow * window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.alpha = 0.0;
    [window addSubview:self];
//    [NSTimer scheduledTimerWithTimeInterval:(TOAST_SHOW_TIME) target:self selector:@selector(hide) userInfo:nil repeats:YES];
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5];
    self.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void) showThread {
    UIWindow * window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.alpha = 0.0;
    [window addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval:(TOAST_SHOW_TIME) target:self selector:@selector(hide) userInfo:nil repeats:YES];
    [UIView beginAnimations:@"show" context:NULL];                                                                                   
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];                                                                           
    [UIView setAnimationDuration:0.5];                                                                                               
    self.alpha = 1.0f;                                                                                                        
    [UIView commitAnimations];  
}

- (void)hide {
    [UIView beginAnimations:@"hide" context:NULL];                                                                                  
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];                                                                         
    [UIView setAnimationDelegate:self];                                                                                             
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];                                                                   
    [UIView setAnimationDuration:0.8];                                                                                              
    self.alpha = 0.0f;                                                                                                       
    [UIView commitAnimations];     
}

- (IBAction) dismissToast {
    self.hidden = YES;
    [self removeFromSuperview ];
}

- (id)initWithType:(int) type text:(NSString *)text {
    [super init ];
    if(self){
        self.type = type;
        self.text = text;
        
        [self setContent ];
    }
    return self;
}

- (void) setContent {
    CGSize labelSize = [self.text sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] constrainedToSize:CGSizeMake(LABEL_MAX_WIDTH, LABEL_MAX_HEIGTH) lineBreakMode:UILineBreakModeCharacterWrap];

    CGFloat toastTotalHeigth = DEFAULT_TOAST_HEIGHT + labelSize.height;
    
    UIImage * bgImg = [UIImage imageNamed:@"bg_toast"];
    bgImg = [bgImg stretchableImageWithLeftCapWidth:bgImg.size.width/4 topCapHeight:bgImg.size.height/4];
    

    UIImageView * bkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_TOAST_WIDTH, toastTotalHeigth)];
    bkImgView.backgroundColor = [UIColor clearColor];
    bkImgView.image = bgImg;
    
    [self addSubview:bkImgView];
    [bkImgView release];
    
    self.typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(85, 15, 30, 30)];
    self.typeImage.backgroundColor = [UIColor clearColor];
    self.typeImage.contentMode = UIViewContentModeCenter;
    self.typeImage.image = [UIImage imageNamed:[self getTypeImage]];
    [self addSubview:self.typeImage];
    [self.typeImage release];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 170, 16)];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [self.textLabel setNumberOfLines:0];
    
    self.textLabel.text = self.text;
    self.textLabel.frame = CGRectMake(10, 55, LABEL_MAX_WIDTH, labelSize.height);

    [self addSubview:self.textLabel];
    [self.textLabel release];
    
    self.frame = CGRectMake(DEFAULT_TOAST_X, DEFAULT_TOAST_Y, DEFAULT_TOAST_WIDTH, toastTotalHeigth);
}

- (NSString *)getTypeImage {
    switch (self.type) {
        case TOAST_STYLE_SUCC:
            return @"icon_toast_success";
            break;
        case TOAST_STYLE_FAIL:
            return @"icon_toast_info";
            break;
        default:
            return @"icon_toast_info";
            break;
    }
}

-(void) dealloc {
    [self.textLabel release];
    [self.typeImage release];
    [self.text release];
    
    [super dealloc];
}


@end
