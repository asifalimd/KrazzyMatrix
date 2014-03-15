//
//  rtwJigsawMatrix.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 1/26/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "RtwJigsawMatrix.h"
#import "RtwSetting.h" 
#import "constants.h"
//import <QuartzCore/QuartzCore.h>

static RtwJigsawMatrix* singleton = nil;

@interface RtwJigsawMatrix()
// Private properties
@property (nonatomic) RtwSetting* settings;


@end

@implementation RtwJigsawMatrix
UIColor* color;


@synthesize matrixGrid = _matrixGrid;
@synthesize matrixSize = _matrixSize;
@synthesize diffPoint = _diffPoint;
@synthesize matrixCells = _matrixCells;
@synthesize cellCenter = _cellCenter;
@synthesize cellFrame = _cellFrame;
@synthesize emptyCellCenter = _emptyCellCenter;
@synthesize emptyCellFrame = _emptyCellFrame;
@synthesize emptyCell = _emptyCell;
@synthesize moves = _moves;

+ (RtwJigsawMatrix*) singleton
{
    return singleton;
}
-(RtwSetting*) settings
{
    if (_settings == nil)
        _settings = [RtwSetting getSettingsObject];
    return _settings;
}

- (id) initWithCoder: (NSCoder *)coder
{
    self = [super init];
    if (self != nil)
	{
      //  self.matrixGrid = [coder decodeObjectForKey:@"matrixGrid"];
        self.matrixSize = [coder decodeIntForKey:@"matrixSize"];
        self.diffPoint = [coder decodeCGPointForKey:@"diffPoint"];
        self.matrixCells = [coder decodeObjectForKey:@"matrixCells"];
        self.cellCenter = [coder decodeCGPointForKey:@"cellCenter"];
        self.cellFrame = [coder decodeCGRectForKey:@"cellFrame"];
        self.emptyCellCenter = [coder decodeCGPointForKey:@"emptyCellCenter"];
        self.emptyCellFrame = [coder decodeCGRectForKey:@"emptyCellFrame"];
        self.emptyCell = [coder decodeObjectForKey:@"emptyCell"];
        self.moves = [coder decodeIntForKey:@"moves"];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)coder
{
    //[coder encodeObject:_matrixGrid forKey:@"matrixGrid"];
    [coder encodeInt:_matrixSize forKey:@"matrixSize"];
    [coder encodeCGPoint:_diffPoint forKey:@"diffPoint"];
    [coder encodeObject:_matrixCells forKey:@"matrixCells"];
    [coder encodeCGPoint:_cellCenter forKey:@"cellCenter"];
    [coder encodeCGRect:_cellFrame forKey:@"cellFrame"];
    [coder encodeCGPoint:_emptyCellCenter forKey:@"emptyCellCenter"];
    [coder encodeCGRect:_emptyCellFrame forKey:@"emptyCellFrame"];
    [coder encodeObject:_emptyCell forKey:@"emptyCell"];

    [coder encodeInt:_moves forKey:@"moves"];
    
}

- (id) initWithSize:(int) size view: (UIView *) view
{
 
    self = [super init];
    if (self != nil)
    {
        self.matrixSize = size;
        self.matrixGrid = view;
    }
    
    // This is not exactly a singlton object but it actually returns the current object.
    singleton = self;
    return self;
}

// Returns the total cell count excluding the empty cell
-(int) getMatrixCellCount
{
    return (self.matrixSize * self.matrixSize)-1;
}

- (int) moves
{
    if (!_moves)
        _moves=0;
    
    return _moves;
}
- (void) addJigsawMatrixForView:(UIView *) view
{
    //(@"in addjigsawmatrix");
    int screenWidth = [self getMatrixWidth];
    int size= self.matrixSize;
    float avgWidth = screenWidth/size;
    float spacing = avgWidth * kCellSpacing;
    float useArea = screenWidth-((size+3)*spacing);
    float width = useArea / size;
    float height = width;
    float x = spacing *2;float y=[self getStartingY];//kMatrixYPoint;
    CGPoint diff = CGPointMake(width+spacing, height+spacing);
    self.diffPoint = diff;
    int tag=1, max=[self getMatrixCellCount];
    int emptyBox = rand() % (max-tag) + tag;
    
//    NSLog(@"svg SZIE%dwidth%f, spacing %f, useArea%f, width%f, height%f, x%f, diff%f",self.matrixSize, avgWidth, spacing,useArea, width, height, x, width+spacing);

    
    NSMutableArray *btns = [[NSMutableArray alloc] init] ;
    
    for(int i=0; i<size;i++)
    {
        
        for(int j=0;j<size;j++)
        {
            CGRect cell = CGRectMake(x,y, width,height);
            ColoredRoundedButton *btn = [[ColoredRoundedButton alloc] initWithFrame:cell];
            NSString *title = [[NSString alloc] initWithFormat:@"%d",tag ];
            [btn.layer setCornerRadius:spacing*2];
            if(emptyBox == tag && emptyBox)
            {
                btn.backgroundColor = [self.settings emptyCellColor];
                btn.highlightedButtonBackgroundColor= [self.settings emptyCellColor];
                self.emptyCell = btn;
                
                // Not to execute this if again set the value to 0
                emptyBox = 0;
                
                // Setting a high value to avoid getting this empty tag in game over check
                [btn setTag:1000];
                [btn setTitle:@"" forState:UIControlStateNormal];
                self.emptyCellIndex = tag-1;
                self.emptyCellRow = i+1;
//                NSLog(@"ading empty box at index %d", self.emptyCellIndex);
            }
            else{

                CGFloat cg = [self getCellFontSize];
//                NSLog(@"Setting the font size %f, %f %d", cga,cg, [self getCurrentLevel]);
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:cg];
                btn.titleLabel.adjustsFontSizeToFitWidth = TRUE;
                [btn setTag:tag];
                [btn setTitle:title forState:UIControlStateNormal];
                btn.backgroundColor = [self.settings cellColor];
                btn.clipsToBounds = YES;
                [btns addObject:btn];
                tag = tag+1;
            }
          
            [view addSubview:btn];
            
            //calculate the next cell x value in the same row.
            x +=width+spacing;
        }
        // set the row's first cell x value
        x=spacing*2;
        
        // Calculate the next Y value for next row cells
        y += height+spacing;
    }
    
    
    ///[view addSubview:self.emptyBox];
    self.matrixCells = btns;
  
}

