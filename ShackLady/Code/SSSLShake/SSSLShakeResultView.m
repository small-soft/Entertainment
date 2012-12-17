//
//  SSSLShakeResultView.m
//  ShakeLady
//
//  Created by 于 佳 on 12-12-7.
//
//

#import "SSSLShakeResultView.h"

@implementation SSSLShakeResultView
@synthesize resultLabel = _resultLabel;
@synthesize ladyImg = _ladyImg;
- (id)init
{
    self = [super init];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SSSLShakeResultView" owner:self options:nil];
        
        self = [[views objectAtIndex:0] retain];

    }
    return self;
}

-(void)dealloc{
    self.resultLabel = nil;
    self.ladyImg = nil;
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
@end
