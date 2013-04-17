///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCTableGroupedCell.h
//  iOSTester
//
//  Created by Dalton Cherry on 4/17/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
//  this is a custom drawn grouped tablecell.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCTableViewCell.h"

typedef enum {
    DCGroupedCellTop,
    DCGroupedCellMiddle,
    DCGroupedCellBottom,
    DCGroupedCellSingle
} DCGroupedCellPosition;

@interface GroupedCustomView : UIView

//set if the cell is the top of a row, middle,bottom,etc
@property(nonatomic,assign)DCGroupedCellPosition position;

//set the color to fill the cell with (the background color)
@property(nonatomic,strong)UIColor* fillColor;

@end

@interface DCTableGroupedCell : DCTableViewCell

//set your normal view
@property(nonatomic,strong)GroupedCustomView* shadowView;

//set the selected state view
@property(nonatomic,strong)GroupedCustomView* selectedView;

//set if the cell is the top of a row, middle,bottom,etc
@property(nonatomic,assign)DCGroupedCellPosition position;

@end
