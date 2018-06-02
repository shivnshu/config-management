#!/usr/bin/env python
import os
import sys
import yaml
import subprocess

def readConfig(fileName):
    fd = open(fileName, "r")
    return yaml.load(fd)

def executeCommand(task, conf_dir):
    print("")
    print("Executing " + task['name'])
    command = task['command']
    try:
        p = subprocess.run(command, cwd=conf_dir, shell=True, check=True)
    except:
        print(task['name'] + " failed!!")
        exit(0)
    print("")

if __name__ == "__main__":
    print("Firing config manager..")
    configFileLocation = 'conf.yml'
    if len(sys.argv) == 1:
        print("Using default: conf.yml config")
    else:
        configFileLocation = sys.argv[1]
        if len(sys.argv) != 2:
            print("Ignoring extra arguments")
    conf_dir = os.path.join(os.getcwd(), configFileLocation.rpartition('/')[0])

    cfgObject = readConfig(configFileLocation)

    # Preparation commands
    for prep_task in cfgObject['pre']:
        executeCommand(prep_task, conf_dir)

    # Clone repos
    for repo in cfgObject['subrepos']:
        _location = os.path.join(conf_dir, os.path.expandvars(repo['location']))
        _origin = repo['origin']
        print("Cloning " + repo['name'])
        subprocess.call(["git", "clone", _origin, _location])

    # Softlinking directories
    for direc in cfgObject['directories']:
        _placed = os.path.join(conf_dir, os.path.expandvars(direc['placed']))
        _location = direc['location']
        print("Softlinking " + direc['name'])
        subprocess.call(["ln", "-s", _placed, _location])

    # Softlinking files
    for f in cfgObject['files']:
        _placed = os.path.join(conf_dir, os.path.expandvars(f['_placed']))
        _location = f['location']
        print("Softlinking " + f['name'])
        subprocess.call(["ln", "-s", _placed, _location])

    # Finishing Tasks
    for post_task in cfgObject['post']:
        executeCommand(post_task, conf_dir)
