//
//  ConfigProjectCommand.m
//  Squall
//
//  Created by cooper on 11/09/2016.
//  Copyright © 2016 cooper. All rights reserved.
//

#import "ConfigProjectCommand.h"


NSDictionary* g_customization = nil;


@implementation ConfigProjectCommand

- (id)performDefaultImplementation
{
    NSDictionary* args = [self evaluatedArguments];
    if (args.count < 1 || args.count > 3) {
        [self setScriptErrorNumber:-50];
        [self setScriptErrorString:@"Parameter Error: A JSON parameter is expected for the verb 'config'"];

    } else {
        NSDocumentController* dc = [NSDocumentController sharedDocumentController];
        NSString* jsonString = [args valueForKey:@"json"];
        NSDictionary* config = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        // we've got a customization - I can't find a good way to pass this
        // to the creation of the document - and we need it increation as
        // we need it before we load the plugin.  So we're going to do
        // something horrid.  We're going to store it in a global.
        //
        // Theres an obvious race condition here
        // but we shouldn't be creating two documents within miliseconds of
        // each other - so we can live with it.
        g_customization = config;
        if (args.count >= 2) {
            BOOL template = NO;
            NSString* tmp = [args valueForKey:@"template"];
            if (tmp != nil && [tmp isEqualToString:@"YES"]) {
                template = YES;
            }
            NSString* project = [args valueForKey:@"project"];
            if (project != nil) {
                if (template == NO) {
                    [dc openDocumentWithContentsOfURL:[NSURL fileURLWithPath:project]
                                              display:YES
                                    completionHandler:^(NSDocument *document,
                                                        BOOL documentWasAlreadyOpen,
                                                        NSError *error) {
                        // already open - so the customization was ignored
                        if (documentWasAlreadyOpen) {
                            g_customization = nil;
                        }
                    }];
                } else {
                    // duplicate the doc
                    [dc duplicateDocumentWithContentsOfURL:[NSURL fileURLWithPath:project] copying:YES displayName:nil error:nil];
                }
            }
        } else {
            [dc openUntitledDocumentAndDisplay:YES error:nil];
        }
        // you'd think you could set g_customization = nil here but we can't as
        // the opens all appen on the main thread - the same reason they cant
        // access the current event directly as well
    }
    return nil;
}

@end
