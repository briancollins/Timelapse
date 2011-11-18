#import "TLAppDelegate.h"
#import "TLMainViewController.h"

@implementation TLAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.mainViewController = [[TLMainViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] 
                                      initWithRootViewController:self.mainViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
