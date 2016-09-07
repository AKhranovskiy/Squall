//
//  ConsolePaneController.h
//  ConsolePane
//
//  Created by cooper on 07/09/2016.
//  Copyright © 2016 cooper. All rights reserved.
//

#import <squall/PaneController.h>
#import "ConsoleCommand.h"
#import "ConsoleResults.h"


@interface ConsolePaneController : NSObject

- (IBAction)updated:(id)sender;

- (void)updatePane:(NSAttributedString*)s;

@property (assign) IBOutlet NSTextField* toolbar;
@property (assign) IBOutlet NSView* content;
@property (assign) IBOutlet ConsoleCommand* console;
@property (assign) IBOutlet ConsoleResults* results;

@property (retain) NSFont* font;
@property (retain) NSFont* bold;

@end
