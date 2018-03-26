# friday night suggestion generator
A bash script that generates random activities for a Friday night. Inspired by:

![screenshot](assets/screenshot.png?raw=true "This is a Screenshot. There are many like it, but this one is mine.")

## Usage:

```
$> chmod +x what_should_i_do_tonight.sh
$> ./what_should_i_do_tonight.sh
```
If one suggestion isn't enough, you can spice it up with the "bulk" feature:
```
$> ./what_should_i_do_tonight.sh bulk
```

## Other Features:
 - **Cryptographically Secure Randomness**: To make sure the generated ideas are completely unique.
 - **Controlled source**: all of the suggestions are stored in `data/`.
     - You can add a new suggestion category by creating a new file in this directory.
	 - You can remove suggestion categories by removing the file (`rm file`) or simply hiding it (`mv file .file`).
	 - You can add suggestions by adding more entries to the category files.
	 - You can remove suggestions by deleting lines or commenting them (`active` `#passive`)
	 - By default, you can weight the suggestions by adding duplicate lines for entries you want to appear more often.
	 You can disable behavior this by modifying `ALLOW_DUPE` in `config`.
	 - You can restrict the opener and closer by enabling `IN_ORDER` in `config`.
	 This causes the program to source the files `first` and `last`.
	 (If you look at their contents you'll pretty quickly figure out how they work)
 - **Meta Functions**: if by random chance, the file `meta` is selected as the category, it doesn't produce a selection but instead modifies the existing selections.
     - You can disable this by setting `NO_META` in `config`
     - `end`: Immediately terminate the suggestion with `.. and nothing else` (or simply `nothing` if it's the first). 
	 This will sometimes conflict with the the `last` entry if you're using `IN_ORDER`.
	 This is not a bug, but a feature. Deal with it ¯\\\_(ツ)_/¯
	 - `and`: Add another entry to the list.
	 This will sometimes trigger several times (and is more likely to trigger the more often it triggers) and you will periodically get ridiculously long suggestions.
	 - `not`: Simply puts `not` in front of the next suggestion.
	 - `dup`: Duplicates a suggestion if space is available.
	 (`minecraft and minecraft`, for example)


