/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import "LocationTracker.h"
#import "RCTRootView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  /**
   * Loading JavaScript code - uncomment the one you want.
   *
   * OPTION 1
   * Load from development server. Start the server from the repository root:
   *
   * $ npm start
   *
   * To run on device, change `localhost` to the IP address of your computer
   * (you can get this by typing `ifconfig` into the terminal and selecting the
   * `inet` value under `en0:`) and make sure your computer and iOS device are
   * on the same Wi-Fi network.
   */

  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle"];

  /**
   * OPTION 2
   * Load from pre-bundled file on disk. To re-generate the static bundle
   * from the root of your project directory, run
   *
   * $ react-native bundle --minify
   *
   * see http://facebook.github.io/react-native/docs/runningondevice.html
   */

//   jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"Drop"
                                                   launchOptions:launchOptions];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [[UIViewController alloc] init];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  UIAlertView * alert;
  
  //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
  if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
    
    alert = [[UIAlertView alloc]initWithTitle:@""
                                      message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                     delegate:nil
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil, nil];
    [alert show];
    
  }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
    
    alert = [[UIAlertView alloc]initWithTitle:@""
                                      message:@"The functions of this app are limited because the Background App Refresh is disable."
                                     delegate:nil
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil, nil];
    [alert show];
    
  } else{
    
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
    
    //Send the best location to server every 60 seconds
    //You may adjust the time interval depends on the need of your app.
    NSTimeInterval time = 10.0;
    self.locationUpdateTimer =
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];
  }
  
  self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  
  return YES;
}

-(void)updateLocation {
  NSLog(@"updateLocation");
  
  [self.locationTracker updateLocationToServer];
}

@end
