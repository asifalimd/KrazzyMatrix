//
//  RtwSetting.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 2/1/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "RtwSetting.h"


static RtwSetting* singleton = nil;
@implementation RtwSetting

@synthesize scores = _scores;
@synthesize currentLevel = _currentLevel;
@synthesize gameState = _gameState;
@synthesize maxUnlockedLevel = _maxUnlockedLevel;
@synthesize cellColor = _cellColor;
@synthesize nextCellColor = _nextCellColor;
@synthesize rightCellColor = _rightCellColor;
@synthesize emptyCellColor = _emptyCellColor;

+ (RtwSetting *) getSettingsObject
{
    if (!singleton)
    {
        singleton = [RtwSetting new];
    }
    
   // [singleton loadSettings];
    return singleton;
    
}

- (void) setGameState
{
    RtwJigsawMatrix* gameState = [RtwJigsawMatrix singleton];
    //RtwGameController* gameState = [RtwGameController singleton];
   // NSLog(@"setting state with moves %d", gameState.moves);
    //    NSLog(@"jigsaw matrix %@", gameState);
    if (gameState.moves >0)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameState];
        self.gameState = data;
    }
}


- (void) loadSettings
{
   // NSLog(@"Loading settings");
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    self.scores = [[NSMutableDictionary alloc] initWithDictionary:[settings dictionaryForKey:@"scores"]];
    
    int level = [settings integerForKey:@"currentLevel"];
    NSData* data = [settings objectForKey:@"gameState"];
    if(data)
    {
        self.gameState = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
//    self.gameState = nil;
    self.currentLevel = (level) ?level : 1;
    int maxUnlockedLevel = [settings integerForKey:@"maxUnlockedLevel"];
    
    // If there is no maxUnlocked then set it to the current level.
    self.maxUnlockedLevel = (maxUnlockedLevel) ?maxUnlockedLevel :self.currentLevel;
  //  NSLog(@"loading game state obj %@ level%d max level%d", self.gameState,  level, maxUnlockedLevel);
    
    self.cellColor = [self getColorForKey:@"cellColor"];
    self.nextCellColor = [self getColorForKey:@"nextCellColor"];
    self.emptyCellColor = [self getColorForKey:@"emptyCellColor"];
    self.rightCellColor = [self getColorForKey:@"rightCellColor"];
//    NSLog(@"Loading colors%@,%@, %@, %@", self.cellColor, self.nextCellColor, self.rightCellColor,self.emptyCellColor);
}

- (void) saveSettings
{

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setInteger:self.currentLevel forKey:@"currentLevel"];
    [settings setInteger:self.maxUnlockedLevel forKey:@"maxUnlockedLevel"];
    [settings setObject:self.scores forKey:@"scores"];
    [settings setObject:self.gameState forKey:@"gameState"];
   // NSLog(@"scores in saveSettings%@", self.scores);
    [settings synchronize];
   // NSLog(@"saving game level%d max level%d", self.currentLevel, self.maxUnlockedLevel);
}

- (void) saveColorSettings
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
   
    [settings setObject:self.cellColor forKey:@"cellColor"];
    [settings setObject:self.rightCellColor forKey:@"rightCellColor"];
    [settings setObject:self.nextCellColor forKey:@"nextCellColor"];
    [settings setObject:self.emptyCellColor forKey:@"emptyCellColor"];
    [settings synchronize];
}



- (NSMutableArray *) getScoresArray
{
    NSString *key, *row;
    NSMutableArray *scoresArray = [[NSMutableArray alloc] init];
    for(int i=1;i<=self.maxUnlockedLevel;i++)
    {
        key = [[NSString alloc] initWithFormat:@"Level %d",i];
       // NSLog(@"Score dictionay object%@",[self.scores objectForKey:key]);
        if([self.scores objectForKey:key])
        {
            row = [[NSString alloc] initWithFormat:@"Level %d - %@", i,[self.scores objectForKey:key]] ;
            [scoresArray addObject:row];
        }
        
    }
   // NSLog(@"Scores %@", scoresArray);
    return scoresArray;
}

-(void) loadColorSettings
{
   self.cellColor = [self getColorForKey:@"cellColor"];
   self.nextCellColor = [self getColorForKey:@"nextCellColor"];
   self.rightCellColor = [self getColorForKey:@"rightCellColor"];
   self.emptyCellColor = [self getColorForKey:@"emptyCellColor"];
}


-(UIColor*) getColorForKey:(NSString*) key;
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSData *colorData = [settings objectForKey:key];

    
    if (colorData)
    {
      return [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    else
    {
       if ([key isEqualToString:@"cellColor"])
           return kCellColor;
        else if ([key isEqualToString:@"nextCellColor"])
            return kNextCellColor;
        else if ([key isEqualToString:@"rightCellColor"])
                return kRightCellColor;
        else if ([key isEqualToString:@"emptyCellColor"])
            return kEmptyCellColor;
           
    }

}

-(void) setColorForKey: (NSString *) key color:(UIColor*) color
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    [settings setObject:colorData forKey:key];
  //  NSLog(@"Saving data for key %@", key);
    [settings synchronize];
    

}

- (void) resetGameState
{
    self.gameState = nil;
    [self saveSettings];
    
}


@end
