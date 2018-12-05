#import "MenuViewController.h"
#import "ScanViewController.h"


#pragma mark - ViewController Setup

@interface MenuViewController ()
{}


@end

@implementation MenuViewController

+ (instancetype) viewController
{
    MenuViewController* vc = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    return vc;
}

- (IBAction)startScanButtonPressed:(id)sender
{
    ScanViewController *scanViewController = [ScanViewController viewController];
    [self presentViewController:scanViewController animated:YES completion:nil];

}


@end
