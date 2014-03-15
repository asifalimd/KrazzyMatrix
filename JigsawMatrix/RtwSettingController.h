//
//  rtwSettingController.h
//  JigsawMatrix
//
//  Created by Asif ali Mohammad on 2/2/13.
//  Copyright (c) 2013 ReloadTheWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RtwSetting.h"
#import "ColoredRoundedButton.h"

@interface RtwSettingController : UIViewController

@property (nonatomic) RtwSetting* settings;
@property (nonatomic) UIColor* cellColor;
@property (nonatomic) UIColor* rightCellColor;
@property (nonatomic) UIColor* nextCellColor;
@property (nonatomic) UIColor* emptyCellColor;
@property (nonatomic) UIButton* currentCell;

@end
