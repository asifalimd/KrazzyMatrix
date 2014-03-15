//
//  RtwUtility.h
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 1/27/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RtwJigsawMatrix.h"

@class RtwJigsawMatrix;

@interface RtwUtility : NSObject

+ (NSArray*) getRandomNumbersWithMax: (int) max;
+ (NSArray*) getRandomNumbersForMatrix: (RtwJigsawMatrix*) jm;
+ (NSMutableArray*) getRandomArrayWithMax: (int) max;
+ (Boolean) isSolvable: (NSMutableArray*) numbers withEmptyCellIndex: (int) emptyCellIndex;
+ (BOOL) isiPad;
+ (int) getDeviceWidth;
+(BOOL) playSoundFXnamed: (NSString*) filename;
+ (NSString*) getStoryBoard;
@end
