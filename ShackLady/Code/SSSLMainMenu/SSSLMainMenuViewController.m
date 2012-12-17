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
@interface SSSLMainMenuViewController ()<SSMenuViewDelegate,SSSLShakePicLoderDelegate,FGalleryViewControllerDelegate>
@property (nonatomic, retain) IBOutlet SSMenuView * menuView;
@property (nonatomic, retain) NSArray *menuTitle;
@end

@implementation SSSLMainMenuViewController
@synthesize menuView = _menuView;
@synthesize menuTitle = _menuTitle;

-(NSArray *)menuTitle{
    if(nil==_menuTitle){
        self.menuTitle = [[NSArray alloc] initWithObjects:NSLocalizedString(@"ShakeLady",nil), NSLocalizedString(@"MyLady", nil), nil];
    }
    
    return _menuTitle;
}
-(void)dealloc{
    self.menuView = nil;
    self.menuTitle = nil;
    [super dealloc];
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
    self.menuView.yPadding = 20;
    [self.menuView reloadData];
    [SSSLShakePicLoder sharedInstance].delegate = self;
    [SSSLShakePicLoder sendRequestToGetLadyList];
    [self.loadingView showLoadingView];
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
    }

}

-(NSUInteger)menuViewNumberOfItems:(SSMenuView*)menuView{
    return self.menuTitle.count;
}

-(SSMenuItemView*)menuView:(SSMenuView *)menuView ItemViewForRowAtIndex:(NSUInteger)index{
    SSMenuItemView * menuItemView = [[[SSMenuItemView alloc] initWithStyle:SSMenuItemViewStyleTextOnly] autorelease];
    menuItemView.label.text = [self.menuTitle objectAtIndex:index];
    menuItemView.backgroundImageView.backgroundColor = [UIColor blueColor];
    
    return menuItemView;
}

-(void)SSSLShakePicLoderRequestFinished:(BOOL)isLoadSuccessed{
    [self.loadingView hideLoadingView];
}

#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
	return [SSSLShakePicLoder sharedInstance].historyPicArray.count;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeLocal;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    HJManagedImageV *ladyImageV = [[SSSLShakePicLoder sharedInstance].historyPicArray objectAtIndex:index];
    return [ladyImageV.url absoluteString];
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    HJManagedImageV *ladyImageV = [[SSSLShakePicLoder sharedInstance].historyPicArray objectAtIndex:index];
    HJObjManager *objManager = [HJObjManager sharedManager];
    
    return [objManager.fileCache readyFilePathForOid:ladyImageV.url];
}
@end
