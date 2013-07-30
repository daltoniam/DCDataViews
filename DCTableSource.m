///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCTableSource.m
//
//  Created by Dalton Cherry on 4/15/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCTableSource.h"
#import <objc/runtime.h>
#import "DCTableViewCell.h"
#import "DCTableGroupedCell.h"

@implementation DCTableSource

@synthesize items,sections,searchController,stayActive;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)init
{
    if(self = [super init])
    {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sections)
    {
        if(self.items.count > section)
        {
            NSArray* itemArray = [self.items objectAtIndex:section];
            return itemArray.count;
        }
        return 0;
    }
    return self.items.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self tableView:table objectForRowAtIndexPath:indexPath];
    Class cellClass = [self tableView:table cellClassForObject:object];
    const char* className = class_getName(cellClass);
    NSString* identifier = [[NSString alloc] initWithBytesNoCopy:(char*)className
                                                          length:strlen(className)
                                                        encoding:NSASCIIStringEncoding freeWhenDone:NO];
    
    UITableViewCell* cell = (UITableViewCell*)[table dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    if([cell respondsToSelector:@selector(setDelegate:)])
        [cell performSelector:@selector(setDelegate:) withObject:self.delegate];
    
    [(DCTableViewCell*)cell setObject:object];
    
    if([cell isKindOfClass:[DCTableGroupedCell class]])
    {
        if(indexPath.row == 0)
        {
            if([table numberOfRowsInSection:indexPath.section] == 1)
                [(DCTableGroupedCell*)cell setPosition:DCGroupedCellSingle];
            else
                [(DCTableGroupedCell*)cell setPosition:DCGroupedCellTop];
        }
        else if([table numberOfRowsInSection:indexPath.section] == indexPath.row+1)
            [(DCTableGroupedCell*)cell setPosition:DCGroupedCellBottom];
        else
            [(DCTableGroupedCell*)cell setPosition:DCGroupedCellMiddle];
    }
    
    [self processCell:cell object:object index:indexPath table:table];
    
    if([self.delegate respondsToSelector:@selector(cell:withObject:atIndex:)])
        [self.delegate cell:cell withObject:object atIndex:indexPath];
    
    if(self.selectedColor)
    {
        UIView* bgView = cell.backgroundView;
        if(!bgView)
        {
            bgView = [[UIView alloc] init];
            bgView.backgroundColor = self.selectedColor;
            cell.selectedBackgroundView = bgView;
        }
        else
            bgView.backgroundColor = self.selectedColor;
    }
    return cell;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)processCell:(UITableViewCell*)cell object:(id)object index:(NSIndexPath*)index table:(UITableView*)table
{
    //left blank on purpose, this is subclasses.
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table
{
    return self.sections ? self.sections.count : 1;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section
{
    id object = nil;
    if(self.sections.count > section)
        object = [self.sections objectAtIndex:section];
    
    if([object isKindOfClass:[NSString class]])
    {
        if([object isEqualToString:UITableViewIndexSearch])
            return nil;
        return object;
    }
    return nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)table viewForHeaderInSection:(NSInteger)section
{
    if(self.sections.count > section)
    {
        id object = [self.sections objectAtIndex:section];
        if([object isKindOfClass:[NSString class]] && [object isEqualToString:UITableViewIndexSearch])
            return searchController.searchBar;
        
        if([object isKindOfClass:[UIView class]])
        {
            UIView* view = (UIView*)[self.sections objectAtIndex:section];
            return view;
        }
    }
    return nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id object = [self.sections objectAtIndex:section];
    if([object isKindOfClass:[UIView class]])
    {
        UIView* view = (UIView*)object;
        return view.frame.size.height;
    }
    if([object isKindOfClass:[NSString class]])
    {
        NSString* string = (NSString*)object;
        if([string isEqualToString:UITableViewIndexSearch])
            return 44;
        if(string.length > 0)
            return 24;
    }
    return 0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//simple way to query the our items/sections array for the correct item
- (id)tableView:(UITableView*)table objectForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.sections)
    {
        if(self.items.count > indexPath.section)
        {
            NSArray* itemArray = [self.items objectAtIndex:indexPath.section];
            return [itemArray objectAtIndex:indexPath.row];
        }
    }
    return [self.items objectAtIndex:indexPath.row];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//where the tableview magic happens. return the cell class for the object class that comes through
- (Class)tableView:(UITableView*)table cellClassForObject:(id)object
{
    if([self.delegate respondsToSelector:@selector(classForObject:)])
    {
        Class class = [self.delegate classForObject:object];
        if(class)
            return class;
    }
    // This will display an empty white table cell - probably not what you want, but it
    // is better than crashing, which is what happens if you return nil here
    return [DCTableViewCell class];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//return height
- (CGFloat)tableView:(UITableView*)table heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id object = [self tableView:table objectForRowAtIndexPath:indexPath];
    return [self heightOfObject:object tableView:table];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//does the custom checkmark and GPLoadMore actions. Use didselect object below to get type
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self tableView:table objectForRowAtIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(didSelectObject:atIndex:)])
        [self.delegate didSelectObject:object atIndex:indexPath];
    if(!self.stayActive)
        [table deselectRowAtIndexPath:indexPath animated:YES];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)tableView:(UITableView *)table canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canEdit = NO;
    if([self.delegate respondsToSelector:@selector(canEditObject:atIndexPath:)])
        canEdit = [self.delegate canEditObject:[self tableView:table objectForRowAtIndexPath:indexPath] atIndexPath:indexPath];
    return canEdit;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        id object = [self tableView:table objectForRowAtIndexPath:indexPath];
        if([self.delegate respondsToSelector:@selector(didDeleteObject:atIndexPath:)])
            [self.delegate didDeleteObject:object atIndexPath:indexPath];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCellEditingStyle)tableView:(UITableView *)table editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self tableView:table objectForRowAtIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(editingStyleForObject:atIndexPath:)])
        return [self.delegate editingStyleForObject:object atIndexPath:indexPath];

    return UITableViewCellEditingStyleDelete;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setSearchController:(UISearchDisplayController *)controller
{
    searchController = controller;
    //controller.searchResultsDelegate = self;
    //controller.searchResultsDataSource = self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat)heightOfObject:(id)object tableView:(UITableView*)table
{
    Class cls = [self tableView:table cellClassForObject:object];
    CGFloat height = [cls tableView:table rowHeightForObject:object];
    return height;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.delegate scrollViewWillBeginDragging:scrollView];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:scrollView];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
