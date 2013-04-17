///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCDisclosureIndicator.m
//
//  Created by Dalton Cherry on 4/17/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCDisclosureIndicator.h"

@implementation DCDisclosureIndicator

@synthesize accessoryColor,highlightedColor,hightlightImage,accessoryImage;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect
{
    if(accessoryImage)
    {
        [super drawRect:rect];
        if(self.highlighted && hightlightImage)
            [hightlightImage drawInRect:self.bounds];
        else
            [accessoryImage drawInRect:self.bounds];
        return;
    }
	// (x,y) is the tip of the arrow
	CGFloat x = CGRectGetMaxX(self.bounds)-3.0;;
	CGFloat y = CGRectGetMidY(self.bounds);
	const CGFloat R = 4.5;
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
    
	if (self.highlighted)
		[self.highlightedColor setStroke];
	else
		[self.accessoryColor setStroke];
    
	CGContextStrokePath(ctxt);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCDisclosureIndicator*)accessoryWithColor:(UIColor *)color highlight:(UIColor*)hightlightColor
{
    DCDisclosureIndicator* accessory = [[DCDisclosureIndicator alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)] ;
    accessory.accessoryColor = color;
    accessory.highlightedColor = hightlightColor;
    return accessory;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCDisclosureIndicator*)accessoryWithImage:(UIImage*)image highlight:(UIImage*)hightImage
{
    DCDisclosureIndicator* accessory = [[DCDisclosureIndicator alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
    accessory.accessoryImage = image;
    accessory.hightlightImage = hightImage;
    return accessory;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
