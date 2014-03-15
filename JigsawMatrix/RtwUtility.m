//
//  RtwUtility.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 1/27/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "RtwUtility.h"
#import <AVFoundation/AVFoundation.h>

@implementation RtwUtility



+ (NSArray*) getRandomNumbersWithMax: (int) max {
    
       
    NSMutableArray *numbers;
    
    numbers = [RtwUtility  getRandomArrayWithMax:max];
    
//    while (![RtwUtility isSolvable:numbers])
//    {  NSLog(@"FALSE");
//        numbers = [RtwUtility  getRandomArrayWithMax:max];
//   
//    }
    
    return numbers;
        
}

+ (NSArray*) getRandomNumbersForMatrix:(RtwJigsawMatrix *)jm {
    
    
    NSMutableArray *numbers;
    int max = [jm getMatrixCellCount];

    
    do
    {
//        NSLog(@"FALSE");
        numbers = [RtwUtility  getRandomArrayWithMax:max];
        
    } while (![jm isSolvable:numbers]);
    
    return numbers;
    
}

+ (Boolean) isSolvable: (NSArray*) numbers  withEmptyCellIndex: (int) emptyCellIndex
{

    NSMutableArray *numbersCopy = [[NSMutableArray alloc] initWithArray:numbers];
    int n = [numbersCopy count];
    int count= n-emptyCellIndex;
    
    NSLog(@"Initial Count %d, emptyCellIndex %d size %d ", count, emptyCellIndex, n);
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
//    NSLog(@"count %d", count);
//    NSLog(@"Aray %@", numbersCopy);
    return count %2 ==0;
    
    
//( (grid width odd) && (#inversions even) )  ||  ( (grid width even) && ((blank on odd row from bottom) == (#inversions even)) )
}

+ (NSMutableArray*) getRandomArrayWithMax: (int) max
{
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:max];
    for ( int i = 1 ; i <= max ; i ++ )
        [array addObject:[NSNumber numberWithInt:i]];
    
    
    //shuffle the array
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    //NSLog(@"Shuffled %@", temp);
    return [NSArray arrayWithArray:temp];
}

+ (BOOL) isiPad {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}

+ (int) getDeviceWidth
{
    if ([self isiPad])
        return 760;
    else
        return 320;
    
}

+ (BOOL) playSoundFXnamed: (NSString*) filename
{
    
  NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"wav"];
    
    NSURL* filePath = [NSURL fileURLWithPath: audioFilePath];
    SystemSoundID soundID;

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);

    AudioServicesPlaySystemSound(soundID);
    
//    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"wav"];
//    
//    NSURL *url = [NSURL fileURLWithPath:audioFilePath];
//   
//    NSLog(@"Playing sound %@",audioFilePath);
//	
//	NSError *error;
//	AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//	audioPlayer.numberOfLoops = 3;
//
//	if (audioPlayer == nil)
//		NSLog([error description]);
//	else{
//        
//        
//        NSLog(@"Playing sound url %@",url);
//   //     [audioPlayer setDelegate:self];
//       // [audioPlayer prepareToPlay];
//        NSLog(@"%hhd",[audioPlayer play]);
//    }
    return true;
}
+ (NSString *) getStoryBoard
{

    NSString *storyBoard;
    if ([[self class] isiPad])
        storyBoard = @"MainStoryboard_iPad";
    else
        storyBoard = @"MainStoryboard_iPhone";
  //  NSLog(@"storyboard %@",storyBoard );
    return storyBoard;
}

@end
