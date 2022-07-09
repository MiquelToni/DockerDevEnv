# DockerDevEnv

Dockerfiles for development

## Purpose

Build a easy-setup dev environment templates for development

## Docker tips

If not working or not able to pull images then delete config.json

Ubuntu
```sh
rm  ~/.docker/config.json 
```

Windows
```powershell
%APPDATA%\Roaming\Docker\config.json
```

## Docker dev environment

Setup with
```sh
.scripts/setupDevelopment.sh <template>
```

Run with
```sh
.scripts/CreatePersistentContainer.sh <template> <container-name>
```

### Templates

- base: A basic setup of Oh-my-zsh and ASDF
- python-node: Sets Oh-my-zsh, ASDF, nodejs plugin, python plugin and installs `.tool-versions` versions of node and python
  - Add to `.default-python-packages` a list of python packages to pre-install.
