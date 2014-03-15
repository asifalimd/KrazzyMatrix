//
//  rtwViewController.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 1/26/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "rtwViewController.h"
#import "rtwJigsawMatrix.h"

@interface rtwViewController ()

@property (nonatomic, retain) IBOutlet UILabel *label;
@end

@implementation rtwViewController

@synthesize label;


-(void)menuButtonPressed
{
    NSLog(@"CLICKED");
    [label setText:@"HELLO"];
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
   
    
    [[self navigationController] setNavigationBarHidden:false];
}


@end
