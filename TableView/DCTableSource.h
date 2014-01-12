///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCTableSource.h
//
//  Created by Dalton Cherry on 4/15/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol DCTableSourceDelegate <NSObject>

@optional

//use so you can set different settings on the cell from the view controller layer
-(void)cell:(UITableViewCell*)cell withObject:(id)object atIndex:(NSIndexPath*)indexPath;

//use to set cell class to object class mapping
-(Class)classForObject:(id)object;

//returns that a cell was tapped
-(void)didSelectObject:(id)object atIndex:(NSIndexPath*)index;

//return True or false if a item can be edited (swipe to delete,reorder,etc).
-(BOOL)canEditObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

//when the tableview delete button is pressed.
-(void)didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

//when the tableview delete button is pressed.
-(UITableViewCellEditingStyle)editingStyleForObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 Set the delete text.
 @param indexPath is the index path to set the delete text at
 @return the string to use for the delete text
 */
-(NSString*)deleteTextAtIndex:(NSIndexPath*)indexPath;

//scrollView forward
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DCTableSource : NSObject<UITableViewDataSource,UITableViewDelegate>

//this is the items of your datasource
@property(nonatomic,strong)NSMutableArray* items;

//this is the sections of your datasource
@property(nonatomic,strong)NSMutableArray* sections;

//this is the sections of your datasource
@property(nonatomic,assign)id<DCTableSourceDelegate> delegate;

//this is the sections of your datasource
@property(nonatomic,weak)UISearchDisplayController* searchController;

//this is use to set the highlighted/selected background color of a cell.
@property(nonatomic,strong)UIColor* selectedColor;

//do not deselect the cell after selection.
@property(nonatomic,assign)BOOL stayActive;

//get the height of an object.
-(CGFloat)heightOfObject:(id)object tableView:(UITableView*)tableView;

//this does nothing. Just here for subclass convenience. is Called by cellForRowAtIndexPath.
-(void)processCell:(UITableViewCell*)cell object:(id)object index:(NSIndexPath*)index table:(UITableView*)table;

@end
