//
//  rtwSettingController.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 2/2/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "RtwSettingController.h"
#import "NEOColorPickerViewController.h"


@interface RtwSettingController () <NEOColorPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet ColoredRoundedButton *cell;
@property (weak, nonatomic) IBOutlet ColoredRoundedButton *rightCell;
@property (weak, nonatomic) IBOutlet ColoredRoundedButton *nextCell;
@property (weak, nonatomic) IBOutlet ColoredRoundedButton *emptyCell;

@property(nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;
@end

@implementation RtwSettingController

@synthesize settings = _settings;
@synthesize cellColor = _cellColor;
@synthesize rightCellColor = _rightCellColor;
@synthesize nextCellColor  = _nextCellColor;
@synthesize emptyCellColor = _emptyCellColor;
@synthesize currentCell = _currentCell;


-(RtwSetting*) settings
{
    if (_settings == nil)
        _settings = [RtwSetting getSettingsObject];
    return _settings;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   [self loadColors];
	// Do any additional setup after loading the view.
    
//    NSLog(@"SETTING bounds");
    
    UIImage* wall = [UIImage imageNamed:@"wallpaper.jpg"];
    UIColor *bgcolor = [[UIColor alloc] initWithPatternImage:wall];
    self.view.backgroundColor = bgcolor;//[UIColor darkGrayColor];
    
    self.title = kSettingsTitle;
    [self setNavigationBarButtonsForIphone];
}

- (void) setNavigationBarButtonsForIphone
{
    // We need the navigation bar only for iPhone
    // For iPad we are diplaying as modal with custom toolbar for navigation.
    if (![RtwUtility isiPad])
    {
        UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModel:)];
        
        UIBarButtonItem* left = [[UIBarButtonItem alloc] initWithTitle:@"Default" style:UIBarButtonItemStyleDone target:self action:@selector(restoreAndSaveDefaults:)];
        
        
      //  done.tintColor = [UIColor colorWithRed:0xff/255.0 green:0X66/255.0 blue:0X33/255.0 alpha:1.0];
        done.tintColor = [UIColor colorWithRed:0xff/255.0 green:0X66/255.0 blue:0X33/255.0 alpha:1.0];
        [self.navigationItem setRightBarButtonItem:done];
        [self.navigationItem setLeftBarButtonItem:left];
    }
}

- (void) loadColors
{
    
    [self.settings loadColorSettings];
   
    self.cell.accessibilityIdentifier = @"cellColor";
    self.nextCell.accessibilityIdentifier = @"nextCellColor";
    self.rightCell.accessibilityIdentifier = @"rightCellColor";
    self.emptyCell.accessibilityIdentifier = @"emptyCellColor";
    
    self.rightCell.backgroundColor = self.settings.rightCellColor;
    self.emptyCell.backgroundColor = self.settings.emptyCellColor;
    self.nextCell.backgroundColor = self.settings.nextCellColor;
    self.cell.backgroundColor = self.settings.cellColor;

    [self.cell.layer setCornerRadius:10];
    [self.nextCell.layer setCornerRadius:10];
    [self.rightCell.layer setCornerRadius:10];
    [self.emptyCell.layer setCornerRadius:10];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)colorPicker:(UIButton*)sender {
//    NSLog(@"color picker");
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    self.currentCell = sender;
    controller.delegate = self;
    controller.selectedColor = [self.settings getColorForKey:sender.accessibilityIdentifier];
    controller.dialogTitle = @"Pick a color";

    // this setting is only applied for the ipad
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
    if ([RtwUtility isiPad])
    {
      controller.view.superview.bounds = CGRectMake(0, 0, 320, 480);
    }
}

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    // Do something with the color.
  //  self.view.backgroundColor = color;
    
    self.currentCell.backgroundColor = color;
   // NSLog(@"color in controllerr %@", color);
    [self.settings setColorForKey:self.currentCell.accessibilityIdentifier color:color];
    //[self.settings saveColorSettings];
    [self.settings loadSettings];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// Action for loadDefaults buttons
- (IBAction)restoreAndSaveDefaults:(id)sender {
    
   // NSLog(@"Constant color%@", kRightCellColor);
    
    [self.settings setColorForKey:@"cellColor" color:kCellColor];
    [self.settings setColorForKey:@"rightCellColor" color:kRightCellColor];
    [self.settings setColorForKey:@"nextCellColor" color: kNextCellColor];
    [self.settings setColorForKey:@"emptyCellColor" color: kEmptyCellColor];
    
  [self loadColors];
    [self dismissModel:sender];
}

// Action for done.
- (IBAction)dismissModel:(id)sender {
    

    if ([RtwUtility isiPad])
    {
         [self dismissViewControllerAnimated:YES completion: nil];
    }
    else
    { 
        [[self navigationController] popViewControllerAnimated:YES];
        
    }

      
}

@end
