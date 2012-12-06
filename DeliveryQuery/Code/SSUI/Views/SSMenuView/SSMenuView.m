//
//  SSMenuView.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-25.
//
//

#import "SSMenuView.h"
#import "SSMenuItemView.h"
@interface SSMenuView()
@property (nonatomic, retain) NSMutableArray *itemViews;
- (void)setupItemViews;
- (void)itemPressed:(id)sender;
@end

@implementation SSMenuView
@synthesize menuDelegate = _menuDelegate;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize itemViews = _itemViews;
@synthesize columnCount = _columnCount;
@synthesize itemSize = _itemSize;
@synthesize topPadding = _topPadding;
@synthesize leftPadding = _leftPadding;
@synthesize bottomPadding = _bottomPadding;
@synthesize yPadding = _yPadding;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemViews = [[NSMutableArray alloc] init];
		_backgroundImageView = [[UIImageView alloc]init];
		// set some defaults
		_columnCount = 4;
		_itemSize = CGSizeMake(80, 80);
        _yPadding = -1;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	
	if (self = [super initWithCoder:aDecoder]) {
		_itemViews = [[NSMutableArray alloc] init];
		_backgroundImageView = [[UIImageView alloc]init];
		// set some defaults
		_columnCount = 4;
		_itemSize = CGSizeMake(80, 80);
        _yPadding = -1;
	}
	
	return self;
}
-(void)dealloc{
    self.itemViews = nil;
    self.backgroundImageView = nil;
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setupItemViews {
	
    NSUInteger numColumns = self.columnCount;
	
	NSUInteger numItems = [self.menuDelegate menuViewNumberOfItems:self];
    
    for (UIView *view in self.itemViews) {
		[view removeFromSuperview];
	}
	
	[self.itemViews removeAllObjects];
	
	    
    for (NSUInteger i = 0; i < numItems; i++) {
        
        SSMenuItemView * itemView = [self.menuDelegate menuView:self ItemViewForRowAtIndex:i];
        
        itemView.tag = i;
        
        [itemView addTarget:self action:@selector(itemPressedUp:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addTarget:self action:@selector(itemPressedDown:) forControlEvents:UIControlEventTouchDown];
        [itemView addTarget:self action:@selector(itemPressedUpOutsideAction:) forControlEvents:UIControlEventTouchUpOutside];
        [itemView addTarget:self action:@selector(itemPressedUpOutsideAction:) forControlEvents:UIControlEventTouchCancel];
        
        [self.itemViews addObject:itemView];
        [self addSubview:itemView];
    }
    
    CGFloat padding = roundf((self.bounds.size.width - self.leftPadding*2-(self.itemSize.width * numColumns)) / (numColumns + 1));

    CGFloat yPadding = padding;
    if (self.yPadding >= 0 ) {
        yPadding = self.yPadding;
    }
    
    for (int i = 0; i < numItems; i++) {
        UIView *item = [self.itemViews objectAtIndex:i];
        NSUInteger column = i % numColumns;
        NSUInteger row = i / numColumns;
        
        CGFloat xOffset = (column * (self.itemSize.width + padding)) + padding+self.leftPadding;
        CGFloat yOffset = (row * (self.itemSize.height + yPadding)) + yPadding;
        item.frame = CGRectMake(xOffset, yOffset + self.topPadding, self.itemSize.width, self.itemSize.height);
    }
}

- (void)itemPressedUp:(UIButton *)sender {
	NSParameterAssert(sender);
    SSMenuItemView *view = (SSMenuItemView *)[sender superview];
    if ([self.menuDelegate respondsToSelector:@selector(menuView:ItemPressedAtIndex:)]) {
        [self.menuDelegate menuView:self ItemPressedAtIndex:sender.tag];
    }
    else {
        [UIView animateWithDuration:0.1 animations:^(void){view.maskImageView.alpha = 0.0f;}];
        
    }
    [self.menuDelegate menuView:self didSelectItemAtIndex:sender.tag];
}

- (void)itemPressedDown:(UIButton *)sender {
    NSParameterAssert(sender);
    SSMenuItemView *view = (SSMenuItemView *)[sender superview];
    if ([self.menuDelegate respondsToSelector:@selector(menuView:ItemPressedDownAtIndex:)]) {
        [self.menuDelegate menuView:self ItemPressedDownAtIndex:sender.tag];
    }
    else {
        view.maskImageView.alpha = 0.3f;
    }
    
}

- (void)itemPressedUpOutsideAction:(UIButton *)sender {
    NSParameterAssert(sender);
    SSMenuItemView *view = (SSMenuItemView *)[sender superview];
    if ([self.menuDelegate respondsToSelector:@selector(menuView:ItemPressedUpOutsideActionAtIndex:)]) {
        [self.menuDelegate menuView:self ItemPressedUpOutsideActionAtIndex:sender.tag];
    }
    else {
        view.maskImageView.alpha = 0.0f;
    }
    
}


-(void)reloadData{
    [self setupItemViews];
    [self setupBackgroundImageView];
}

-(void)setupBackgroundImageView{
    [self.backgroundImageView removeFromSuperview];
    if ([self.itemViews count] != 0) {
        [self insertSubview:self.backgroundImageView belowSubview:[self.itemViews objectAtIndex:0]];
    }else {
        [self addSubview:self.backgroundImageView];
    }
    
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.frame = self.frame;
    
}
//自适应的大小
-(CGSize)contentSize{
    
    NSUInteger numColumns = self.columnCount;
	
	NSUInteger numItems = [self.menuDelegate menuViewNumberOfItems:self];
    
    CGFloat padding = roundf((self.bounds.size.width - self.leftPadding*2 - (self.itemSize.width * numColumns)) / (numColumns + 1));
    NSUInteger numRows = numItems % numColumns == 0 ? (numItems / numColumns) : (numItems / numColumns) + 1;
    CGFloat yPadding = padding;
    if (self.yPadding>=0) {
        yPadding = self.yPadding;
    }
    CGFloat totalHeight = ((self.itemSize.height + yPadding) * numRows) + yPadding;
        
    return CGSizeMake(self.bounds.size.width, totalHeight + self.topPadding +self.bottomPadding);

}
@end
