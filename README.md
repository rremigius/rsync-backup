# rsync-backup
Creates a backup of a directory, with incremental hard-link copies up to any number of times.

## Usage

```bash
rsync-backup.sh <src> <dst> <num_recycle>
```

- **src** the source directory to backup;
- **dst** the destination directory to store the backups;
- **num_recycle** the maximum number of copies to store.

One run will only create one backup. Consecutive runs with the same command will create **new** copies and recycle old
copies with **hard links**, not exceeding the maximum number of copies.

## Backup structure

The backup copies will be stored in the destination directory as `backup.<number>`, starting with `<number>` is 0.
Each backup directory contains a `date.txt` file with the backup date and a copy of the source directory.

Example: running `rsync-backup.sh source target 3` 3+ times will result in the following directory structure:

```
target
	backup.0
		source
		date.txt
	backup.1
		source
		date.txt
	backup.2
		source
		date.txt
```

All following runs of the same command will recycle these directories and shift them 'up', meaning the most recent
backup is always in `backup.0`.