//
//  rtwGameController.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 1/28/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "RtwGameController.h"
#import "RtwJigsawMatrix.h"
#import "RtwSetting.h"
#import "RtwSettingController.h"

//import <QuartzCore/QuartzCore.h>



@interface RtwGameController ()

@property (weak, nonatomic) IBOutlet UIView *matrixView;
@property (weak, nonatomic) IBOutlet UILabel *moves;
@property (weak, nonatomic) IBOutlet ColoredRoundedButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreBoard;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonAction;
@property (nonatomic) int level;
@property (nonatomic) Boolean isPanning;
@property (nonatomic) ColoredRoundedButton* pannedButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moves1;


@property (strong, nonatomic) RtwJigsawMatrix* jm;

@end


@implementation RtwGameController


@synthesize jm = _jm;
@synthesize resetButton = _resetButton;
@synthesize moves = _moves;
@synthesize scoreBoard = _scoreBoard;
@synthesize level = _level;
@synthesize isPanning = _isPanning;
@synthesize pannedButton = _pannedButton;

- (int) level
{
    _level = [RtwSetting getSettingsObject].currentLevel;

    if(!_level)
    {
        _level = 1;
    }
    
    return _level;
}

- (int) getMatrixSize
{
    return self.level+2;
}


- (RtwJigsawMatrix *) jm
{
   
    if (_jm == nil)
    {
        _jm = [[RtwJigsawMatrix alloc] initWithSize:[self getMatrixSize]  view:self.matrixView];
       // RtwJigsawMatrix.singleton = _jm;
    }
    
    return _jm;
}

- (void) loadView
{
    [[RtwSetting getSettingsObject] loadSettings];
    [super loadView];
    RtwJigsawMatrix *jm  = [RtwJigsawMatrix getStateObject];

    // Checking for the existing game state
    if( jm != nil)
    {
        self.jm = jm;

        self.jm.matrixGrid = self.matrixView;

        for (int i=0;i<[jm.matrixCells count];i++) {
           ColoredRoundedButton *btn = [jm.matrixCells objectAtIndex:i];
            [self.jm setRounderCornersForCell:btn];
            [self.matrixView addSubview:btn];
        }

        [self.matrixView addSubview:jm.emptyCell];
        [self.jm setRounderCornersForEmptyCell];
        
       // [[RtwSetting getSettingsObject] resetGameState];
        [self setMovesCount];
    }
    else
    {
        [self.jm addJigsawMatrixForView:self.matrixView];
        [self.jm resetMatrix];
    }

   // NSLog(@"jigsaw matrix %@", self.jm);
    [self setTitle:[[NSString alloc] initWithFormat:@"Level %d", [self level]]];
    [self setNavigationColors];
}

- (void) setNavigationColors
{
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0x66/255.0 green:0X33/255.0 blue:0 alpha:1.0];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0xff/255.0 green:0X66/255.0 blue:0X33/255.0 alpha:1.0];
   // self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0xff/255.0 green:0X66/255.0 blue:0X33/255.0 alpha:1.0];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    for (UIButton*  btn in self.jm.matrixCells) {
        
        [self addPanGestureFor: btn];
    }
   // NSLog(@"in viewDidLoad");
    UIImage* wallpaper = [UIImage imageNamed:@"wallpaper.jpg"];
    UIColor *bgcolor = [[UIColor alloc] initWithPatternImage:wallpaper];
    self.view.backgroundColor = bgcolor;
    self.matrixView.backgroundColor= bgcolor;

}


- (void) addPanGestureFor:(UIButton *) aButton
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [aButton addGestureRecognizer:panRecognizer];
    panRecognizer.delegate= (id) self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) panDetected:(UIPanGestureRecognizer *) panRecognizer
{
    ColoredRoundedButton *currentBtn = (ColoredRoundedButton *) panRecognizer.view;
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.pannedButton == nil)
        {
          self.pannedButton = (ColoredRoundedButton *) panRecognizer.view;
        }
    }

    if (self.pannedButton !=nil && currentBtn.tag == self.pannedButton.tag)
    {
       // NSLog(@"ELSE current, stored %d,%d", currentBtn.tag, self.pannedButton.tag);
        if (panRecognizer.state == UIGestureRecognizerStateBegan)
        {
            [self.jm setEmptyCellCenterAndFrame];
            [self.jm setCellCenterAndFrame:panRecognizer];
        }
    
        // Show the movind animation
        CGPoint translation = [panRecognizer locationInView:self.view];
        CGPoint buttonLocation = panRecognizer.view.center;
    
    
        buttonLocation.x = translation.x;
        buttonLocation.y = translation.y;
        panRecognizer.view.center = buttonLocation;
    
    
        if(panRecognizer.state == UIGestureRecognizerStateEnded)
        {
            [self.jm swapCell:panRecognizer];
            [self setMovesCount];
//            if (self.level < [RtwSetting getSettingsObject].currentLevel)

            if ([self.jm isGameOver])
            {
                NSString* score = [[NSString alloc] initWithFormat:@"Your score is %d",[self.jm getHighscore]];
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congratulations!!"
                                                              message: score
                                                             delegate:self
                                                    cancelButtonTitle:@"Continue"
                                                    otherButtonTitles: nil];
                [message show];
            }

            self.pannedButton = nil;
        }

    }
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex              {

    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue"])
    { 
        RtwGameController* rgc = [[UIStoryboard storyboardWithName:[RtwUtility getStoryBoard] bundle:nil] instantiateViewControllerWithIdentifier:@"RtwGameController"];
        [[self navigationController] pushViewController: rgc animated:YES];   
    }
}

- (void) increaseMoveCount
{

    [self.jm increaseMoves];
    [self setMovesCount];
}

- (void) setMovesCount
{
    int moves = self.jm.moves;
    self.moves.text = [[NSString alloc] initWithFormat:(@"%d"), moves];
 //   self.moves.textAlignment = UITextAlignmentRight;
    self.moves.textColor = [UIColor whiteColor];
    self.moves1.title = [[NSString alloc] initWithFormat:(@"Moves: %d"), moves];
}
- (IBAction)reset:(id)sender {
//    NSLog(@"I am Reset nav bar button");
    [self resetGame:sender];
}

- (IBAction)resetGame:(id)sender {
    
    [self.jm resetMatrix];
    [self setMovesCount];
    
}


- (IBAction)gotoSettings:(id)sender {
//    NSLog(@"In setting action");
    RtwSettingController* controller = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"RtwSettingController"];

    controller.modalPresentationStyle = UIModalPresentationFormSheet;

    [self.navigationController presentViewController:controller animated:YES completion:nil];

    //[self pushViewController:controller animated:TRUE];
    
    controller.view.superview.bounds = CGRectMake(0, 0, 320, 480);
    

}
- (IBAction)gotoStats:(id)sender {
    
   // NSLog(@"In stats action");
    RtwSettingController* controller = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"RtwStatsController"];
    
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:controller animated:YES completion:nil];
    
    controller.view.superview.bounds = CGRectMake(0, 0, 320, 480);
    [controller.navigationController setNavigationBarHidden:FALSE];
}




@end
