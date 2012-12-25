//
//  SSSLMainMenuViewController.m
//  ShakeLady
//
//  Created by 于 佳 on 12-12-9.
//
//

#import "SSSLMainMenuViewController.h"
#import "SSMenuItemView.h"
#import "SSMenuView.h"
#import "SSSLShakeViewController.h"
#import "SSSLShakePicLoder.h"
#import "FGalleryViewController.h"
#import "HJManagedImageV.h"
#import "HJObjManager.h"
#import "HJMOFileCache.h"
#import "FMDatabase.h"
#import "SSSLAppDelegate.h"
#import "SSSLLadyListResult.h"
#import "UIView+UIViewUtil.h"
#import "SSSLLadyTopViewController.h"
#import "SSMoreViewController.h"

@interface SSSLMainMenuViewController ()<SSMenuViewDelegate,SSSLShakePicLoderDelegate,FGalleryViewControllerDelegate>
@property (nonatomic, retain) IBOutlet SSMenuView * menuView;
@property (nonatomic, retain) NSArray *menuTitle;
@property (nonatomic, retain) NSArray *menuSubTitle;
@property (nonatomic, retain) NSMutableArray *myLady;
@property (nonatomic, retain) IBOutlet UIView *accountView;
@property (nonatomic, retain) IBOutlet UILabel *account;
@property (nonatomic, retain) IBOutlet UILabel *money;

@end

@implementation SSSLMainMenuViewController
@synthesize menuView = _menuView;
@synthesize menuTitle = _menuTitle;
@synthesize myLady = _myLady;
@synthesize accountView = _accountView;
@synthesize menuSubTitle = _menuSubTitle;
@synthesize account = _account;
@synthesize money = _money;

-(void)dealloc{
    self.menuView = nil;
    self.menuTitle = nil;
    self.menuSubTitle = nil;
    self.myLady = nil;
    self.accountView = nil;
    self.account = nil;
    self.money = nil;
    [super dealloc];
}

-(NSArray *)menuTitle{
    if(nil==_menuTitle){
        self.menuTitle = [[NSArray alloc] initWithObjects:NSLocalizedString(@"ShakeLady",nil), NSLocalizedString(@"MyLady", nil),NSLocalizedString(@"Top10", nil),NSLocalizedString(@"AllLady", nil),NSLocalizedString(@"Shop", nil),NSLocalizedString(@"Setting", nil), nil];
        
        self.menuSubTitle = [[NSArray alloc] initWithObjects:NSLocalizedString(@"ShakeLadyDes",nil), NSLocalizedString(@"MyLadyDes", nil),NSLocalizedString(@"Top10Des", nil),NSLocalizedString(@"AllLadyDes", nil),NSLocalizedString(@"ShopDes", nil),NSLocalizedString(@"SettingDes", nil), nil];
    }
    
    return _menuTitle;
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
    self.menuView.menuDelegate = self;
    self.menuView.itemSize = CGSizeMake(240, 40);
    self.menuView.columnCount = 1;
    self.menuView.yPadding = 15;
    [self.menuView reloadData];
    [SSSLShakePicLoder sharedInstance].delegate = self;
    [SSSLShakePicLoder sendRequestToGetLadyList];
    [self.loadingView showLoadingView];
    
//    self.view.backgroundColor = [UIColor colorWithRed:255. green:75. blue:112. alpha:1];
    
//    self.view.backgroundColor = [UIColor blackColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"shake_bg"];
    UIImage *stretchableImage = [buttonImageNormal stretchableImageWithLeftCapWidth:0 topCapHeight:100];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:stretchableImage];
    
    self.accountView.layer.borderWidth = 1;
    self.accountView.layer.cornerRadius = 12;
    self.accountView.layer.borderColor = [[UIColor grayColor] CGColor];
    
//    SET_GRAY_BG(self);
}

-(void)viewWillAppear:(BOOL)animated {
    [self initData];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setAccountInfo];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSMenuViewDelegate Methods
