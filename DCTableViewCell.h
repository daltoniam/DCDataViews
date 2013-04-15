///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCTableViewCell.h
//
//  Created by Dalton Cherry on 4/15/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
//  use this as your subclass instead of UITableViewCell. Just adds some methods to make datasource interaction simpler.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@interface DCTableViewCell : UITableViewCell

//return/caculate the height you want this cell subclass to be
+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;

//this is use to style the cell with the current object.
//It is not recommend to not do any intensive work in this method
//as cells recycle, so this gets called a lot when scrolling.
-(void)setObject:(id)object;

@end
