///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCCollectionViewLayout.m
//
//  Created by Dalton Cherry on 12/20/13.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCCollectionViewLayout.h"
#import "DCCollectionViewCell.h"
#import "DCCollectionSource.h"

@interface DCCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

//the original bounds of the layout
@property(nonatomic,assign)CGRect ogBounds;

@end

@implementation DCCollectionViewLayoutAttributes

@end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface DCCollectionViewLayout ()

@property(nonatomic,weak)DCCollectionSource *dataSource;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, assign) CGSize totalSize;
@property (nonatomic, strong) NSMutableArray *layoutAttributes;

@end

@implementation DCCollectionViewLayout

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithDataSource:(DCCollectionSource*)source
{
    if(self = [super init])
    {
        self.enabledSpring = NO;
        self.dataSource = source;
        self.dataSource.layoutDelegate = (id<DCCollectionLayoutDelegate>)self;
        self.verticalSpacing = self.horizontalSpacing = 6.0f;
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visibleIndexPathsSet = [NSMutableSet set];
        self.layoutAttributes = [NSMutableArray new];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (Class)layoutAttributesClass
{
    return [DCCollectionViewLayoutAttributes class];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareLayout
{
    [super prepareLayout];
    if(self.dataSource.items.count > 0 && self.layoutAttributes.count == 0)
        [self sourceDidReload];
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, 0, -100); //-100
    
    NSArray *visibleItemArray = [self cellLayout:visibleRect];
    
    NSSet *visibleItemSet = [NSSet setWithArray:[visibleItemArray valueForKey:@"indexPath"]];
    
    // Step 1: Remove any behaviours that are no longer visible.
    NSArray *recycledItems = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [visibleItemSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }]];
    
    [recycledItems enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        DCCollectionViewLayoutAttributes *layout = [[obj items] firstObject];
        layout.frame = layout.ogBounds;
        [self.visibleIndexPathsSet removeObject:layout.indexPath];
    }];
    
    // Step 2: Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [visibleItemArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DCCollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(DCCollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        if(self.enabledSpring)
        {
            springBehaviour.length = 1.0f;
            springBehaviour.damping = 0.8f;//0.8f;
            springBehaviour.frequency = 1.0f;//1.0f;
        }
        else
        {
            springBehaviour.length = 0.0f;
            springBehaviour.damping = 0.0f;
            springBehaviour.frequency = 0.0f;
        }
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
            
            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    //NSLog(@"delta: %f",delta);
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        DCCollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        float offset = 0.0f;
        CGPoint center = item.center;
        if (delta < 0)
        {
            offset += MAX(delta, delta*scrollResistance);
        }
        else
        {
            offset += MIN(delta, delta*scrollResistance);
        }
        center.y += offset;
        item.center = center;
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    return NO;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)collectionViewContentSize
{
    return self.totalSize;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)didEndScrolling
{
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        DCCollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        item.frame = item.ogBounds;
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)sourceDidReload
{
    [self.layoutAttributes removeAllObjects];
    float left = self.horizontalSpacing;
    float top = self.verticalSpacing;
    int row = 0;
    if(self.dataSource.sections)
    {
        //not sure yet
    }
    else
    {
        for(id object in self.dataSource.items)
        {
            Class class = [self.dataSource cellClassForObject:object];
            CGSize size = [class collectionView:self.collectionView sizeForObject:object];
            if(left+size.width > self.collectionView.frame.size.width)
            {
                left = self.horizontalSpacing;
                top += size.height + self.verticalSpacing;
            }
            DCCollectionViewLayoutAttributes *attribs = [DCCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            attribs.frame = attribs.ogBounds = CGRectMake(left, top, size.width, size.height);
            [self.layoutAttributes addObject:attribs];
            left += size.width+self.horizontalSpacing;
            row++;
        }
    }
    UICollectionViewLayoutAttributes *attribs = [self.layoutAttributes lastObject];
    if(attribs)
        self.totalSize = CGSizeMake(self.collectionView.frame.size.width, attribs.frame.size.height+attribs.frame.origin.y+self.verticalSpacing);
    else
        self.totalSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSMutableArray*)cellLayout:(CGRect)rect
{
    //NSLog(@"cell layout: rect.x: %f, rect.y: %f, rect.width: %f, rect.height: %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    float threshHold = rect.size.height;
    if(rect.origin.y > 0)
        threshHold += rect.origin.y;
    NSMutableArray *collect = nil;
    int row = 0;
    if(self.dataSource.sections)
    {
        
    }
    else
    {
        collect = [NSMutableArray array];
        for(DCCollectionViewLayoutAttributes *attribs in self.layoutAttributes)
        {
            if(CGRectContainsRect(rect, attribs.frame))
            {
                //DCCollectionViewLayoutAttributes *layout = [DCCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:attribs.indexPath];
                //layout.frame = layout.ogBounds = attribs.ogBounds;
                //[self.layoutAttributes replaceObjectAtIndex:row withObject:layout];
                //attribs.frame = attribs.ogBounds;
                //NSLog(@"attribs: %@",attribs);
                [collect addObject:attribs];
            }
            if(attribs.frame.size.height+attribs.frame.origin.y > threshHold)
                break;
            row++;
        }
    }
    return collect;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
