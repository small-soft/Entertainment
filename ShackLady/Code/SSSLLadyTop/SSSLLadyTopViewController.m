//
//  SSSLLadyTopViewController.m
//  ShakeLady
//
//  Created by 刘 佳 on 12-12-21.
//
//

#import "SSSLLadyTopViewController.h"
#import <RestKit/RestKit.h>
#import "SSSLLadyListResult.h"
#import "SSMapping4RestKitUtils.h"
#import "SSMenuItemView.h"
#import "SSMenuView.h"
#import "HJObjManager.h"
#import "UIView+UIViewUtil.h"
#import "FGalleryPhotoView.h"

#import <QuartzCore/QuartzCore.h>

@interface SSSLLadyTopViewController ()<RKRequestDelegate,SSMenuViewDelegate>

@property(nonatomic,retain) NSArray *data;
@property(nonatomic,retain) IBOutlet SSMenuView *menuView;
@property(nonatomic,retain) IBOutlet HJManagedImageV *bigImage;

@end

@implementation SSSLLadyTopViewController
@synthesize data = _data;
@synthesize menuView = _menuView;
@synthesize bigImage = _bigImage;

-(void)dealloc {
    self.data = nil;
    self.menuView = nil;
    self.bigImage = nil;
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;

    [super viewWillAppear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"排行榜";
    [self sendRequestToGetLadyList];
    
    self.bigImage.hidden = YES;
    
    [self setBigImageGuesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark request

-(void)sendRequestToGetLadyList{
    RKClient *client = [RKClient sharedClient];
    [client get:[NSString stringWithFormat:@"favorites/json/shakeLady.json?operation=top&userType=%@&userName=%@",USER_TYPE,USER_NAME] delegate:self];
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"response %@", [response bodyAsString]);
    SSSLLadyListResult * ladyListResult = [SSMapping4RestKitUtils performMappingWithMapping:[SSSLLadyListResult sharedObjectMapping] forJsonString:[response bodyAsString]];
//    HJObjManager * objManager = [HJObjManager sharedManager];
    
    if (ladyListResult == nil || ladyListResult.dataList.count == 0) {
        [self.loadingView showNoDataView];
        return;
    }
    
    self.data = ladyListResult.dataList;    
    [self setMenu];
//    for (SSSLLadyPic * ladyPic in ladyListResult.dataList) {
//        HJManagedImageV * imageV = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//        imageV.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.aisoucang.com/upload/shakeLady/%d.jpg",[ladyPic.picId integerValue]]];
////        [objManager manage:imageV];
////        [self.picMutArray addObject:imageV];
//        [imageV release];
//        
//        [self.ladyMutArray addObject:ladyPic];
//    }
//    if ([self.delegate respondsToSelector:@selector(SSSLShakePicLoderRequestFinished:)]) {
//        [self.delegate SSSLShakePicLoderRequestFinished:YES];
//    }
    
}

#pragma mark -
#pragma mark menu

#pragma mark - SSMenuViewDelegate Methods
-(void)menuView:(SSMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index{
//    NSString * menuTileForIndex = [self.menuTitle objectAtIndex:index];
//    if ([menuTileForIndex isEqualToString:NSLocalizedString(@"ShakeLady",nil)]) {
//        SSSLShakeViewController * shakeViewController = [[SSSLShakeViewController alloc] init];
//        [self.navigationController pushViewController:shakeViewController animated:YES];
//        [shakeViewController release];
//    }else if ([menuTileForIndex isEqualToString:NSLocalizedString(@"MyLady",nil)]){
//        //        SSSLMyLadyViewController *myLadyViewController = [[SSSLMyLadyViewController alloc] init];
//        //        [self.navigationController pushViewController:myLadyViewController animated:YES];
//        //        [myLadyViewController release];
//        
//        FGalleryViewController * localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
//        [self.navigationController pushViewController:localGallery animated:YES];
//        [localGallery release];
//    }else if ([menuTileForIndex isEqualToString:NSLocalizedString(@"Top10",nil)]) {
//        SSSLLadyTopViewController * shakeViewController = [[SSSLLadyTopViewController alloc] init];
//        [self.navigationController pushViewController:shakeViewController animated:YES];
//        [shakeViewController release];
//    }
    SSSLLadyPic *lady = [self.data objectAtIndex:index];
    HJObjManager * objManager = [HJObjManager sharedManager];
    
    self.bigImage.frame = self.view.frame;
    self.bigImage.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.aisoucang.com/upload/shakeLady/%d.jpg",[lady.picId integerValue]]];
    [objManager manage:self.bigImage];
    
    self.bigImage.hidden = NO;
}

-(NSUInteger)menuViewNumberOfItems:(SSMenuView*)menuView{
    return self.data.count;
}

-(SSMenuItemView*)menuView:(SSMenuView *)menuView ItemViewForRowAtIndex:(NSUInteger)index{
    SSMenuItemView * menuItemView = [[[SSMenuItemView alloc] initWithStyle:SSMenuItemViewStyleImageAndText] autorelease];
    
    SSSLLadyPic *lady = [self.data objectAtIndex:index];
    
    HJObjManager * objManager = [HJObjManager sharedManager];
    
    menuItemView.imageFromNet.frame = CGRectMake(0, 0, 120, 170);
    menuItemView.imageFromNet.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.aisoucang.com/upload/shakeLady/%d.jpg",[lady.picId integerValue]]];
    [objManager manage:menuItemView.imageFromNet];
    
    menuItemView.label.text = [NSString stringWithFormat:@"No.%d",index+1];
    menuItemView.label.textAlignment = UITextAlignmentLeft;
    [menuItemView.label setOriginX:5];
    menuItemView.label.textColor = [UIColor whiteColor];
    
    UIView *rateBg = [[UIView alloc]initWithFrame:CGRectMake(0, 145, 40, 12)];
    rateBg.backgroundColor = [UIColor grayColor];
    rateBg.alpha = 0.7f;
    
    [menuItemView addSubview:rateBg];
    
    [menuItemView bringSubviewToFront:menuItemView.label];
    
    UILabel *rateLabel = [[[UILabel alloc]initWithFrame:menuItemView.label.frame]autorelease];
    rateLabel.backgroundColor = [UIColor clearColor];
    rateLabel.textColor = [UIColor redColor];
    rateLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [rateLabel setOriginWithX:50 andY:140];
    rateLabel.text = [NSString stringWithFormat:@"%.1f",lady.rate];
    
    [menuItemView addSubview:rateLabel];
    
    menuItemView.layer.borderWidth = 1;
//    menuItemView.layer.cornerRadius = 12;
    menuItemView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    return menuItemView;
}

-(void)setMenu{
    self.menuView.scrollEnabled = YES;
    self.menuView.menuDelegate = self;
    self.menuView.itemSize = CGSizeMake(120, 170);
    self.menuView.columnCount = 2;
    self.menuView.yPadding = 20;
    [self.menuView reloadData];

}

-(void)setBigImageGuesture{
    UITapGestureRecognizer *oneFingerOneTaps =
    
    [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBigImage)] autorelease];
    

    // Set required taps and number of touches

    [oneFingerOneTaps setNumberOfTapsRequired:1];
    [oneFingerOneTaps setNumberOfTouchesRequired:1];

    // Add the gesture to the view
    [self.bigImage addGestureRecognizer:oneFingerOneTaps];

}

-(void)hideBigImage{
    self.bigImage.hidden = YES;
}
@end
