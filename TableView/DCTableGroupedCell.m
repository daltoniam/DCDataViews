///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCTableGroupedCell.m
//
//  Created by Dalton Cherry on 4/17/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCTableGroupedCell.h"

@implementation GroupedCustomView

@synthesize position,fillColor;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //shadow
    int top = 0;
    int hOffset = 0;
    int wOffset = 2;
    UIRectCorner corners = 0;
    if(self.position == DCGroupedCellTop)
    {
        corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        top = 2;
        hOffset = 2;
    }
    else if(self.position == DCGroupedCellBottom)
    {
        corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        top = 0;
        hOffset = -2;
    }
    else if(self.position == DCGroupedCellSingle)
    {
        corners = UIRectCornerAllCorners;
        top = 2;
        hOffset = -4;
    }
    
    int borderWidth = 1;
    UIColor* shadowColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:0.75];
    UIColor* borderColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:0.75];
    CGRect frame = CGRectMake(wOffset, top, self.frame.size.width-(wOffset*2), self.frame.size.height+hOffset);
    
    if(borderWidth > 0)
    {
        CGContextSaveGState(ctx);
        
        CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 2, shadowColor.CGColor);
        CGContextSetLineWidth(ctx, borderWidth);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:frame
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(5, 5)].CGPath;
        CGContextAddPath(ctx, path);
        
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    //fill rect
    CGContextSaveGState(ctx);
    // draws body
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame, borderWidth-0.5, borderWidth-0.5)
                                           byRoundingCorners:corners
                                                 cornerRadii:CGSizeMake(5, 5)].CGPath;
    
    CGContextAddPath(ctx, path);
    
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    if(borderWidth <= 0)
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 2, shadowColor.CGColor);
    CGContextFillPath(ctx);
    //CGContextDrawPath(ctx,kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    if(self.position != DCGroupedCellBottom && self.position != DCGroupedCellSingle)
    {
        CGContextSaveGState(ctx);
        
        float y = self.frame.size.height;
        
        CGContextMoveToPoint(ctx, CGRectGetMinX(frame), y);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(frame), y);
        
        CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
        CGContextSetLineWidth(ctx, borderWidth);
        CGContextStrokePath(ctx);
        
        CGContextRestoreGState(ctx);
    }
}

@end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation DCTableGroupedCell

@synthesize shadowView,selectedView;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        shadowView = [[GroupedCustomView alloc] init];
        shadowView.fillColor = self.backgroundColor;
        self.backgroundView = shadowView;
        
        selectedView = [[GroupedCustomView alloc] init];
        selectedView.fillColor = [UIColor colorWithRed:0/255.0f green:136/255.0f blue:204/255.0f alpha:1];
        self.selectedBackgroundView = selectedView;
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setPosition:(DCGroupedCellPosition)position
{
    self.shadowView.position = self.selectedView.position = position;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCGroupedCellPosition)position
{
    return self.shadowView.position;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
