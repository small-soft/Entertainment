//
//  SSSLShakeViewController.m
//  ShakeLady
//
//  Created by 于 佳 on 12-12-6.
//
//

#import "SSSLShakeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SSSLShakeResultView.h"
#import "SSSLLadyListResult.h"
#import "SSMapping4RestKitUtils.h"
#import "HJObjManager.h"
#import "HJManagedImageVDelegate.h"
#import "SSSLShakePicLoder.h"
@interface SSSLShakeViewController ()<SSSLShakePicLoderDelegate,HJManagedImageVDelegate>{
    SystemSoundID _soundID;
}

@property (nonatomic, retain) IBOutlet UIImageView * upImg;
@property (nonatomic, retain) IBOutlet UIImageView * downImg;
@property (nonatomic, retain) IBOutlet UIImageView * bgImg;
@property (nonatomic, retain) SSSLShakeResultView * resultView;
//@property (nonatomic, retain) SSSLLadyListResult * ladyListResult;
@property (nonatomic, assign) BOOL isShaked;
//@property (nonatomic, retain) NSMutableArray * ;
@end

@implementation SSSLShakeViewController
@synthesize upImg = _upImg;
@synthesize downImg = _downImg;
@synthesize bgImg = _bgImg;
@synthesize resultView = _resultView;
//@synthesize ladyListResult = _ladyListResult;
@synthesize isShaked = _isShaked;

-(SSSLShakeResultView *)resultView{
    if (_resultView==nil) {
        _resultView = [[SSSLShakeResultView alloc] init];
        [self.view addSubview:_resultView];
        self.resultView.alpha = 0;
    }
    return _resultView;
}

-(void)dealloc{
//    [SSSLShakePicLoder sharedInstance].delegate = nil;
    self.bgImg = nil;
    self.upImg = nil;
    self.downImg = nil;
    self.resultView = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isShaked = NO;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *shakeBg = [UIImage imageNamed:@"shake_bg"];
    self.bgImg.image = shakeBg;
    UIImage *shakeUp = [UIImage imageNamed:@"shake_up"];
    self.upImg.image = [shakeUp stretchableImageWithLeftCapWidth:shakeUp.size.width/2 topCapHeight:shakeUp.size.height/2];
    UIImage *shakeDown = [UIImage imageNamed:@"shake_down"];
    self.downImg.image = [shakeDown stretchableImageWithLeftCapWidth:shakeDown.size.width/2 topCapHeight:shakeDown.size.height/2];
    [SSSLShakePicLoder sharedInstance].delegate = self;
    
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
    if (self.isShaked) {
        return;
    }
	if (motion == UIEventSubtypeMotionShake )
	{
        NSLog(@"shake");
        [self shake];
        self.isShaked = YES;
	}
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

-(void)shake{

    AudioServicesPlaySystemSound(_soundID);
    //让imgup上下移动
    CABasicAnimation *translationUp = [CABasicAnimation animationWithKeyPath:@"position"];
    translationUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translationUp.fromValue = [NSValue valueWithCGPoint:self.upImg.center];
    translationUp.toValue = [NSValue valueWithCGPoint:CGPointMake(self.upImg.center.x, self.upImg.center.y - 75)];
    translationUp.duration = 0.4;
    translationUp.repeatCount = 1;
    translationUp.autoreverses = YES;
    
    //让imagdown上下移动
    CABasicAnimation *translationDown = [CABasicAnimation animationWithKeyPath:@"position"];
    translationDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translationDown.fromValue = [NSValue valueWithCGPoint:self.downImg.center];
    translationDown.toValue = [NSValue valueWithCGPoint:CGPointMake(self.downImg.center.x, self.downImg.center.y + 75)];
    translationDown.duration = 0.4;
    translationDown.repeatCount = 1;
    translationDown.autoreverses = YES;
    [self.downImg.layer addAnimation:translationDown forKey:@"translationDown"];
    [self.upImg.layer addAnimation:translationUp forKey:@"translationUp"];
    NSMutableArray * picMutArray = [SSSLShakePicLoder sharedInstance].picMutArray;

    [self.loadingView showLoadingView];
    if (picMutArray==nil||picMutArray.count<=5) {
        [SSSLShakePicLoder sendRequestToGetLadyList];
    }else{
        [self showResultView];
    }
}


-(void)showResultView{
    NSMutableArray * picMutArray = [SSSLShakePicLoder sharedInstance].picMutArray;
    if (picMutArray!=nil&&picMutArray.count!=0) {
        self.resultView.ladyImg = (HJManagedImageV*)[picMutArray objectAtIndex:0];
        [self.resultView insertSubview:(HJManagedImageV*)[picMutArray objectAtIndex:0] belowSubview:self.resultView.resultLabel];

        NSLog(@"pop imgurl:%@",self.resultView.ladyImg.url.absoluteString);
        
        if (self.resultView.ladyImg.image==nil) {
            self.resultView.ladyImg.callbackOnSetImage = self;
            return;
        }
        
        [self popInLady];
    }
}

-(void)SSSLShakePicLoderRequestFinished:(BOOL)isLoadSuccessed{
    if (isLoadSuccessed) {
        [self showResultView];
    }
}
-(void)managedImageSet:(HJManagedImageV *)mi{
    [self popInLady];
}

-(void)popInLady{
    [self.loadingView hideLoadingView];
    NSTimeInterval duration = 0.7;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.85f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = duration * .4f;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeIn.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeIn, nil]];
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBoth;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.resultView.layer addAnimation:group forKey:@"translationPopIn"];
//    NSMutableArray * picMutArray = [SSSLShakePicLoder sharedInstance].picMutArray;
//    [[SSSLShakePicLoder sharedInstance].historyPicArray addObject:[picMutArray objectAtIndex:0]];
    
    [[SSSLShakePicLoder sharedInstance] nextLady];
    
}
@end
