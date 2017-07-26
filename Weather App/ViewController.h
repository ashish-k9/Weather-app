//
//  ViewController.h
//  Weather App
//
//  Created by Ashish kumar on 7/21/17.
//  Copyright © 2017 Ashish kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UITableView *forcastTableView;
    IBOutlet UITextField *cityTxtfield;
    NSMutableArray *citiesArray;
}

@end