// Only neighboring cells of empty cell can be panned
-(Boolean) validateMove:(int) x: (int) y
{
    if (x == (int)self.diffPoint.x && y==0)
        return true;
    else if (x == -(int)self.diffPoint.x && y==0)
        return true;
    else if (x == 0 && y == (int)self.diffPoint.y)
        return true;
    else if (x == 0 && y == -(int)self.diffPoint.y)
        return true;
    else return false;
}

- (Boolean) isGameOver
{
    int screenWidth = [self getMatrixWidth];
    int size=self.matrixSize;
    float avgWidth = screenWidth/size;
    float spacing = avgWidth * kCellSpacing; // 0.0625
    float useArea = screenWidth-((size+3)*spacing);
    float width = useArea / size;
    float height = width;
    float x = spacing *2;float y=[self getStartingY];//kMatrixYPoint;
    NSInteger tag=1;
    int isGameIncomplete = 0;
    int hintTag=0;
    Boolean showHint = TRUE;
    for(int i=0; i<size;i++)
    {
        
        for(int j=0;j<size;j++)
        {
            
            CGRect cell = CGRectMake(x,y, width,height);
            CGPoint center = CGPointMake(CGRectGetMidX(cell), CGRectGetMidY(cell));
            
            ColoredRoundedButton* btn = (ColoredRoundedButton *) [self.matrixGrid viewWithTag:tag];
            
            if ([self isCellCenter:btn.center nearToThis:center])
            //if((int)btn.center.x != (int)center.x || (int)btn.center.y!= (int)center.y)
            {
                [btn setBackgroundColor:[self.settings rightCellColor]];
                hintTag = tag;
            }
            else
            {
                if(showHint)
                {
                    showHint=FALSE;
                    ColoredRoundedButton* nextBtn = (ColoredRoundedButton *) [self.matrixGrid viewWithTag:tag];
                    [nextBtn setBackgroundColor:[self.settings nextCellColor]];
                }
                else
                {
                    [btn setBackgroundColor:[self.settings cellColor]];
                }

                isGameIncomplete = 1;
            }
            
            
            x += width+spacing;
            
            tag = tag+1;
            
            if (tag > [self getMatrixCellCount])
                break;
        }
       
        x=spacing*2;
        y+=width+spacing;
        
    }

    if(isGameIncomplete) return false;
    
    [self showGameOverMessage];
   
    return true;
}

