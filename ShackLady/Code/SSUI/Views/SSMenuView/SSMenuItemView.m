//
//  SSMenuItemView.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-25.
//
//

#import "SSMenuItemView.h"

@implementation SSMenuItemView
@synthesize imageView = _imageView;
@synthesize label = _label;
@synthesize detailLabel = _detailLabel;
@synthesize button = _button;
@synthesize maskImageView = _maskImageView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize imageFromNet = _imageFromNet;
- (id)init {
	self = [super init];
	
	if (self = [self initWithStyle:SSMenuItemViewStyleImageAndText]) {
        
	}
	
	return self;
}

-(id)initWithStyle:(SSMenuItemViewStyle)style{
    self = [super init];
	
	if (self) {
        switch (style) {
            case SSMenuItemViewStyleImageAndText:
            {
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SSMenuItemViewStyleImageAndText" owner:self options:nil];
                
                self = [[views objectAtIndex:0] retain];
                
                
                break;
            }
            case SSMenuItemViewStyleTextOnly:{
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SSMenuItemViewStyleTextOnly" owner:self options:nil];
                
                self = [[views objectAtIndex:0] retain];
                
                
                break;
            }
//            case SSMenuItemViewStyleImageOnly:{
//                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SSMenuItemViewStyleImageOnly" owner:self options:nil];
//                
//                self = [[views objectAtIndex:0] retain];
//                
//                
//                break;
//            }
            default:
                break;
        }
        
	}
	
	return self;
}

-(void)dealloc{
    self.imageView = nil;
    self.label = nil;
    self.button = nil;
    self.maskImageView = nil;
    self.backgroundImageView = nil;
    self.detailLabel = nil;
    self.imageFromNet = nil;
    [super dealloc];
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setTag:(NSInteger)tag {
	self.button.tag = tag;
}

- (NSInteger)tag {
	return self.button.tag;
}
@end
