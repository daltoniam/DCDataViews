///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCDisclosureIndicator.h
//
//  Created by Dalton Cherry on 4/17/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@interface DCDisclosureIndicator : UIControl

//set the colors that will be used
@property (nonatomic, strong)UIColor *accessoryColor;
@property (nonatomic, strong)UIColor *highlightedColor;

//use images if you are into that kinda of thing
@property(nonatomic,strong)UIImage* accessoryImage;
@property(nonatomic,strong)UIImage* hightlightImage;

//factory methods.
+(DCDisclosureIndicator*)accessoryWithColor:(UIColor *)color highlight:(UIColor*)hightlightColor;
+(DCDisclosureIndicator*)accessoryWithImage:(UIImage*)image highlight:(UIColor*)hightImage;


@end