- (Boolean) isCellCenter:(CGPoint) cellCenter nearToThis:(CGPoint)center
{
    float diffX = cellCenter.x - center.x;
    float diffY = cellCenter.y- center.y;
    
    if(diffX <=1 && diffX >= -1 && diffY <=1 && diffY >= -1)
    {
        return true;
    }
    else
    {
        return false;
    }
    
}

- (void) showGameOverMessage
{
    [RtwUtility playSoundFXnamed:@"gameover"];
    [self setHighscore];
    
    int level = self.matrixSize-2;

    if (level < [self getMaxLevelForDevice])
    {
        if (level == [[RtwSetting getSettingsObject] maxUnlockedLevel])
            [[RtwSetting getSettingsObject] setMaxUnlockedLevel: level+1];
        
        [[RtwSetting getSettingsObject] setCurrentLevel: level+1];
        [[RtwSetting getSettingsObject] saveSettings];

    }
    
}


- (void) setHighscore
{
    NSMutableDictionary *scores = [[RtwSetting getSettingsObject] scores];
    
    NSString *level = [[NSString alloc] initWithFormat:@"Level %d", [self getCurrentLevel] ];
    NSNumber *score = [[NSNumber alloc] initWithInt:[self getHighscore] ];
 
    int currentHightScore = [[scores objectForKey:level] integerValue];

    if ([score integerValue] > currentHightScore)
    {
        [scores setObject:score forKey:level];
    
        [RtwSetting getSettingsObject].scores = scores;
    
        [[RtwSetting getSettingsObject] saveSettings];
    }
    
}

- (int) increaseMoves
{
    return self.moves++;
}

- (void)resetMatrix
{
    NSArray * numbers = [RtwUtility getRandomNumbersForMatrix:self];
    NSMutableArray *tags = [[NSMutableArray alloc] initWithCapacity:[numbers count]];
    NSString *title;
    NSInteger *tag;
    int i;
    ColoredRoundedButton *myBtn;

    for (i=0; i < [numbers count];i++)
    {
        
        tag   = i+1;
        title = [[NSString alloc] initWithFormat:@"%@",[numbers objectAtIndex:i]];
        myBtn =  (ColoredRoundedButton *) [self.matrixGrid viewWithTag:tag];

        [myBtn setBackgroundColor:[self.settings cellColor]];
        [myBtn setTitle:title forState:UIControlStateNormal];
        [tags addObject:title];
        
    }

    self.moves = 0;
    // this will again reset the tags as per the title values.
    [self resetTags];
    self.emptyCell.backgroundColor = self.settings.emptyCellColor;
    
    // We have to remove any state while resetting the matrix, otherwise after gameover it will load the previous saved state
    [self.settings resetGameState];
    
    // DO NOT DELETE THIS. I FORGOT WHAT THIS LOGIC IS FOR
    // DELETE ONLY AFTER THOROUGH TESTING
    
//    myBtn =  (ColoredRoundedButton *) [ self.matrixGrid viewWithTag:[title integerValue]];
//    NSLog(@"last button in resetmatric%@", myBtn);
//    [myBtn setBackgroundColor:kCellColor];
//    CGRect btnFrame = [myBtn frame];
//    CGRect boxFrame = [self.emptyCell frame];
//    
//    self.cellFrame = [myBtn frame];
//    
//    btnFrame.origin = self.emptyCell.frame.origin;
//    boxFrame.origin = self.cellFrame.origin;
//    
//    self.emptyCell.frame = boxFrame;
//    myBtn.frame = btnFrame;
// 
   
    
}

- (int) getMatrixWidth
{
    int width;
    
    if ([RtwUtility isiPad])
    {
        width = 760;
    }
    else
    {
        width = 320;
    }
    
    return width;
}

// Validates a pannign gesture and swap the cell with the empty cell.
- (void) swapCell:(UIPanGestureRecognizer *) panRecognizer
{
    CGFloat xDist = (int)(self.emptyCellFrame.origin.x - self.cellFrame.origin.x);
    CGFloat yDist = (int)(self.emptyCellFrame.origin.y - self.cellFrame.origin.y);
    // NSLog(@"Diff x,y %f,%f", xDist, yDist);
    
    if ([self validateMove:xDist :yDist])
    {
        CGRect btnFrame = [panRecognizer.view frame];
        CGRect boxFrame = [self.emptyCell frame];
        
        btnFrame.origin = self.emptyCellFrame.origin;
        boxFrame.origin = self.cellFrame.origin;
        
        panRecognizer.view.frame = btnFrame;
        self.emptyCell.frame = boxFrame;
        
        [self increaseMoves];
       // [self isGameOver];

    }
    else
    {
        // If the move is not valid, keep the cell in its original place.
        panRecognizer.view.center = self.cellCenter;
        [RtwUtility playSoundFXnamed:@"error"];
    }

}

