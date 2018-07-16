//
//  AppDelegate.m
//  TouchBarTest
//
//  Created by Alexsander Akers on 2/13/17.
//  Copyright © 2017 Alexsander Akers. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchBar.h"

static const NSTouchBarItemIdentifier kBearIdentifier = @"io.a2.Bear";
static const NSTouchBarItemIdentifier kPandaIdentifier = @"io.a2.Panda";
static const NSTouchBarItemIdentifier kGroupIdentifier = @"io.a2.Group";

@interface AppDelegate () <NSTouchBarDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic) NSTouchBar *groupTouchBar;

@end

@implementation AppDelegate

- (NSTouchBar *)groupTouchBar
{
    if (!_groupTouchBar) {
        NSTouchBar *groupTouchBar = [[NSTouchBar alloc] init];
        groupTouchBar.defaultItemIdentifiers = @[ kBearIdentifier ];
        groupTouchBar.delegate = self;
        _groupTouchBar = groupTouchBar;
    }

    return _groupTouchBar;
}

- (void)bear:(id)sender
{
}

- (void)present:(id)sender
{
    if (@available(macOS 10.14, *)) {
        [NSTouchBar presentSystemModalTouchBar:self.groupTouchBar
                      systemTrayItemIdentifier:kPandaIdentifier];
    } else {
        [NSTouchBar presentSystemModalFunctionBar:self.groupTouchBar
                         systemTrayItemIdentifier:kPandaIdentifier];
    }
}

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar
       makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:kBearIdentifier]) {
        NSCustomTouchBarItem *bear =
            [[NSCustomTouchBarItem alloc] initWithIdentifier:kBearIdentifier];
        bear.view = [NSButton buttonWithTitle:@"\U0001F43B" target:self action:@selector(bear:)];
        return bear;
    } else if ([identifier isEqualToString:kPandaIdentifier]) {
        NSCustomTouchBarItem *panda =
            [[NSCustomTouchBarItem alloc] initWithIdentifier:kPandaIdentifier];
        panda.view =
            [NSButton buttonWithTitle:@"\U0001F43C" target:self action:@selector(present:)];
        return panda;
    } else {
        return nil;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);

    NSCustomTouchBarItem *panda =
        [[NSCustomTouchBarItem alloc] initWithIdentifier:kPandaIdentifier];
    panda.view = [NSButton buttonWithTitle:@"\U0001F43C" target:self action:@selector(present:)];
    [NSTouchBarItem addSystemTrayItem:panda];
    DFRElementSetControlStripPresenceForIdentifier(kPandaIdentifier, YES);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
