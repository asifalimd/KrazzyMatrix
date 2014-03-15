//
//  RtwSetting.h
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 2/1/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RtwJigsawMatrix.h"
#import "constants.h"


@interface RtwSetting : NSObject


@property (strong, nonatomic) NSDictionary *scores;
@property (nonatomic, assign) int currentLevel;
@property (nonatomic, assign) int maxUnlockedLevel;
@property (nonatomic) id gameState;
@property (nonatomic) UIColor* cellColor;
@property (nonatomic) UIColor* rightCellColor;
@property (nonatomic) UIColor* nextCellColor;
@property (nonatomic) UIColor* emptyCellColor;


- (void) loadSettings;
- (void) saveSettings;
+ (RtwSetting *) getSettingsObject;
//- (void) loadGameState;
- (NSMutableArray *) getScoresArray;
- (void) setGameState;
-(void) saveColorSettings;
-(void) loadColorSettings;
-(UIColor*) getColorForKey:(NSString*) key;
-(void) setColorForKey: (NSString *) key color:(UIColor*) color;
- (void) resetGameState;
@end
