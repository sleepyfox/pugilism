# pugilism
Because pair-boxes, in bash.

## Design rationale

Pairing remotely is hard. There seem to be plenty of solutions, but they either:

* aren't inclusive, and only work on one platform
* are buggy, to the point of being almost unusable
* are locally hosted, meaning one person has no lag (hoster), and everyone else has twice the lag
* force you to use a particular editor (VS Code Liveshare)
* are sloooooooowwww
* mysteriously lock up
* lose changes
* ...

Pairing remotely using TDD with PingPong is even harder.

Something like Cyberdojo would be good, but it doesn't support 'multiplayer' (simultaneous remote editing). Repl.it looked like a brilliant solution with its recent multiplayer functionality, only to completely drop the ball with running tests (which have such a huge startup time as to be basically useless for TDD). Code9 was interesting, but it was bought by Amazon and now only works with AWS, and lumbers you with an IDE. Github _may_ be coming out with a solution with Codespaces, but until it is released???

It turns out there is a solution that has been sucessfully used since the 1980s. Tmux, SSH, and BYOE - Bring Your Own (terminal) Editor.

The idea: spin up a disposable remote VM on your cloud provider of choice. The machine image is pre-configured with your team's SSH public keys. You SSH into the box and start a pairing session in Tmux. Git clone your repo. You send your pair the box's address and the tmux session name. They log in and join the terminal/editing session. When you're done you git push any remaining unpushed work (perhaps to a brnach if on red) and kill the box. Cattle not pets.

A write up of how we approached this at Gower.st is [here](https://gower.st/articles/how-we-pair-using-aws-tmux-vim-and-emacs/).

It may seem 'old skool', but the advantages are:

* windows, without the disadvantages of slowness and needing to take your fingers off the keyboard
* your own choice of editor (provided it works in the terminal, which all good editors do, of course)
* persistant sessions for the duration of the work, not your laptop's battery
* can switch laptop to desktop simply and quickly (or even tablet if necessary)
* SRP, doesn't hitch you to a conferencing solution or IDE
* reliability, it just works, no missed keystrokes/changes
* no unequal lag
* speed, it is very **very** fast
