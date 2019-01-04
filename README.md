# BakkesMod-thirdparty
This repository contains open source third party plugins for BakkesMod. 

/sources/ contains links to the source code of these plugins. Submodules are used for easy updating of this repository.

The repository also contains a script which compiles these plugins and copies the dll and settings to the /plugins/ folder.
To use this script locally, change ```$vs_location $bakkesmod_sdk_include $bakkesmod_sdk_lib``` to the correct paths on your computer.

Plugins are indexed using a JSON file, see plugins.json for a list of all these plugins.

If you want a new plugin to be added, add a new configuration to the plugins.json and submit a pull request. For example: 
```
{
            "name": "SciencePlugin",
            "author": "https://github.com/AratorRL",
            "repo": "https://github.com/AratorRL/SciencePlugin",
            "submodule": "SciencePlugin",
            "sourcedir": "SciencePlugin",
            "entrypoint": "SciencePlugin.cpp",
            "dllname": "scienceplugin.dll",
            "settings": "scienceplugin.set"
}
```
