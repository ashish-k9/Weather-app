//
//  AppDelegate.h
//  Weather App
//
//  Created by Ashish kumar on 7/21/17.
//  Copyright © 2017 Ashish kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

