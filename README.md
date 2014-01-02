# Simplenote-to-git Backup

This is a small package that enables you to back up your Simplenote notes to a git repo!  This is compatible with both standard git repos and github gists.

### Requirements:

- Python 2.7+
- Virtualenv
- git

### Execution
 - Fill in settings.cfg
 - Run `./run.sh`

If you are going to use this script, I would recommend setting it up hourly with cron:

    0 * * * * bash /path/to/run.sh
