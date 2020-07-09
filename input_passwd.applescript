on input_passwd()
	set my_password to "yourpasswd"
	-- tell application "System Events" to key code 53 using command down
	-- delay 0.1
	
	tell application "System Events"
		keystroke "a" using command down -- select all
		keystroke my_password --enter password
		-- delay 0.1
		key code 52 -- enter
	end tell
end input_passwd

try
	set a to do shell script ("python -c 'import Quartz;d=Quartz.CGSessionCopyCurrentDictionary();print d'|grep -E 'CGSSessionScreenIsLocked|kCGSSessionSecureInputPID'|wc -l")
	if ("1" is in a) then
		do shell script ("/usr/bin/caffeinate -u -t 1&")
		input_passwd()
	else if ("2" is in a) then
		input_passwd()
	end if
	
	delay 0.5
on error errString number errorNumber
	log (errString)
end try

