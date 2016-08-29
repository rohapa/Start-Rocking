--
--  AppDelegate.applescript
--  Start Rocking
--
--  Created by Java Lancer on 08/08/16.
--  Copyright © 2016 Java Lancer. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
	
	property idleTimeout : 4 * 60
	property checkTimer : 5 * 60
	property scriptTimeout : 60 * 60
	
	property playSpotify : false
	property spotifyPlaying : «constant ****kPSP»
	
	global theMenuItem
	global isRocking

	-- IBOutlets
	property theWindow : missing value
	
	on applicationWillFinishLaunching_(aNotification)
		-- Create menu item
		set myMenu to current application's class "NSMenu"'s alloc()'s init()
		set myBar to current application's class "NSStatusBar"'s systemStatusBar()
		
		--add the menu to the system's status bar
		set theMenuItem to myBar's statusItemWithLength_(current application's NSSquareStatusItemLength)
		-- theMenuItem's button's setTitle_("Start Rocking")
		theMenuItem's button's setImage_((current application's NSImage's imageNamed:"on"))
		tell theMenuItem to setHighlightMode_(true)
		tell theMenuItem to setTarget_(me)
		tell theMenuItem  to setAction_("menuClicked:")
		
		set isRocking to true
		
		current application's NSTimer's scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_(checkTimer, me, "timerFired:", "Spotify Timer", true)
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
	on timerFired_(theTimer)
		if (isRocking)
			with timeout of scriptTimeout seconds
				-- Check idle time.
				set idleTime to do shell script "echo $((`ioreg -c IOHIDSystem | sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'` / 1000000000))"

				-- If idle then do not do anything.
				if (idleTime as integer > idleTimeout) then
					set playSpotify to false
				end if
				
				-- Specified time passed - check if Spotify is playing or not. If not playing, start playing.
				if playSpotify then
					tell application "Spotify"
						if player state is not spotifyPlaying then
--							tell me to display notification "You should be Rockin' right now."
							tell me to set userConfirmation to display alert "You should be Rockin' right now." message "Please click the button to start playing Spotify. This dialog will close automatically in 60 seconds." buttons ["Start Rockin'", "Not Now"] default button 1 cancel button 2 giving up after 60

							if button returned of userConfirmation is equal to "Start Rockin'" then
								-- Volume fade in
								set currentVolume to output volume of (get volume settings)
								delay 0.5
								set volume output volume 1
								play
								repeat while (currentVolume > (output volume of (get volume settings)))
									set volume output volume ((output volume of (get volume settings)) + 1)
									delay 0.05
								end repeat
							end if
						end if
					end tell
				end if
				
				-- Waits specified time before next invocation.
				set playSpotify to true
			end timeout
		end if
	end timerFired_
	
	--actions
	on menuClicked_(info)
		if (isRocking)
			set isRocking to false
			theMenuItem's button's setImage_((current application's NSImage's imageNamed:"off"))
		else
			set isRocking to true
			theMenuItem's button's setImage_((current application's NSImage's imageNamed:"on"))
		end if
	end menuClicked_

end script