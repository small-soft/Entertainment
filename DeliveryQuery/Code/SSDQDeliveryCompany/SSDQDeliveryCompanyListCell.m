//
//  SSDQDeliveryCompanyListCell.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-12.
//
//

#import "SSDQDeliveryCompanyListCell.h"
#import "SSDQDeliveryCompany.h"

@interface SSDQDeliveryCompanyListCell ()

@end

@implementation SSDQDeliveryCompanyListCell

@synthesize site = _site;
@synthesize phone = _phone;
@synthesize name = _name;
@synthesize logo = _logo;
@synthesize company = _company;

- (void)dealloc {
    self.site = nil;
    self.phone = nil;
    self.name = nil;
    self.logo = nil;
    self.company = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupView
{
    _name.text = _company.name;
    _logo.image = [UIImage imageNamed:_company.code];
    _phone.text = _company.phone;
    _site.text = _company.site;
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}
+(CGFloat)cellHeight
{
    return 44.0;
}
+(CGFloat)cellWidth
{
    return SCREEN_WIDTH;
}
+(NSString*)cellIdentifer
{
    return @"SSDQDCL";
}
+(id)createCell:(SSDQDeliveryCompany *)company
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSDQDeliveryCompanyListCell"
                                                 owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[SSDQDeliveryCompanyListCell class]])
        {
            SSDQDeliveryCompanyListCell *obj = (SSDQDeliveryCompanyListCell *)oneObject;
            obj.frame = CGRectMake(0.0, 0.0, [SSDQDeliveryCompanyListCell cellWidth], [SSDQDeliveryCompanyListCell cellHeight]);
            obj.company = company;
            
            [obj setupView];
            
            return  obj;
        }
    }
    return nil;
}

@end
