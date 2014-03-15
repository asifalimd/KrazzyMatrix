//
//  rtwLevelsController.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 2/3/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "RtwLevelsController.h"
#import "RtwJigsawMatrix.h"
#import "RtwSetting.h"
#import "RtwGameController.h"
#import "RtwUtility.h"
#import "ColoredRoundedButton.h"
#import <QuartzCore/QuartzCore.h>
#import "constants.h"


@interface RtwLevelsController ()

@end

@implementation RtwLevelsController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self generateLevels];
    UIImage* wall = [UIImage imageNamed:@"wallpaper.jpg"];
    UIColor *bgcolor = [[UIColor alloc] initWithPatternImage:wall];
    self.view.backgroundColor = bgcolor;

    
    self.title = kLevelsTitle;
    
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0x66/255.0 green:0X33/255.0 blue:0 alpha:1.0];
}

- (void) generateLevels
{
    int screenWidth, rows,cols;
    
    
    screenWidth = [RtwUtility getDeviceWidth];
    
    if ([RtwUtility isiPad])
    {
        rows = 3;
        cols=4;
    }
    else
    {
        rows = 2;
        cols=2;
    }	
   
  
    int avgWidth = screenWidth/cols;
    float spacing = avgWidth * 0.0625;
    float useArea = screenWidth-((cols+3)*spacing);
    float width = useArea / cols;
    float height = width;
    int x = spacing *2;int y=kMatrixYPoint;
    int tag=1;
    UIImage* lock = [UIImage imageNamed:@"lock.png"];
    UIImage* unlock = [UIImage imageNamed:@"unlock.png"];
    int maxUnlockedLevel = [[RtwSetting getSettingsObject] maxUnlockedLevel];

    for(int i=0;i<rows;i++)
    {
        for(int j=0;j<cols;j++)
        {
//                NSLog(@"Level %d, max Unlocked %d", tag, maxUnlockedLevel);
            CGRect cell = CGRectMake(x,y, width,height);
            ColoredRoundedButton *btn = [[ColoredRoundedButton alloc] initWithFrame:cell];
            [btn.layer setCornerRadius:spacing];
            btn.backgroundColor = [UIColor whiteColor];
            btn.highlightedButtonBackgroundColor = [UIColor whiteColor];
            
            [btn setTag: tag];
            NSString *title = [[NSString alloc] initWithFormat:@"Level %d", tag ];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor]];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
            
            if ( tag <= maxUnlockedLevel)
            {
              [btn addTarget:self action:@selector(setGameLevel:)
                               forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage: unlock forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:lock forState:UIControlStateNormal];
            }
            [self.view addSubview:btn];
            x += width + spacing;
            tag++;
        }
        x = spacing*2;
        y += width+spacing;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)performAction:(id)sender {
    
//    [[self navigationController] popToRootViewControllerAnimated:YES];
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)setGameLevel:(UIButton*) sender {

    [[RtwSetting getSettingsObject] setCurrentLevel:sender.tag];
    
    [[RtwSetting getSettingsObject] resetGameState];

   
   RtwGameController* rgc = [[UIStoryboard storyboardWithName:[RtwUtility getStoryBoard] bundle:nil] instantiateViewControllerWithIdentifier:@"RtwGameController"];
    
   // NSLog(@"Sender tag%@", sender);
    [[self navigationController] pushViewController:rgc animated:YES];
 //   NSLog(@"Controllers stack%@", [self.navigationController viewControllers]);
    
    
}



@end
