# gbl_json_fix

GBL 3.3 uses a gem that no longer allows ENVELOPE E-W and N-S coordinates to be the same. This goes through downloaded json records, and amends and re-saves the files with envelope data that won't crash gbl

The only thing you will need to change are the two paths -- fill those in with where ever your data lives and where you'd like the audit file to go (the script lists which files it changed in a txt file).
