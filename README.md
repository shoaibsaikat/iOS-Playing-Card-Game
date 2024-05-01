# iOS-Playing-Card-Game-Public
Own implementation of Stanford CS193P Course, Playing Card Game

# How to add existing local git repo to GitHub
1. Create the remote repository and copy the URL
2. In your existing local git repository run "git remote add origin <copied_url>"
3. Run "git pull origin main --allow-unrelated-histories" and fix merge conflicts
4. Then run "git push origin main". For mac and linux you might find issue in pushing with terminal, in that case download GitHub desktop client and push from that app


# Some Vi editor commands (collected from Stack Overflow)
Hit the Esc key to enter "Normal mode". Then you can type : to enter "Command-line mode". A colon (:) will appear at the bottom of the screen and you can type in one of the following commands. To execute a command, press the Enter key.

1. :q to quit (short for :quit)
2. :q! to quit without saving (short for :quit!)
3. :wq to write and quit
4. :wq! to write and quit, attempting to force the write if the file lacks write permission
5. :x to write and quit; like :wq but writes only if modified (short for :exit)
6. :qa to quit all (short for :quitall)
7. :cq to quit, without saving, with a nonzero exit code to indicate failure (short for :cquit)
You can also quit Vim directly from "Normal mode" by typing ZZ to save and quit (same as :x) or ZQ to just quit (same as :q!). (Note that case is important here. ZZ and zz do not mean the same thing.)

Vim has extensive help - that you can access with the :help command - where you can find answers to all your questions and a tutorial for beginners.
