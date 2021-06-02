# noita-utils
Some scripts for Noita (Nolla Games)

# backup.bat

## Usage 

Run as `backup.bat [description]`

Copies the current game from `save00` to a timestamped directory under `backups`, found under the game directory in the user's`AppData`. The directory is named with a timestamp plus anything passed as parameters.

`Nolla_Games_Noita\backups\20210601-0224-jungle`, or
`Nolla_Games_Noita\backups\20210601-0224` if no arguments are given.

___NOTE___ The `description` parameter must be path-friendly or things might break in an undefined manner.

___NOTE___ The timestamp-to-string thing might misbehave in some locale scenarios.

# restore.bat

## Usage

Run as `restore.bat [ ls | auto | <backup name> ]`

Restores a backup into the `save00` directory. Any existing `save00` directory will first be backed up to `save00.old` (purging any existing such directory). Probably not needed anymore but who knows - things got real borked for me back in the prerelease days. 

param | description
--- | :---
`ls` | Lists existing backups to the console then exists
`auto` | Restores the last created backup without user prompt.
