///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCCollectionSource.m
//
//  Created by Dalton Cherry on 12/20/13.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCCollectionSource.h"
#import <objc/runtime.h>
#import "DCCollectionViewCell.h"

@interface DCCollectionSource ()

@property(nonatomic,strong)NSMutableDictionary *regMapping;

@end

@implementation DCCollectionSource

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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.layoutDelegate respondsToSelector:@selector(sourceDidReload)])
        [self.layoutDelegate sourceDidReload];
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectAtIndexPath:indexPath];
    Class cellClass = [self cellClassForObject:object];
    const char* className = class_getName(cellClass);
    NSString* identifier = [[NSString alloc] initWithBytesNoCopy:(char*)className
                                                          length:strlen(className)
                                                        encoding:NSASCIIStringEncoding freeWhenDone:NO];
    if(!self.regMapping[identifier])
    {
        if(!self.regMapping)
            self.regMapping = [NSMutableDictionary new];
        self.regMapping[identifier] = [NSNumber numberWithBool:YES];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if([cell respondsToSelector:@selector(setDelegate:)])
        [cell performSelector:@selector(setDelegate:) withObject:self.delegate];
    
    [(DCCollectionViewCell*)cell setObject:object];
    
    if([self.delegate respondsToSelector:@selector(cell:withObject:atIndex:)])
        [self.delegate cell:cell withObject:object atIndex:indexPath];
    return cell;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//where the collectionView magic happens. return the cell class for the object class that comes through
- (Class)cellClassForObject:(id)object
{
    if([self.delegate respondsToSelector:@selector(classForObject:)])
    {
        Class class = [self.delegate classForObject:object];
        if(class)
            return class;
    }
    // This will display an empty white collection cell - probably not what you want, but it
    // is better than crashing, which is what happens if you return nil here
    return [DCCollectionViewCell class];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//simple way to query the our items/sections array for the correct item
- (id)objectAtIndexPath:(NSIndexPath*)indexPath
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(self.sections)
        return self.sections.count;
    return 1;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectAtIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(didSelectObject:atIndex:)])
        [self.delegate didSelectObject:object atIndex:indexPath];
    if(!self.stayActive && !collectionView.allowsMultipleSelection)
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectAtIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(didDeselectObject:atIndex:)])
        [self.delegate didDeselectObject:object atIndex:indexPath];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
        if([self.layoutDelegate respondsToSelector:@selector(didEndScrolling)])
            [self.layoutDelegate didEndScrolling];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
