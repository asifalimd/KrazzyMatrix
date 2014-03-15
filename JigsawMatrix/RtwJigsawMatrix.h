//
//  rtwJigsawMatrix.h
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 1/26/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColoredRoundedButton.h"
#import "RtwUtility.h"


@interface RtwJigsawMatrix : NSObject <NSCoding>


// UIView that contains all the matrix cells
@property (strong, nonatomic) UIView * matrixGrid;

// All jigsaw matrix cell are stored here for future referencing.
@property (strong, nonatomic, retain) NSArray *matrixCells;

// There still scope to refactor and avoid few of the below properties
@property (nonatomic) CGPoint cellCenter;
@property (nonatomic) CGRect cellFrame;
@property (nonatomic) ColoredRoundedButton* emptyCell;
@property (nonatomic) CGPoint emptyCellCenter;
@property (nonatomic) CGRect emptyCellFrame;

// Size of the matrix
@property (nonatomic) int matrixSize;

// Diff between each cell is equal and stored in diffPoint to calculate the valid move.
@property (nonatomic) CGPoint diffPoint;

// Calculate the no of moves during the game
@property (nonatomic) int moves;

// This is used to generate solvable games
@property (nonatomic) int emptyCellIndex;
@property (nonatomic) int emptyCellRow;

- (id) initWithSize:(int) size view:(UIView *) view;
- (int) getMatrixCellCount;
- (void) addJigsawMatrixForView: (UIView *) view;
- (Boolean) validateMove:(int) x: (int) y;
- (Boolean) isGameOver;
- (int) increaseMoves;
- (void)resetMatrix;
- (int) getMatrixWidth;
- (void) showGameOverMessage;
- (void) swapCell:(UIPanGestureRecognizer *) panRecognizer;
- (void) setEmptyCellCenterAndFrame;
- (void) setCellCenterAndFrame:(UIPanGestureRecognizer *) panRecognizer;
- (int) getMaxLevelForDevice;
- (int) getHighscore;
- (int) getCurrentLevel;
+ (RtwJigsawMatrix*) singleton;
- (float) getCellSpacing;
- (void) setRounderCornersForCell:(UIButton*)cell;
- (void) setRounderCornersForEmptyCell;
- (void) resetTags;
+ (RtwJigsawMatrix*) getStateObject;
- (CGFloat) getCellFontSize;
- (CGFloat) getCellWidth;
- (CGFloat) getStartingY;
- (Boolean) isSolvable: (NSArray*) numbers;
- (int) getEmptyCellRowFromBottom;
@end