-(void)menuView:(SSMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index{
    NSString * menuTileForIndex = [self.menuTitle objectAtIndex:index];
    if ([menuTileForIndex isEqualToString:NSLocalizedString(@"ShakeLady",nil)]) {
        SSSLShakeViewController * shakeViewController = [[SSSLShakeViewController alloc] init];
        [self.navigationController pushViewController:shakeViewController animated:YES];
        [shakeViewController release];
    }else if ([menuTileForIndex isEqualToString:NSLocalizedString(@"MyLady",nil)]){
//        SSSLMyLadyViewController *myLadyViewController = [[SSSLMyLadyViewController alloc] init];
//        [self.navigationController pushViewController:myLadyViewController animated:YES];
//        [myLadyViewController release];
        
        FGalleryViewController * localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:localGallery animated:YES];
        [localGallery release];
    }else if ([menuTileForIndex isEqualToString:NSLocalizedString(@"Top10",nil)]) {
        SSSLLadyTopViewController * shakeViewController = [[SSSLLadyTopViewController alloc] init];
        [self.navigationController pushViewController:shakeViewController animated:YES];
        [shakeViewController release];
    }else if ([menuTileForIndex isEqualToString:NSLocalizedString(@"Setting",nil)]) {
        SSMoreViewController * shakeViewController = [[SSMoreViewController alloc] init];
        [self.navigationController pushViewController:shakeViewController animated:YES];
        [shakeViewController release];
    }

}

-(NSUInteger)menuViewNumberOfItems:(SSMenuView*)menuView{
    return self.menuTitle.count;
}

-(SSMenuItemView*)menuView:(SSMenuView *)menuView ItemViewForRowAtIndex:(NSUInteger)index{
    SSMenuItemView * menuItemView = [[[SSMenuItemView alloc] initWithStyle:SSMenuItemViewStyleTextOnly] autorelease];
    menuItemView.label.text = [self.menuTitle objectAtIndex:index];
    menuItemView.label.textColor = [UIColor whiteColor];
    [menuItemView.label verticalMove:-5];
    
    menuItemView.detailLabel.text = [self.menuSubTitle objectAtIndex:index];
    menuItemView.detailLabel.textColor = [UIColor whiteColor];
    [menuItemView.detailLabel verticalMove:-5];
    
    menuItemView.backgroundImageView.backgroundColor = [UIColor grayColor];
    menuItemView.backgroundImageView.layer.borderWidth = 1;
    menuItemView.backgroundImageView.layer.cornerRadius = 12;
    menuItemView.backgroundImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    menuItemView.maskImageView.layer.borderWidth = 1;
    menuItemView.maskImageView.layer.cornerRadius = 12;
    menuItemView.maskImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    return menuItemView;
}

-(void)SSSLShakePicLoderRequestFinished:(BOOL)isLoadSuccessed{
    [self.loadingView hideLoadingView];
}

#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
	return self.myLady.count;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeLocal;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    SSSLLadyPic *lady = [self.myLady objectAtIndex:index];
    HJManagedImageV *ladyImageV = lady.imageView;
    return [ladyImageV.url absoluteString];
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    
    SSSLLadyPic *lady = [self.myLady objectAtIndex:index];
    
    HJManagedImageV *ladyImageV = lady.imageView;
    
    HJObjManager *objManager = [HJObjManager sharedManager];
    
    return [objManager.fileCache readyFilePathForOid:ladyImageV.url];
}

-(void)initData{
    FMDatabase *db = GETDB;
    self.myLady = [NSMutableArray arrayWithCapacity:100];

    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from SLMyLady"];
        
        [sql appendString:@" order by id desc"];
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        
//        HJObjManager * objManager = [HJObjManager sharedManager];

        while ([rs next]) {
            
            SSSLLadyPic *lady = [[[SSSLLadyPic alloc]init]autorelease];
            lady.picId = [NSNumber numberWithInt:[rs intForColumn:@"ladyId"]];
            HJManagedImageV * imageV = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
            imageV.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.aisoucang.com/upload/shakeLady/%d.jpg",[lady.picId integerValue]]];
//            [objManager manage:imageV];
            lady.imageView = imageV;
            
            [self.myLady addObject:lady];
        }
        
    }
    
    [db close];
}

-(void)setAccountInfo{
    if (![USER_TYPE isEqualToString:@"IPHONE"]) {

        self.account.text = USER_NAME;
    }else{
        self.account.text = @"屌丝终有逆袭日";
    }
    
    self.money.text = [NSString stringWithFormat:@"屌丝币：%d",[USER_MONEY intValue]];
    
}
@end