- (void) setEmptyCellCenterAndFrame
{
    self.emptyCellCenter = self.emptyCell.center;
    self.emptyCellFrame  = self.emptyCell.frame;
}

- (void) setCellCenterAndFrame:(UIPanGestureRecognizer *)panRecognizer
{
    self.cellCenter = panRecognizer.view.center;
    self.cellFrame  = panRecognizer.view.frame;
}

-(int) getMaxLevelForDevice
{
    // the matrix size is level+2 
    if ([RtwUtility isiPad])
         return 12;
    else
         return 4;
}

- (int) getHighscore
{
    return (int) (self.matrixSize * self.matrixSize * (self.getCurrentLevel) * (self.getCurrentLevel) * 10000 )/ self.moves;
    
}

- (int) getCurrentLevel
{
    return self.matrixSize-2;
}

- (float) getCellSpacing
{
    return [self getMatrixWidth] / self.matrixSize * kCellSpacing;
}

- (void) setRounderCornersForCell:(ColoredRoundedButton*)cell
{

    [cell.layer setCornerRadius:[self getCellSpacing]*2];
      
}

- (void) setRounderCornersForEmptyCell
{
    [self.emptyCell.layer setCornerRadius:[self getCellSpacing]*2];
}

- (void) resetTags
{
    UIButton *myBtn;
    int count = [self.matrixCells count];
    for(int i=0;i<count;i++)
    {
        myBtn = [self.matrixCells objectAtIndex:i];
        [myBtn setTag:[[[myBtn titleLabel] text] integerValue]];
    }
}

+(RtwJigsawMatrix*) getStateObject
{
    singleton = [RtwSetting getSettingsObject].gameState;
    
    return (singleton) ?singleton :nil;
}

- (CGFloat) getCellFontSize
{
    
    CGFloat cg1 = [self getCellWidth] * 0.35;
    return cg1;

}

-(CGFloat) getCellWidth
{
    return [self getMatrixWidth]/self.matrixSize;
}

- (CGFloat) getStartingY
{
    if ([RtwUtility isiPad])
    {
        return kMatrixYPoint*3;
    }
    else
    {
        return kMatrixYPoint;
        
    }
}

- (Boolean) isSolvable: (NSArray*) numbers
{
    
    NSMutableArray *numbersCopy = [[NSMutableArray alloc] initWithArray:numbers];
    int n = [numbersCopy count];
    int count= 0; // n- self.emptyCellIndex;
    
//    NSLog(@"random array %@, count %d size %d ", numbersCopy, count,  n);
    for (int i=0;i <n-1;i++)
    {
        for(int j=i+1; j<n;j++)
        {
            int m = [[numbersCopy objectAtIndex:i] integerValue];
            int n = [[numbersCopy objectAtIndex:j] integerValue];
            if(m > n)
            {
                count++;
                
            }
        }
    }
//    NSLog(@"count %d, size %d empty index %d row %d bottm row %d",count, self.matrixSize, self.emptyCellIndex, self.emptyCellRow, [self getEmptyCellRowFromBottom]);

    int bottomRow = [self getEmptyCellRowFromBottom];
    if (self.matrixSize %2 !=0)
    {
//        NSLog(@"Width is odd and return even");
        return count%2 == 0;
    
    }
    else
    {
//        NSLog(@"Width is even");
        return (bottomRow %2 != 0) == (count %2 ==0);
        if(bottomRow %2 ==0)
        {
//            NSLog(@"Width is even and row is even and return odd inverse");
            return count %2 != 0;
        }
        
        if (bottomRow %2 != 0)
        {
//            NSLog(@"Width is even and row is odd and return even inverse");
            return count %2 == 0;
        }
    }

    return count %2 ==0;


    
    //( (grid width odd) && (#inversions even) )  ||  ( (grid width even) && ((blank on odd row from bottom) == (#inversions even)) )
}

// Return the row no from bottom
- (int) getEmptyCellRowFromBottom
{
    return self.matrixSize - self.emptyCellRow +1;
}
@end
