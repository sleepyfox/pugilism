# Pugilism

Because pair-boxes, in bash.

## Design rationale

Pairing remotely is hard. There seem to be plenty of solutions, but they either:

* Aren't inclusive, and only work on one platform
* Are buggy, to the point of being almost unusable
* Are locally hosted, meaning one person has no lag (hoster), and everyone else has twice the lag
* Force you to use a particular editor (VS Code Liveshare)
* Are sloooooooowwww
* Mysteriously lock up
* Lose changes
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

## Usage

Pugilism is a set of scripts that enable you to:

* Define what your pair-box looks like, as a Packer script
* Build a machine image based upon that definition
* Create or delete a box on a cloud provider based upon that definition

### To create and push a new machine image

> make build

### To create a new pair-box

> make create-box <name>

### To delete a named pair box

> make delete-box <name>

### To connect to a named pair box

> make ssh <name>

## Customisation

You will want to customise the image before you `make build`, the most important of these customisations is to add the public key of yourself and any other colleagues or friends that you want to have access to the box. The public keys go in the `keys` folder. These are copied into the image by the Packer script. This is safe because these are _public_ keys.

The second piece of customisation is for your dotfiles. Any file placed into the `dotfiles` directory will be added to the pairing user's home directory.

## Security

This Makefile and Dockerfile make use of several private credentials.

* Your private SSH key
  This is needed by packer in order to create a Cloud instance that you will be able to SSH into. See [docs](https://www.packer.io/docs/builders/scaleway) for details.
* Your Scaleway access key and secret key
  These are needed for packer to be able to access the Scaleway API in order to create or destroy an instance

None of the Pugilism scripts do anything with these credentials, these are only used by Packer and the Scaleway API; this is easily checked by reviewing the scripts themselves, there's very little code.
