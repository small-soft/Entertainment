//
//  SSSystemUtils.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-20.
//
//

#import "SSSystemUtils.h"

#import "SSSystemUtils.h"
#import <AddressBook/AddressBook.h>

@implementation SSSystemUtils

+ (void) makeCallWithNumber:(NSString *) phoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

//+ (void) makeCallWithNumber2:(NSString *)phoneNumber
//{
//    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",phoneNumber]; //number为号码字符串
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
//}

//通过系统浏览器打开url
+ (void) openBrowserWithUrl:(NSString *) url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (NSString *) getAppFilePath:(NSString *) fileName
{
    NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
    NSString *path = [mainBundleDirectory  stringByAppendingPathComponent:fileName];
    return path;
}

/*
 *写入地址薄
 */
+(void)insertContact:(NSString* )personName withMobile:(NSString*)personMobile andPhone:(NSString*) personPhone
{
//    NSLog(@"inserting contact");
//    ABAddressBookRef addressBook = nil;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
//    {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1
//        // This code will only compile on versions >= iOS 6.0
//        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//        //等待同意后向下执行
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
//                                                 {
//                                                     dispatch_semaphore_signal(sema);
//                                                 });
//        
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_release(sema);
//#endif
//        
//    }
//    else
//    {
//        addressBook = ABAddressBookCreate();
//    }
//    
//    NSString *name = [personName retain];
//    NSString *mobile = [personMobile retain];
//    NSString *phone = [personPhone retain];
//    
//    if (addressBook != nil) {
//        
//        ABRecordRef result = ABPersonCreate();
//        CFErrorRef error = NULL;
//        
//        ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef)name , &error);
//        ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef)@"来自阿里巴巴" , &error);
//        ABMultiValueRef mv = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//        ABMultiValueIdentifier mi;
//        mi = ABMultiValueAddValueAndLabel(mv, (CFStringRef)mobile , (CFStringRef)@"手机", &(mi));
//        mi = ABMultiValueAddValueAndLabel(mv, (CFStringRef)phone , (CFStringRef)@"固定电话", &(mi));
//        
//        
//        ABRecordSetValue(result, kABPersonPhoneProperty, mv, &error);
//        
//        BOOL successAdd = ABAddressBookAddRecord(addressBook, result, &error);
//        
//        if (successAdd) {
//            NSLog(@"success add");
//        }
//        
//        if (ABAddressBookHasUnsavedChanges(addressBook)) {
//            BOOL successSave =ABAddressBookSave(addressBook, &error);
//            if (successSave) {
//                NSLog(@"success save");
//            }
//            
//        }
//        
//        CFRelease(addressBook);
//    }
//    [name release];
//    [mobile release];
//    [phone release];
}

+(void)setGrayBtn:(UIButton *)btn {
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"gray_btn_small"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [btn setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"gray_btn_small_p"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [btn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    
}

+(void)sendShotMessage:(UIViewController<MFMessageComposeViewControllerDelegate> *)controller content:(NSString *)content {
    MFMessageComposeViewController *sendController = [[[MFMessageComposeViewController alloc] init] autorelease];
    if ([MFMessageComposeViewController canSendText])        {
        sendController.recipients =  [NSArray arrayWithObjects:@"", nil];
        sendController.body = content;
        sendController.messageComposeDelegate = controller;
        
        
        [controller presentModalViewController:sendController animated:YES];
    }
}

+ (void)sendEmail:(UIViewController<MFMailComposeViewControllerDelegate>*)controller title:(NSString *)title content:(NSString *)content toRecipients:(NSArray *)toRecipients{
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            
            if ([mailClass canSendMail])
            {
                [SSSystemUtils displayComposerSheet:controller title:title content:content toRecipients:toRecipients];
            }
            else
            {
                [SSSystemUtils launchMailAppOnDevice];
            }
        }
        else
        {
            [SSSystemUtils launchMailAppOnDevice];
        }
}

+(void)displayComposerSheet:(UIViewController<MFMailComposeViewControllerDelegate>*)controller title:(NSString *)title content:(NSString *)content toRecipients:(NSArray *)toRecipients
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = controller;
	
	[picker setSubject:title];
    [picker setMessageBody:content isHTML:NO];
    
    if (toRecipients!=nil && [toRecipients count]>0) {
        [picker setToRecipients:toRecipients];
    }
	
	[controller presentModalViewController:picker animated:YES];
    
}

+(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:small-soft@live.com&subject=意见反馈";
	
	NSString *email = [NSString stringWithFormat:@"%@", recipients];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
@end

