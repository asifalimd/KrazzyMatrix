//
//  RtwStatsController.m
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 2/13/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import "RtwStatsController.h"
#import "RtwSetting.h"
#import "RtwUtility.h"

@interface RtwStatsController ()

@end

@implementation RtwStatsController




- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    listOfItems = [[RtwSetting getSettingsObject] getScoresArray];
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wallpaper.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    

    self.title = kStatsTitle;
self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0x66/255.0 green:0X33/255.0 blue:0 alpha:1.0];
    
//    NSLog(@"%c bar status", self.navigationController.navigationBarHidden);
    [self.navigationController setNavigationBarHidden:false];
    
    

    [self addCloseButtonForIpadModal];

 
}

- (void) addCloseButtonForIpadModal
{
    if ( [RtwUtility isiPad] )
    {
        UIButton* x = [[UIButton alloc] init];
        [x setTitle:@"X" forState:UIControlStateNormal];
        [x addTarget:self action:@selector(closeModal:) forControlEvents:UIControlEventTouchUpInside];
        [x.titleLabel setFont:[UIFont boldSystemFontOfSize:29.0f]];
        [x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGRect frame = CGRectMake(295, 5, 30,30);
        x.frame = frame;
        
        UILabel* header = [[UILabel alloc] init];
        header.text = @"Score Board";
        [header setFont:[UIFont boldSystemFontOfSize:16.0f]];
        header.textAlignment = UIBaselineAdjustmentAlignCenters;

       header.backgroundColor =   [UIColor colorWithRed:0x66/255.0 green:0X33/255.0 blue:0 alpha:1.0];
        header.backgroundColor = [UIColor whiteColor];
        CGRect headerFrame = CGRectMake(0,0, 320, 40);
        header.frame = headerFrame;
        
        

    

//        [self.view addSubview:header];
        UIView* headerView  = [[UIView alloc] initWithFrame:headerFrame];

        [self.tableView setTableHeaderView:headerView];
        [headerView addSubview:header];
        
        
        [self.view addSubview:x];
        self.tableView.backgroundColor = [UIColor colorWithRed:0x66/255.0 green:0X33/255.0 blue:0 alpha:1.0];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return  12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"cell parseindex %d total%d",indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    NSString *cellValue;
    
    if([listOfItems count] > indexPath.row)
    {
        cellValue = [NSString stringWithFormat:@"%@",[listOfItems objectAtIndex:indexPath.row]];
    }
    else
    {
        //cellValue = @"hello";
    }
        
    cell.textLabel.text = cellValue;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}


- (IBAction)closeModal:(id)sender {
//    NSLog(@"HEHHE i am in clode modal");
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
