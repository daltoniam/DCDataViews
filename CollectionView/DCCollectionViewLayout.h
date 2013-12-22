///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCCollectionViewLayout.h
//
//  Created by Dalton Cherry on 12/20/13.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@class DCCollectionSource;

@interface DCCollectionViewLayout : UICollectionViewLayout

/**
 Your MUST create a DCCollectionViewLayout with its datasource to get a proper dynamic layout
 */
-(id)initWithDataSource:(DCCollectionSource*)source;

/**
 Enable the spring animation on the collectionView. Default is NO.
 */
@property(nonatomic,assign)BOOL enabledSpring;

/**
 The spacing between rows vertically. Default is 6.0.
 */
@property(nonatomic,assign)CGFloat verticalSpacing;

/**
 The spacing between rows horizontally. Default is 6.0.
 */
@property(nonatomic,assign)CGFloat horizontalSpacing;



@end
