//
//  SSSLShakeViewController.m
//  ShakeLady
//
//  Created by 于 佳 on 12-12-6.
//
//

#import "SSSLShakeViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SSSLShakeViewController ()
@property (nonatomic, retain) IBOutlet UIImageView * imgUp;
@property (nonatomic, retain) IBOutlet UIImageView * imgDown;
@end

@implementation SSSLShakeViewController
@synthesize imgUp = _imgUp;
@synthesize imgDown = _imgDown;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake )
	{
        NSLog(@"shake");
        [self shake];
	}
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

-(void)shake{
    //让imgup上下移动
    CABasicAnimation *translationUp = [CABasicAnimation animationWithKeyPath:@"position"];
    translationUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translationUp.fromValue = [NSValue valueWithCGPoint:self.imgUp.center];
    translationUp.toValue = [NSValue valueWithCGPoint:CGPointMake(self.imgUp.center.x, self.imgUp.center.y - 75)];
    translationUp.duration = 0.4;
    translationUp.repeatCount = 1;
    translationUp.autoreverses = YES;
    
    //让imagdown上下移动
    CABasicAnimation *translationDown = [CABasicAnimation animationWithKeyPath:@"position"];
    translationDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translationDown.fromValue = [NSValue valueWithCGPoint:self.imgDown.center];
    translationDown.toValue = [NSValue valueWithCGPoint:CGPointMake(self.imgDown.center.x, self.imgDown.center.y + 75)];
    translationDown.duration = 0.4;
    translationDown.repeatCount = 1;
    translationDown.autoreverses = YES;
    
    [self.imgDown.layer addAnimation:translationDown forKey:@"translationDown"];
    [self.imgUp.layer addAnimation:translationUp forKey:@"translationUp"];
}

@end
