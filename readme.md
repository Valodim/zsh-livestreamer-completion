zsh livestreamer / twitch.tv completion
===

This is a zsh completion for
[livestreamer](https://github.com/chrippa/livestreamer). At this point, it only
completes options and channels from twitch.tv. I have no plans to change that,
since twitch is all I really use livestreamer for - but feel free to a send
pull request.

![screenshot](http://valodim.stratum0.net/livestreamer_completion.png "Pinkie Pie Style!")

installation and configuration
---

Installation works by copying or symlinking the _livestreamer completion file
somewhere into your fpath, or putting the repo directory in your fpath variable
like this:

    fpath+=( /path/to/zsh-livestreamer-completion )

Without configuration, options and stuff will be completed, but no channels.
There are two types of completions supported for channels, followed and teams.


followed channel config
---

To get completion of channels followed by an account, a twitch
[implicit grant flow](https://github.com/justintv/Twitch-API/blob/master/authentication.md#implicit-grant-flow)
oauth token with scope user_read for that account is required. To get one,
simply run the 'oauth.zsh' script, which should guide you through the process.
In the end, you should end up with a zstyle like this:

    zstyle ":completion:*:twitch:follows" oauth-token abcdefghijklmnopqrstuvwxyz12345

That's it! Completion should otherwise just work™


team channel config
---

This is the easier one, it completes twitch teams. All you need to do is set a
style to all teams you want completed:

    zstyle ":completion:*:twitch" teams srl

This completes the [SpeedRunsLive](http://twitch.tv/team/srl) team. More than
one is possible by just adding more names to the line.


fine tuning
---

There are a couple more zstyles for fine tuning:

    # minimum number of viewers a stream needs to have to show up
    zstyle ":completion:*:twitch:x" viewmin 0

    # max streams to show for one category
    zstyle ":completion:*:twitch:x" maxstreams 20

    # completion description format. placeholders %n, %d, %c, %g, %t are
    # available for name, displayname, viewercount, game and title.
    zstyle ":completion:*:twitch:x" format "%-5c %15d %t"

The x in the style can be either "follows" for followed streams, "teams:*"
to set styles for all teams, or "teams:teamname" to set for a specific team.
For example, to show srl streams with more than 100 viewers only:

    zstyle ":completion:*:twitch:teams:srl" viewmin 100

By default, there is no minimum viewer count, and at most 20 streams per
category are shown.


caveats
---

One thing I am not quite happy about is that the completion is not pure zsh, it
calls to python for json parsing.
[I tried](https://gist.github.com/Valodim/7017924) doing the parsing in zsh,
but it's just not feasible in an efficent manner. But since livestreamer itself
is python, I figured it'd be okay to outsource this with some lines of python.
Then again, it uses curl for fetching the data so~

