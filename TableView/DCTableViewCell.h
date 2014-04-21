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

/**
Return/caculate the height you want this cell subclass to be.
 @param the tableview this cell will be in. Use this to find out the width of the tableview.
 @param object is the object that will be apart of this cell.
 @return height of cell.
*/
+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object indexPath:(NSIndexPath*)indexPath;

/**
 Use this to style the cell with the current object.
 It is strongly not recommend to not do any intensive work in this method, just simple property assignment from the object,
 as scrolling preformance will be damage if work is too intensive.
 As cells are recycled, this method is called often.
 @param object is the object that associated with this cell for the time being.
 */
-(void)setObject:(id)object;

/**
 This cell was selected, so do any styling needs when selected.
 @param object is the object that associated with this tap.
 */
-(void)didSelectCell:(id)object;

@end
