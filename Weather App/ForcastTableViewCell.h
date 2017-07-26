//
//  ForcastTableViewCell.h
//  Weather App
//
//  Created by Ashish kumar on 7/21/17.
//  Copyright © 2017 Ashish kumar . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForcastTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UIImageView *forcastIcon;
@property (nonatomic,strong) IBOutlet UILabel *forcastTitle;
@property (nonatomic,strong) IBOutlet UILabel *highTemp;
@property (nonatomic,strong) IBOutlet UILabel *LowTemp;
@property (nonatomic,strong) IBOutlet UILabel *forcastdescription;

@end
