///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCCollectionSource.h
//
//  Created by Dalton Cherry on 12/20/13.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@protocol DCCollectionSourceDelegate <NSObject>

@optional

/**
use so you can set different settings on the cell from the view controller layer
 */
-(void)cell:(UICollectionViewCell*)cell withObject:(id)object atIndex:(NSIndexPath*)indexPath;

/**
use to set cell class to object class mapping
 */
-(Class)classForObject:(id)object;

/**
returns that a cell was tapped
 */
-(void)didSelectObject:(id)object atIndex:(NSIndexPath*)index;

/**
scrollView forward
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@protocol DCCollectionLayoutDelegate <NSObject>

/**
 notifies the flow that the collection did reload
 */
-(void)sourceDidReload;

/**
 notifies the flow that the collection did end scrolling
 */
-(void)didEndScrolling;


@end

@interface DCCollectionSource : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>

/**
this is the items of your datasource
 */
@property(nonatomic,strong)NSMutableArray* items;

/**
this is the sections of your datasource
 */
@property(nonatomic,strong)NSMutableArray* sections;

/**
this is the delegate of your datasource
 */
@property(nonatomic,weak)id<DCCollectionSourceDelegate> delegate;

/**
 this can be ignored. Is used by DCCollectionViewLayout to notify on dataSource changes.
 */
@property(nonatomic,weak)id<DCCollectionLayoutDelegate> layoutDelegate;

/**
 This can be ignored. It is just so the layout can find the proper cell class.
 @param object that is mapped to a class
 @return cell class to be used.
 */
- (Class)cellClassForObject:(id)object;

/**
 Returns a object for a index path.
 @param indexpath of the collectionView.
 @return object at that path.
 */
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;

@end
