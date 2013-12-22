///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCCollectionViewCell.h
//
//  Created by Dalton Cherry on 12/20/13.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@interface DCCollectionViewCell : UICollectionViewCell

/**
 Return/caculate the height you want this cell subclass to be.
 @param the collectionView this cell will be in. Use this to find out the width of the collectionView.
 @param object is the object that will be apart of this cell.
 @return the size of the cell.
 */
+(CGSize)collectionView:(UICollectionView*)collectionView sizeForObject:(id)object;

/**
 Use this to style the cell with the current object.
 It is strongly not recommend to not do any intensive work in this method, just simple property assignment from the object,
 as scrolling preformance will be damage if work is too intensive.
 As cells are recycled, this method is called often.
 */
-(void)setObject:(id)object;

@end
